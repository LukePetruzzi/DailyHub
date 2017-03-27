import requests
import json
import my_config as mc

def getFromEtsy():
	parameters = {'api_key': mc.etsy_apiKey}
	headers = {'Content-Type': 'application/json'}
	r = requests.get("https://api.etsy.com/v2/listings/trending", params = parameters, headers = headers)

	# only continue if successful
	if r.status_code != 200:
		return None

	results = r.json()['results']

	resultList = list()
	i = 0

	for result in results:
		# create a dictionary for the current result (some items may be null)
		singleDict = {}
			

		# get the author of the article
		singleDict['author'] = ""

		# get the description of the article
		singleDict['description'] = result['description']

		# get the thumbnail image of the article
		singleDict['thumbnail'] = ""

		# get the title of the article
		singleDict['title'] = result['title']

		# get the url of the article
		singleDict['url'] = result['url']

		# add the result to the list of all results
		resultList.append(singleDict)

		# only get top 10 results (can change)
		i += 1
		if i is 10:
			break

	# add the full dictionary with title of the website pulling from
	outerDict = {}
	outerDict['Etsy'] = resultList
	return outerDict

getFromEtsy()