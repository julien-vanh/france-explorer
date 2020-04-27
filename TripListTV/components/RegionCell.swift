//
//  ThumbnailPageCell.swift
//  PrettyWiki
//
//  Created by Julien Vanheule on 24/10/2019.
//  Copyright © 2019 Julien Vanheule. All rights reserved.
//

import Foundation
import UIKit

class RegionCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    
    func configure(region: PlaceRegion) {
        titleLabel.text = region.name
        
        imageView.adjustsImageWhenAncestorFocused = true
        self.imageView.image  = ImageStore.shared.uiimage(forRegion: region)
        imageView.overlayContentView.addSubview(titleLabel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.textColor = .white
    }
        
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        
        coordinator.addCoordinatedAnimations({
            self.titleLabel.textColor = self.isFocused ? UIColor.explored : .white
            self.titleLabel.font = self.titleLabel.font.withSize(self.isFocused ? 42 : 38)
        }, completion: nil)
    }
}
