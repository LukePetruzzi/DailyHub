import requests
import json
import my_config as mc

#from bs4 import BeautifulSoup

def getFromStackOverflow():

	r = requests.get('https://api.stackexchange.com/2.2/search/advanced?order=desc&sort=votes&q=created:1d is:question&site=stackoverflow')

	# print(json.dumps(r.json(), indent=4, sort_keys=True))

	# only continue if got the stuff successfully
	if r.status_code != 200:
		return None


	results = r.json()['items']

	# create a list for each item that is a dict of data
	resultList = list()

	i = 0
	for result in results:
		# create a dictionary for the current result
		singleDict = {}

		# print the question's title
		singleDict['title'] = result['title']

		# print the questions's user
		singleDict['author'] = result['owner']['display_name']

		# print URL to thumbnail of user's image
		singleDict['thumbnail'] = result['owner']['profile_image']

		# print all the tags for the question comma separated
		singleDict['description'] = ''
		for j in range(len(result['tags'])):
			if j == len(result['tags']) - 1:
				singleDict['description'] += result['tags'][j]
			else:
				singleDict['description'] += result['tags'][j] + ', '

		# print the link to the question
		singleDict['url'] = result['link']

		resultList.append(singleDict)

		# only get top 10 results (can change)
		i += 1
		if i is 10:
			break

	# add the full dictionary with title of the website pulling from
	outerDict = {}
	outerDict['StackOverflow'] = resultList
	return outerDict

# print(json.dumps(getFromStackOverflow(), indent=4, sort_keys=True))
