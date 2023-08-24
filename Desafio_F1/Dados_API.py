import requests
import pandas as pd
from flatten_json import flatten

base_url = "https://ergast.com/api/f1/2021/results.json"
limit = 40
offset = 0
all_data = []

while True:
    url = f"{base_url}?limit={limit}&offset={offset}"
    response = requests.get(url)
    
    if response.status_code == 200:
        data = response.json()

        if len(data["MRData"]["RaceTable"]["Races"]) == 0:
            break 
            
        all_data.extend(data["MRData"]["RaceTable"]["Races"])
        offset += limit
    else:
        print(f"Erro na requisição: {response.status_code}")
        break

flattened_data = [flatten(item) for item in all_data]
df = pd.DataFrame(flattened_data)
