//
//  ParametersViewController.swift
//  TripListTV
//
//  Created by Julien Vanheule on 30/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import UIKit
import TVUIKit
import StoreKit

class ParametersViewController: UIViewController  {
    
    @IBOutlet weak var purchaseView: UIView!
    @IBOutlet weak var purchaseTitleLabel: UILabel!
    @IBOutlet weak var purchaseImageView: UIImageView!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var restaureButton: UIButton!
    @IBOutlet weak var purchaseViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var qrTitleLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    
    private var products: [SKProduct] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Plus", comment: ""), image: nil, tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        buildPurchaseView()
        
        let store = TVProductsStore.shared
        self.products = store.products
        _ = store.objectWillChange.sink { _ in
            self.products = store.products
            self.buildPurchaseView()
        }
    }
    
    @IBAction func purchaseAction(_ sender: Any) {
        purchaseButton.isEnabled = false
        TVIAPManager.shared.purchaseProduct(product: products.first!, success: {
            self.purchaseButton.isEnabled = true
            self.buildPurchaseView()
        }) { (error) in
            self.purchaseButton.isEnabled = true
            self.displayError(error: error)
        }
    }
    
    @IBAction func restaureAction(_ sender: Any) {
        restaureButton.isEnabled = false
        TVIAPManager.shared.restorePurchases(success: {
            self.restaureButton.isEnabled = true
            self.buildPurchaseView()
        }) { (error) in
            self.restaureButton.isEnabled = true
            self.displayError(error: error)
        }
    }
    
    private func displayError(error: Error?){
        if let err = error {
            let alert = UIAlertController(title: NSLocalizedString("Erreur", comment: ""), message: err.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func buildViews(){
        purchaseTitleLabel.attributedText = computePurchasetitle()
        purchaseImageView.image = UIImage(named: "premium0.jpg")
        purchaseView.addBlur(1, style: .dark)
        purchaseView.layer.cornerRadius = 15
        purchaseView.layer.masksToBounds = true
        purchaseView.addSubview(purchaseTitleLabel)
        purchaseView.addSubview(purchaseImageView)
        purchaseView.addSubview(purchaseButton)
        purchaseView.addSubview(restaureButton)
        
        qrTitleLabel.text = NSLocalizedString("Retrouvez l'application complète sur iPhone et iPad.", comment: "")
        qrImageView.image = UIImage(named: "qrcode.png")
    }
    
    private func computePurchasetitle() -> NSAttributedString {
        let lineTitleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 36),
        ]
        let lineContentAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 32),
        ]
        let minilineContentAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 22),
        ]
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "plus")?.withTintColor(.yellow)
        let imageString = NSAttributedString(attachment: imageAttachment)
        

        let result = NSMutableAttributedString(string: "")
        
        let title = NSAttributedString(string: NSLocalizedString("Guide complet", comment: "").uppercased()+"\n\n", attributes: lineTitleAttributes)
        result.append(title)
        
        result.append(imageString)
        let line1 = NSAttributedString(string: " "+NSLocalizedString("Le guide complet contient 350 destinations supplémentaires.", comment: "")+"\n", attributes: lineContentAttributes)
        result.append(line1)
        
        result.append(imageString)
        let line2 = NSAttributedString(string: " "+NSLocalizedString("Liste des destinations 100% hors-ligne.", comment: "")+"\n\n", attributes: lineContentAttributes)
        result.append(line2)
        
        let line3 = NSAttributedString(string: " "+NSLocalizedString("Un achat unique pour votre compte iTunes valable sur iPhone, iPad et Apple TV.", comment: ""), attributes: minilineContentAttributes)
        result.append(line3)
        
        
        return result
    }
    
    private func buildPurchaseView() {
        purchaseViewWidthConstraint.constant = 0
        purchaseButton.isHidden = true
        restaureButton.isHidden = true
        
        if !TVAppState.shared.isPremium {
            purchaseViewWidthConstraint.constant = 900
            
            if let product = TVProductsStore.shared.products.first {
                purchaseButton.setTitle(String(format: NSLocalizedString("Acheter %@", comment: ""), product.localizedPrice), for: .normal)
                
                
                restaureButton.setTitle(NSLocalizedString("Restaurer mes achats", comment: ""), for: .normal)
                
                purchaseButton.isHidden = false
                restaureButton.isHidden = false
            }
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
    }

}
