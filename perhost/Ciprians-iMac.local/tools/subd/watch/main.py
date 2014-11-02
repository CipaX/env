from csutil.log import *
from common import *
import os
import re

def watchAdd(args):
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
   newWatchDict = {itemKey: item}

   watchFileExists = os.path.isfile(Common.C_WATCH_LIST_PATH)

   C_WATCH_LIST_BAK_PATH = Common.C_WATCH_LIST_PATH + ".bak"
   if watchFileExists:
      os.rename(Common.C_WATCH_LIST_PATH, C_WATCH_LIST_BAK_PATH)

   Common.WriteDictToIndexFile(newWatchDict, Common.C_WATCH_LIST_PATH)

   if watchFileExists:
      Common.JoinIndexFiles(Common.C_WATCH_LIST_PATH, C_WATCH_LIST_BAK_PATH)

   printInfo("Added " + Common.ItemToText(item) + " to the watch list.")


def watchRemove(args):
   if None == re.search("^w\d+$", args.watch_id):
      printError("The index_id argument [" + args.watch_id + "] is not in the expected format.\n" +
                 "It should be composed by the letter 'w' followed by a number with no spaces between.")

   watchId = -1
   try:
      watchId = int(re.search("(\d+)", args.watch_id).group(1))
   except ValueError:
      printError("A number could not be extracted from the watch_id argument. Use the value on the left returned by 'watch list'")
      return

   if watchId < 0:
      printError("The watch_id argument is negative")
      return

   watchDict = Common.GetDictFromIndexFile(Common.C_WATCH_LIST_PATH)

   if watchId >= len(watchDict):
      printError("The watch_id argument [" + str(watchId) + "] is out of range [0; " + str(len(watchDict)) + ")")
      return

   itemKey = watchDict.keys()[watchId]
   item = watchDict[itemKey]

   del watchDict[itemKey]

   Common.WriteDictToIndexFile(watchDict, Common.C_WATCH_LIST_PATH)

   printInfo("Removed " + Common.ItemToText(item) + " from the watch list.")


def watchList(args):
   indexDict = Common.GetDictFromIndexFile(Common.C_WATCH_LIST_PATH)

   filterReStr = ".*" + ".*".join(args.filter.split()) + ".*"

   itemPos = 0
   for key in indexDict:
      item = indexDict[key]
      if None != re.match(filterReStr, item["title"], re.IGNORECASE):
         print "w" + str(itemPos) + ": [" + item["title"] + "] S[" + item["season"] + "]"
      itemPos += 1
