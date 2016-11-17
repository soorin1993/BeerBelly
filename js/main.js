/* map */
var map;
function initMap() {
map = new google.maps.Map(document.getElementById('map'), {
  center: {lat: -34.397, lng: 150.644},
  zoom: 8
});
var infoWindow = new google.maps.InfoWindow({map: map});

        // Try HTML5 geolocation.
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(function(position) {
            var pos = {
              lat: position.coords.latitude,
              lng: position.coords.longitude
            };

            infoWindow.setPosition(pos);
            infoWindow.setContent('Location found.');
            map.setCenter(pos);
          }, function() {
            handleLocationError(true, infoWindow, map.getCenter());
          });
        } else {
          // Browser doesn't support Geolocation
          handleLocationError(false, infoWindow, map.getCenter());
        }
}

search()
/* brewery db */
/*

var URL = "http://api.brewerydb.com/v2/beers/?key=546e79849610632a56e3ea49a776f1ba&name=bud+light"

var req = new XMLHttpRequest();
req.open("get", URL, true);
req.addEventListener('load', function() {
  if(req.status >= 200 && req.status < 400) {
    var response = JSON.parse(req.responseText);
    var numberOfResults = response.totalResults;
    console.log(numberOfResults);
  } else {
    console.log("Error in network request: " + req.statusText);
  }
});
req.send(null);
*/

function search() {
	//daURL = "http://52.40.59.238:3000/";

		//var searchInput = document.getElementById('searchInput').value;
		//var textToSubmit = "?search=" + searchInput;
		//var textToSubmit = "?search=" + "fat";
		var newURL = "http://api.brewerydb.com/v2/beers/?key=546e79849610632a56e3ea49a776f1ba&name=bud+light"
		//var newURL = daURL + textToSubmit;
		var req = new XMLHttpRequest();
		req.open("get", newURL, true);
		req.addEventListener('load', function() {
			if(req.status >= 200 && req.status < 400) {
				var response = JSON.parse(req.responseText);
				response.headers = "Access-Control-Allow-Origin: *";
				var numberOfResults = response.totalResults;
				console.log(numberOfResults);
				showResults(response);		

			$("#search-result").text("Search results for: " + searchInput);
			
				
			} else {
				console.log("Error in network request: " + req.statusText);
			}
		});
		req.send(null);
}
