import requests
import datetime
import json
import tweepy

def getFromTwitter():
	#find all tweets from the day
	#pull the one with the most combined retweets and favorites
	consumerKey = "XQlyGZbUFzhpL6YkhTOCz53LN"
	consumerSecret = "8nPgWw46T5TBkyAmBIu4rstoGWlzdyYdef6ozhRMCYCFK2Mn8H"
	accessToken = "851476033106784257-fDp2Jml6ecuz8B4r6l741Pb9QT8fXQ1"
	accessTokenSecret = "pz7EMWEPh7JB8TCoZhGjquehMUZGJ1b0bbRli1FIneAow"

	auth = tweepy.OAuthHandler(consumerKey, consumerSecret)
	auth.set_access_token(accessToken, accessTokenSecret)
	api = tweepy.API(auth)

	#results = json.loads()
	#print len(results)
	results = api.trends_place(1)[0]["trends"]
	# print(json.dumps(results, indent=4, sort_keys=True))

	# create a list for each item that is a dict of data
	# create a dictionary for the current result
	resultList = []
	for result in results:
		#print result
		
		singleDict = {}
		# get the title of the video
		singleDict['title'] = result['query']

		singleDict['description'] = result['tweet_volume']

		# get the thumbnail image of the video (this is the lowest res)
		singleDict['thumbnail'] = result['snippet']['thumbnails']['default']['url']

		# get the youtube url
		singleDict['url'] = result['url']

		# add the result to the list of all results
		resultList.append(singleDict)

	# add the full dictionary with title of the website pulling from
	outerDict = {}
	outerDict['Twitter'] = resultList
	return outerDict
