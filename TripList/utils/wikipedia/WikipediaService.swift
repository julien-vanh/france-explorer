//
//  WikipediaService.swift
//  PrettyWiki
//
//  Created by Julien Vanheule on 23/10/2019.
//  Copyright © 2019 Julien Vanheule. All rights reserved.
//

import Foundation

public enum WikipediaError: Error, LocalizedError{
    case cannotBuildUrl
    case noDataAvailable
    case canNotProcessData
    
    public var errorDescription: String? {
        switch self {
        case .noDataAvailable:
            return NSLocalizedString("Données non disponibles", comment: "")
        default:
            return NSLocalizedString("Une erreur est suvenue", comment: "")
        }
    }
}

struct WikipediaService {
    static let shared = WikipediaService()
    
    let host: String
    let wikipedia_Accueil: String
    
    private init(){
        self.host = NSLocalizedString("wikipedia.host", comment: "")
        self.wikipedia_Accueil = NSLocalizedString("wikipedia.main-page", comment: "")
    }
    
    
    
    func getPage(_ pageid: Int, completion: @escaping(Result<WikiPage, WikipediaError>) -> Void ) {
        let urlString  = "\(self.host)?action=query&pageids=\(pageid)&prop=extracts%7Cpageimages&lhnamespace=0&lhlimit=20&lhprop=title%7Cpageid&exintro&explaintext&format=json&pithumbsize=400"
        
        guard let URL = URL(string: urlString) else {
            print(urlString)
            completion(.failure(.cannotBuildUrl))
            return
        }
        
        //print("getPage \(pageid) : \(URL.absoluteString)")
        let datatask = URLSession.shared.dataTask(with: URL) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let response = try JSONDecoder().decode(WikiResponse.self, from: jsonData)
                guard let result = response.query.pages.values.first else {
                    completion(.failure(.noDataAvailable))
                    return
                }
                
                if case .page(let value) = result {
                    completion(.success(value))
                } else {
                    completion(.failure(.canNotProcessData))
                }
            } catch {
                print("(getPage) Unexpected error: \(error).")
                completion(.failure(.canNotProcessData))
            }
        }
        datatask.resume()
    }
    
    
    func getPageImages(_ pageid: Int, limit: Int = 40, completion: @escaping(Result<[ImageMetadata], WikipediaError>) -> Void) {
        let imagesLimit = min(limit, 50) //Pas plus de 50 images retournées par l'aPI si resize
        let MAX_WIDTH = 800
        let urlString  = "\(self.host)?action=query&pageids=\(pageid)&generator=images&gimlimit=\(imagesLimit)&prop=imageinfo&iiprop=url%7Cmime%7Cextmetadata&iiurlwidth=\(MAX_WIDTH)&iiextmetadatafilter=ImageDescription%7CArtist&format=json"
        
        guard let URL = URL(string: urlString) else {
            completion(.failure(.cannotBuildUrl))
            return
        }
        
        //print("getPageImages \(pageid) : \(URL.absoluteString)")
        let datatask = URLSession.shared.dataTask(with: URL) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let response = try JSONDecoder().decode(WikiResponse.self, from: jsonData)
                //print("getPageImages response OK")
                var images:[ImageMetadata] = []
                for value in response.query.pages.values {
                    if case .image(let image) = value {
                        if image.imageinfo[0].mime != "image/jpeg" {
                            continue
                        }
                        
                        if let metadata = image.imageinfo[0].extmetadata, let description = metadata.ImageDescription {
                            if description.value.uppercased().contains("CARTE ") || description.value.uppercased().contains("MAP ") {
                                //Pour supprimer les cartes vectorielles 
                                continue
                            }
                            
                            if description.value.uppercased().contains("CATHERINE DE ") {
                                //Pour ne pas afficher la photo de chenonceau qui remonte à chaque monument !
                                continue
                            }
                        }
                            
                        let imageMetadata = ImageMetadata(image)
                        images.append(imageMetadata)
                        
                    }
                }
                completion(.success(images))
            } catch {
                print("(getPageImages) Unexpected error: \(error.localizedDescription).")
                completion(.failure(.canNotProcessData))
            }
        }
        datatask.resume()
    }
    
    
}
