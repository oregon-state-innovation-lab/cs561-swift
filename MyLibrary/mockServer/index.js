const express =require('express');
const app = express();
app.get('/data/2.5/weather',(request,response)=>{
    response.json({
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
          "temp": 293.62,
          "feels_like": 293.18,
          "temp_min": 293.18,
          "temp_max": 297.65,
          "pressure": 1015,
          "humidity": 56
        },
        "visibility": 10000,
        "wind": {
          "speed": 5.66,
          "deg": 310
        },
        "clouds": {
          "all": 0
        },
        "dt": 1665956988,
        "sys": {
          "type": 1,
          "id": 3727,
          "country": "US",
          "sunrise": 1665930569,
          "sunset": 1665970039
        },
        "timezone": -25200,
        "id": 5720727,
        "name": "Corvallis",
        "cod": 200
      });
});

app.listen(3000,()=>{
    console.log("Server running on  3000");
});