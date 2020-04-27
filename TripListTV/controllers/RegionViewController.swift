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
    var placesModel: [[Place]] = []

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var placesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let places = PlaceStore.shared.getAllForRegion(regionId: region.id, premium: true).sorted(by: { (p1, p2) -> Bool in //TODO
            return p1.popularity < p2.popularity
        })
        placesModel = self.getViewModel(places: places)
        
        self.initViews()
    }
    
    private func getViewModel(places: [Place]) -> [[Place]]{
        var result:[[Place]] = []
        
        PlaceStore.shared.getCategoriesWithoutAll().forEach { (category) in
            let placesOfCategory = places.filter { (place) -> Bool in
                return place.category == category.category
            }
            if placesOfCategory.count > 0 {
                result.append(placesOfCategory)
            }
        }
        print("result", result)
        return result
    }
    

    private func initViews(){
        self.titleLabel.text = region.name
        self.descriptionLabel.text = "La Normandie a connu une histoire riche de l'époque romaine au débarquement en 1944 en passant par l'invasion Viking et chacune de ces périodes à marquée le visage de la Normandie et il en reste des traces, des monuments, des événements qui permettent au tourisme normand de s'appuyer sur son histoire." //TODO
        
        self.backgroundImage.image  = ImageStore.shared.uiimage(forRegion: region)
        
        
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.init(white: 0, alpha: 0.8).cgColor, UIColor.black.cgColor]
        backgroundImage.layer.insertSublayer(gradient, at: 0)
        
        
        placesTableView.delegate = self
        placesTableView.dataSource = self
        placesTableView.register(CatalogueTableViewCell.self,  forCellReuseIdentifier: "CatalogueTableViewCell")
    }
}

extension RegionViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return placesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogueTableViewCell", for: indexPath) as? CatalogueTableViewCell {
            cell.configure(places: placesModel[indexPath.section])
            cell.parentVC = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let place = placesModel[section][0]
        
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.textColor = AppStyle.color(for: place.category)
        titleLabel.textAlignment = .left
        titleLabel.font = titleLabel.font.withSize(40)
        titleLabel.frame = CGRect(x: 90, y: 0, width: tableView.bounds.width, height: 50)
        titleLabel.text = PlaceStore.shared.getCategory(placeCategory: place.category).titlePlural
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
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
