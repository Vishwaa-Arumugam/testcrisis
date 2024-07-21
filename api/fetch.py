import requests
import json
import os
import schedule
import time

base_path = '/home/vishwaa-arumugam/Documents/GitHub/Crisis-HackFest/api'

locations = [
    'Chennai',
    'Tambaram',
    'Guindy',
    'Anna Nagar',
    'Mylapore',
    'Adyar',
    'Nungambakkam',
    'Egmore',
    'Royapettah',
    'Kodambakkam',
    'Pallavaram',
    'Thiruvanmiyur',
    'Ambattur',
    'Porur',
    'Teynampet',
    'Perambur',
    'Kotturpuram'
]

def fetch_weather_data(location):
    print(f'Fetching weather data for {location}')
    url = f'http://api.weatherapi.com/v1/forecast.json?key=89b9b32d8e644a4fa0e141503240707&q={location}&days=1&aqi=yes&alerts=yes'
    response = requests.get(url)
    if response.status_code == 200:
        result = response.json()
        file_path = os.path.join(base_path, f'{location}.json')
        with open(file_path, 'w') as file:
            json.dump(result, file, indent=4)
        print(f'Saved weather data for {location}')
    else:
        print(f'Failed to fetch weather data for {location}')

def fetch_weather_data_all_locations():
    for location in locations:
        fetch_weather_data(location)

schedule.every(10).minutes.do(fetch_weather_data_all_locations)

fetch_weather_data_all_locations()

while True:
    schedule.run_pending()
    time.sleep(1)
