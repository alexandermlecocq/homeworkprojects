// Creating map object
var myMap = L.map("map-id", {
  center: [37.0902, -95.7129],
  zoom: 4
});

// Adding tile layer
L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
  attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
  maxZoom: 18,
  id: "mapbox.streets",
  accessToken: API_KEY
}).addTo(myMap);

// Link to GeoJSON
var APILink = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson";

// Function adapted from https://stackoverflow.com/questions/7128675/from-green-to-red-color-depend-on-percentage
function chooseColor(magnitude) {
  var H_value = (1 - (magnitude / 7))*100;
  if (H_value < 0){
    H_value = 0;
  };
  return 'hsl(' + H_value + ', 100%, 50%)';
};

// UTC conversion based on https://stackoverflow.com/questions/4631928/convert-utc-epoch-to-local-date
function getTime(utcSeconds) {
  var d = new Date(0);
  d.setUTCSeconds(utcSeconds);
  return d;
};


// Grab data with d3
d3.json(APILink).then(function(data) {
  var features = data.features;
  features.forEach(feature => {
    var coordinates = feature.geometry.coordinates;
    var color = chooseColor(feature.properties.mag);
    var time = getTime(feature.properties.time);

    L.circle([coordinates[1], coordinates[0]], {
      color: color,
      fillColor: color,
      opacity: 0.75,
      fillOpacity: 0.75,
      radius: feature.properties.mag**2 * 4000
    }).bindPopup(
      feature.properties.place + "<br>" +
      "<strong>Magnitude:</strong> " + feature.properties.mag + "<br>" +
      "<strong>Date:</strong> " + time
      ).addTo(myMap);
  });

});
