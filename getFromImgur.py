import requests
import json
import my_config as mc


def getFromImgur():
    headers = {'Content-Type': 'application/json', 'Authorization': 'Client-ID:' + mc.imgur_clientId}
    r = requests.get('https://api.imgur.com/3/gallery/hot/viral/0.json', headers=headers)

    # print("imgurRESPONSE_CODE:", r.status_code)

    # only continue if got the stuff successfully
    if r.status_code != 200:
        return None

    results = r.json()['data']

    # print(json.dumps(results, indent=4, sort_keys=True))

    # create a list for each item that is a dict of data
    resultList = list()
    i = 0
    for result in results:
        # create a dictionary for the current result
        singleDict = {}

        # get the title of the post
        singleDict['title'] = result['title']

        # get the thumbnail
        if 'cover' not in result:
            singleDict['thumbnail'] = 'https://i.imgur.com/' + result['id'] + 'b.jpg'
        else:
            singleDict['thumbnail'] = 'https://i.imgur.com/' + result['cover'] + 'b.jpg'

        # get the imgur url
        singleDict['url'] = result['link']

        # add the result to the list of all results
        resultList.append(singleDict)

        # only get top 10 results (can change)
        i += 1
        if i is 10:
            break

    # add the full dictionary with title of the website pulling from
    outerDict = {}
    outerDict['Imgur'] = resultList
    return outerDict


# print(json.dumps(getFromImgur(), indent=4, sort_keys=True))


