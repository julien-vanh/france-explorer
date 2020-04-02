const csv = require('csv-parser');
const fs = require('fs');


generatePlaces().then(()=> {
    console.log("Places generated")
    return generateArticles()
}).then(()=>{
    console.log("Articles generated")
    return generateThirdParty()
}).then(() => {
    console.log("Finish !")
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

function generateThirdParty(){
    var results = []

    return readCSVFile("./TapFormsExport/ThirdPartyMentions.csv").then(lines => {
        lines.forEach(line => {
            let result = {
                title: line["title"],
                licence: line["licence"]
            }
            results.push(result)
        });
    }).then(()=> {
        
        let data = JSON.stringify(results);
        return new Promise((resolve, reject) => {
            fs.writeFile("./step4output/thirdPartyMentions.json", data, error => {
                if (error) reject(error);
                resolve();
            });
        });
    })
}

function generatePlaces(){
    var results = []

    return readCSVFile("./TapFormsExport/Places/Places.csv").then(places => {
        places.forEach(place => {
            let result = {
                id: place["id"],
                title: {
                    fr: place["title"].trim()
                },
                description: {},
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

            if(place["title-en"]){
                result["title"]["en"] = place["title-en"].trim()
            }
    
            if(place["address"] && place["address"] != ""){
                result["address"] = place["address"].trim()
            }
    
            if(place["website"] && place["website"] != ""){
                result["website"] = place["website"].trim()
            }
    
            if(place["photo"]){
                result["illustration"] = {
                    path: place["photo"],
                    description: place["photo-description"].trim(),
                    credit: place["photo-credit"].trim(),
                    source: place["photo-source"].trim()
                }
            }
    
            if(place["desc-fr"] && place["desc-fr"] != ""){
                result["description"]["fr"] = {
                    content: place["desc-fr"].trim(),
                    credit: place["credit-desc-fr"].trim()
                }
            }

            if(place["desc-en"] && place["desc-en"] != ""){
                result["description"]["en"] = {
                    content: place["desc-en"].trim(),
                    credit: place["credit-desc-en"].trim()
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
                title: {
                    fr: article["title"].trim()
                },
                description: {},
                iap: article["iap"] === "Non" ? false : true,
            }

            if(article["title-en"] && article["title-en"] != ""){
                result["title"]["en"] = article["title-en"].trim()
            }

            if(article["desc-fr"] && article["desc-fr"] != ""){
                result["description"]["fr"] = article["desc-fr"].trim()
            }
            
            if(article["desc-en"] && article["desc-en"] != ""){
                result["description"]["en"] = article["desc-en"].trim()
            }

            if(article["photo"]){
                result["illustration"] = {
                    path: article["photo"],
                    description: article["photo-description"].trim(),
                    credit: article["photo-credit"].trim(),
                    source: article["photo-source"].trim()
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