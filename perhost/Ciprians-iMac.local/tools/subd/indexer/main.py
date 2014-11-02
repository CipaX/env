from csutil.log import *
from common import *
import json
import subprocess
import os
import re

def indexUpdate(args):
   printInfo("Updating index. Please wait ...");

   olderIndexExists = os.path.isfile(Common.C_SUBS_INDEX_PATH)

   C_SUBS_INDEX_BAK_PATH = Common.C_SUBS_INDEX_PATH + ".bak"
   if olderIndexExists:
      os.rename(Common.C_SUBS_INDEX_PATH, C_SUBS_INDEX_BAK_PATH)

   command = "cd indexer && exec scrapy crawl subs_ro -o " + Common.C_SUBS_INDEX_PATH + " -t json"

   scrapyP = subprocess.Popen(command, stderr = subprocess.PIPE, shell = True)
   (out, err) = scrapyP.communicate()
   retCode = scrapyP.returncode

   if retCode != 0:
      if None == retCode:
         printError("Internal: Scrapy didn't finish executing.")
      elif retCode > 0:
         printError("Scrapy returned with exit code:", retCode)
      else:
         printError("Scrapy interrupted. Signal:", -retCode)

      if (None != out) and ("" != out):
         printError("Scrapy stdout: \n", out)
      if (None != err) and ("" != err):
         printError("Scrapy stderr: \n", err)

      return

   if olderIndexExists:
      Common.JoinIndexFiles(Common.C_SUBS_INDEX_PATH, C_SUBS_INDEX_BAK_PATH)


def indexList(args):
   indexDict = Common.GetDictFromIndexFile(Common.C_SUBS_INDEX_PATH)

   filterReStr = ".*" + ".*".join(args.filter.split()) + ".*"

   itemPos = 0
   for key in indexDict:
      item = indexDict[key]
      if None != re.match(filterReStr, item["title"], re.IGNORECASE):
         print str(itemPos) + ": [" + item["title"] + "] S[" + item["season"] + "]"
      itemPos += 1
