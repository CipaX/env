from __future__ import print_function
import sys

def printInfo(*objs):
   print("", *objs, file = sys.stdout)

def printWarning(*objs):
   print("WARNING: ", *objs, file = sys.stderr)

def printError(*objs):
   print("ERROR: ", *objs, file = sys.stderr)
