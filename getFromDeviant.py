import requests
import json
import my_config as mc

def getFromDeviant():
	parameters = {'client_id': mc.deviant_id, 'client_secret': mc.deviant_secret, 'grant_type': 'client_credentials'}
	headers = {'Content-Type': 'application/json'}
	r = requests.get("https://www.deviantart.com/oauth2/token", params = parameters, headers = headers)

	# only continue if successful
	if r.status_code != 200:
		return None
	
	access = r.json()['access_token']

	parameters = {'access_token': access}
	headers = {'Content-Type': 'application/json'}
	r = requests.get('https://www.deviantart.com/api/v1/oauth2/browse/popular', params = parameters, headers = headers)

	if r.status_code != 200:
		return None

	results = r.json()['results']

	resultList = list()
	i = 0
	for result in results:
		# create a dictionary for the current result (some items may be null)
		singleDict = {}

		# get the author of the article
		singleDict['author'] = result['author']['username']

		# get the description of the article
		singleDict['description'] = result['category']

		# get the thumbnail image of the article
		singleDict['thumbnail'] = result['content']['src']

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
	outerDict['Deviant'] = resultList
	return outerDict

# print(json.dumps(getFromDeviant(), indent=4, sort_keys=True))

