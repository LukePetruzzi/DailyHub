import threading
import random
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
from getFromStackOverflow import *
from getFromGiphy import *

# maybe do Medium next??

def createMasterDict():
	# create an array of all the function names
	funcNames = [getFromYouTube, getFromSoundcloud, getFromNYTimes, getFromImgur, getFromESPN, getFromIGN, getFromBuzzFeed, getFromNatGeo, getFromTechcrunch, getFromVimeo, getFrom500px, getFromAP, getFromBBCNews, getFromBBCSport, getFromBloomberg, getFromBusinessInsider, getFromCNN, getFromDeviant, getFromEntertainmentWeekly, getFromEtsy, getFromHackerNews, getFromMTV, getFromNYMag, getFromNewsweek, getFromReuters, getFromSpotify, getFromTime, getFromUSAToday, getFromWSJ, getFromWashPost, getFromStackOverflow, getFromGiphy]
	# create a list of all the answers
	finalDict = {}
	# create a lock for adding threads to the list
	myLock = threading.Lock()
	# all the threads
	threads = list()

	# to run the function in a thread
	def getAndAppend(funcName):
		currentDict = runFunction(funcName)
		# append results to the list one at a time with the lock
		with myLock:
			# print(json.dumps(currentDict, indent=4, sort_keys=True))
			finalDict[next(iter(currentDict))] = currentDict[random.choice(currentDict.keys())]

	# create a new thread for each function call
	for funcName in funcNames:
		# get response from the thread
		threads.append(threading.Thread(target=getAndAppend, args=[funcName]))

	# run and then join all the threads
	for thread in threads:
		thread.start()
	for thread in threads:
		thread.join()

	# If there are any empty strings in the output, change them to null.
	# DynamoDB doesn't take empty strings
	keys = finalDict.keys()
	for k in keys:
		for dic in finalDict[k]:
			for key, value in dic.items():
				if value == "":
					dic[key] = None

	return finalDict

def runFunction(func):
	# run the function until it works (when the response code is 200)
	# THIS IS REALLY SLOPPY AND SHOULD BE DONE BETTER PROBABLY
	answer = None
	while answer is None:
		answer = func()
	return answer

# createMasterDict()
# print(json.dumps(createMasterDict(), indent=4, sort_keys=True))

