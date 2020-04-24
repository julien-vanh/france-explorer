//
//  File.swift
//  TripListTV
//
//  Created by Julien Vanheule on 24/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import UIKit

class RegionViewController: UIViewController  {
    var region: PlaceRegion = PlaceStore.shared.getRegions()[0]
    var places: [Place] = []

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var placesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.initViews()
    }
    

    private func initViews(){
        self.titleLabel.text = region.name
        self.descriptionLabel.text = "La Normandie a connu une histoire riche de l'époque romaine au débarquement en 1944 en passant par l'invasion Viking et chacune de ces périodes à marquée le visage de la Normandie et il en reste des traces, des monuments, des événements qui permettent au tourisme normand de s'appuyer sur son histoire." //TODO
        
        self.backgroundImage.image  = ImageStore.shared.uiimage(forRegion: region)
        
        
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.init(white: 0, alpha: 0.8).cgColor, UIColor.black.cgColor]
        backgroundImage.layer.insertSublayer(gradient, at: 0)
        
        
        self.places = PlaceStore.shared.getAllForRegion(regionId: region.id, premium: true) //TODO
        placesCollectionView.delegate = self
        placesCollectionView.dataSource = self
        placesCollectionView.register(UINib(nibName: "ThumbnailPageCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailPageCell")
    }
}

extension RegionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailPageCell", for: indexPath) as! ThumbnailPageCell
        let place = self.places[indexPath.item]
        cell.configure(place: place)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let place = self.places[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
        vc.place = place
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension RegionViewController : PlaceDetailViewControllerDelegate {
    func shouldRedirectToPage(place: Place) {
        self.dismiss(animated: false) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
            vc.place = place
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}
