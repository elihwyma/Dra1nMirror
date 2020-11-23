//
//  ColourAwareLabel.swift
//  dra1n
//
//  Created by Amy While on 10/09/2020.
//

import UIKit

class ColourAwareLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
                
        colourAwareness()
        NotificationCenter.default.addObserver(self, selector: #selector(colourAwareness), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.colourAwareness()
    }
    
    @objc func colourAwareness() {
        self.textColor = textColor
    }
}

