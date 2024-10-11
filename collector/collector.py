import requests
import redis
import time
import dotenv
import os
import boto3
from botocore.exceptions import ClientError
import json


secret_name = "weather_api_key"
region_name = "us-east-1"
session = boto3.session.Session()
client = session.client(service_name='secretsmanager', region_name=region_name)
get_secret_value_response = client.get_secret_value(SecretId=secret_name)
api_key = json.loads(get_secret_value_response['SecretString'])['APIkey']

dotenv.load_dotenv()
host = os.getenv('REDIS_HOST')
port = os.getenv('REDIS_PORT')
r = redis.Redis(host=host, port=port)

while True:
    url = 'http://api.weatherapi.com/v1/current.json'

    params = {
        'key': api_key,
        'q': '18018',
    }

    results = requests.get(url, params=params).json()

    temp_f = results['current']['temp_f']

    r.set('temp_f', temp_f)
    # Flush the buffer to ensure it is printed immediately
    print('Saved {}. Sleeping for 15 minutes'.format(temp_f), flush=True)
    time.sleep(15 * 60)
