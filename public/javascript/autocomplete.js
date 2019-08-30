let autocomplete = function (input, cityInput, stateInput, zipInput, latInput, lngInput) {
    if (!input) {
        console.log("Couldn't find the address input on this page.")
        return;
    }
    const dropdown = new google.maps.places.Autocomplete(input);
    dropdown.addListener("place_changed", () => {
        const place = dropdown.getPlace();
        let stateInfo = place.address_components.filter(x => {
            let forFilter = false;
            if (x["types"] && x["types"].includes("administrative_area_level_1")) {
                forFilter = true;
            }
            return forFilter;
        });
        let cityInfo = place.address_components.filter(x => {
            let forFilter = false;
            if (x["types"] && x["types"].includes("locality")) {
                forFilter = true;
            }
            return forFilter;
        });
        let zipInfo = place.address_components.filter(x => {
            let forFilter = false;
            if (x["types"] && x["types"].includes("postal_code")) {
                forFilter = true;
            }
            return forFilter;
        });
        let streetNumInfo = place.address_components.filter(x => {
            let forFilter = false;
            if (x["types"] && x["types"].includes("street_number")) {
                forFilter = true;
            }
            return forFilter;
        });
        let streetNameInfo = place.address_components.filter(x => {
            let forFilter = false;
            if (x["types"] && x["types"].includes("route")) {
                forFilter = true;
            }
            return forFilter;
        });
        input.value = streetNumInfo[0]["long_name"] + " " + streetNameInfo[0]["long_name"];
        cityInput.value = cityInfo[0]["long_name"];
        stateInput.value = stateInfo[0]["long_name"];
        zipInput.value = zipInfo.length > 0 ? zipInfo[0]["long_name"] : null;
        latInput.value = place.geometry.location.lat();
        lngInput.value = place.geometry.location.lng();
        // if someone hits enter on the address form, don't submit the whole form
        input.addEventListener("keydown", e => {
            if (e.keyCode == 13) {
                e.preventDefault();
            }
        });
    });
};

let addressInput = document.getElementById("browser_address");
let cityInput = document.getElementById("browser_city");
let stateInput = document.getElementById("browser_state");
let zipInput = document.getElementById("browser_zip");
let latInput = document.getElementById("browser_lat");
let lngInput = document.getElementById("browser_lng");

autocomplete(addressInput, cityInput, stateInput, zipInput, latInput, lngInput);