import requests
import json
import base64
import my_config as mc

def getFromSpotify():
    
    # get access token
    authorization = base64.standard_b64encode(mc.spotify_id + ':' + mc.spotify_secret)
    headers = { 'Authorization': 'Basic ' + authorization }
    data = { 'grant_type': 'client_credentials' }
    response = requests.post('https://accounts.spotify.com/api/token', data = data, headers = headers)
    if response.status_code != 200:
        return None
    access = response.json()['access_token']


    headers = {'Content-Type': 'application/json',
               'Authorization' : 'Bearer ' + access}    
    r = requests.get('https://api.spotify.com/v1/users/spotify/playlists/4hOKQuZbraPDIfaGbM3lKI', headers=headers)
    if r.status_code != 200:
        return None

    results = r.json()['tracks']['items']
    resultList = list()

    i = 0

    for result in results:
        # create dictionary for current result
        singleDict = {}

        # print the tracks' title
        singleDict['title'] = result['track']['name']
        
        # print the track's artist (could include multiple artists later?)
        singleDict['artist'] = result['track']['album']['artists'][0]['name']
        
        # print URL to thumbnail
        singleDict['thumbnail'] = result['track']['album']['images'][0]['url']
        
        # print the link to the song
        singleDict['url'] = result['track']['external_urls']['spotify']        
        resultList.append(singleDict)

        # only get top 10; could change later
        i += 1
        if i == 10:
            break;
        
    # add the full dictionary with title of the website pulling from
    outerDict = {}
    outerDict['Spotify'] = resultList
    return outerDict


