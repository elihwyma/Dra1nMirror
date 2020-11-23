//
//  mainCell.swift
//  dra1n
//
//  Created by Amy While on 14/08/2020.
//

import UIKit

class mainCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //All the outlets from the cell
    @IBOutlet weak var title: ColourAwareLabel!
    @IBOutlet weak var specificValue: UILabel!
    @IBOutlet weak var descriptionText: ColourAwareLabel!
    
    
    //Taken from SO, just to set a minimum size of the cell
    var icon = ""
    let minHeight: CGFloat! = 100
    
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        guard let minHeight = minHeight else { return size }
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
 
    
    //All the minor things that I'm doing through code
    func allTheAdjustments() {
        descriptionText.sizeToFit()
        title.adjustsFontSizeToFitWidth = true
        specificValue.adjustsFontSizeToFitWidth = true
        descriptionText.adjustsFontSizeToFitWidth = true
        descriptionText.sizeToFit()
        
        self.backgroundColor = customGray5
        self.specificValue.textColor = .red
    }
    
    func addSubViews() {
        
        for v in self.subviews{
           if v is customUIView{
              v.removeFromSuperview()
           }
        }
        
        let imageView: UIImageView!
                
        if #available(iOS 13.0, *) {
            imageView = UIImageView(image: UIImage(systemName: icon))
        } else {
            imageView = UIImageView(image: UIImage(named: icon)?.withRenderingMode(.alwaysTemplate))
            imageView.contentMode = .center
        }
        
        let backgroundCircle = customUIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        backgroundCircle.center = CGPoint(x: 45, y: 50)
        backgroundCircle.layer.cornerRadius = 30 // half the width/height
        backgroundCircle.backgroundColor = UIColor(red: 0.75, green: 0.56, blue: 0.83, alpha: 0.2)
        
        imageView.tintColor = UIColor(red: 0.75, green: 0.56, blue: 0.83, alpha: 1.00)

        imageView.frame = CGRect(x: 0, y: 0, width: imageView.frame.size.width * 1.4, height: imageView.frame.size.height * 1.4)
        imageView.center = CGPoint(x: 30, y: 30)
        self.addSubview(backgroundCircle)
        backgroundCircle.addSubview(imageView)
        
    }
    
    
}

class customUIView: UIView {
    //To stop it from making duplicate views, I just made another class :shrug:
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
      }
    
      //initWithCode to init view from xib or storyboard
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }
}
