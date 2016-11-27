import requests
from bs4 import BeautifulSoup

# none of this stuff works.... always goes to sign in page

headers = {'Accept-Encoding': 'identity'}
r = requests.get('https://www.quora.com/#', headers=headers)

soup = BeautifulSoup(r.text, 'html.parser')
nice = soup.prettify()

print(nice)