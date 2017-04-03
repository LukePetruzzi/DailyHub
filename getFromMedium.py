import requests
import json
import base64
import my_config as mc
from bs4 import BeautifulSoup

def getFromMedium():
	# get the medium url for their popular/trending stuff
	r = requests.get("https://medium.com/topic/popular")	

	soup = BeautifulSoup(r.content.encode('ascii', 'ignore'))
	print soup.prettify()

getFromMedium()