const rp = require('request-promise');
const request = require('request');
const fs = require('fs');
const csv = require('csv-parser');
const createCsvWriter = require('csv-writer').createObjectCsvWriter;

let REGION_FILTER = "limousin"

var places
var metadatas
var files
var results = []

let p1 = readJSONFile("./step2output/"+REGION_FILTER+"/SELECTION/metadata.json").then(_metadatas => {
    metadatas = _metadatas
})

let p2 = readCSVFile("./step1-output.csv").then(_places => {
    places = _places
})

let p3 = new Promise((resolve, reject) => {
    fs.readdir("./step2output/"+REGION_FILTER+"/SELECTION", function (err, files) {
        //handling error
        if (err)  reject(err)
        resolve(files)
    });
}).then(_files=> {
    files = _files
})

Promise.all([p1, p2, p3]).then(()=> {
    places.forEach(place => {
        
        if(place.region === REGION_FILTER){
            //console.log("place", place)
            let pageId = place["wiki-fr"]

            files.forEach(file => {
                //console.log("file", file)
                if(file.split("-")[0] === ""+pageId){
                    
                    let photoNumber = file.substring(file.indexOf('-')+1, file.indexOf('.'));
                    let metadata = metadatas[pageId][photoNumber];
                    //console.log(pageId, photoNumber, metadata)
                    place["photo-description"] = metadata.description
                    place["photo-credit"] = metadata.artist + " "+metadata.licence
                    place["photo-source"] = metadata.source
                }
            })
            results.push(place)
        }
        
    })
}).then(()=>{
    const csvWriter = createCsvWriter({
        path: 'step3-output.csv',
        header: [
          {id: 'title', title: 'title'},
          {id: 'title-en', title: 'title-en'},
          {id: 'category', title: 'category'},
          {id: 'region', title: 'region'},
          {id: 'position', title: 'position'},
          {id: 'website', title: 'website'},
          {id: 'address', title: 'address'},
          {id: 'desc-fr', title: 'desc-fr'},
          {id: 'desc-en', title: 'desc-en'},
          {id: 'wiki-fr', title: 'wiki-fr'},
          {id: 'wiki-en', title: 'wiki-en'},
          {id: 'popularity', title: 'popularity'},
          {id: 'credit-desc-fr', title: 'credit-desc-fr'},
          {id: 'credit-desc-en', title: 'credit-desc-en'},
          {id: 'photo-description', title: 'photo-description'},
          {id: 'photo-credit', title: 'photo-credit'},
          {id: 'photo-source', title: 'photo-source'},
        ]
      });
      return csvWriter.writeRecords(results)
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

function readCSVFile(filename){
    var places = []
    return new Promise((resolve) => {
        fs.createReadStream(filename).pipe(csv())
        .on('data', (row) => {
            //console.log(row);
            places.push(row)
        })
        .on('end', () => {
            console.log('CSV file successfully read');
            resolve(places)
        });
    })
}