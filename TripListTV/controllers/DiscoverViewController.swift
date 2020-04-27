//
//  FirstViewController.swift
//  PrettyWiki
//
//  Created by Julien Vanheule on 23/10/2019.
//  Copyright © 2019 Julien Vanheule. All rights reserved.
//

import UIKit
import TVUIKit


class DiscoverViewController: UIViewController  {
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var selectionCollectionView: UICollectionView!
    
    @IBOutlet weak var regionsTitle: UILabel!
    @IBOutlet weak var regionsCollectionView: UICollectionView!
    
    private var places: [Place] = []
    private var regions: [PlaceRegion] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Destinations", comment: ""), image: nil, tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.places = PlaceStore.shared.getRandom(count: 10, premium: false)
        self.regions = PlaceStore.shared.getRegions().sorted(by: { (r1, r2) -> Bool in
            r1.name < r2.name
        })
        
        self.initViews()
    }
    
    private func initViews(){
        selectionLabel.text = NSLocalizedString("Suggestions", comment: "")
        
        selectionCollectionView.delegate = self
        selectionCollectionView.dataSource = self
        selectionCollectionView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellWithReuseIdentifier: "PlaceCell")
        
        regionsTitle.text = NSLocalizedString("Régions", comment: "")
        
        regionsCollectionView.delegate = self
        regionsCollectionView.dataSource = self
        regionsCollectionView.register(UINib(nibName: "RegionCell", bundle: nil), forCellWithReuseIdentifier: "RegionCell")
    }
}



extension DiscoverViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.selectionCollectionView {
            return places.count
        } else {
            return regions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.selectionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
            cell.configure(place: places[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegionCell", for: indexPath) as! RegionCell
            cell.configure(region: regions[indexPath.item])
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.selectionCollectionView {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
            vc.place = places[indexPath.item]
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegionViewController") as! RegionViewController
            vc.region = regions[indexPath.item]
            present(vc, animated: true, completion: nil)
        }
    }
}

extension DiscoverViewController : PlaceDetailViewControllerDelegate {
    func shouldRedirectToPage(place: Place) {
        self.dismiss(animated: false) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
            vc.place = place
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}
