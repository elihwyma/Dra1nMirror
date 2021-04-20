//
//  tabViewController.swift
//  dra1n
//
//  Created by Amy While on 11/07/2020.
//


import UIKit

class tabViewController: UITabBarController {
    
    @IBOutlet weak var tabView: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tabView.tintColor = UIColor(red: 0.75, green: 0.56, blue: 0.83, alpha: 1.00)
        self.tabView.barTintColor = .secondaryBackground
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                self.tabView.barTintColor = .secondaryBackground
            }
        }
    }
    
}
