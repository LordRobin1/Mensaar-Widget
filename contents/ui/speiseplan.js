/**
 * Funktion, die den Speiseplan der Mensa Lübeck abruft
 * @param {Function} setSpeiseplan Die Funktion, an die der Speiseplan übergeben wird
 * @param {Number} mensa Der Index der Mensa (kann unter "General" bearbeitet werden)
 */
function fetchSpeiseplan(setSpeiseplan, mensa) {
    const mensen = ["sb", "mensagarten", "b4r1sta", "hom", "htwgtb", "htwcas", "htwcrb", "musiksb"]
    var xhr = new XMLHttpRequest();
    console.log(mensen[mensa])

    xhr.onreadystatechange = function () {
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
                let color = (counter.color.r << 16) + (counter.color.g << 8) + counter.color.b;
                meals.push({ 
                    name: meal.name,
                    components: meal.components,
                    price: meal.prices != null ? meal.prices.s + "€" : "N/A",
                    counter: counter.displayName, 
                    color: counter.color,
                })
            }
        }
        day.counters = meals;
    }
    return result.days
}
