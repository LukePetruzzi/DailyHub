import requests
import json

def getFromGiphy():
	apiKey = 'dc6zaTOxFJmzC'
	url = 'http://api.giphy.com/v1/gifs/trending?api_key=' + apiKey
	r = requests.get(url)

	# only continue if successful
	if r.status_code != 200:
		return None
	
	results = r.json()['data']

	# create a list for each dict item
	resultList = list()

	i = 0

	for result in results:

		singleDict = {}
		
		# print the article's title
		singleDict['title'] = ''

		# print the article's author
		singleDict['author'] = results['username']
	
		# print URL to thumbnail (can change to more HQ)
		singleDict['thumbnail'] = result['images']['downsized']['url']

		# print the link to the article
		singleDict['url'] = results['url']
		
		# print description
		singleDict['description'] = ''

		resultList.append(singleDict)

		# only get top 10 results (can change)
		i += 1
		if i is 10:
			break
		
	# add the full dictionary with title of the website pulling from
	outerDict = {}
	outerDict['Giphy'] = resultList
	return outerDict

print(json.dumps(getFromGiphy(), indent=4, sort_keys=True))
