//
//  ColourAwareButton.swift
//  dra1n
//
//  Created by Amy While on 10/09/2020.
//

import UIKit

class ColourAwareButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        colourAwareness()
        NotificationCenter.default.addObserver(self, selector: #selector(colourAwareness), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
    }
    
    @objc func colourAwareness() {
        self.setTitleColor(.dra1nLabel, for: .normal)
    }

}
