const rp = require('request-promise');
const request = require('request');
const fs = require('fs');
const csv = require('csv-parser');
const download = require('image-downloader')

let REGION_FILTER = "aquitaine"

var cpt = 0
let photosData = {}

let clean = new Promise((resolve, reject) => {
    fs.rmdir("./step2output/"+REGION_FILTER, {recursive: true}, (err) => {
        if(err) reject(err)
        resolve()
    })
})

clean.then(()=>{
    return readCSVFile('step1-output.csv')
}).then(places => {
    let promises = []

    places.forEach(place => {
        if(typeof place['wiki-fr'] === "string" && place['wiki-fr'] != ""){
            let pageId = place['wiki-fr']
            let region = place.region
            let title = place.title.replace(/[^0-9a-z]/gi, '')
            
            if(region === REGION_FILTER){
                let p = getPhotos(pageId, region, title).then(data => {
                    photosData[pageId] = data
                })
                promises.push(p)
            }
        }
    })
    return Promise.all(promises)
}).then(()=> {
    //console.log(photosData)
    let data = JSON.stringify(photosData);
    return new Promise((resolve, reject) => {
        fs.writeFile("./step2output/"+REGION_FILTER+"/SELECTION/metadata.json", data, error => {
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

function getPhotos(pageId, region, title){
    let photos = {}

    var options = {
        uri: "https://fr.wikipedia.org/w/api.php?action=query&pageids="+pageId+"&generator=images&gimlimit=45&prop=imageinfo&iiprop=url|mime|extmetadata&iiextmetadatafilter=ImageDescription|LicenseShortName|Artist&format=json",
        json: true
    };

    return rp(options).then( data => {
        let promise = Promise.resolve()
        
        Object.values(data.query.pages).forEach((page, index) => {
            if(page.imageinfo[0].mime === "image/jpeg"){
                
                let extmetadata = page.imageinfo[0].extmetadata
                var description, artist, licence;
                if(extmetadata.ImageDescription){
                    description = removeHTMLTags(extmetadata.ImageDescription.value)
                }
                if(extmetadata.Artist){
                    artist = removeHTMLTags(extmetadata.Artist.value)
                }
                if(extmetadata.LicenseShortName){
                    licence = removeHTMLTags(extmetadata.LicenseShortName.value)
                }
                
                let imageUrl = page.imageinfo[0].url

                photos[""+index] = {
                    description: description,
                    artist: artist,
                    licence: licence,
                    source: page.imageinfo[0].descriptionshorturl
                }

                fs.mkdirSync("./step2output/"+REGION_FILTER+"/SELECTION", { recursive: true }, (err) => {
                    if (err) console.log("err", err)
                });
                
                let foldername = "./step2output/"+REGION_FILTER+"/"+title
                let filename = pageId+"-"+index+".jpeg"
                promise.then(()=> {
                    return downloadImage(imageUrl, foldername, filename).catch(err => {console.log("error downloanding ", filename)})
                })
            }
        })

        return promise.then(()=> {
            return photos
        })
    })
}

function removeHTMLTags(str){
    if(typeof(str) === "string"){
        return str.replace(/<\/?[^>]+(>|$)/g, "").trim()
    }
    else return null
}

function downloadImage(url, foldername, filename){
    console.log("downloading : "+foldername+"/"+filename);
    fs.mkdirSync(foldername, { recursive: true }, (err) => {
        if (err) console.log("err", err)
    });
    cpt = cpt + 1

    let options = {
        url: url,
        dest: foldername+"/"+filename,
        timeout: 10* 60 * 1000  
    }
    
    return download.image(options).then(({ filename, image }) => {
        cpt = cpt-1
        console.log('Saved to', filename, cpt)
        
    }).catch((err) => console.error(err))
}

