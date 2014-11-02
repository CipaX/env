import indexer.main as indexer
import watch.main as watch
import down.main as down
import argparse

def main():
   parser = argparse.ArgumentParser(description="Subtitle downloader")


   # {index|watch|down}
   parserSub = parser.add_subparsers(help="first level sub-command")
   parserIndex = parserSub.add_parser("index", help="tv/movie index related commands")
   parserWatch = parserSub.add_parser("watch", help="watch list related commands")
   parserDown = parserSub.add_parser("down", help="download related commands")

   # index {update [<link>] | list [<filter>]}

   parserIndexSub = parserIndex.add_subparsers(help="index sub-commands")

   parserIndexUpdate = parserIndexSub.add_parser("update", help="update the index")
   parserIndexUpdate.set_defaults(func=indexer.indexUpdate)

   parserIndexList = parserIndexSub.add_parser("list", help="list the index (with optional filtering - see help)")
   parserIndexList.add_argument("filter", default="*", help="wildcard (.*) filter for listing")
   parserIndexList.set_defaults(func=indexer.indexList)


   # watch {add|rm|list}
   parserWatchSub = parserWatch.add_subparsers(help="tv/movie watch list sub-commands")
   parserWatchAdd = parserWatchSub.add_parser("add", help="add a tv/movie to the watch list")
   parserWatchRm = parserWatchSub.add_parser("rm", help="remove a tv/movie from the watch list")
   parserWatchList = parserWatchSub.add_parser("list", help="list the tv/movie watch list (with optional filtering)")

   # watch add <index_id>
   parserWatchAdd.add_argument("index_id", help="the id reported by 'index list'")
   parserWatchAdd.set_defaults(func=watch.watchAdd)

   # watch rm <watch_id>
   parserWatchRm.add_argument("watch_id", help="the id of the tv/movie to remove, as listed by the list command")
   parserWatchRm.set_defaults(func=watch.watchRemove)

   # watch list <filter>
   parserWatchList.add_argument("filter", default=".*", help="wildcard (.*) filter for listing")
   parserWatchList.set_defaults(func=watch.watchList)


   # down {watch|one}
   parserDownSub = parserDown.add_subparsers(help="download sub-commands")
   parserDownWatch = parserDownSub.add_parser("watch", help="download all tv shows / movies in the watch list")
   parserDownOne = parserDownSub.add_parser("one", help="download a specific tv/movie")

   # down watch
   parserDownWatch.set_defaults(func=down.downWatch)

   # down one <index_id>
   parserDownOne.add_argument("index_id", help="the id reported by 'index list'")
   parserDownOne.set_defaults(func=down.downOne)


   # PARSE
   args = parser.parse_args()


   # EXECUTE
   args.func(args)


if __name__ == "__main__":
   main()
