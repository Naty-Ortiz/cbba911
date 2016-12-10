

function gmap_show(project) {
    if ((project.latitude === null) || (project.longitude === null) ) {
        return 0;
    }

    handler = Gmaps.build('Google');
    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
        markers = handler.addMarkers([
            {
                "lat": project.latitude,
                "lng": project.longitude,
                "picture": {
                    //"url": 'http://www.planet-action.org/img/2009/interieur/icons/orange-dot.png',
                    "width":  32,
                    "height": 32
                }
            }
        ]);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
        handler.getMap().setZoom(17);
    });
}


function gmap_form(project) {
    handler = Gmaps.build('Google');
    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
        if (project && project.latitude && project.longitude) {
            markers = handler.addMarkers([
                {
                    "lat": project.latitude,
                    "lng": project.longitude,
                    "picture": {
                        "url": 'http://maps.google.com/mapfiles/ms/icons/green-dot.png',
                        "width":  32,
                        "height": 32
                    }
                }
            ]);
            handler.bounds.extendWith(markers);
            handler.fitMapToBounds();
            handler.getMap().setZoom(17);
        }
        else {
            handler.fitMapToBounds();
            handler.map.centerOn([-17.3941855, -66.1585695]);
            handler.getMap().setZoom(18);
        }
    });

    var markerOnMap;

    function placeMarker(location) {
        if (markerOnMap) {
            markerOnMap.setPosition(location);
        }
        else {
            markerOnMap = new google.maps.Marker({
                position: location,
                map: handler.getMap()
            });
        }
    }

    if(document.getElementById("map_lat").value !== ""){
        placeMarker(new google.maps.LatLng(document.getElementById("map_lat").value, document.getElementById("map_lng").value));
    }

    google.maps.event.addListener(handler.getMap(), 'click', function(event) {
        placeMarker(event.latLng);
        document.getElementById("map_lat").value = event.latLng.lat();
        document.getElementById("map_lng").value = event.latLng.lng();
    });


    var input = document.getElementById('pac-input');
 var searchBox = new google.maps.places.SearchBox(input);
 handler.getMap().controls[google.maps.ControlPosition.TOP_LEFT].push(input);

 // Bias the SearchBox results towards current map's viewport.

 var options = {

  componentRestrictions: {country: "bol"}
 };


 var autocomplete = new google.maps.places.Autocomplete(input, options);


handler.getMap().addListener('bounds_changed', function() {
   searchBox.setBounds(handler.getMap().getBounds());
 });
handler.getMap().setZoom(38);
 var markers = [];
 // Listen for the event fired when the user selects a prediction and retrieve
 // more details for that place.
 searchBox.addListener('places_changed', function() {
   var places = searchBox.getPlaces();

   if (places.length === 0) {
     return;
   }

   // Clear out the old markers.
   markers.forEach(function(marker) {
     marker.setMap(null);
   });
   markers = [];

   // For each place, get the icon, name and location.
   var bounds = new google.maps.LatLngBounds();
   places.forEach(function(place) {
     var icon = {
       url: place.icon,
       size: new google.maps.Size(71, 71),
       origin: new google.maps.Point(0, 0),
       anchor: new google.maps.Point(17, 34),
       scaledSize: new google.maps.Size(25, 25)
     };

     // Create a marker for each place.
     markers.push(new google.maps.Marker({
       map: map,
       icon: icon,
       title: place.name,
       position: place.geometry.location
     }));

     if (place.geometry.viewport) {
       // Only geocodes have viewport.
       bounds.union(place.geometry.viewport);
     } else {
       bounds.extend(place.geometry.location);
     }
   });
  handler.getMap().fitBounds(bounds);
 });
 handler.getMap().setZoom(18);

}


function gmap_show_polygons(numberN,numberW,numberS,NE,NW,CN,CS,SE,SW) {
  
var colorNW;
var colorNE;
var colorCN;
var colorCS;
var colorSE;
var colorSO;

 if ((numberN>=numberS&&numberN>=numberW)&&(numberW<numberS)){
           colorW="#2EFE64";
       colorN ="#FFFF00";
        colorS="#FF000";
 }
   else if((numberS>=numberN)&&(numberS>=numberW)){
       colorN="#2EFE64";
       colorS ="#FFFF00";
        colorW="#FF0000";
    
      console.log("numberN");
    }

  
  
 var handler = Gmaps.build('Google');
     handler.buildMap({ internal: {id: 'map'}}, function(){
      marker = handler.addMarkers([
                {
                    "lat":-17.442072,
                    "lng": -66.207866,
                    "picture": {
                        "url": 'http://maps.google.com/mapfiles/ms/icons/green-dot.png',
                        "width":  32,
                        "height": 32
                    },
                    "infowindow": "la probabilidad es"+NE
                }
            ]);
          marker2 = handler.addMarkers([
                {
                    "lat":-17.186415,
                    "lng": -66.150529,
                    "picture": {
                        "url": 'http://maps.google.com/mapfiles/ms/icons/green-dot.png',
                        "width":  32,
                        "height": 32
                    },
                    "infowindow": "la probbilidad es"+NW
                }
            ]);
     var polyNW = handler.addPolygons(
       [
         [
           {lat: -17.185103, lng: -66.161516}, 
           {lat: -17.186415, lng: -66.150529},
           {lat:-17.187727,  lng: -66.145723},  
           {lat: -17.200846, lng: -66.147783},
           {lat: -17.210029, lng: -66.149843}, 
           {lat: -17.282164, lng: -66.145036},
           {lat:-17.303144,  lng: -66.143663}, 
           {lat:-17.349028,  lng: -66.141603},
           {lat: -17.344440, lng: -66.210268},  
         ]
       ],
        {
        "strokeColor": colorN

      
        }
     );


     var polyNE = handler.addPolygons(
       [
      [
       {lat:-17.246756,lng:-66.107957},
       {lat:-17.187727,lng:-66.145723},     
       {lat:-17.282164,lng:-66.145036},
       {lat:-17.303144,lng:-66.143663}, 
       {lat:-17.349028,lng:-66.141603},
       {lat:-17.307733,lng:-66.061265 }, 
         ]
       ],
        {
        "strokeColor": colorW,
        } 

     );



      var polyCN = handler.addPolygons(
       [
         [
         { lat:-17.392279,lng:-66.062984},
         { lat:-17.307733,lng:-66.061265}, 
         { lat:-17.349028,lng:-66.141603},
         { lat:-17.344440,lng:-66.210268},
         { lat:-17.425039,lng:-66.243572},      
          ]
       ],
        {
        "strokeColor": colorN,
        } 

     );
var polyCS = handler.addPolygons(
       [
         [
         {lat:-17.392279, lng:-66.062984},
         {lat:-17.425039,lng: -66.243572},
         {lat: -17.442072, lng:-66.207866},
       ]
       ],
        {
        "strokeColor": colorN,
        } 

     );
var polySW = handler.addPolygons(
       [
         [
         {lat:-17.425039,lng: -66.243572},
         {lat: -17.442072, lng:-66.207866},
         {lat: -17.483238,  lng:-66.177096},
         {lat:-17.471953, lng:-66.216448},         
       ]
       ],
        {
        "strokeColor": colorS,
        } 

     );
var polySE = handler.addPolygons(
       [
         [     
          {lat: -17.442072, lng:-66.207866},
          {lat:-17.392279, lng:-66.062984},
          {lat: -17.433432, lng:-66.072673 },
          {lat: -17.483238,  lng:-66.177096},   
       ]
       ],
        {
        "strokeColor": colorW,
        } 

     );
function initialize() {


var i;
  var arrDestinations = [
    {
      lat: -17.433432, 
      lon: -66.072673, 

      title: "probabilidad", 
      description: "es" + NE 
    },
    {
      lat: -17.346734, 
      lon:  -66.110017,
      title: "probabilidad", 
      description:"es" + NW
    },
    {
      lat: -17.246756, 
      lon: -66.107957,
      title: "English's", 
      description: CN
    }
  ];
  
    var homeLatlng = new google.maps.LatLng(-17.442072, -66.207866);

  var myOptions = {
    zoom: 15,
    center: homeLatlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

 
 var infowindow1 =  new google.maps.InfoWindow({
    content: "la probabilidad es "+ NE,
    map: handler.getMap(),
    position: new google.maps.LatLng( -17.277247, -66.182802)
  });
  var infowindow2 =  new google.maps.InfoWindow({
    content:"la probabilidad es "+  NW,
    map: handler.getMap(),
    position:new google.maps.LatLng(-17.346734, -66.110017)
  });
  var infowindow3 =  new google.maps.InfoWindow({
    content: "la probabilidad es "+ CN,
    map: handler.getMap(),
    position: new google.maps.LatLng( -17.370327, -66.149156)
  });
  

  var infowindow =  new google.maps.InfoWindow({
    content: ''
  });

  // loop over our array
  for (i = 0; i < arrDestinations.length; i++) {
    // create a marker
    var marker = new google.maps.Marker({
      title: arrDestinations[i].title,
      position: new google.maps.LatLng(arrDestinations[i].lat, arrDestinations[i].lon),
      map: handler.getMap()
    });
    
    // add an event listener for this marker
    bindInfoWindow(marker, map, infowindow, "<p>" + arrDestinations[i].description + "</p>");
    
    infowindow.setContent( "<p>" + arrDestinations[i].description + "</p>"); 
    
  }
}

function bindInfoWindow(marker, map, infowindow, html) { 
  google.maps.event.addListener(marker, 'click', function() { 
    infowindow.setContent(html); 
    infowindow.open(map, marker); 
  }); 
} 

google.maps.event.addDomListener(window, 'load', initialize);
     handler.bounds.extendWith(marker);
    handler.bounds.extendWith(marker2);
 
     handler.map.centerOn([-17.3941855, -66.1585695]);
     handler.bounds.extendWith(polyNW);
    
     handler.bounds.extendWith(polyNE);
     handler.bounds.extendWith(polyCN);
     handler.bounds.extendWith(polyCS);
     handler.bounds.extendWith(polySW);
     handler.bounds.extendWith(polySE);
     handler.fitMapToBounds();
     handler.getMap().setZoom(12);
   });
}
