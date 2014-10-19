from indexer.items import IndexerItem
from scrapy.spider import Spider
from scrapy.selector import Selector
import re


class SubsRoSpider(Spider):
    name = "subs_ro"
    allowed_domains = ["subs.ro"]
    start_urls = ["http://subs.ro/subtitrari/seriale/pagina/%s" % page for page in xrange(1, 200)]

    def parse(self, response):
      sel = Selector(response)
      webItems = sel.xpath("//div[@id='subtitles-page']/ul/li/div[@class='details']")
      items = []

      for webItem in webItems:
        item = IndexerItem()

        fullNames = webItem.xpath(".//h2[@class='title']/a[1]/text()").extract()
        if 1 != len(fullNames):
           print "Node expected to have one and only one title. Skipping ... \n", webItem
           break

        fullName = fullNames[0].strip()

        filteredTitle = re.sub("(.*?)[\s\-]*(\((sezonul|season)\s*\d+\)|(sezonul|season)\s*\d+)\s*(.*?$)",
                               r"\1 \5", 
                               fullName, 
                               flags=re.IGNORECASE)
        if "" == filteredTitle:
           print "Could not match series title. Skipping ... \n [" + fullName + "]"
           break
        item['title'] = filteredTitle

        seasonSearch = re.search("(sezonul|season)\s*(\d+)", fullName, re.IGNORECASE)
        if None == seasonSearch:
           print "Could not match series season. Considering it as a movie ... \n [" + fullName + "]"
           break
        item['season'] = seasonSearch.group(2).strip()

        downLinks = webItem.xpath(".//div[@class='sub-buttons']/a[@class='btn-download']/@href").extract()
        if 1 != len(downLinks):
           print "Node expected to have one and only one download link. Skipping ... \n", webItem
           break

        item['downLink'] = downLinks[0].strip()

        items.append(item)

      return items;
