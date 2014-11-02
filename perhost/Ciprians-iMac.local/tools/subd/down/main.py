from csutil.log import *
from common import *
import zipfile
import rarfile
import urllib2
import subprocess
import os
import re
import sys

def downWatch(args):
   watchDict = Common.GetDictFromIndexFile(Common.C_WATCH_LIST_PATH)

   for item in watchDict.values():
      downItem(item)


def downOne(args):
   indexId = -1
   try:
      indexId = int(args.index_id)
   except ValueError:
      printError("The index_id argument is not in the expected format. Use the value on the left returned by 'index list'")
      return

   if indexId < 0:
      printError("The index_id argument is negative")
      return

   indexDict = Common.GetDictFromIndexFile(Common.C_SUBS_INDEX_PATH)

   if indexId >= len(indexDict):
      printError("The index_id argument [" + str(indexId) + "] is out of range [0; " + str(len(indexDict)) + "]")
      return

   itemKey = indexDict.keys()[indexId]
   item = indexDict[itemKey]

   downItem(item)


def downItem(item):
   printInfo("Downloading " + Common.ItemToText(item) + " ...")

   destFolder = os.path.join(Common.C_SUBS_DIR, item["title"])

   seasonInt = int(item["season"])
   if seasonInt > 0:
      destFolder = os.path.join(destFolder, "S{0:0>2}".format(seasonInt))

   Common.MkdirP(destFolder)

   destFolderRaw = os.path.join(destFolder, Common.C_RAW_DOWNLOADS_FOLDER)
   Common.MkdirP(destFolderRaw)

   downloadedFilePath = downloadUrlToFile(item["downLink"], destFolderRaw)

   unidentifiedFolder = os.path.join(destFolder, Common.C_UNIDENTIFIED_FILES_FOLDER)
   Common.MkdirP(unidentifiedFolder)

   printInfo("Extracting file [" + downloadedFilePath + "] ...")

   fileType = getArchiveType(downloadedFilePath)
   if "zip" == fileType:
      unzip(downloadedFilePath, unidentifiedFolder)
   elif "rar" == fileType:
      unrar(downloadedFilePath, unidentifiedFolder)
   else:
      printError("Unknown file type.")


def downloadUrlToFile(url, folderPath):
   opener = urllib2.build_opener()
   headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 5.1; rv:10.0.1) Gecko/20100101 Firefox/10.0.1',
   }
   opener.addheaders = headers.items()
   u = opener.open(url);

   meta = u.info()
   contentDisposition = meta.getheaders("Content-Disposition")[0]
   fileNameMatch = re.search("filename\s*=\s*(.*?)(;|$)", contentDisposition, re.IGNORECASE)
   if None != fileNameMatch:
      fileName = fileNameMatch.group(1)
   else:
      printWarning("File name not specified in content-headers. Using last URL segment.")
      fileName = os.path.join(folderPath, url.split('/')[-1])

   filePath = os.path.join(folderPath, fileName)

   if os.path.isfile(filePath):
      os.remove(filePath)

   f = open(filePath, 'wb')

   file_size = int(meta.getheaders("Content-Length")[0])
   print("Downloading: {0} Bytes: {1}".format(url, file_size))

   file_size_dl = 0
   block_sz = 8192
   while True:
      buffer = u.read(block_sz)
      if not buffer:
         break

      file_size_dl += len(buffer)
      f.write(buffer)
      p = float(file_size_dl) / file_size
      status = r"{0}  [{1:.2%}]".format(file_size_dl, p)
      status = status + chr(8)*(len(status)+1)
      sys.stdout.write(status)

   f.close()

   return filePath


def unzip(sourceFilename, destDir):
   with zipfile.ZipFile(sourceFilename) as zf:
      for member in zf.infolist():
         # Path traversal defense copied from
         # http://hg.python.org/cpython/file/tip/Lib/http/server.py#l789
         words = member.filename.split('/')
         path = destDir
         for word in words[:-1]:
            drive, word = os.path.splitdrive(word)
            head, word = os.path.split(word)
            if word in (os.curdir, os.pardir, ''):
               continue
            path = os.path.join(path, word)
         zf.extract(member, path)


def unrar(sourceFilename, destDir):
   with rarfile.RarFile(sourceFilename) as rf:
      for member in rf.infolist():
         # Path traversal defense copied from
         # http://hg.python.org/cpython/file/tip/Lib/http/server.py#l789
         words = member.filename.split('/')
         path = destDir
         for word in words[:-1]:
            drive, word = os.path.splitdrive(word)
            head, word = os.path.split(word)
            if word in (os.curdir, os.pardir, ''):
               continue
            path = os.path.join(path, word)
         rf.extract(member, path)


def getArchiveType(filePath):
   magicDict = {
         "\x50\x4B\x03\x04": "zip",
         "\x52\x61\x72\x21\x1A\x07\x00": "rar"
         }
   max_len = max(len(x) for x in magicDict)

   with open(filePath) as f:
      fileStart = f.read(max_len)
   for magic, fileType in magicDict.items():
      if fileStart.startswith(magic):
         return fileType

   return "no match"
