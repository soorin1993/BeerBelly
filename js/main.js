var button = document.getElementById("button");
button.addEventListener("click", search);

var map;
var markers = [];

var styleDD = document.getElementById("style_dd")
var cityDD = document.getElementById("city_dd")

var city;
var style;

function initMap() {
	map = new google.maps.Map(document.getElementById('map'), {
		center: {lat: -34.397, lng: 150.644},
		zoom: 8,
		scrollwheel: false
	});
	
		
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var pos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };

        map.setCenter(pos);
      }, function() {
        handleLocationError(true, infoWindow, map.getCenter());
      });
    } else {
      // Browser doesn't support Geolocation
      handleLocationError(false, infoWindow, map.getCenter());
    }
}

function getData() {
	
	var request = new XMLHttpRequest();
	request.open("GET", "/data/" + city + ".json", false);
	request.send(null);
	var cityData = JSON.parse(request.responseText);

	var list = document.getElementById("brew_data");

	for (i = 0; i < cityData.data.length; i++) {
		var brewName = cityData.data[i].brewery.name;
		var streetName = cityData.data[i].streetAddress;
		var cityStateZip = cityData.data[i].locality + ", " + cityData.data[i].region + " " + cityData.data[i].postalCode;
		var website = cityData.data[i].brewery.website;
		var phone = cityData.data[i].brewery.phone;
		var lng = cityData.data[i].longitude;
		var lat = cityData.data[i].latitude;
		        
		var myLatLng = {lat: lat, lng: lng};

		var marker = new google.maps.Marker({
			position: myLatLng,
			map: map,
			title: brewName
		});
		
/*
		infoWindow = new google.maps.InfoWindow({
			title: brewName,
			content: brewWeb
		});
		
        google.maps.event.addListener(marker, 'click', function() {
			infoWindow.open(map,this);
        });
*/

   		markers.push(marker);


		var item = document.createElement('li');

		if (i % 2 == 0) {
			item.style.backgroundColor = "#521300";
			item.style.color = "#FFF1D7";
		}
		
		var brewNameItem = document.createElement('p');
		var brewStreet = document.createElement('p');
		var brewCityStateZip = document.createElement('p');
		var brewWeb = document.createElement('p');
		var brewPhone = document.createElement('p');

		brewNameItem.innerHTML = brewName;
		brewStreet.innerHTML = streetName;
		brewCityStateZip.innerHTML = cityStateZip;
		brewWeb.innerHTML = website;
		brewPhone.innerHTML = phone;
		
		item.appendChild(brewNameItem);
		item.appendChild(brewStreet);
		item.appendChild(brewCityStateZip);
		item.appendChild(brewWeb);
		item.appendChild(brewPhone);
		
		list.appendChild(item);
	}
	
	var bounds = new google.maps.LatLngBounds();
	for (var i = 0; i < markers.length; i++) {
		bounds.extend(markers[i].getPosition());
	}
	
	map.fitBounds(bounds);
}

function search() {

	if (markers.length > 0) {
		alert(markers.length);
		for (var j = 0; j < markers.length; j++) {
	        markers[j].setMap(null);
	        markers[j] = null;
	    }
	    markers = []
    }

	style = styleDD.options[styleDD.selectedIndex].value;
	city = cityDD.options[cityDD.selectedIndex].value;

	getData(city);
	

}
