const path = require('path');
const fs = require('fs');

const basePathToData = path.join(__dirname, './Response');

const getJsonData = function (basePathToData, filename) {
  var filename = path.join(basePathToData, filename);
  return JSON.parse(fs.readFileSync(filename, 'utf-8'));
};

exports.getData = function (request, response) {
  var data = getJsonData(basePathToData, 'Tucson.json');
  setTimeout(function() {
    return response.send(data);
  }, 200);
};
