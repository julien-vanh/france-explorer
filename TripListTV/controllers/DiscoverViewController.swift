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
    
    private var places: [Place] = PlaceStore.shared.getRandom(count: 10, premium: false)
    private var regions = PlaceStore.shared.getRegions()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Destinations", comment: ""), image: nil, tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
    }
    
    private func initViews(){
        selectionLabel.text = NSLocalizedString("Suggestions", comment: "")
        
        selectionCollectionView.delegate = self
        selectionCollectionView.dataSource = self
        selectionCollectionView.register(UINib(nibName: "ThumbnailPageCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailPageCell")
        
        regionsTitle.text = NSLocalizedString("Régions", comment: "")
        
        regionsCollectionView.delegate = self
        regionsCollectionView.dataSource = self
        regionsCollectionView.register(UINib(nibName: "ThumbnailPageCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailPageCell")
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailPageCell", for: indexPath) as! ThumbnailPageCell
            cell.configure(place: places[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailPageCell", for: indexPath) as! ThumbnailPageCell
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
            //TODO go to region
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
