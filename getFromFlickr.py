import requests
import datetime
import json
import flickrapi

#easy_install flickrapi

def getFromFlickr():
	#find all tweets from the day
	#pull the one with the most combined retweets and favorites
	api_key = "9fee94b125b1b5465553cf9421479d3b"
	api_secret = "30da1e8e4dcbc7ca"
	flickr = flickrapi.FlickrAPI(api_key, api_secret, format='parsed-json')
	sets   = flickr.interestingness.getList()
	#title  = sets['photosets']['photoset'][0]['title']['_content']
	title = sets['photos']['photo']
	#print('First set title: %s' % title)
	print sets
	# create a dictionary for the current result
	
	resultList = []
	for result in title: 
		url = "https://www.flickr.com/photos/" + str(result["owner"]) + "/" + str(result["id"])
		photo = "https://farm" + str(result['farm']) + ".staticflickr.com//" + str(result['server']) + "//" + str(result['id']) + "_" + str(result['secret'])+ ".jpg"
		singleDict = {}
		singleDict['title'] = result['title']
		descrip = flickr.photos.getInfo(photo_id = str(result['id']), secret = result['secret'])['photo']["description"]["_content"]
		singleDict['description'] = descrip

		# get the thumbnail image of the video (this is the lowest res)
		singleDict['thumbnail'] = photo
		# get the youtube url
		singleDict['url'] = url

		# add the result to the list of all results
		resultList.append(singleDict)
	outerDict = {}
	outerDict['Flickr'] = resultList
	return outerDict


	# for result in title: 

	# 	# get the title of the video
	# 	singleDict['title'] = result['query']

	# 	#singleDict['description'] = result['tweet_volume']
	# 	url = "https://farm" + 1 + ".staticflickr.com/" + 2 + "/" + 1418878+"_" + 1e92283336 + "_m.jpg"
	# 	# get the thumbnail image of the video (this is the lowest res)
	# 	singleDict['thumbnail'] = result['snippet']['thumbnails']['default']['url']

	# 	# get the youtube url
	# 	singleDict['url'] = result['url']

	# 	# add the result to the list of all results
	# 	resultList.append(singleDict)

	# # add the full dictionary with title of the website pulling from
	# outerDict = {}
	# outerDict['Twitter'] = resultList
	# return outerDict

getFromFlickr()