from csbase.log import *
import exiftool
import shutil
from datetime import datetime, date, time
import os
import errno
import re
import sys

def sanitizeFileName(iFileName):
   result = iFileName

   convertToUnderscoreChars = (" ",)
   result = re.sub('[' + "".join(convertToUnderscoreChars) + ']', '_', result)

   keepCharacters = ('.','_','-')
   result = "".join([c for c in result if c.isalpha() or c.isdigit() or c in keepCharacters]).rstrip()

   return result

def mkdirP(iDirPath):
   try:
      os.makedirs(iDirPath)
   except OSError as exc: 
      if exc.errno == errno.EEXIST and os.path.isdir(iDirPath):
         pass

def hasDirNoFilesRecursively(iDirPath):
   for dirPath, subDirList, fileList in os.walk(iDirPath):
      if fileList:
         return False

   return True

def removeUnwantedFiles(iDirPath):
   unwantedFiles = {'.DS_Store'}

   for dirPath, subDirList, fileList in os.walk(iDirPath):
      for fileName in fileList:
         if fileName in unwantedFiles:
            filePath = os.path.join(dirPath, fileName)
            print(" rm -f " + filePath)
            os.remove(filePath)

def main(iPath):
   mediaFileExtensions = ["jpg", "png", "gif", "mov", "mp4"]
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


   # Gather file info
   #

   imageFileDict = {}

   for dirPath, subDirList, fileList in os.walk(iPath):
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
               'fileName': fileName,
               'filePath': filePath,
               'extrasFileNames': extrasFileNames
            }


   # Gather exif metadata
   #

   with exiftool.ExifTool() as et:
      metadataList = et.get_metadata_batch( imageFileDict.keys() )

      #metadataList = et.execute_json( b"-d \"%Y:%m:%d %H:%M:%S\"", *imageFileDict.keys() )

      #params = ["-d", "\"%Y:%m:%d\""]
      #params.extend(imageFileDict.keys())
      #metadataList = et.execute_json(*params)

   for metadata in metadataList:
      filePath = metadata["SourceFile"]
      if filePath not in imageFileDict:
         printInfo("imageFileDict: " + "\n".join(imageFileDict.keys()))
         printError("Error matching metadata SourceFile [" + filePath + "] to imageFileDict.")
         return

      imageFileDict[filePath]['metadata'] = metadata


   # Create rename list
   #

   dateTagPriority = [
      'EXIF:DateTimeOriginal',
      'EXIF:CreateDate',
      'EXIF:ModifyDate',
      'H264:DateTimeOriginal',
      'QuickTime:CreateDate',
      'QuickTime:TrackCreateDate',
      'QuickTime:MediaCreateDate',
      'QuickTime:ModifyDate',
      'QuickTime:TrackModifyDate',
      'QuickTime:MediaModifyDate',
      'QuickTime:CreationDate',
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

   for entry in imageFileDict.itervalues():
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

         newFilenameNoExt = sanitizeFileName(newFilenameNoExt)

         entry['newFilenameNoExt'] = newFilenameNoExt

         # Folder
         #

         newDirPath = dateTime.strftime("%Y.%m")
         mkdirList |= {newDirPath}

         entry['newDirPath'] = newDirPath

      else:
         printWarning("File [" + entry['filePath'] + "] has no metadata.")


   # Prepare mvMap
   #

   mvMap = {}
   dstFilePathSet = set()
   srcDirPathSet = set()

   for entry in imageFileDict.itervalues():
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

   # Remove existing directories from mkdirList
   #

   tmpMkdirList = set()
   for newDir in mkdirList:
      if not os.path.isdir(newDir):
         tmpMkdirList |= {newDir}
   mkdirList = tmpMkdirList

   # Ask for confirmation
   #

   print("About to perform the following actions:")

   for newDir in mkdirList:
      print(" Make dir " + newDir)

   srcFilePathList = sorted(mvMap.keys())

   for srcFilePath in srcFilePathList:
      dstFilePath = mvMap[srcFilePath]
      print(" " + srcFilePath + " -> " + dstFilePath)

   agree = raw_input("Do you agree? (y=return/n): ")
   if agree and agree.lower() != "y":
      print(" Canceled!")
      return

   print("")
   print("Executing:")

   # Perform mkdir
   #

   for newDir in mkdirList:
      print(" mkdir -p " + newDir)
      mkdirP(newDir)

   # Perform mv
   #

   for srcFilePath in srcFilePathList:
      dstFilePath = mvMap[srcFilePath]
      print(" mv " + srcFilePath + " " + dstFilePath)
      shutil.move(srcFilePath, dstFilePath)

   # Removing leftover unwanted files and empty directories
   #

   print("Removing leftover unwanted files and empty directories:")

   removeUnwantedFiles(".")

   removedDirSet = set()
   for dirPath in srcDirPathSet:
      if os.path.isdir(dirPath):
         if hasDirNoFilesRecursively(dirPath):
            print(" rm -rf " + dirPath)
            shutil.rmtree(dirPath)
            rmDirPerformed = True
            removedDirSet |= {dirPath}


   print("DONE!")
   print("")

   # Print reversal actions
   #

   print("Reversal actions:")

   for srcDir in srcDirPathSet:
      print(" mkdir -p " + removedDir)

   revSrcFilePathList = sorted(mvMap.keys(), reverse=True)
   for srcFilePath in revSrcFilePathList:
      dstFilePath = mvMap[srcFilePath]
      print(" mv " + dstFilePath + " " + srcFilePath)

   for createdDir in mkdirList:
      print(" if [[ -z \"$(find '" + createdDir + "' -type f)\" ]]; then rm -rf " + createdDir + "; fi")

if __name__ == "__main__":
   path = "."
   if(len(sys.argv) > 1):
      path = sys.argv[1]

   main(path)
