const csv = require('csv-parser');
const fs = require('fs');


generatePlaces().then(()=> {
    return generateArticles()
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

function generatePlaces(){
    var results = []

    return readCSVFile("./TapFormsExport/Places/Places.csv").then(places => {
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
            fs.writeFile("./step4output/places.json", data, error => {
                if (error) reject(error);
                resolve();
            });
        });
    })
}


function generateArticles(){
    var places = []
    var results = []

    return readCSVFile("./TapFormsExport/Articles/Table-places.csv").then(_places => {
        places = _places
    }).then(()=> {
        return readCSVFile("./TapFormsExport/Articles/Articles.csv")
    }).then(articles => {
        articles.forEach(article => {
            let result = {
                id: article["id"],
                title: article["title"],
                iap: article["iap"] === "Non"? false: true,
            }

            if(article["desc-fr"]){
                result["descriptionFr"] = {
                    title: article["title"],
                    description: article["desc-fr"]
                }
            }
            if(article["desc-en"]){
                result["descriptionEn"] = {
                    title: article["title-en"],
                    description: article["desc-en"]
                }
            }
            var placesIds = []
            places.forEach(place => {
                if(place["parent_record_id"] === article["form_record_id"]){
                    placesIds.push({
                        placeId: place["placeId"],
                        order: parseInt(place["order"])
                    })
                }
            })
            result["places"] = placesIds

            results.push(result)
        });
    }).then(()=> {
        
        let data = JSON.stringify(results);
        return new Promise((resolve, reject) => {
            fs.writeFile("./step4output/articles.json", data, error => {
                if (error) reject(error);
                resolve();
            });
        });
    })
}