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
from getFrom500px import *
from getFromAP_NA import *
from getFromBBCNews_NA import *
from getFromBBCSport_NA import *
from getFromBloomberg_NA import *
from getFromBusinessInsider_NA import *
from getFromCNN_NA import *
from getFromDeviant import *
from getFromEntertainmentWeekly_NA import *
from getFromEtsy import *
from getFromHackerNews_NA import *
from getFromMTV_NA import *
from getFromNYMag_NA import *
from getFromNewsweek_NA import *
from getFromReuters_NA import *
from getFromSpotify import *
from getFromTime_NA import *
from getFromUSAToday_NA import *
from getFromWSJ_NA import *
from getFromWashPost_NA import *

# HERE

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
	finalList.append(runFunction(getFrom500px))
	finalList.append(runFunction(getFromAP))
	finalList.append(runFunction(getFromBBCNews))
	finalList.append(runFunction(getFromBBCSport))
	finalList.append(runFunction(getFromBloomberg))
	finalList.append(runFunction(getFromBusinessInsider))
	finalList.append(runFunction(getFromCNN))
	finalList.append(runFunction(getFromDeviant))
	finalList.append(runFunction(getFromEntertainmentWeekly))
	finalList.append(runFunction(getFromEtsy))
	finalList.append(runFunction(getFromHackerNews))
	finalList.append(runFunction(getFromMTV))
	finalList.append(runFunction(getFromNYMag))
	finalList.append(runFunction(getFromNewsweek))
	finalList.append(runFunction(getFromReuters))
	finalList.append(runFunction(getFromSpotify))
	finalList.append(runFunction(getFromTime))
	finalList.append(runFunction(getFromUSAToday))
	finalList.append(runFunction(getFromWSJ))
	finalList.append(runFunction(getFromWashPost))

	# If there are any empty strings in the output, change them to null.
	# DynamoDB doesn't take empty strings
	for v in finalList:
		for k, array in v.items():
			for dic in array:
				for key, value in dic.items():
					if value == "":
						dic[key] = None

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

