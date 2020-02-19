const fs = require('fs')
const xml2js = require('xml2js')
const createCsvWriter = require('csv-writer').createObjectCsvWriter;
const rp = require('request-promise');

const csvWriter = createCsvWriter({
  path: 'step1-output.csv',
  header: [
    {id: 'title', title: 'title'},
    {id: 'titleen', title: 'title-en'},
    {id: 'category', title: 'category'},
    {id: 'region', title: 'region'},
    {id: 'position', title: 'position'},
    {id: 'website', title: 'website'},
    {id: 'address', title: 'address'},
    {id: 'descfr', title: 'desc-fr'},
    {id: 'descen', title: 'desc-en'},
    {id: 'wikifr', title: 'wiki-fr'},
    {id: 'wikien', title: 'wiki-en'},
    {id: 'popularity', title: 'popularity'},
    {id: 'creditdescfr', title: 'credit-desc-fr'},
    {id: 'creditdescen', title: 'credit-desc-en'},
  ]
});

var lines = []

let f1 = readFile("triplist1.kml")
let f2 = readFile("triplist2.kml")

Promise.all([f1, f2]).then(()=> {
    return csvWriter.writeRecords(lines)
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
        //console.log(result)

        var promises = []

        let folders = result.kml['Document'][0]['Folder']
        folders.forEach((folder) => {
            let region = folder.name[0]         
            let placemarks = folder.Placemark

            placemarks.forEach(placemark => {
                //console.log(placemark)
                let titlefr = placemark.name[0]
                let coordinates = placemark.Point[0].coordinates[0].trim().split(",")
                let longitude = parseFloat(coordinates[0])
                let latitude = parseFloat(coordinates[1])
                let position = "["+latitude+","+longitude+"]"
                            
                //console.log(title)
                //console.log(longitude, latitude)
                                       
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
                else if(style === "#icon-1511-0288D1"){
                    category = "event"
                }
                else {
                    //category = "undefined"
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

                var line = {
                    'title':titlefr,
                    'category':category,
                    'region':region,
                    'position':position,
                    'website':website,
                    'address':address,
                    'popularity':popularity,
                }

                var p
                if(wiki){
                    p = getWikiData(wiki).then(wikiData => {
                        
                        line['descfr'] = wikiData.extract.fr
                        line['wikifr'] = wikiData.pageid.fr
                        line['creditdescfr'] = "Wikipédia : "+wikiData.title.fr

                        if(wikiData.title.en) {
                            line['titleen'] = wikiData.title.en
                            line['wikien'] = wikiData.pageid.en
                            line['descen'] = wikiData.extract.en
                            line['creditdescen'] = "Wikipédia : "+wikiData.title.en
                        }
                    }).catch(err => {
                        console.warn("error getWikiData", wiki, err.message)
                    })
                } else {
                    p = Promise.resolve()
                }
                
                promises.push(p.then(()=>{
                    lines.push(line)
                }))             
            })
        })

        return Promise.all(promises)
    }).then(()=>{
        //console.log('Done', lines);
    }).catch(error => {
        console.log(error.message)
    });
}



function getWikiData(pageid){
    var enData
    var frData

    var options = {
        uri: "https://fr.wikipedia.org/w/api.php?action=query&pageids="+pageid+"&prop=langlinks|extracts&lllang=en&exintro&explaintext&format=json",
        json: true
    };

    
    return rp(options).then( data => {
        let page = data.query.pages[pageid]
        

        var result = {
            pageid: {
                fr: page.pageid
            },
            title: {
                fr: page.title
            },
            extract: {
                fr: page.extract
            }
        }

        
        if(Array.isArray(page.langlinks) && typeof(page.langlinks[0]["*"]) === "string") {
            let pageNameEN = page.langlinks[0]["*"]
            return getWikiDataEN(pageNameEN).then(endata => {
                result.pageid["en"] = endata.pageid
                result.title["en"] = endata.title
                result.extract["en"] = endata.extract

                return result;
            })
        } else {
            console.warn("no EN page for "+page.title, pageid)
            return result
        }
    })
}

function getWikiDataEN(pageTitle){
    var options = {
        uri: "https://en.wikipedia.org/w/api.php?action=query&titles="+pageTitle+"&prop=extracts&exintro&explaintext&format=json",
        json: true
    };

    return rp(options).then( data => {
        let page = Object.values(data.query.pages)[0]
        return {
            pageid: page.pageid,
            title: page.title,
            extract: page.extract
        }
    }).catch(err => {
        console.error("error getWikiExtractEN", pageTitle, err.message)
    })
}