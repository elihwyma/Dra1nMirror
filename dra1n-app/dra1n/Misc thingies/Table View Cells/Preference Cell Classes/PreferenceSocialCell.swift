//
//  PreferenceSocialCell.swift
//  dra1n
//
//  Created by Amy While on 10/09/2020.
//

import UIKit

class PreferenceSocialCell: UIControl {
    
    @IBInspectable private var url: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addTarget(self, action: #selector(openURL), for: .touchUpInside)
    }
    
    
    @objc func openURL() {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }

}
