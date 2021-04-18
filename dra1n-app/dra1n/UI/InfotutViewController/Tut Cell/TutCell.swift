

import UIKit

class TutCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if #available(iOS 13.0, *) {
            dra1nImageView = UIImageView(image: UIImage(systemName: "megaphone.fill"))
        } else {
            dra1nImageView = UIImageView(image: UIImage(named: icon)?.withRenderingMode(.alwaysTemplate))
            dra1nImageView.contentMode = .center
        }
        
        let backgroundCircle = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        backgroundCircle.center = CGPoint(x: 30, y: 50)
        backgroundCircle.layer.cornerRadius = 30 // half the width/height
       
        
        dra1nImageView.tintColor = UIColor(red: 0.75, green: 0.56, blue: 0.83, alpha: 1.00)

        dra1nImageView.frame = CGRect(x: 0, y: 0, width: dra1nImageView.frame.size.width * 1.4, height: dra1nImageView.frame.size.height * 1.4)
        dra1nImageView.center = CGPoint(x: 30, y: 30)
        self.addSubview(backgroundCircle)
        backgroundCircle.addSubview(dra1nImageView)
        
        title.adjustsFontSizeToFitWidth = true

        descriptionText.adjustsFontSizeToFitWidth = true
        
 
    }

    //All the outlets from the cell
    @IBOutlet weak var title: ColourAwareLabel!

    @IBOutlet weak var descriptionText: ColourAwareLabel!
    var dra1nImageView: UIImageView!
    
    //Taken from SO, just to set a minimum size of the cell
    var icon = ""
    let minHeight: CGFloat! = 100
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        guard let minHeight = minHeight else { return size }
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
 
    func allTheAdjustments() {
        descriptionText.sizeToFit()
        self.backgroundColor = customGray5
    }
}
