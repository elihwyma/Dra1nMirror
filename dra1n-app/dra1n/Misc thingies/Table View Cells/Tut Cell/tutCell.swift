//
//  tutCell.swift
//  dra1n
//
//  Created by Domien Fovel on 12/04/2021.
//

import UIKit

class tutCell: UITableViewCell {
    @IBOutlet weak var backgroundImageCell: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    let minHeight: CGFloat! = 100
    
    
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        guard let minHeight = minHeight else { return size }
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
