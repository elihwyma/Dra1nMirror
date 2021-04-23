//
//  mainCell.swift
//  dra1n
//
//  Created by Amy While on 14/08/2020.
//

import UIKit

class MainCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        imageBackground.layer.cornerRadius = 30 // half the width/height
        imageBackground.backgroundColor = UIColor(red: 0.75, green: 0.56, blue: 0.83, alpha: 0.2)
        iconImageView.tintColor = UIColor(red: 0.75, green: 0.56, blue: 0.83, alpha: 1.00)
        title.adjustsFontSizeToFitWidth = true
        specificValue.adjustsFontSizeToFitWidth = true
        descriptionText.adjustsFontSizeToFitWidth = true
        self.specificValue.textColor = .systemRed
    }

    //All the outlets from the cell
    @IBOutlet weak var title: ColourAwareLabel!
    @IBOutlet weak var specificValue: UILabel!
    @IBOutlet weak var descriptionText: ColourAwareLabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var imageBackground: UIView!
    
    var icon = "" {
        didSet {
            if #available(iOS 13.0, *) {
                iconImageView.image = UIImage(systemName: icon)
            } else {
                iconImageView.image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
                iconImageView.contentMode = .center
            }
        }
    }
    let minHeight: CGFloat! = 100
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        guard let minHeight = minHeight else { return size }
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
 
    func allTheAdjustments() {
        descriptionText.sizeToFit()
        self.backgroundColor = .secondaryBackground
    }
}
