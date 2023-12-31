//
//  SecondViewController.swift
//  PrettyWiki
//
//  Created by Julien Vanheule on 23/10/2019.
//  Copyright © 2019 Julien Vanheule. All rights reserved.
//

import UIKit
import CoreData

class DreamListViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dreams: [Dream] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Voyage", comment: ""), image: nil, tag: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = ImageStore.shared.uiimage(forPlace: PlaceStore.shared.get(id: "ParcNaturelRegionaldeMillevachesenLimousin"))
        backgroundImageView.addBlur(1, style: .dark)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellWithReuseIdentifier: "PlaceCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<Dream>(entityName: "Dream")
      
      do {
        let results: [Dream] = try managedContext.fetch(fetchRequest)
        dreams = results.sorted(by: { (d1, d2) -> Bool in
            return d1.order < d2.order
        })
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
}

extension DreamListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dreams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        if let placeId = dreams[indexPath.item].placeId {
            if let place = PlaceStore.shared.get(id: placeId) {
                cell.configure(place: place)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let placeId = dreams[indexPath.item].placeId {
            if let place = PlaceStore.shared.get(id: placeId) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
                vc.place = place
                vc.delegate = self
                present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension DreamListViewController : PlaceDetailViewControllerDelegate {
    func shouldRedirectToPage(place: Place) {
        self.dismiss(animated: false) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
            vc.place = place
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}
