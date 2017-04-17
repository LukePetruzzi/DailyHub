#ADOPTED FROM https://gist.github.com/Moving-Electrons/e7b03cc489de359890e4
import feedparser #need manual installation. Doesn't come with Python.
import os



# Linux:
#folderPath = '/home/ananyajoshi/Desktop/Woot/'

# Just woot.com items:
#url = "https://api.woot.com/1/sales/current.rss/www.woot.com"

# All woot feeds:
url = "http://api.woot.com/1/sales/current.rss"
#alertsFile = folderPath+'alert_list.txt'
#dealsFile = folderPath+'dealsgroup' #omit extension as it will be provided by the script.



def getFromWoot():

	parsedFeed = feedparser.parse(url)
	entryIndex = 0
	resultList = []
	for entry in parsedFeed['entries']:
		#print entry
		entryIndex += 1

		try:
			# The feed only has one entry. Therefore, the data from index [0] is assigned.
			title = entry['title']
			soPercentage = entry['woot_soldoutpercentage']
			price = entry['woot_price']
			wootoff = entry['woot_wootoff']
			url2 = entry['links'][0]['href']
			picture = entry['woot_detailimage']
			singleDict = {}
		# get the title of the video
			singleDict['title'] = title

			singleDict['description'] = str(price) + " after discount of " + str(wootoff)

			# get the thumbnail image of the video (this is the lowest res)
			singleDict['thumbnail'] = picture

			# get the youtube url
			singleDict['url'] = url2

			# add the result to the list of all results
			resultList.append(singleDict)

		# add the full dictionary with title of the website pulling from
		

		except IOError:
			print ('Variables could not be assigned based on parsed data')
	outerDict = {}
	outerDict['Woot'] = resultList
	return outerDict

getFromWoot()