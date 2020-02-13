function getWikiData(pageid){
    var enData
    var frData

    var options = {
        uri: "https://fr.wikipedia.org/w/api.php?action=query&pageids="+pageid+"&prop=langlinks|extracts&lllang=en&exintro&explaintext&format=json",
        json: true
    };

    
    return rp(options).then( data => {
        let page = data.query.pages[pageid]
        frData = {
            pageid: page.pageid,
            title: page.title,
            extract: page.extract
        }

        
        if(Array.isArray(page.langlinks) && typeof(page.langlinks[0]["*"]) === "string") {
            let pageNameEN = page.langlinks[0]["*"]
            return getWikiDataEN(pageNameEN).then(data => {
                enData = data
            })
        } else {
            console.warn("no EN page for "+page.title, pageid)
            return Promise.resolve()
        }
    }).then(()=>{
        return {
            pageid: {
                fr: frData.pageid,
                en: enData.pageid
            },
            title: {
                fr: frData.title,
                en: enData.title
            },
            extract: {
                fr: frData.extract,
                en: enData.extract
            }
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