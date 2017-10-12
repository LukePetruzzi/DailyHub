import requests
import datetime
import json
import my_config as mc

def getFromYouTube():
	# get the top trending vids
	parameters = {'part': 'snippet', 'chart': 'mostPopular', 'regionCode': 'US', 'videoCategoryId': '0',
				  'maxResults': '10', 'key': mc.youtube_apiKey}
	headers = {'Content-Type': 'application/json'}
	r = requests.get('https://www.googleapis.com/youtube/v3/videos', params=parameters, headers=headers)

	#print("youtubeRESPONSE_CODE:", r.status_code)

	# only continue if got the stuff successfully
	if r.status_code != 200:
		return None

	results = r.json()['items']
	# print(json.dumps(results, indent=4, sort_keys=True))

	# create a list for each item that is a dict of data
	resultList = list()

	for result in results:
		# create a dictionary for the current result
		singleDict = {}

		# get the title of the video
		singleDict['title'] = result['snippet']['title']

		# get the poster's channel name
		singleDict['author'] = result['snippet']['channelTitle']

		singleDict['description'] = result['snippet']['description']

		# get the thumbnail image of the video (this is the lowest res)
		singleDict['thumbnail'] = result['snippet']['thumbnails']['high']['url']

		# get the youtube url
		singleDict['url'] = 'https://www.youtube.com/watch?v=' + result['id']

		# add the result to the list of all results
		resultList.append(singleDict)

	# add the full dictionary with title of the website pulling from
	outerDict = {}
	outerDict['YouTube'] = resultList
	return outerDict

# getFromYouTube()
# print(json.dumps(getFromYouTube(), indent=4, sort_keys=True))

#this stuff gets the highest viewCount vids
# # get the rfc time of 24 hour ago
# thePast = datetime.datetime.utcnow() - datetime.timedelta(hours=24)
# thePastRFC = strict_rfc3339.timestamp_to_rfc3339_utcoffset(int(thePast.timestamp()))
#
#
# parameters = {'part': 'snippet', 'maxResults': '10', 'order': 'viewCount', 'publishedAfter': thePastRFC,
#               'relevanceLanguage': 'en', 'regionCode': 'US', 'key': apiKey}
# r = requests.get('https://www.googleapis.com/youtube/v3/search', params=parameters)
#
# print("RESPONSE_CODE:", r.status_code)
# print(json.dumps(r.json(), indent=4, sort_keys=True))

