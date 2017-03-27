from getFromImgur import *
from getFromNYTimes import *
from getFromSoundcloud import *
from getFromYouTube import *
from getFromESPN_NA import *
from getFromIGN_NA import *
from getFromBuzzfeed import *
from getFromNatGeo_NA import *
from getFromTechcrunch_NA import *
from getFromVimeo import *

# maybe do Medium next??

def createMasterDict():
	# create a list of all the answers
	finalList = list()

	finalList.append(runFunction(getFromYouTube))
	finalList.append(runFunction(getFromSoundcloud))
	finalList.append(runFunction(getFromNYTimes))
	finalList.append(runFunction(getFromImgur))
	finalList.append(runFunction(getFromESPN))
	finalList.append(runFunction(getFromIGN))
	finalList.append(runFunction(getFromBuzzFeed))
	finalList.append(runFunction(getFromNatGeo))
	finalList.append(runFunction(getFromTechcrunch))
	finalList.append(runFunction(getFromVimeo))


	#finalList.append(runFunction(getFromReddit))

	# add all the lists to the master dictionary
	newDict = {}
	newDict['data'] = finalList
	return newDict


def runFunction(func):
	# run the function until it works (when the response code is 200)
	# THIS IS REALLY SLOPPY AND SHOULD BE DONE BETTER PROBABLY
	answer = None
	while answer is None:
		answer = func()
	return answer



# print(json.dumps(createMasterDict(), indent=4, sort_keys=True))

 # create mode 100644 getFrom500px.py
 # create mode 100644 getFromAP_NA.py
 # create mode 100644 getFromBBCNews_NA.py
 # create mode 100644 getFromBBCSport_NA.py
 # create mode 100644 getFromBloomberg_NA.py
 # create mode 100644 getFromBusinessInsider_NA.py
 # create mode 100644 getFromCNN_NA.py
 # create mode 100644 getFromDeviant.py
 # create mode 100644 getFromEntertainmentWeekly_NA.py
 # create mode 100644 getFromEtsy.py
 # create mode 100644 getFromHackerNews_NA.py
 # create mode 100644 getFromMTV_NA.py
 # create mode 100644 getFromNYMag_NA.py
 # create mode 100644 getFromNewsweek_NA.py
 # create mode 100644 getFromReuters_NA.py
 # create mode 100644 getFromSpotify.py
 # create mode 100644 getFromTime_NA.py
 # create mode 100644 getFromUSAToday_NA.py
 # create mode 100644 getFromWSJ_NA.py
 # create mode 100644 getFromWashPost_NA.py
