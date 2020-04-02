/*
Abstract:
Helpers for loading images and data.
*/

import Foundation
import CoreLocation
import UIKit
import SwiftUI

let placesData: [Place] = load("places.json")
let articlesData: [Article] = load("articles.json")
let regionsData: [PlaceRegion] = load("regions.json")
let thirdPartyMentions: [ThirdPartyMention] = load("thirdPartyMentions.json")


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

enum ImageStoreError: Error {
    case cannotLoadImage
}

final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(verbatim: name))
    }
    
    
    func image(forPlace place: Place) -> Image {
        var path = "placeholder.jpg"
        if let illustration = place.illustration {
            path = illustration.path.replacingOccurrences(of: "jpeg", with: "jpg")
        }
        let index = _guaranteeImage(name: path)
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(verbatim: path))
    }

    static func loadImage(name: String) throws -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: nil),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            throw ImageStoreError.cannotLoadImage
            
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        if let image = try? ImageStore.loadImage(name: name) {
            images[name] = image
            return images.index(forKey: name)!
        }
        
        images[name] = try! ImageStore.loadImage(name: "placeholder.jpg")
        return images.index(forKey: name)!
    }
}


