const rp = require('request-promise');
const request = require('request');
const fs = require('fs');

let rawdata = fs.readFileSync('step1-output.json');
let mymapsplaces = JSON.parse(rawdata);

let promises = []
let photosData = {}
mymapsplaces.forEach(place => {
    if(place.wiki){
        let pageId = place.wiki
        let region = place.region
        let title = place.title.replace(/[^0-9a-z]/gi, '')
        
        if(region === "alsace"){
            let p = getPhotos(pageId, region, title).then(data => {
                photosData[pageId] = data
            })
            promises.push(p)
        }
    }
})
Promise.all(promises).then(()=> {
    console.log(photosData)
    let data = JSON.stringify(photosData);
    return new Promise((resolve, reject) => {
        fs.writeFile("step2-output.json", data, error => {
            if (error) reject(error);
            resolve();
        });
    });
}).then(()=>{
    "Finish !"
}).catch(err=> {
    console.error(err.message)
})



function getPhotos(pageId, region, title){
    let photos = {}

    var options = {
        uri: "https://fr.wikipedia.org/w/api.php?action=query&pageids="+pageId+"&generator=images&gimlimit=35&prop=imageinfo&iiprop=url|mime|extmetadata&iiextmetadatafilter=ImageDescription|LicenseShortName|Artist&format=json",
        json: true
    };

    return rp(options).then( data => {
        let promises = [];
        
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
                
                let foldername = "./photos/"+region+"/"+title
                let filename = pageId+"-"+index+".jpeg"
                promises.push(downloadImage(imageUrl, foldername, filename).catch(err => {console.log("error downloanding ", filename)}))
            }
        })

        return Promise.all(promises).then(()=> {
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
    fs.mkdirSync(foldername, { recursive: true }, (err) => {
        if (err) console.log("err", err)
      });

    return new Promise((resolve, reject) => {
        request(url).pipe(fs.createWriteStream(foldername+"/"+filename))
            .on('finish', () => {
                console.log(foldername+"/"+filename+" downloaded");
                resolve();
            })
            .on('error', (error) => {
                reject(error);
            });
    })
}