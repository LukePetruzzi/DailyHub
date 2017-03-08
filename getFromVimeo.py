import requests
import datetime
import json
import base64
import my_config as mc

def getFromVimeo():
	# get the top trending vids
	parameters = {'page': '1', 'per_page': '10', 'query': '', 'sort': 'plays', 'direction': 'desc', 'filter': 'trending', 'grant_type': 'client_credentials'}
	headers = {'Content-Type': 'application/json', 'Authorization': 'basic ' + 
	base64.b64encode(mc.vimeo_id + ':' + mc.vimeo_secret)}
	r = requests.get('https://api.vimeo.com/videos', params=parameters, 
		headers=headers)

	# only continue if got the stuff successfully
	if r.status_code != 200:
		return None

	results = r.json()['data']
	# print(json.dumps(results, indent=4, sort_keys=True))

	# create a list for each item that is a dict of data
	resultList = list()

	for result in results:
		# create a dictionary for the current result
		singleDict = {}

		# get the title of the video
		singleDict['title'] = result['name']

		# get the description of the video
		singleDict['description'] = result['description']

		# get the poster's user name
		singleDict['author'] = result['user']['name']

		# get the thumbnail image of the video (this is the lowest res)
		singleDict['thumbnail'] = result['pictures']['sizes'][1]['link']

		# get the youtube url
		singleDict['url'] = result['link']

		# add the result to the list of all results
		resultList.append(singleDict)

	# add the full dictionary with title of the website pulling from
	outerDict = {}
	outerDict['Vimeo'] = resultList
	return outerDict


# getFromVimeo()
# print(json.dumps(getFromVimeo(), indent=4, sort_keys=True))