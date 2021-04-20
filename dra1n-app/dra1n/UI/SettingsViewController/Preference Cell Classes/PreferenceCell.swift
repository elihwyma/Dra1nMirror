//
//  PreferenceCell.swift
//  dra1n
//
//  Created by Amy While on 13/09/2020.
//

import UIKit

class PreferenceCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
        self.colourControl()
        NotificationCenter.default.addObserver(self, selector: #selector(colourControl), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.colourControl()
    }
    
    @objc func colourControl() {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                self.backgroundColor = .secondaryBackground
            } else {
                self.backgroundColor = .dra1nBackground
            }
        } else {
            self.backgroundColor = .dra1nBackground
        }
    }
}
