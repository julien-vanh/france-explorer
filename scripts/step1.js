var fs = require('fs'),
    xml2js = require('xml2js');
var lines = []

readFile("triplist1.kml").then(()=>{
    return readFile("triplist2.kml");
}).then(()=> {
    let data = JSON.stringify(lines);
    return new Promise((resolve, reject) => {
        fs.writeFile("step1-output.json", data, error => {
            if (error) reject(error);
            resolve();
        });
    });
}).then(()=> {
    console.log('step1 success')
}).catch(err => {
    console.error("step1 error", err.message)
});


function readFile(filename){
    var parser = new xml2js.Parser();
    
    return new Promise(resolve => {
        fs.readFile(__dirname + '/'+filename, function(err, data) {
                resolve(data)
        })
    }).then(data => {
        return parser.parseStringPromise(data)
    }).then(result => {
            console.log(result)
            let folders = result.kml['Document'][0]['Folder']
            folders.forEach((folder) => {
                let region = folder.name[0]
                console.log(region)
                            
                let placemarks = folder.Placemark
                    placemarks.forEach(placemark => {
                            console.log(placemark)
                            let title = placemark.name[0]
                            let coordinates = placemark.Point[0].coordinates[0].trim().split(",")
                            let longitude = coordinates[0]
                            let latitude = coordinates[1]
                            
                            console.log(title)
                            console.log(longitude, latitude)
                                       
                            let extendedData = placemark.ExtendedData[0].Data
                            //console.log(extendedData)
                                       
                            let style = placemark.styleUrl[0]
                            let category
                            
                            if(style === "#icon-1720-0288D1"){
                                category = "nature"
                            }
                            else if(style === "#icon-1636-0288D1"){
                                category = "museum"
                            }
                            else if(style === "#icon-1598-0288D1"){
                                category = "historical"
                            }
                            else if(style === "#icon-1546-0288D1"){
                                category = "city"
                            }
                            else {
                                category = "event"
                            }
                                       
                            var website
                            var popularity
                            var address
                            var wiki
                            extendedData.forEach(data => {
                                    let name = data['$'].name
                                    let value = data['value'][0]
                                                 
                                    //console.log(name, value)
                                    if (name == "website") website = value;
                                    else if (name == "popularity"){
                                        let strVal = value+""
                                        if(strVal == "1.0") popularity = 1;
                                        if(strVal == "2.0") popularity = 2;
                                        if(strVal == "3.0") popularity = 3;
                                        else popularity = 1
                                    }
                                    else if (name == "address") address = value;
                                    else if (name == "wiki") wiki = value;
                            })
                            
                            lines.push({
                                region: region,
                                title: title,
                                longitude: longitude,
                                latitude: latitude,
                                website: website,
                                popularity: popularity,
                                address: address,
                                category: category,
                                wiki: wiki
                            })
                    })
            })
                           
            //console.log('Done', lines);
        
            }).catch(error => {
                console.log(error.message)
            });
}
