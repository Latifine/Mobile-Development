/* Implementation of AR-Experience (aka "World"). */
var World = {
    /* True once data was fetched. */
    initiallyLoadedData: false,

    /* Different POI-Marker assets. */
    markerDrawableIdle: null,
    markerDrawableSelected: null,

    /* List of AR.GeoObjects that are currently shown in the scene / World. */
    markerList: [],

    /* the last selected marker. */
    currentMarker: null,
    /* Called to inject new POI data. */
    loadPoisFromJsonData: function loadPoisFromJsonDataFn(poiData) {
        /* Empty list of visible markers. */
        World.markerList = [];

        /* Start loading marker assets. */
        World.markerDrawableIdle = new AR.ImageResource("assets/marker_idle.png", {
            onError: World.onError
        });
        World.markerDrawableSelected = new AR.ImageResource("assets/marker_selected.png", {
            onError: World.onError
        });

        /* Loop through POI-information and create an AR.GeoObject (=Marker) per POI. */
        for (var currentPlaceNr = 0; currentPlaceNr < poiData.length; currentPlaceNr++) {
            var singlePoi = {
                "id": poiData[currentPlaceNr].id,
                "latitude": parseFloat(poiData[currentPlaceNr].latitude),
                "longitude": parseFloat(poiData[currentPlaceNr].longitude),
                "description": poiData[currentPlaceNr].description,
                "language_id": poiData[currentPlaceNr].language_id,
                "translation": poiData[currentPlaceNr].translation,
            };

            /*
                To be able to deselect a marker while the user taps on the empty screen, the World object holds an
                 array that contains each marker.
            */
            World.markerList.push(new Marker(singlePoi));
        }

        World.updateStatusMessage(currentPlaceNr + ' places loaded');
    },

    /* Updates status message shown in small "i"-button aligned bottom center. */
    updateStatusMessage: function updateStatusMessageFn(message, isWarning) {
        document.getElementById("popupButtonImage").src = isWarning ? "assets/warning_icon.png" : "assets/info_icon.png";
        document.getElementById("popupButtonTooltip").innerHTML = message;
    },

    /* Location updates, fired every time you call architectView.setLocation() in native environment. */
    locationChanged: function locationChangedFn(lat, lon, alt, acc) {

        /*
            The custom function World.onLocationChanged checks with the flag World.initiallyLoadedData if the
            function was already called. With the first call of World.onLocationChanged an object that contains geo
            information will be created which will be later used to create a marker using the
            World.loadPoisFromJsonData function.
        */
        if (!World.initiallyLoadedData) {
            /*
                requestDataFromLocal with the geo information as parameters (latitude, longitude) creates different
                poi data to a random location in the user's vicinity.
            */
            World.requestDataFromLocal(lat, lon);
            World.initiallyLoadedData = true;
        }
    },

    /* Fired when user pressed marker on screen. */
    onMarkerSelected: function onMarkerSelectedFn(marker) {
        /* Pop up shows up, if you click on 'Ok' the data of the collected word will be send to the flutter app */
        var confirmation = confirm("Do you want to collect '" + marker.poiData.description + "'");
        if (confirmation) {
            var id = marker.poiData.id //!!VERWIJDER DEZE VAR!!
            var word = marker.poiData.description
            var language_id = marker.poiData.language_id
            var translation = marker.poiData.translation
            console.log("Collected " + marker.poiData.description);
            var dataToSend = {id:id,word : word, language_id:language_id,translation:translation}; //!!VERWIJDER id:id!!
            fetch('https://74cd-2a02-1810-a68b-8c00-e422-1a8d-ad73-5406.ngrok-free.app/collected_words', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'ngrok-skip-browser-warning': 'true'
                },
                body: JSON.stringify(dataToSend)
            })
        }
        else{
            console.log("Did not collect " + marker.poiData.description)
        }
        
        /* Deselect previous marker. */
        if (World.currentMarker) {
            if (World.currentMarker.poiData.id === marker.poiData.id) {
                return;
            }
            World.currentMarker.setDeselected(World.currentMarker);
        }

        /* Highlight current one. */
        marker.setSelected(marker);
        World.currentMarker = marker;

        marker.setDeselected(marker);
        World.currentMarker = null;

    },

    /* Screen was clicked but no geo-object was hit. */
    onScreenClick: function onScreenClickFn() {
        if (World.currentMarker) {
            World.currentMarker.setDeselected(World.currentMarker);
        }
    },

    /* Request POI data. */
    requestDataFromLocal: function requestDataFromLocalFn(centerPointLatitude, centerPointLongitude) {
        var poisToCreate = 5;
        var poiData = [];
        var fetchPromises = [];
        /* Sends an API call to the flutter app to recieve the data of a random words and adds the value's to the POI data*/
        for (var i = 0; i < poisToCreate; i++) {
            var randomId = Math.floor(Math.random() * 15) + 1;
            fetchPromises.push(
                fetch('https://74cd-2a02-1810-a68b-8c00-e422-1a8d-ad73-5406.ngrok-free.app/words/' + randomId, {
                    headers: {
                        'ngrok-skip-browser-warning': 'true'
                    }
                })
                .then(response => response.json())
                .then(json => {
                    var id = json.id // !!VERWIJDER DEZE VAR!!
                    var word = json.word;
                    var language_id = json.language_id
                    var translation = json.translation
                    poiData.push({
                        "id": id, // !!VERANDER NAAR (i+1)!!
                        "longitude": (centerPointLongitude + (Math.random() / 5 - 0.1)),
                        "latitude": (centerPointLatitude + (Math.random() / 5 - 0.1)),
                        "description": (word),
                        "language_id": language_id,
                        "translation": translation
                    });
                })
                .catch(error => console.error("API request failed: " + error))
            );
        }
    
        Promise.all(fetchPromises)
            .then(() => {
                console.log(poiData); // Now the data is available
                World.loadPoisFromJsonData(poiData);
            });
    },
};

/*
    Set a custom function where location changes are forwarded to. There is also a possibility to set
    AR.context.onLocationChanged to null. In this case the function will not be called anymore and no further
    location updates will be received.
*/
AR.context.onLocationChanged = World.locationChanged;

/*
    To detect clicks where no drawable was hit set a custom function on AR.context.onScreenClick where the
    currently selected marker is deselected.
*/
AR.context.onScreenClick = World.onScreenClick;