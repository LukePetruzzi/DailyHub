from getFromImgur import *
from getFromNYTimes import *
from getFromSoundcloud import *
from getFromYouTube import *


def createMasterDict():
    # create a list of all the answers
    finalList = list()

    finalList.append(runFunction(getFromYouTube))
    finalList.append(runFunction(getFromSoundcloud))
    finalList.append(runFunction(getFromNYTimes))
    finalList.append(runFunction(getFromImgur))
    #finalList.append(runFunction(getFromReddit))


    # add all the lists to the master dictionary
    newDict = {}
    newDict['data'] = finalList
    return newDict


def runFunction(func):
    # run the function until it works (when the response code is 200)
    answer = None
    while answer is None:
        answer = func()
    return answer



# THIS THING RUNS FOREVER!!
# sched = BlockingScheduler()
# @sched.scheduled_job('interval', seconds=10)
# def updateMasterDict():
#     masterDictionary = createMasterDict()
#
#     #sys.stdout.write("It's on!!!!!!" + str(masterDictionary))
#
#     print(json.dumps(masterDictionary, indent=4, sort_keys=True))
#     print("MASTER DICTIONARY WAS UPDATED AT: " + str(datetime.datetime.now()))
#     sys.stdout.flush()

# sched.start()
