from flask import Flask
from flask import jsonify
import requests
import pprint
import json
# r =requests.get('https://api.openweathermap.org/data/2.5/weather?q=Corvallis,us&APPID=0d4c3c05756767f0202df9dd82e9d402')
f = open('data.json')
data = json.load(f)
pprint.pprint(data,indent=2)

app = Flask(__name__)

@app.route('/')
def hello_world():
    return json.dumps(data,indent=2)
 
# main driver function
if __name__ == '__main__':
 
    # run() method of Flask class runs the application
    # on the local development server.
    app.run(debug=True,port=3000)