//
//  ParametersViewController.swift
//  TripListTV
//
//  Created by Julien Vanheule on 30/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import UIKit
import TVUIKit


class ParametersViewController: UIViewController  {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Paramètres", comment: ""), image: nil, tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = ImageStore.shared.uiimage(forPlace: PlaceStore.shared.get(id: "Bordeaux"))
        backgroundImageView.addBlur(1, style: .dark)

        titleLabel.text = NSLocalizedString("Partout avec vous", comment: "")
        bodyLabel.text = NSLocalizedString("Retrouvez l'application complète sur iPhone et iPad.", comment: "")
        
        qrImageView.image = UIImage(named: "qrcode.png")
        qrImageView.layer.cornerRadius = 15
        qrImageView.layer.masksToBounds = true
    }

}
