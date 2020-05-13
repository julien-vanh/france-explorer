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
import TvOSMoreButton
import TvOSTextViewer


class PlaceDetailViewController: UIViewController {
    var delegate:PlaceDetailViewControllerDelegate?
    var place: Place = PlaceStore.shared.getRandom(count: 1, premium: false)[0]
    var mustScrollToTop = true
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionMoreButton: TvOSMoreButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dreamCaptionButton: TVCaptionButtonView!
    @IBOutlet weak var exploreCaptionButton: TVCaptionButtonView!
    
    
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var imagesTitleLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var imagesHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var associatesView: UIView!
    @IBOutlet weak var associatesTitleLabel: UILabel!
    @IBOutlet weak var associatesCollectionView: UICollectionView!
    @IBOutlet weak var creditLabel: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    let buttonImageConfig = UIImage.SymbolConfiguration(textStyle: .headline)
    private var pageImages: [ImageMetadata] = []
    private var linkedPlaces: [Place] = []
    private var dreams: [Dream] = [] {
        didSet {
            displayDreamButton()
        }
    }
    private var completions: [Completion] = [] {
        didSet {
            displayExploreButton()
        }
    }
    private var focusGuide = UIFocusGuide()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.linkedPlaces = PlaceStore.shared.getAssociatedPlaceTo(place: place, count: 10, premium: TVAppState.shared.isPremium)
        
        initViews()
        displayPageContent()
        
        //Pour aider le passage de "Images associée" au bouton "Exploré" en remontant
        self.view.addLayoutGuide(self.focusGuide)
        self.focusGuide.leftAnchor.constraint(equalTo: self.exploreCaptionButton.rightAnchor).isActive = true
        self.focusGuide.topAnchor.constraint(equalTo: self.exploreCaptionButton.topAnchor).isActive = true
        self.focusGuide.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.focusGuide.heightAnchor.constraint(equalTo: self.exploreCaptionButton.heightAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
      
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest1 = NSFetchRequest<Dream>(entityName: "Dream")
        let fetchRequest2 = NSFetchRequest<Completion>(entityName: "Completion")
        fetchRequest2.predicate = NSPredicate(format: "placeId == %@", place.id)
        
        do {
            dreams = try managedContext.fetch(fetchRequest1)
            completions = try managedContext.fetch(fetchRequest2)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
    private func initViews(){
        scrollView.delegate = self
        titleLabel.text = ""
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageViewCell")
        //imagesView.addBlur(0.5, style: .light)
        imagesTitleLabel.text = NSLocalizedString("Images associées", comment: "")
        imagesView.addSubview(imagesTitleLabel)
        imagesView.addSubview(imagesCollectionView)
        
        associatesCollectionView.delegate = self
        associatesCollectionView.dataSource = self
        associatesCollectionView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellWithReuseIdentifier: "PlaceCell")
        associatesView.addBlur(0.5, style: .light)
        associatesTitleLabel.text = NSLocalizedString("Découvrez aussi à proximité", comment: "")
        associatesView.addSubview(associatesTitleLabel)
        associatesView.addSubview(associatesCollectionView)
        
        addressLabel.text = ""
        creditLabel.text = ""
    }
    
    private func displayDreamButton() {
        if dreams.contains(where: { (dream) -> Bool in
            return dream.placeId == self.place.id
        }) {
            dreamCaptionButton.contentImage = UIImage(systemName: "text.badge.minus", withConfiguration: buttonImageConfig)
            dreamCaptionButton.title = NSLocalizedString("Retirer du Voyage", comment: "")
        } else {
            dreamCaptionButton.contentImage = UIImage(systemName: "text.badge.plus", withConfiguration: buttonImageConfig)
            dreamCaptionButton.title = NSLocalizedString("Ajouter au Voyage", comment: "")
        }
        dreamCaptionButton.subtitle = ""
        dreamCaptionButton.isHidden = false
    }
    
    private func displayExploreButton(){
        if completions.contains(where: { (completion) -> Bool in
            return completion.placeId == self.place.id
        }) {
            exploreCaptionButton.contentImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: buttonImageConfig)
            exploreCaptionButton.title = NSLocalizedString("Exploré", comment: "")
        } else {
            exploreCaptionButton.contentImage = UIImage(systemName: "circle", withConfiguration: buttonImageConfig)
            exploreCaptionButton.title = NSLocalizedString("Exploré", comment: "")
        }
        exploreCaptionButton.subtitle = ""
        exploreCaptionButton.isHidden = false
    }
    
    private func displayPageContent(){
        titleLabel.text = place.titleLocalized
        
        categoryLabel.text = PlaceStore.shared.getCategory(placeCategory: place.category).title
        categoryLabel.textColor = AppStyle.color(for: place.category)
        
        if let descriptionLocalized = place.descriptionLocalized {
            descriptionMoreButton.text = descriptionLocalized.content
            descriptionMoreButton.buttonWasPressed = {
                [weak self] text in
                self?.moreButtonWasPressed(text: descriptionLocalized.content)
            }
        } else {
            descriptionMoreButton.isHidden = true
        }
        
        displayAddressLabel()
        displayMap()
        displayCredits()
        
        if place.illustration != nil {
            thumbnailImageView.image = ImageStore.shared.uiimage(forPlace: place)
            backgroundImageView.image = ImageStore.shared.uiimage(forPlace: place)
            backgroundImageView.addBlur(1, style: .dark)
        } else {
            //Pas d'image, le texte prend toute la largeur
            thumbnailWidthConstraint.constant = 0.0
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
        self.associatesCollectionView.reloadData()
    }
    
    private func moreButtonWasPressed(text: String) -> Void {
        let viewController = TvOSTextViewerViewController()
        viewController.text = text
        viewController.textEdgeInsets = UIEdgeInsets(top: 100, left: 250, bottom: 100, right: 250)
        present(viewController, animated: true)
    }
    
    private func displayAddressLabel(){
        let lineTitleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 26),
        ]
        let lineContentAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 26),
        ]

        let text = NSMutableAttributedString(string: "")
        
        let region = PlaceStore.shared.getRegions().first { (region) -> Bool in
            region.id == place.regionId
        }
        if let regionFound = region {
            let regionTitle = NSAttributedString(string: NSLocalizedString("Région", comment: "").uppercased()+" :", attributes: lineTitleAttributes)
            text.append(regionTitle)
            
            let regionContent = NSAttributedString(string: "\n"+regionFound.name+"\n\n", attributes: lineContentAttributes)
            text.append(regionContent)
        }
        
        if let address = place.address {
            let addressTitle = NSAttributedString(string: NSLocalizedString("Adresse", comment: "").uppercased()+" :", attributes: lineTitleAttributes)
            text.append(addressTitle)
            
            let addressContent = NSAttributedString(string: "\n"+address+"\n\n", attributes: lineContentAttributes)
            text.append(addressContent)
        }
        
        if let website = place.website {
            let addressTitle = NSAttributedString(string: NSLocalizedString("Site web", comment: "").uppercased()+" :", attributes: lineTitleAttributes)
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
        
        map.layer.cornerRadius = 15
        map.clipsToBounds = true
    }
    
    private func displayCredits(){
        var credits = ""
        if place.illustration != nil {
            credits += NSLocalizedString("Photo", comment: "")
            credits += " "
            credits += place.illustration!.credit
            credits += " "
            credits += place.illustration!.source
            credits += "\n"
        }
        if (self.place.descriptionLocalized != nil){
            credits += NSLocalizedString("Texte", comment: "")
            credits += " "
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
    
    @IBAction func exploreClickedAction(_ sender: Any) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        
        if self.completions.first != nil {
            self.completions.forEach({
                context.delete($0)
            })
            completions = []
        } else {
            let completion = Completion(context: context)
            completion.configure(placeId: self.place.id)
            completions.append(completion)
            
            // Si dans la Dreams liste, on complete le Dream
            if let index = dreams.firstIndex(where: {$0.placeId == place.id}) {
                let item = self.dreams[index]
                item.completed = true
            }
        }
        appDelegate.saveContext()
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if context.previouslyFocusedView == self.exploreCaptionButton {
            self.focusGuide.preferredFocusEnvironments = nil
        } else {
            self.focusGuide.preferredFocusEnvironments = [self.exploreCaptionButton]
        }
        
        let must:Bool = (
            context.nextFocusedView == self.descriptionMoreButton ||
            context.nextFocusedView == self.dreamCaptionButton ||
            context.nextFocusedView == self.exploreCaptionButton
        )
        self.mustScrollToTop = must
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return true
    }
}

extension PlaceDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.associatesCollectionView {
            return linkedPlaces.count
        } else {
            return self.pageImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.associatesCollectionView {
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
        if collectionView == self.associatesCollectionView {
            let place = linkedPlaces[indexPath.item]
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
