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
import MapKit
import CoreData

let MAX_ITEM_IN_HISTORY = 30

protocol PlaceDetailViewControllerDelegate {
    func shouldRedirectToPage(place: Place)
}

class PlaceDetailViewController: UIViewController {
    var delegate:PlaceDetailViewControllerDelegate?
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
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    let buttonImageConfig = UIImage.SymbolConfiguration(textStyle: .headline)
    private var pageImages: [ImageMetadata] = []
    private var linkedPlaces: [Place] = []
    private var dreams: [Dream] = [] {
        didSet {
            displayBookmark()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.linkedPlaces = PlaceStore.shared.getAssociatedPlaceTo(place: place, count: 6, premium: false)
        
        initViews()
        displayPageContent()
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
        dreams = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
    
    
    private func initViews(){
        scrollView.delegate = self
        titleLabel.text = ""
        
        extractTextView.text = ""
        extractTextView.isSelectable = true
        extractTextView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageViewCell")
        
        linksCollectionView.delegate = self
        linksCollectionView.dataSource = self
        linksCollectionView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellWithReuseIdentifier: "PlaceCell")
        
        addressLabel.text = ""
        creditLabel.text = ""
    }
    
    private func displayBookmark() {
        if dreams.contains(where: { (dream) -> Bool in
            return dream.placeId == self.place.id
        }) {
            favoriteCaptionButton.contentImage = UIImage(systemName: "text.badge.minus", withConfiguration: buttonImageConfig)
            favoriteCaptionButton.title = NSLocalizedString("Retirer du Voyage", comment: "")
        } else {
            favoriteCaptionButton.contentImage = UIImage(systemName: "text.badge.plus", withConfiguration: buttonImageConfig)
            favoriteCaptionButton.title = NSLocalizedString("Ajouter au Voyage", comment: "")
        }
        favoriteCaptionButton.subtitle = ""
    }
    
    private func displayPageContent(){
        titleLabel.text = place.titleLocalized
        displayDescription()
        displayAddressLabel()
        displayMap()
        displayCredits()
        
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
        
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        self.linksCollectionView.reloadData()
        
        
    }
    
    private func displayDescription(){
        
        let text = NSMutableAttributedString(string: "")
        
        let categoryAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: AppStyle.color(for: place.category),
            .font: UIFont.systemFont(ofSize: 50),
        ]
        
        let description = NSAttributedString(string: PlaceStore.shared.getCategory(placeCategory: self.place.category).title, attributes: categoryAttributes)
        text.append(description)
        
        
        if let descriptionLocalized = place.descriptionLocalized {
            let lineContentAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 40),
            ]
            
            let description = NSAttributedString(string: "\n\n"+descriptionLocalized.content, attributes: lineContentAttributes)
            text.append(description)
        }
        
        extractTextView.attributedText = text
    }
    
    private func displayAddressLabel(){
        let lineTitleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            .font: UIFont.boldSystemFont(ofSize: 30),
        ]
        let lineContentAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 40),
        ]

        let text = NSMutableAttributedString(string: "")
        
        let region = PlaceStore.shared.getRegions().first { (region) -> Bool in
            region.id == place.regionId
        }
        if let regionFound = region {
            let regionTitle = NSAttributedString(string: NSLocalizedString(NSLocalizedString("Région", comment: ""), comment: ""), attributes: lineTitleAttributes)
            text.append(regionTitle)
            
            let regionContent = NSAttributedString(string: "\n"+regionFound.name+"\n\n", attributes: lineContentAttributes)
            text.append(regionContent)
        }
        
        if let address = place.address {
            let addressTitle = NSAttributedString(string: NSLocalizedString("Adresse", comment: ""), attributes: lineTitleAttributes)
            text.append(addressTitle)
            
            let addressContent = NSAttributedString(string: "\n"+address+"\n\n", attributes: lineContentAttributes)
            text.append(addressContent)
        }
        
        if let website = place.website {
            let addressTitle = NSAttributedString(string: NSLocalizedString("Site web", comment: ""), attributes: lineTitleAttributes)
            text.append(addressTitle)
            
            let addressContent = NSAttributedString(string: "\n"+website+"\n\n", attributes: lineContentAttributes)
            text.append(addressContent)
        }
        addressLabel.attributedText = text
    }
    
    private func displayMap(){
        map.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let annotation = PlaceAnnotation(place: place, style: .Colored)
        map.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: place.locationCoordinate, span: span)
        map.setRegion(region, animated: true)
    }
    
    private func displayCredits(){
        var credits = ""
        if place.illustration != nil {
            credits += place.illustration!.credit + " " + place.illustration!.source + "\n"
        }
        if (self.place.descriptionLocalized != nil){
            credits += self.place.descriptionLocalized!.credit
        }
        creditLabel.text = credits
    }
    
    @IBAction func favoritesClickedAction(_ sender: Any) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        
        if let index = dreams.firstIndex(where: {$0.placeId == place.id}) {
            let dream = self.dreams[index]
            context.delete(dream)
            dreams.remove(at: index)
        } else {
            let dream = Dream(context: context)
            dream.configure(place: place)
            dream.order = (dreams.last?.order ?? 0) + 1
            dreams.append(dream)
        }
        appDelegate.saveContext()
    }
    
    private func addDream(){
        
        
    }
    
    private func removeDream(){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        appDelegate.saveContext()
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

extension PlaceDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.linksCollectionView {
            return linkedPlaces.count
        } else {
            return self.pageImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.linksCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
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



extension PlaceDetailViewController : UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Force the scrollview to the top when buttons are selected
        if mustScrollToTop {
            targetContentOffset.pointee = CGPoint.zero
        }
        
    }
}
