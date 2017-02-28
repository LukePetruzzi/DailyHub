import requests
import json

def getFromBuzzFeed():
    r = requests.get('http://www.buzzfeed.com/api/v2/feeds/trending')

    # only continue if successful
    if r.status_code != 200:
        return None
    
    results = r.json()['buzzes']

    # create a list for each item
    resultList = list()

    i = 0

    for result in results:

        singleDict = {}
        
        # print the article's title
        singleDict['title'] = result['title']

        # print the article's author
        singleDict['author'] = result['bylines'][0]['display_name']
    
        # print URL to thumbnail (can change to more HQ)
        singleDict['thumbnail'] = result['images']['standard']

        # print the link to the article
        singleDict['url'] = "http://buzzfeed.com/" + result['username'] + '/' + result['uri']
        
        # print description
        singleDict['description'] = result['description']

        resultList.append(singleDict)

        # only get top 10 results (can change)
        i += 1
        if i == 10:
            break
        
    # add the full dictionary with title of the website pulling from
    outerDict = {}
    outerDict['Buzzfeed'] = resultList
    return outerDict
