/**
 * Funktion, die den Speiseplan der Mensa Lübeck abruft
 * @param {Function} setSpeiseplan Die Funktion, an die der Speiseplan übergeben wird
 * @param {Number} mensa Der Index der Mensa (kann unter "General" bearbeitet werden)
 */
function fetchSpeiseplan(setSpeiseplan, mensa) {
    const mensen = ["sb", "mensagarten", "b4r1sta", "hom", "htwgtb", "htwcas", "htwcrb", "musiksb"]
    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = () => {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                const responseText = xhr.responseText;
                const result = JSON.parse(responseText);
                const formated = format(result)
                setSpeiseplan(formated);
            } else {
                console.error(`Fehler beim Abrufen des Speiseplans für ${mensen[mensa]}. Statuscode: ${xhr.status}`);
            }
        }
    };
    xhr.open("GET", `https://mensaar.de/api/2/TFtD8CTykAXXwrW4WBU4/1/de/getMenu/${mensen[mensa]}`);
    xhr.send();
}  
function format(result) {
    for (let day of result.days) {
        var meals = [];

        for (let counter of day.counters) {

            for (let meal of counter.meals) {
                meals.push({ 
                    name: meal.name,
                    components: meal.components,
                    prices: meal.prices,
                    counter: counter.displayName, 
                    counter_desc: counter.description,
                    color: counter.color,
                })
            }
        }
        day.counters = meals;
    }
    return result.days
}

/**
 * @param {Function} setBaseData Die Funktion, an die die Basisdaten übergeben werden
*/
function fetchBaseData(setBaseData) {
    let xhr = new XMLHttpRequest();

    xhr.onreadystatechange = () => {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                const responseText = xhr.responseText;
                const result = JSON.parse(responseText);
                setBaseData({locations: result.locations, priceTiers: result.priceTiers});
            } else {
                console.error(`Fehler beim Abrufen der Basisdaten. Statuscode: ${xhr.status}`);
            }
        }
    };
    xhr.open("GET", `https://mensaar.de/api/2/TFtD8CTykAXXwrW4WBU4/1/de/getBaseData`)
    xhr.send();
}
