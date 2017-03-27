import requests
import json


def getFromReddit():
	parameters = {'t': 'day', 'limit': '10'}
	headers = {'Content-Type': 'application/json'}
	r = requests.get('https://www.reddit.com/r/all/top.json', params=parameters, headers=headers)

	#print("redditRESPONSE_CODE:", r.status_code)

	# only continue if got the stuff successfully
	if r.status_code != 200:
		return None

	# get the json and strip off the tips
	results = r.json()
	field_list = results['data']['children']

	#print(json.dumps(field_list, indent=4, sort_keys=True))

	# create a list for each item that is a dict of data
	resultList = list()

	for field in field_list:
		# create a dictionary for the current result
		singleDict = {}

		#get the title
		singleDict['title'] = field['data']['title']

		#get the thumbnail image
		url = field['data']['preview']['images'][0]['resolutions'][0]['url']
		singleDict['thumbnail'] = str(url.replace('amp;', ''))

		#get and format the url of the thing the post points to
		url = field['data']['url']
		singleDict['postSourceUrl'] = str(url.replace('amp;', ''))

		#get the full reddit post
		redditLink = 'https://m.reddit.com' + field['data']['permalink']
		singleDict['url'] = str(redditLink)

		resultList.append(singleDict)

	# add the full dictionary with title of the website pulling from
	outerDict = {}
	outerDict['Reddit'] = resultList
	return outerDict


