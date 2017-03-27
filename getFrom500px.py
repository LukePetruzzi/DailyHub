import requests
import json
import my_config as mc

def getFrom500px():
	parameters = {'consumer_key': mc.fivepx_key, 'feature': 'popular'}
	headers = {'Content-Type': 'application/json'}
	r = requests.get('https://api.500px.com/v1/photos', params = parameters, headers = headers)
  
	# only continue if successful
	if r.status_code != 200:
		return None

	results = r.json()['photos']

	resultList = list()
	i = 0
	for result in results:
		# create a dictionary for the current result (some items may be null)
		singleDict = {}

		# get the author of the article
		singleDict['author'] = result['user']['username']

		# get the description of the article
		singleDict['description'] = result['description']

		# get the thumbnail image of the article
		singleDict['thumbnail'] = result['image_url']

		# get the title of the article
		singleDict['title'] = result['name']

		# get the url of the article
		singleDict['url'] = 'https://500px.com' + result['url']

		# add the result to the list of all results
		resultList.append(singleDict)

		# only get top 10 results (can change)
		i += 1
		if i is 10:
			break

	# add the full dictionary with title of the website pulling from
	outerDict = {}
	outerDict['500px'] = resultList
	return outerDict





