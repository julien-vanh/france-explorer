//
//  ThumbnailPageCell.swift
//  PrettyWiki
//
//  Created by Julien Vanheule on 24/10/2019.
//  Copyright © 2019 Julien Vanheule. All rights reserved.
//

import Foundation
import UIKit

class ThumbnailPageCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var unfocusedConstraint: NSLayoutConstraint!
    
    private var focusedConstraint: NSLayoutConstraint!
    
    func configure(place: Place) {
        let topImage = UIImageView()
        topImage.frame = imageView.frame
        topImage.contentMode = .scaleAspectFill
        topImage.image = ImageStore.shared.uiimage(forPlace: place)
        
        for view in self.imageView.overlayContentView.subviews{
            view.removeFromSuperview()
        }
        self.imageView.overlayContentView.addSubview(topImage)
        
        titleLabel.text = place.titleLocalized
    }
    
    func configure(region: PlaceRegion) {
        let randomPlaceForRegion = PlaceStore.shared.getAllForRegion(regionId: region.id)[0]
        
        let topImage = UIImageView()
        topImage.frame = imageView.frame
        topImage.contentMode = .scaleAspectFill
        topImage.image = ImageStore.shared.uiimage(forPlace: randomPlaceForRegion)
        
        for view in self.imageView.overlayContentView.subviews{
            view.removeFromSuperview()
        }
        self.imageView.overlayContentView.addSubview(topImage)
        
        titleLabel.text = region.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        focusedConstraint = titleLabel.topAnchor.constraint(equalTo: imageView.focusedFrameGuide.bottomAnchor, constant: 6)
        imageView.adjustsImageWhenAncestorFocused = true
        titleLabel.layer.zPosition = 99
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        focusedConstraint.isActive = isFocused
        unfocusedConstraint.isActive = !isFocused
        
        titleLabel.textColor = isFocused ? .white : .darkGray
    }
        
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        setNeedsUpdateConstraints()
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
