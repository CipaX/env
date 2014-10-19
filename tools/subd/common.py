import indexer.indexer.items
import json
import os
import errno

IndexerItem = indexer.indexer.items.IndexerItem

class Common:
   C_HOME_DIR = os.path.expanduser("~")
   C_METADATA_DIR = os.getenv("SUBD_METADATA_DIR", os.path.join(C_HOME_DIR, ".subd"))
   C_SUBS_DIR = os.getenv("SUBD_SUBS_DIR", os.path.join(C_HOME_DIR, "subd_subs"))
   C_SUBS_INDEX_PATH = os.path.join(C_METADATA_DIR, "subs_index.json")
   C_WATCH_LIST_PATH = os.path.join(C_METADATA_DIR, "watch_list.json")
   C_RAW_DOWNLOADS_FOLDER = "raw"
   C_UNIDENTIFIED_FILES_FOLDER = "unidentified"

   @staticmethod
   def GetDictFromIndexFile(indexFilePath):
      resultDict = {}

      jsonItems = []
      try:
         with open(indexFilePath, "r") as indexF:
            jsonItems = json.load(indexF)
      except IOError:
         pass

      for jsonItem in jsonItems:
         indexerItem = IndexerItem()
         indexerItem["title"] = jsonItem["title"]
         indexerItem["season"] = jsonItem["season"]
         indexerItem["downLink"] = jsonItem["downLink"]

         key = indexerItem["title"] + "-" + indexerItem["season"]

         resultDict[key] = indexerItem

      return resultDict

   @staticmethod
   def WriteDictToIndexFile(indexDict, filePath):
      finalList = []
      for key in indexDict:
         dictItem = indexDict[key]
         listItem = {"title": dictItem["title"],
                     "season": dictItem["season"],
                     "downLink": dictItem["downLink"]}
         finalList.append(listItem)

      with open(filePath, "w") as destF:
         json.dump(finalList, destF)

   @staticmethod
   def JoinIndexFiles(destNewFilePath, withOldFilePath):
      finalDict = Common.GetDictFromIndexFile(withOldFilePath)
      finalDict.update( Common.GetDictFromIndexFile(destNewFilePath) )

      Common.WriteDictToIndexFile(finalDict, destNewFilePath)

      return finalDict

   @staticmethod
   def ItemToText(item):
      if int(item["season"]) > 0:
         return "TV Show [" + item["title"] + "] - Season [" + item["season"] + "]"
      else:
         return "Movie [" + item["title"] + "]"

   @staticmethod
   def MkdirP(path):
      try:
         os.makedirs(path)
      except OSError as exc: # Python >2.5
         if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
         else:
            raise
