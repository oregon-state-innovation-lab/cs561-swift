"use strict"

var express = require('express')
var app = express()

app.listen(3000)
console.log('Node.js Express server id is running on port 3000...')

app.get('/data/2.5/weather', get_weather)

function get_weather(request, response) {
    response.json(
    {
        "coord": {
          "lon": -123.262,
          "lat": 44.5646
        },
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 59.32,
          "feels_like": 57.36,
          "temp_min": 55.09,
          "temp_max": 60.42,
          "pressure": 1022,
          "humidity": 51
        },
        "visibility": 10000,
        "wind": {
          "speed": 5.75,
          "deg": 310
        },
        "clouds": {
          "all": 0
        },
        "dt": 1666564641,
        "sys": {
          "type": 2,
          "id": 2040223,
          "country": "US",
          "sunrise": 1666535916,
          "sunset": 1666574148
        },
        "timezone": -25200,
        "id": 5720727,
        "name": "Corvallis",
        "cod": 200
    })
}