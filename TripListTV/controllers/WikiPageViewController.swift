//
//  WikiPageViewController.swift
//  PrettyWiki
//
//  Created by Julien Vanheule on 28/10/2019.
//  Copyright © 2019 Julien Vanheule. All rights reserved.
//

import Foundation
import UIKit
import TVUIKit

let MAX_ITEM_IN_HISTORY = 30

protocol WikiPageViewControllerDelegate {
    func shouldRedirectToPage(place: Place)
}

class WikiPageViewController: UIViewController {
    var delegate:WikiPageViewControllerDelegate?
    var place: Place = PlaceStore.shared.getRandom(count: 1, premium: false)[0]
    var mustScrollToTop = true
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var extractTextView: UITextView!
    @IBOutlet weak var extractHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var favoriteCaptionButton: TVCaptionButtonView!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var imagesHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var linksCollectionView: UICollectionView!
    @IBOutlet weak var linksHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var creditLabel: UILabel!
    let buttonImageConfig = UIImage.SymbolConfiguration(textStyle: .headline)
    private var pageImages: [ImageMetadata] = []
    private var linkedPlaces: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.linkedPlaces = PlaceStore.shared.getAssociatedPlaceTo(place: place, count: 6, premium: false)
        
        initViews()
        displayPageContent()
    }
    
    private func initViews(){
        scrollView.delegate = self
        titleLabel.text = ""
        
        extractTextView.text = ""
        extractTextView.isSelectable = true
        extractTextView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        
        //Bookmark button
        if false {//if favorites.firstIndex(of: pageid) != nil {
            favoriteCaptionButton.contentImage = UIImage(systemName: "bookmark.fill", withConfiguration: buttonImageConfig)
            favoriteCaptionButton.title = NSLocalizedString("button.favorites.added", comment: "")
        } else {
            favoriteCaptionButton.contentImage = UIImage(systemName: "bookmark", withConfiguration: buttonImageConfig)
            favoriteCaptionButton.title = NSLocalizedString("button.favorites.add", comment: "")
        }
        favoriteCaptionButton.subtitle = ""
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageViewCell")
        
        linksCollectionView.delegate = self
        linksCollectionView.dataSource = self
        linksCollectionView.register(UINib(nibName: "ThumbnailPageCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailPageCell")
        
        creditLabel.text = ""
    }
    
    
    private func displayPageContent(){
        titleLabel.text = place.titleLocalized
        if let descriptionLocalized = place.descriptionLocalized {
            extractTextView.text = descriptionLocalized.content
        } else {
            extractTextView.text = ""
        }
        
        
        if place.illustration != nil {
            thumbnailImageView.image = ImageStore.shared.uiimage(forPlace: place)
        } else {
            //Pas d'image, le texte prend toute la largeur, réduction de la hauteur pour reter au dessus des boutons
            thumbnailWidthConstraint.constant = 0.0
            extractHeightConstraint.constant = 600.0
        }
 
        
        
        if let wikiPageId = self.place.wikiPageId {
            WikipediaService.shared.getPageImages(wikiPageId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print("error loading images", error)
                        self.imagesHeightConstraint.constant = 0.0
                        self.view.setNeedsUpdateConstraints()
                        self.view.layoutIfNeeded()
                    case .success(let value):
                        self.pageImages = value
                        self.imagesCollectionView.reloadData()
                    }
                }
                
            }
        } else {
            self.imagesHeightConstraint.constant = 0.0
        }
        
        creditLabel.text = "Crédits"//place.descriptionLocalized.credit
        
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        self.linksCollectionView.reloadData()
    }
    
    @IBAction func favoritesClickedAction(_ sender: Any) {
        /*
        var favorites = [Int]()
        
        if let cloudFavorites = NSUbiquitousKeyValueStore.default.array(forKey: "favorites") {
            favorites = cloudFavorites as! [Int]
        }
        
        if let index = favorites.firstIndex(of: pageid) {
            favorites.remove(at: index)
            favoriteCaptionButton.contentImage = UIImage(systemName: "bookmark", withConfiguration: buttonImageConfig)
            favoriteCaptionButton.title = NSLocalizedString("button.favorites.add", comment: "")
        } else {
            favorites.append(pageid)
            if favorites.count > MAX_ITEM_IN_HISTORY {
                favorites.remove(at: 0)
            }
            favoriteCaptionButton.contentImage = UIImage(systemName: "bookmark.fill", withConfiguration: buttonImageConfig)
            favoriteCaptionButton.title = NSLocalizedString("button.favorites.added", comment: "")
        }
        NSUbiquitousKeyValueStore.default.set(favorites, forKey: "favorites")
         */
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self.extractTextView {
            extractTextView.backgroundColor = UIColor.white
        } else {
            extractTextView.backgroundColor = UIColor.clear
        }
        
        let must:Bool = (context.nextFocusedView == self.extractTextView || context.nextFocusedView == self.favoriteCaptionButton)
        self.mustScrollToTop = must
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        if context.previouslyFocusedView == self.extractTextView {
            if extractTextView.contentOffset.y >= (extractTextView.contentSize.height - extractTextView.frame.size.height) {
                //extractView scoll reached the bottom
                return true
            }
            
            if context.nextFocusedView == self.favoriteCaptionButton {
                //one can always go to favorites button
                return true
            }
            return false
        }
        return true
    }
 
}

extension WikiPageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.linksCollectionView {
            return linkedPlaces.count
        } else {
            return self.pageImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.linksCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailPageCell", for: indexPath) as! ThumbnailPageCell
            cell.configure(place: linkedPlaces[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
            cell.configure(image: self.pageImages[indexPath.item])
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.linksCollectionView {
            let place = PlaceStore.shared.getAssociatedPlaceTo(place: self.place, count: 6, premium: false)[indexPath.item]
            if delegate != nil {
                delegate?.shouldRedirectToPage(place: place)
            }
        } else if collectionView == self.imagesCollectionView {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImagesPageViewController") as! ImagesPageViewController
            vc.images = self.pageImages
            vc.currentIndex = indexPath.item
            present(vc, animated: true, completion: nil)
        }
    }
}



extension WikiPageViewController : UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Force the scrollview to the top when buttons are selected
        if mustScrollToTop {
            targetContentOffset.pointee = CGPoint.zero
        }
        
    }
}
