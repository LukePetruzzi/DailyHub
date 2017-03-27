import requests
import json
import my_config as mc

#from bs4 import BeautifulSoup



def getFromSoundcloud():
	# to get from a specific genre, make
	parameters = {'kind': 'trending', 'genre': 'soundcloud:genres:all-music', 'limit': '40', 'client_id': mc.soundcloud_clientId}
	headers = {'Content-Type': 'application/json'}

	r = requests.get('https://api-v2.soundcloud.com/charts', params=parameters, headers=headers)

	#print("soundcloudRESPONSE_CODE:", r.status_code)

	# only continue if got the stuff successfully
	if r.status_code != 200:
		return None

	#print(json.dumps(r.json(), indent=4, sort_keys=True))

	results = r.json()['collection']

	# create a list for each item that is a dict of data
	resultList = list()

	i = 0
	for result in results:
		# create a dictionary for the current result
		singleDict = {}

		# print the tracks' title
		singleDict['title'] = result['track']['title']

		# print the track's artist
		singleDict['artist'] = result['track']['user']['username']

		# print URL to thumbnail
		singleDict['thumbnail'] = result['track']['artwork_url']

		# print the link to the song
		singleDict['url'] = result['track']['permalink_url']

		resultList.append(singleDict)

		# only get top 10 results (can change)
		i += 1
		if i is 10:
			break

	# add the full dictionary with title of the website pulling from
	outerDict = {}
	outerDict['Soundcloud'] = resultList
	return outerDict

# print(json.dumps(getFromSoundcloud(), indent=4, sort_keys=True))


#interesting old bs4 attempt
# r = requests.get('https://soundcloud.com/charts/new?genre=all-music.json')
#
# soup = BeautifulSoup(r.text, "html.parser")
#
# count = 0
# for link in soup.find_all(lambda t: t.get('itemprop','').startswith('name')):
#
#     link = str(link)
#     # get the link to the actual song
#     tuple = link.partition('<a href=\"')
#     trackURI = tuple[2].partition("\"")[0]
#     print('https://soundcloud.com' + trackURI)