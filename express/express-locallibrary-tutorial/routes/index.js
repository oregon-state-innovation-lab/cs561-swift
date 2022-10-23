var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

// new API route: GET /users, returning a list of users
router.get('/data/2.5/weather', (request, response) => {
  response.json([
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
          "temp": 299.37,
          "feels_like": 299.37,
          "temp_min": 298.26,
          "temp_max": 300.98,
          "pressure": 1013,
          "humidity": 45
      },
      "visibility": 10000,
      "wind": {
          "speed": 5.14,
          "deg": 20
      },
      "clouds": {
          "all": 0
      },
      "dt": 1664655723,
      "sys": {
          "type": 2,
          "id": 2005452,
          "country": "US",
          "sunrise": 1664633455,
          "sunset": 1664675654
      },
      "timezone": -25200,
      "id": 5720727,
      "name": "Corvallis",
      "cod": 200
  }
  ]);
});


module.exports = router;
