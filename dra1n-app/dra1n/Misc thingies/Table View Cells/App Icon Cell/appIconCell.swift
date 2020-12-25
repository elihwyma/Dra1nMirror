//
//  appIconCell.swift
//  dra1n
//
//  Created by Amy While on 14/08/2020.
//

import UIKit

class appIconCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func colourThings() {
        self.backgroundColor = .clear
  
        self.iconImage.layer.cornerRadius = 3
        self.iconImage.layer.masksToBounds = true
    }

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconName: ColourAwareLabel!
    
}
