import requests
import json
import os
from flask import Flask, request, jsonify
from flask_caching import Cache

app = Flask(__name__)
app.config['CACHE_TYPE'] = 'simple'
app.config['CACHE_DEFAULT_TIMEOUT'] = 600  
cache = Cache(app)

base_path = '/home/vishwaa-arumugam/Documents/GitHub/Crisis-HackFest/api'

@app.route('/')
def home():
    return '<h1>Home</h1>'

def fetch_weather_data(location):
    print('fetched from api')
    url = f'http://api.weatherapi.com/v1/forecast.json?key=89b9b32d8e644a4fa0e141503240707&q={location}&days=1&aqi=yes&alerts=yes'
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        return None

def get_cached_weather_data(location):
    file_path = os.path.join(base_path, f'{location}.json')
    if os.path.exists(file_path):
        print('caching worked')
        with open(file_path, 'r') as file:
            result = json.load(file)
    else:
        result = fetch_weather_data(location)
        if result:
            with open(file_path, 'w') as file:
                json.dump(result, file, indent=4)
    
    if not result:
        return None

    forecast = {
        'location': result['location']['name'],
        'temp_min': result['forecast']['forecastday'][0]['day']['mintemp_c'],
        'temp_max': result['forecast']['forecastday'][0]['day']['maxtemp_c'],
        'condition': result['current']['condition']['text'],
        'wind_dir': result['current']['wind_dir'],
        'wind_kph': result['current']['wind_kph'],
        'humidity': result['current']['humidity'],
        'visibility': result['current']['vis_km'],
        'feelslike': result['current']['feelslike_c'],
        'time': [hour['time'] for hour in result['forecast']['forecastday'][0]['hour']],
        'temp': [hour['temp_c'] for hour in result['forecast']['forecastday'][0]['hour']],
        'icon': [hour['condition']['icon'].lstrip('//') for hour in result['forecast']['forecastday'][0]['hour']]
    }

    return forecast

@app.route('/get_weather_data')
@cache.cached(timeout=600, query_string=True)
def get_weather_data():
    location = request.args.get('location', default='chennai')
    forecast = get_cached_weather_data(location)
    if forecast:
        return jsonify(forecast)
    else:
        return jsonify({'error': 'Failed to fetch weather data'}), 500

if __name__ == "__main__":
    cache.init_app(app)  # Initialize the cache
    app.run(host='0.0.0.0',debug=True)
