const express = require('express');
const app = express();
const port = 3000;

app.get('/data/2.5/weather', (request, response) => {
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
            "icon": "01n"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 286.57,
          "feels_like": 286.19,
          "temp_min": 284.11,
          "temp_max": 290.98,
          "pressure": 1016,
          "humidity": 85
        },
        "visibility": 10000,
        "wind": {
          "speed": 1.54,
          "deg": 260
        },
        "clouds": {
          "all": 0
        },
        "dt": 1664606130,
        "sys": {
          "type": 1,
          "id": 3727,
          "country": "US",
          "sunrise": 1664546983,
          "sunset": 1664589366
        },
        "timezone": -25200,
        "id": 5720727,
        "name": "Corvallis",
        "cod": 200
    }
  

  )
})

app.delete('/data/2.5/weather', (request, response) => {
    response.json({ result: 'success' });
});

app.listen(3000, () => {});