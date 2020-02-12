var fs = require('fs'),
    xml2js = require('xml2js');

var header = [
    {id: 'region', title: 'region'},
    {id: 'title', title: 'title'},
    {id: 'longitude', title: 'longitude'},
    {id: 'latitude', title: 'latitude'},
    {id: 'website', title: 'website'},
    {id: 'popularity', title: 'popularity'},
    {id: 'address', title: 'address'}
]
var lines = []

const createCsvWriter = require('csv-writer').createObjectCsvWriter;
const csvWriter = createCsvWriter({
  path: 'output.csv',
  header:header
});

readFile("triplist1.kml").then(()=>{
    return readFile("triplist2.kml");
}).then(()=> {
    return csvWriter.writeRecords(lines)
}).then(()=> {
    console.log('The CSV file was written successfully')
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
                            //console.log(placemark)
                            let title = placemark.name[0]
                            let coordinates = placemark.Point[0].coordinates[0].trim().split(",")
                            let longitude = coordinates[0]
                            let latitude = coordinates[1]
                            
                            console.log(title)
                            console.log(longitude, latitude)
                                       
                            let extendedData = placemark.ExtendedData[0].Data
                            //console.log(extendedData)
                            var website
                            var popularity
                            var address
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
                            })
                            
                            lines.push({
                                region:region,
                                title:title,
                                longitude:longitude,
                                latitude:latitude,
                                website:website,
                                popularity:popularity,
                                address:address
                            })
                    })
            })
                           
            console.log('Done', lines);
        
            }).catch(error => {
                console.log(error.message)
            });
}
