from csbase.log import *
import exiftool
import shutil
from datetime import datetime, date, time
import os
import errno
import re
import sys
from pprint import pprint

###################################################################################################

def sanitizeFileName(iFileName):
   result = iFileName

   convertToUnderscoreChars = (" ",)
   result = re.sub('[' + "".join(convertToUnderscoreChars) + ']', '_', result)

   keepCharacters = ('.','_','-')
   result = "".join([c for c in result if c.isalpha() or c.isdigit() or c in keepCharacters]).rstrip()

   return result


###################################################################################################

def mkdirP(iDirPath):
   try:
      os.makedirs(iDirPath)
   except OSError as exc: 
      if exc.errno == errno.EEXIST and os.path.isdir(iDirPath):
         pass


###################################################################################################

def hasDirNoFilesRecursively(iDirPath):
   for dirPath, subDirList, fileList in os.walk(iDirPath):
      if fileList:
         return False

   return True


###################################################################################################

def removeUnwantedFiles(iDirPath):
   unwantedFiles = {'.DS_Store'}

   for dirPath, subDirList, fileList in os.walk(iDirPath):
      for fileName in fileList:
         if fileName in unwantedFiles:
            filePath = os.path.join(dirPath, fileName)
            print(" rm -f " + filePath)
            os.remove(filePath)


###################################################################################################

def getApplePhotosEventFromDirPathRegexObject():
   dateRegexPart = "(" + "|".join([str(day) for day in range(1, 32)]) + ")"
   dateRegexPart += " *(January|February|March|April|May|June|July|August|September|October|November|December)"
   dateRegexPart += " *20\d\d"
   eventRegex = re.compile("(.*/)*(?P<event>.*)(, *" + dateRegexPart + ")/*$", re.UNICODE)

   return eventRegex


###################################################################################################

def getApplePhotosEventNameFromDirPath(iDirPath, eventRegexObject):
   result = None

   eventMatch = eventRegexObject.match(iDirPath)
   if eventMatch:
      eventMatchGroupDict = eventMatch.groupdict();
      if 'event' in eventMatchGroupDict:
         result = eventMatchGroupDict['event']

   return result;


###################################################################################################

def gatherFileInfo(iPath):
   mediaFileExtensions = ["jpg", "png", "gif", "mov", "mp4", "m4v"]
   extrasFileExtensions = ["aae"]

   # Prepare lookup variables
   #

   fileExtTuple = ()
   for ext in mediaFileExtensions:
      fileExtTuple = fileExtTuple + ("." + ext.lower(), "." + ext.upper())

   extrasRegex = "\.("
   isFirstExtraRegexExt = True
   for ext in extrasFileExtensions:
      if not isFirstExtraRegexExt:
         extrasRegex += "|"
      else:
         isFirstExtraRegexExt = False
      extrasRegex += ext
   extrasRegex += ")$"

   eventRegexObject = getApplePhotosEventFromDirPathRegexObject()

   # Gather file info
   #

   imageFileDict = {}
   eventNameSet = set()

   for dirPath, subDirList, fileList in os.walk(iPath):
      eventName = getApplePhotosEventNameFromDirPath(dirPath, eventRegexObject)
      if eventName:
         eventNameSet |= {eventName}

      for fileName in fileList:
         if fileName.endswith(fileExtTuple):
            filePath = os.path.join(dirPath, fileName)

            fileNameNoExt, fileExt = os.path.splitext(fileName)
            possibleExtraRegex = re.compile("^" + fileNameNoExt + extrasRegex, re.IGNORECASE)

            extrasFileNames = [extraMatch.group(0) \
                     for extraFileName in fileList \
                        for extraMatch in [possibleExtraRegex.search(extraFileName)]\
                           if extraMatch]

            imageFileDict[filePath] = {
               'dirPath': dirPath,
               'eventName': eventName,
               'fileName': fileName,
               'fileNameNoExt': fileNameNoExt,
               'fileExt': fileExt,
               'filePath': filePath,
               'extrasFileNames': extrasFileNames
            }

   return (imageFileDict, eventNameSet)


###################################################################################################

def gatherExifMetadata(ioImageFileDict):
   with exiftool.ExifTool() as et:
      metadataList = et.get_metadata_batch( ioImageFileDict.keys() )

      #metadataList = et.execute_json( b"-d \"%Y:%m:%d %H:%M:%S\"", *ioImageFileDict.keys() )

      #params = ["-d", "\"%Y:%m:%d\""]
      #params.extend(ioImageFileDict.keys())
      #metadataList = et.execute_json(*params)

   for metadata in metadataList:
      filePath = metadata["SourceFile"]
      if filePath not in ioImageFileDict:
         # The previous error caught by this check was caused by having different types of
         # string encodings.
         # iPath was originally received as utf-8, thus the paths resulting from the use
         # of os.walk were also utf-8. This meant that the keys of ioMetedataFileDict
         # were also utf-8.
         # On the other hand, paths provided by exiftool get_metadata_batch (undocumented)
         # were plain Unicode.
         # This problem should supposedly be fixed now.

         printInfo("=== ioImageFileDict.keys() ===")
         pprint(ioImageFileDict.keys());
         printInfo("=== metadata ===")
         pprint(metadata, indent=2)
         printInfo("------")
         printError("Error matching metadata SourceFile [" + filePath + "] to ioImageFileDict.")
         return False

      ioImageFileDict[filePath]['metadata'] = metadata

   return True


###################################################################################################

def prepareRenameInfo(ioImageFileDict, iIncludeEventName):
   dateTagPriority = [
      'EXIF:DateTimeOriginal',
      'EXIF:CreateDate',
      'EXIF:ModifyDate',
      'H264:DateTimeOriginal',
      'QuickTime:ContentCreateDate',
      'QuickTime:CreationDate',
      'QuickTime:CreationDate-ron-RO',
      'QuickTime:CreateDate',
      'QuickTime:TrackCreateDate',
      'QuickTime:MediaCreateDate',
      'QuickTime:ModifyDate',
      'QuickTime:TrackModifyDate',
      'QuickTime:MediaModifyDate',
      'File:FileModifyDate'
   ]

   makeTagPriority = [
      'EXIF:Make',
      'H264:Make',
      'QuickTime:Make',
      'QuickTime:Make-ron',
      'QuickTime:Make-ron-RO',
      'EXIF:LensMake'
   ]

   modelTagPriority = [
      'EXIF:Model',
      'H264:Model',
      'QuickTime:Model',
      'QuickTime:Model-ron',
      'QuickTime:Model-ron-RO',
      "EXIF:LensModel"
   ]


   mkdirList = set()

   for entry in ioImageFileDict.itervalues():
      newFilenameNoExt = entry['fileNameNoExt']
      newDirPath = "unclassified"

      # Compute newFilenameNoExt and newDirPath based on metadata
      #
      if 'metadata' in entry:
         metadata = entry['metadata']
         filePath = entry['filePath']

         # Date
         #

         dateTime = datetime.fromtimestamp( min(os.path.getmtime(filePath), os.path.getctime(filePath)) )

         for dateTag in dateTagPriority:
            if dateTag in metadata:
               dateMeta = metadata[dateTag][:19]
               try:
                  dateTime = datetime.strptime(dateMeta, "%Y:%m:%d %H:%M:%S")
                  break
               except:
                  printWarning("File [" + filePath + "]: Tag [ " + dateTag + "]: " + \
                               "could not convert string to date [" + dateMeta + "]. " + \
                               "Skipping tag.")
                  continue

         dateString = dateTime.strftime("%Y-%m-%d_%H.%M.%S")

         # Make
         #

         make = ""

         for makeTag in makeTagPriority:
            if makeTag in metadata:
               make = metadata[makeTag]
               break

         # Model
         #

         model = ""

         for modelTag in modelTagPriority:
            if modelTag in metadata:
               model = metadata[modelTag]
               break

         # New filename (no extension)
         #

         newFilenameNoExt = dateString
         if make:
            newFilenameNoExt += "-" + make
         if model:
            newFilenameNoExt += "-" + model

         # Folder
         #

         newDirPath = dateTime.strftime("%Y.%m")

      else:
         printWarning("File [" + entry['filePath'] + "] has no metadata.")

      # Add event name as exported by Apple Fotos to the newFilenameNoExt if present in path
      #
      if iIncludeEventName:
         if entry['eventName']:
            newFilenameNoExt += "-" + entry['eventName']

      # Add computed newFilenameNoExt and newDirPath to the entry and mkdirList
      #
      newFilenameNoExt = sanitizeFileName(newFilenameNoExt)
      entry['newFilenameNoExt'] = newFilenameNoExt
      mkdirList |= {newDirPath}
      entry['newDirPath'] = newDirPath

   return mkdirList

###################################################################################################

def prepareMoveMap(ioImageFileDict, ioMkdirList):
   mvMap = {}
   dstFilePathSet = set()
   srcDirPathSet = set()

   for entry in ioImageFileDict.itervalues():
      if 'newFilenameNoExt' in entry:
         srcFileNames = [entry['fileName']]
         srcFileNames.extend(entry['extrasFileNames'])
         srcDirPath = entry['dirPath']
         newFilenameNoExt = entry['newFilenameNoExt']
         newDirPath = entry['newDirPath']

         srcDirPathSet |= {srcDirPath}

         renamed = False
         suffixInt = 1
         while not renamed:
            tmpMvMap = {}
            tmpDstFilePathSet = set()

            for srcFileName in srcFileNames:
               srcFileNameNoExt, fileExt = os.path.splitext(srcFileName)

               dstFileName = newFilenameNoExt
               if suffixInt >= 2:
                  dstFileName += "-" + str(suffixInt)
               dstFileName += fileExt

               srcFilePath = os.path.join(srcDirPath, srcFileName)
               dstFilePath = os.path.join(newDirPath, dstFileName)

               tmpMvMap[srcFilePath] = dstFilePath
               tmpDstFilePathSet |= {dstFilePath}

            noFileExists = True
            for srcFilePath, dstFilePath in tmpMvMap.iteritems():
               if (srcFilePath == dstFilePath) and (os.path.exists(dstFilePath) or dstFilePath in dstFilePathSet):
                  noFileExists = False
                  break

            if noFileExists:
               renamed = True
               mvMap.update(tmpMvMap)
               dstFilePathSet |= tmpDstFilePathSet

            suffixInt += 1

   # Remove existing directories from ioMkdirList
   #

   tmpMkdirList = set()
   for newDir in ioMkdirList:
      if not os.path.isdir(newDir):
         tmpMkdirList |= {newDir}
   ioMkdirList = tmpMkdirList

   return (mvMap, srcDirPathSet)


###################################################################################################

def performDiskOperations(iPath, iMkdirList, iMvMap, iSrcFilePathList, iSrcDirPathSet):
   # Perform mkdir
   #

   for newDir in iMkdirList:
      print(" mkdir -p \"" + newDir + "\"")
      mkdirP(newDir)

   # Perform mv
   #

   for srcFilePath in iSrcFilePathList:
      dstFilePath = iMvMap[srcFilePath]
      print(" mv \"" + srcFilePath + "\" \"" + dstFilePath + "\"")
      shutil.move(srcFilePath, dstFilePath)

   # Removing leftover unwanted files and empty directories
   #

   print("Removing leftover unwanted files and empty directories:")

   removeUnwantedFiles(iPath)

   removedDirSet = set()
   for dirPath in iSrcDirPathSet:
      if os.path.isdir(dirPath):
         if hasDirNoFilesRecursively(dirPath):
            print(" rm -rf \"" + dirPath + "\"")
            shutil.rmtree(dirPath)
            rmDirPerformed = True
            removedDirSet |= {dirPath}

   return removedDirSet


###################################################################################################

def askForEventNameConfirmation(iEventNameSet):
   result = "x"

   if iEventNameSet:
      print("Detected event names:")
      print("  " + "\n  ".join(iEventNameSet))

      result = raw_input("Consider them in file names? (Yes [y=return] / No, continue without [n] / Exit [x or any key]): ")
      result = result.lower()
      if not result:
         result = "y"
      if (result != "y") and (result != "n"):
         result = "x"

      if (result == "y"):
         printInfo(" Selected Yes. Using event names.")
      elif (result == "n"):
         printInfo(" Selected No. Continuing without using event names.")
      elif (result == "x"):
         printInfo(" Selected Exit. Aborting entire operation.")
      else:
         printError("Impossible confirmation result: [" + result + "]");
         sys.exit()

   else:
      raw_input("No event names found. Continue without? (Yes [y] / No [n or any key]): ")
      result = result.lower()
      if result != "y":
         result = "n"

      if (result == "y"):
         printInfo(" Selected Yes. Continuing without using event names.")
      elif (result == "n"):
         printInfo(" Selected No. Aborting entire operation.")
      else:
         printError("Impossible confirmation result: [" + result + "]");
         sys.exit()

   return result


###################################################################################################

def askForDiskOperationExecutionConfirmation(iMkdirList, iMvMap, iSrcFilePathList):
   print("About to perform the following actions:")

   for newDir in iMkdirList:
      print(" Make dir " + newDir)

   for srcFilePath in iSrcFilePathList:
      dstFilePath = iMvMap[srcFilePath]
      print(" " + srcFilePath + " -> " + dstFilePath)

   result = raw_input("Do you agree? (Yes [y=return] / No [n or any key]): ")
   result = result.lower()
   if not result:
      result = "y"
   if (result != "y"):
      result = "n"

   if (result == "y"):
      printInfo(" Selected Yes. Continuing.")
   elif (result == "n"):
      printInfo(" Selected No. Aborting entire operation.")
   else:
      printError("Impossible confirmation result: [" + result + "]");
      sys.exit()

   return result


def printDiskOperationReversalActions(iMkdirList, iMvMap, iSrcDirPathSet):
   print("Reversal operations:")

   for srcDir in iSrcDirPathSet:
      print(" mkdir -p \"" + srcDir + "\"")

   revSrcFilePathList = sorted(iMvMap.keys(), reverse=True)
   for srcFilePath in revSrcFilePathList:
      dstFilePath = iMvMap[srcFilePath]
      print(" mv \"" + dstFilePath + "\" \"" + srcFilePath + "\"")

   for createdDir in iMkdirList:
      print(" if [[ -z \"$(find '" + createdDir + "' -type f)\" ]]; then rm -rf \"" + createdDir + "\"; fi")

###################################################################################################

def main(iPath):
   # Convert to Unicode in order to avoid dictionary key mismatches between os.walk results
   # and exiftool results.
   iPath = iPath.decode("utf-8")

   # Gather file info
   #
   imageFileDict, eventNameSet = gatherFileInfo(iPath)
   if not imageFileDict:
      printInfo("No recognized image/video file found.")
      return

   # Gather exif metadata
   #
   ok = gatherExifMetadata(imageFileDict)
   if not ok:
      return;

   # Ask for including event names
   #
   eventNameConfirmation = askForEventNameConfirmation(eventNameSet)
   if eventNameConfirmation == "x":
      return
   includeEventName = ("y" == eventNameConfirmation)

   # Prepare rename info
   #
   mkdirList = prepareRenameInfo(imageFileDict, includeEventName)

   # Prepare move map and dest dirs
   #
   mvMap, srcDirPathSet = prepareMoveMap(imageFileDict, mkdirList)
   srcFilePathList = sorted(mvMap.keys())

   # Ask for confirmation
   #
   executionConfirmation = askForDiskOperationExecutionConfirmation(mkdirList, mvMap, srcFilePathList)
   if executionConfirmation != "y":
      return

   # Perform disk operations
   #
   print("")
   print("Executing:")
   performDiskOperations(iPath, mkdirList, mvMap, srcFilePathList, srcDirPathSet)
   print("DONE!")
   print("")

   # Print reversal actions
   #
   printDiskOperationReversalActions(mkdirList, mvMap, srcDirPathSet)


###################################################################################################
# MAIN()
###################################################################################################

if __name__ == "__main__":
   path = "."
   if(len(sys.argv) > 1):
      path = sys.argv[1]

   main(path)

