//
//  SearchViewController.swift
//  PrettyWiki
//
//  Created by Julien Vanheule on 23/10/2019.
//  Copyright © 2019 Julien Vanheule. All rights reserved.
//

import UIKit

class SearchResultViewController : UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var presentedVc: UIViewController!
    
    var searchResultsPages = [Place]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var filterString = "" {
        didSet {
            guard filterString != oldValue else { return }
            
            // Apply the filter or show all items if the filter string is empty.
            if filterString.count < 3 {
                searchResultsPages = []
            }
            else {
                searchResultsPages = PlaceStore.shared.getAllForSearch(search: filterString, premium: false)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ThumbnailPageCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailPageCell")
    }
}


extension SearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterString = searchController.searchBar.text ?? ""
    }
}


extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultsPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailPageCell", for: indexPath) as! ThumbnailPageCell
        cell.configure(place: searchResultsPages[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let searchResult = searchResultsPages[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WikiPageViewController") as! WikiPageViewController
        vc.place = searchResult
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        self.presentedVc = vc
    }
}


extension SearchResultViewController : WikiPageViewControllerDelegate {
    func shouldRedirectToPage(place: Place) {
        self.presentedVc?.dismiss(animated: false) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WikiPageViewController") as! WikiPageViewController
            vc.place = place
            vc.delegate = self
            self.presentedVc = vc
            self.present(vc, animated: true, completion: nil)
        }
    }
}
