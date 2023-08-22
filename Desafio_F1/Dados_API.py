import requests
import json 
import pandas as pd 


dadosf1 = requests.get('http://ergast.com/api/f1/2021.json')
print(dadosf1)

content_type = dadosf1.headers.get('content-type')
print(content_type)

