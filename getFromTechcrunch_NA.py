import requests
import json
import my_config as mc


# Newsapi.org only returns techcrunch's top 5 for top, so here we make sure 
# we get those 5 and then grab the next 5 from latest
def getFromTechcrunch():
	parameters = {'source': 'techcrunch', 'sortBy': 'top', 'apiKey': mc.newsapi_key}
	headers = {'Content-Type': 'application/json'}
	r = requests.get("https://newsapi.org/v1/articles", params = parameters, headers = headers)

	# only continue if successful
	if r.status_code != 200:
		return None

	results = r.json()['articles']

	resultList = list()
	i = 0
	for result in results:
		# create a dictionary for the current result (some items may be null)
		singleDict = {}

		# get the author of the article
		singleDict['author'] = result['author']

		# get the description of the article
		singleDict['description'] = result['description']

		# get the thumbnail image of the article
		singleDict['thumbnail'] = result['urlToImage']

		# get the title of the article
		singleDict['title'] = result['title']

		# get the url of the article
		singleDict['url'] = result['url']

		# add the result to the list of all results
		resultList.append(singleDict)

		# only get top 10 results (can change)
		i += 1
		if i is 5:
			break

	parameters = {'source': 'techcrunch', 'sortBy': 'latest', 'apiKey': mc.newsapi_key}
	r = requests.get("https://newsapi.org/v1/articles", params = parameters, headers = headers)

	# only continue if successful
	if r.status_code != 200:
		return None

	results = r.json()['articles']

	# continue adding to the same resultList
	i = 0
	for result in results:
		# create a dictionary for the current result (some items may be null)
		singleDict = {}

		# get the author of the article
		singleDict['author'] = result['author']

		# get the description of the article
		singleDict['description'] = result['description']

		# get the thumbnail image of the article
		singleDict['thumbnail'] = result['urlToImage']

		# get the title of the article
		singleDict['title'] = result['title']

		# get the url of the article
		singleDict['url'] = result['url']

		# add the result to the list of all results
		resultList.append(singleDict)

		# only get top 10 results (can change)
		i += 1
		if i is 5:
			break

	# add the full dictionary with title of the website pulling from
	outerDict = {}
	outerDict['Techcrunch'] = resultList
	return outerDict

# print(json.dumps(getFromTechcrunch(), indent=4, sort_keys=True))
