import requests
import json
import my_config as mc

def getFromNYTimes():
    headers = {'Content-Type': 'application/json', 'apiKey': mc.nytimes_apiKey}

    # gets the top for the past day. that's what the 1.json is... the next step is a week, 7.json. nothing in between
    r = requests.get('https://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1.json', headers=headers)

    #print(json.dumps(r.json(), indent=4, sort_keys=True))

    results = r.json()['results']

    #print("nytimesRESPONSE_CODE", r.status_code)

    # only continue if got the stuff successfully
    if r.status_code != 200:
        return None

    # create a list for each item that is a dict of data
    resultList = list()
    i = 0
    for result in results:
        # create a dictionary for the current result
        singleDict = {}

        # get the title of the article
        singleDict['title'] = result['title']

        # get the thumbnail photo for the article
        singleDict['thumbnail'] = result['media'][0]['media-metadata'][0]['url']

        # get the abstract description of the article
        singleDict['description'] = result['abstract']

        # get the url of the article
        singleDict['url'] = result['url']

        resultList.append(singleDict)

        # only get top 10 results (can change)
        i += 1
        if i is 10:
            break


    # add the full dictionary with title of the website pulling from
    outerDict = {}
    outerDict['NYTimes'] = resultList
    return outerDict

# print(json.dumps(getFromNYTimes(), indent=4, sort_keys=True))


