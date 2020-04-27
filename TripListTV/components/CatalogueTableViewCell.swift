//
//  File.swift
//  TripListTV
//
//  Created by Julien Vanheule on 27/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import UIKit

class CatalogueTableViewCell: UITableViewCell {
    fileprivate var catalogueCollectionView: UICollectionView!
    fileprivate let cellOffset: CGFloat = 48
    private var places: [Place] = []
    var parentVC: UIViewController!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func configure(places: [Place]){
        self.places = places
        catalogueCollectionView.reloadData()
    }
    
    fileprivate func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        catalogueCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        catalogueCollectionView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellWithReuseIdentifier: "PlaceCell")
        catalogueCollectionView.delegate = self
        catalogueCollectionView.dataSource = self
        catalogueCollectionView.backgroundColor = .clear
        catalogueCollectionView.showsHorizontalScrollIndicator = false
        catalogueCollectionView.clipsToBounds = false
        addSubview(catalogueCollectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        catalogueCollectionView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let itemSize = CGSize(width: 308, height: bounds.height-cellOffset)
        catalogueCollectionView.contentSize = CGSize(width: itemSize.width * CGFloat(9), height: bounds.height)
        (catalogueCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = itemSize
    }
}

// MARK: - UICollectionViewDelegate methods
extension CatalogueTableViewCell: UICollectionViewDelegate { }

 // MARK: - UICollectionViewDataSource method
extension CatalogueTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        cell.configure(place: places[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let parentVCDelegate = parentVC as? PlaceDetailViewControllerDelegate {
            let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
            vc.place = places[indexPath.item]
            vc.delegate = parentVCDelegate
            parentVC.present(vc, animated: true, completion: nil)
        }
        
    }
}

 // MARK: - UICollectionViewDelegateFlowLayout methods
extension CatalogueTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellOffset / 2, left: cellOffset / 2, bottom: cellOffset / 2, right: cellOffset / 2)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellOffset
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellOffset
    }
}
