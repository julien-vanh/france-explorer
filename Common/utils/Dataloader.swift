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
    static var shared = ImageStore()
    fileprivate static var scale = 1
    
    func localImage(name: String) -> Image {
        var cgimage: CGImage
        if let image = try? loadImage(name: name) {
            cgimage = image
        } else {
            cgimage = try! loadImage(name: "placeholder.jpg")
        }
        return Image(cgimage, scale: CGFloat(ImageStore.scale), label: Text(verbatim: name))
    }
    
    func image(forPlace place: Place) -> Image {
        var name = "placeholder.jpg"
        if let illustration = place.illustration {
            name = illustration.path.replacingOccurrences(of: ".jpeg", with: ".jpg")
            name = name.replacingOccurrences(of: ".png", with: ".jpg")
        }
        return localImage(name: name)
    }
    
    func uiimage(forPlace place: Place) -> UIImage {
        var name = "placeholder.jpg"
        if let illustration = place.illustration {
            name = illustration.path.replacingOccurrences(of: ".jpeg", with: ".jpg")
            name = name.replacingOccurrences(of: ".png", with: ".jpg")
        }
        return UIImage(named: name)!
    }

    private func loadImage(name: String) throws -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: nil),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            throw ImageStoreError.cannotLoadImage
            
        }
        return image
    }
}


