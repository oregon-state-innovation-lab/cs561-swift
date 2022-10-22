
const express = require('express');

const app = express();

var path = require('path')
var bodyParser = require('body-parser')

app.use(express.static(path.join(__dirname, 'build')));

var dataController = require('./dataController');


// API route:
app.get('/data/2.5/weather', dataController.getData);

app.listen(7878, () => {
  console.log('The mock server is listening for request on port 7878');
});