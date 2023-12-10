const fs = require('fs');
const createCsvWriter = require('csv-writer').createObjectCsvWriter;

var placesMini = []

console.log("Start")
readJSONFile("./places.json").then(data => {
    let places = data["@graph"]

    console.log(places[47])
    places.forEach(place => {
        let placeMini = {
            id: place["@id"],
            //types: place["@type"]
        }

        if(Array.isArray(place["rdfs:label"])){
            let labels = place["rdfs:label"]
            labels.forEach(label => {
                if(label["@language"] == "en"){
                    placeMini["titleen"] = label["@value"]
                }
                if(label["@language"] == "fr"){
                    placeMini["titlefr"] = label["@value"]
                }
            })
        } else if(place["rdfs:label"]) {
            let label = place["rdfs:label"]
            if(label["@language"] == "en"){
                placeMini["titleen"] = label["@value"]
            }
            if(label["@language"] == "fr"){
                placeMini["titlefr"] = label["@value"]
            }
        }

        if(Array.isArray(place["rdfs:comment"])){
            let labels = place["rdfs:comment"]
            labels.forEach(label => {
                if(label["@language"] == "en"){
                    placeMini["descen"] = label["@value"]
                }
                if(label["@language"] == "fr"){
                    placeMini["descfr"] = label["@value"]
                }
            })
        } else if(place["rdfs:comment"] && place["rdfs:comment"]["@value"]) {
            let label = place["rdfs:comment"]
            if(label["@language"] == "en"){
                placeMini["descen"] = label["@value"]
            }
            if(label["@language"] == "fr"){
                placeMini["descfr"] = label["@value"]
            }
        }

        if(place["lastUpdate"]){
            placeMini["lastUpdate"] = place["lastUpdate"]["@value"]
        }

        if(place["hasContact"] && place["hasContact"]["schema:telephone"]){
            let contact = place["hasContact"]
            if(contact["schema:telephone"]){
                placeMini["telephone"] = place["hasContact"]["schema:telephone"]
            }
            if(contact["schema:email"]){
                placeMini["email"] = place["hasContact"]["schema:email"]
            }
            if(contact["foaf:homepage"]){
                placeMini["website"] = contact["foaf:homepage"]
            }
        }
        if(place["isLocatedAt"]){
            let isLocatedAt = place["isLocatedAt"]
            if(isLocatedAt["schema:address"]) {
                let address = place["isLocatedAt"]["schema:address"]
            
                placeMini["addresscity"] = address["schema:addressLocality"]
                placeMini["addresspostalCode"] = address["schema:postalCode"]
                placeMini["addressstreet"] = address["schema:streetAddress"]
            }
            
            if(isLocatedAt["schema:geo"]){
                let geo = isLocatedAt["schema:geo"]

                if(geo["schema:latitude"] && geo["schema:longitude"]){
                    let latitude = parseFloat(geo["schema:latitude"]["@value"])
                    let longitude = parseFloat(geo["schema:longitude"]["@value"])
                    placeMini["position"] = "["+latitude+","+longitude+"]"
                }
            }
        }

        if(place["hasBeenCreatedBy"]){
            let hasBeenCreatedBy = place["hasBeenCreatedBy"]
            placeMini["author"] = hasBeenCreatedBy["schema:legalName"]
        }
        placesMini.push(placeMini)
    });
    
}).then(()=>{
    console.log("mini", placesMini[47])
    
    const csvWriter = createCsvWriter({
        path: "./places.csv",
        header: [
          {id: 'id', title: 'id'},
          {id: 'titlefr', title: 'title'},
          {id: 'titleen', title: 'title-en'},
          {id: 'descfr', title: 'desc-fr'},
          {id: 'descen', title: 'desc-en'},
          {id: 'lastUpdate', title: 'lastUpdate'},
          {id: 'telephone', title: 'telephone'},
          {id: 'email', title: 'email'},
          {id: 'website', title: 'website'},
          
          {id: 'addresscity', title: 'addresscity'},
          {id: 'addresspostalCode', title: 'addresspostalCode'},
          {id: 'addressstreet', title: 'addressstreet'},

          {id: 'position', title: 'position'},
          {id: 'author', title: 'author'},
        ]
      });
      return csvWriter.writeRecords(placesMini)
}).then(()=> {
    console.log('step3 success')
}).catch(err => {
    console.error("step3 error", err.message)
});




function readJSONFile(filename){
    return new Promise((resolve, reject)=> {
        fs.readFile(filename, (err, data) => {
            if (err) reject(err);
            let parseddata = JSON.parse(data);
            resolve(parseddata)
        });
    })
}