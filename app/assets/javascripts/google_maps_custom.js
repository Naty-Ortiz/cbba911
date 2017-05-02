

function gmap_show(project) {
  var polyNE, polyNW,polyCN,polyCS,polySW,polySE;
    if ((project.latitude === null) || (project.longitude === null) ) {
        return 0;
    }

    var handler = Gmaps.build('Google');
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

      polyNW = handler.addPolygons(
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
        "strokeColor": "#1B592B",


        }
     );


      polyNE = handler.addPolygons(
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
        "strokeColor": "#1B592B",
        }

     );



      polyCN = handler.addPolygons(
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
        "strokeColor": "#1B592B",
        }

     );
   polyCS = handler.addPolygons(
       [
         [
         {lat:-17.392279, lng:-66.062984},
         {lat:-17.425039,lng: -66.243572},
         {lat: -17.442072, lng:-66.207866},
       ]
       ],
        {
        "strokeColor": "#1B592B",
        }

     );
     polySW = handler.addPolygons(
       [
         [
         {lat:-17.425039,lng: -66.243572},
         {lat: -17.442072, lng:-66.207866},
         {lat: -17.483238,  lng:-66.177096},
         {lat:-17.471953, lng:-66.216448},
       ]
       ],
        {
        "strokeColor": "#1B592B",
        }

     );
     polySE = handler.addPolygons(
       [
         [
          {lat: -17.442072, lng:-66.207866},
          {lat:-17.392279, lng:-66.062984},
          {lat: -17.433432, lng:-66.072673 },
          {lat: -17.483238,  lng:-66.177096},
       ]
       ],
        {
        "strokeColor": "#1B592B",
        }

     );
       
        handler.getMap().setZoom(13);


    
    });

   
    var coordinate = new google.maps.LatLng(project.latitude, project.longitude);                                                                                                                                                                                                       

     var isWithinPolygon =  handler.containsLocation(coordinate, polyCN);
    console.log("poli");
    console.log(isWithinPolygon);
 

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
 var southWest = new google.maps.LatLng( -17.465455, -66.160446);
var northEast = new google.maps.LatLng( -17.321628, -66.194778 );
var east = new google.maps.LatLng( -17.407151, -66.006637);
var west = new google.maps.LatLng( -17.394047, -66.285758 );
var defaultBounds = new google.maps.LatLngBounds( east,west );
var options = {
    bounds:defaultBounds,
    type:['establishment'],
    componentRestrictions:  {country: "BO",city: "BO.CB" }
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
       map: handler.getMap(),
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

function getColorBorder (prob){
  prob=prob.toFixed(0);
        if (prob>=0.0 && prob<=30){
       return "#1B592B";
       }
        if  (prob>=31 && prob<=49)
        {  return "#1231C8";
        }
      if (prob>=50 && prob<=79)
         {
         return "#E8F853";
       }
        if (prob>=80 && prob<=100.0)
        {
          return"#FFFFFF"  ;
        }
}



function gmap_show_polygons(list) {

var todayDate = new Date();
var todayHours = todayDate.getHours();
var todayMinutes =todayDate.getMinutes();
console.log( list);
console.log( "ist");
console.log(list[0]);
console.log(list[2]);
console.log(list[3]);
console.log(list[4]);
console.log(list[5]);


 var handler = Gmaps.build('Google');
     handler.buildMap({ internal: {id: 'map'},provider: { scrollwheel: false, zoomControl: false , draggable: false}}, function(){

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
        "strokeColor": getColorBorder(list[0]),


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
        "strokeColor": getColorBorder(list[1]),
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
        "strokeColor": getColorBorder(list[2]),
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
        "strokeColor": getColorBorder(list[3]),
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
        "strokeColor": getColorBorder(list[4]),
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
        "strokeColor": getColorBorder(list[5]),
        }

     );


var i;
  var arrDestinations = [
 {
      lat: -17.284131,
      lon:  -66.165636 ,
      title: "la probabilidad" +" "+"es" +  " "+list[0]+"%",
      description:"la probabilidad" +" "+"es" +  " "+list[0]+"%"
    },
    {
      lat: -17.253969,
      lon: -66.122377,
      title: "la probabilidad" +" "+"es" +  " "+list[1]+"%",
      description:"la probabilidad" +" "+"es" + " "+ list[1]+"%"
    },
     {
      lat: -17.365412,
      lon:  -66.147783,

      title: "la probabilidad" +" "+"es" +  list[2]+"%",
      description: "la probabilidad" +" "+"es" +  list[2]+"%"
    },
     {
      lat: -17.415341,
      lon:  -66.142593,

      title: "la probabilidad"+" " + "es" +" "+  list[3]+"%",
      description: "la probabilidad"+" " +"es" + " "+ list[3]+"%"
    },
     {
      lat: -17.468273,
      lon:   -66.211986,

      title: "la probabilidad"+" " +"es" + " "+ list[4]+"%",
      description: "la probabilidad"+" " +"es" + " "+ list[4]+"%"
    }, {
      lat:-17.453208,
      lon:  -66.131990 ,

      title: "la probabilidad"+" " +"es" + " "+ list[5]+"%",
      description: "la probabilidad"+" " +"es" + " "+ list[5]+"%"
    }
  ];

    var homeLatlng = new google.maps.LatLng(-17.442072, -66.207866);

  var myOptions = {
   
    center: homeLatlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP

  };





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





function bindInfoWindow(marker, map, infowindow, html) {
  google.maps.event.addListener(marker, 'click', function() {
    infowindow.setContent(html);
    infowindow.open(map, marker);
  });
}



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
