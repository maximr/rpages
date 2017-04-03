var mapInitializer = (function(key, color, container, saturation) { 

  var map_container  = $('#' + container);
  var api_key        = key;
  var color          = color;
  var saturation     = saturation;
  var rawLatLng      = null;
  var parsedLatLng   = null;
  var mapStyles      = null;
  var styledMap      = null;
  var gMapObject     = null;
  var mapMarker      = null;
  var scriptURL      = null;

  function init() {
    if(map_container.length && map_container.data("coordinates")) { 
      _getCoordinates();
      _setScriptURL();
      _buildMap();
    }
  }

  function _getCoordinates() {
    rawLatLng = map_container.data("coordinates").split(',');
    parsedLatLng = {lat: parseFloat(rawLatLng[0]), lng: parseFloat(rawLatLng[1])};
  }

  function _setScriptURL() {
    scriptURL = 'https://maps.googleapis.com/maps/api/js?key=' + api_key;
  }

  function _setStyles() {
    mapStyles = [
      {
        featureType: "all",
        stylers: [
          { hue: color },
          { saturation: ( saturation * -0.8 ) }
        ]
      },{
        featureType: "road.arterial",
        elementType: "geometry",
        stylers: [
          { hue: color },
          { saturation: saturation }
        ]
      },{
        featureType: "poi.business",
        elementType: "labels",
        stylers: [
          { visibility: "off" }
        ]
      }
    ];
  }

  function _createGMapObject() {
    gMapObject = new google.maps.Map(document.getElementById(container), {
      center: parsedLatLng,
      zoom: 15,
      scrollwheel: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDefaultUI: true
    });
  }

  function _setMarker() {
    mapMarker = new google.maps.Marker({
      position: parsedLatLng,
      map: gMapObject,
      title: map_container.data('marker-title')
    });
  }

  function _buildMap() {
    if(!$.mapScriptLoaded) {
      $.loadScript(scriptURL, function(){
        $.mapScriptLoaded = true;
        doTheMagic();
      });
    } else {
      doTheMagic();
    }
  }

  function doTheMagic() {
    setTimeout(function(){ 
      _setStyles();

      StyledMap = new google.maps.StyledMapType(mapStyles, {name: "Styled Custom Map"});
      _createGMapObject();
      _setMarker();

      gMapObject.mapTypes.set('map_style', StyledMap);
      gMapObject.setMapTypeId('map_style');

      google.maps.event.trigger(gMapObject, "resize");
    }, 800);
  }


  return { build: init() }
});