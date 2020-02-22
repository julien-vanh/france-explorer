const csv = require('csv-parser');
const fs = require('fs');

results = []

readCSVFile("./Places.csv").then(places => {
    places.forEach(place => {
        let result = {
            id: place["id"],
            title: place["title"],
            category: place["category"],
            regionId: place["region"],
            iap: place["iap"] === "Non"? false: true,
            popularity: parseInt(place["popularity"]),
            position: {
                lat: parseFloat(place["position (Latitude)"]),
                lon: parseFloat(place["position (Longitude)"])
            },
            wikiPageId: parseInt(place["wiki-fr"])
        }

        if(place["address"] && place["address"] != ""){
            result["address"] = place["address"]
        }

        if(place["website"] && place["website"] != ""){
            result["website"] = place["website"]
        }

        if(place["photo"]){
            result["illustration"] = {
                path: place["photo"],
                description: place["photo-description"],
                credit: place["photo-credit"],
                source: place["photo-source"]
            }
        }

        if(place["desc-fr"]){
            result["descriptionFr"] = {
                title: place["title"],
                description: place["desc-fr"],
                credit: place["credit-desc-fr"],
                wikiPageId: parseInt(place["wiki-fr"])
            }
        }
        if(place["desc-en"]){
            result["descriptionEn"] = {
                title: place["title-en"],
                description: place["desc-en"],
                credit: place["credit-desc-en"],
                wikiPageId: parseInt(place["wiki-en"])
            }
        }

        results.push(result)
    });
}).then(()=> {
    //console.log(photosData)
    let data = JSON.stringify(results);
    return new Promise((resolve, reject) => {
        fs.writeFile("./places.json", data, error => {
            if (error) reject(error);
            resolve();
        });
    });
}).then(()=>{
    "Finish !"
}).catch(err=> {
    console.error(err.message)
})


function readCSVFile(filename){
    var places = []
    return new Promise((resolve) => {
        fs.createReadStream(filename).pipe(csv())
        .on('data', (row) => {
            //console.log(row);
            places.push(row)
        })
        .on('end', () => {
            console.log('CSV file successfully processed');
            resolve(places)
        });
    })
}