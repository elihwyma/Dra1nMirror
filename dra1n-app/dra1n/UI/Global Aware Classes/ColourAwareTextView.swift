//
//  ColourAwareTextView.swift
//  dra1n
//
//  Created by Amy While on 13/09/2020.
//

import UIKit

class ColourAwareTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
                
        colourAwareness()
        NotificationCenter.default.addObserver(self, selector: #selector(colourAwareness), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
    }
    
    @objc func colourAwareness() {
        self.textColor = textColor
    }

}
