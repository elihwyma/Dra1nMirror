//
//  culpritCell.swift
//  dra1n
//
//  Created by Amy While on 14/08/2020.
//

import UIKit

class culpritCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.tweakIcon.image = UIImage(named: "tweakIcon")
    }
    
    var le: DatabaseObject!
    var index: Int?
    
    func colourControl() {
                
        switch (le?.flag) {
            case 2: self.circleView.backgroundColor = .orange; self.circleView.text = "!"; break
            case 3: self.circleView.backgroundColor = .red; self.circleView.text = "!"; break
            case 5: self.circleView.backgroundColor = .blue; self.circleView.text = "✓"; break
            #if staff
            case 1: self.circleView.backgroundColor = .gray; self.circleView.text = "?"; break
            case 4: self.circleView.backgroundColor = .green; self.circleView.text = "!"; break
            #endif
            default: self.circleView.backgroundColor = .gray; self.circleView.text = "?"; break
        }
        
        self.backgroundColor = .clear
        
        self.circleView.layer.cornerRadius = 7.5
        self.circleView.layer.masksToBounds = true
        
        self.tweakIcon.layer.cornerRadius = 4
        self.tweakIcon.layer.masksToBounds = true
        
        self.backgroundColor = .clear
                
        if le?.Bundleid != "Discharge Increase" && !(le?.hide ?? false) && le != nil {
            let failedImage = le?.badImage ?? false
            if (!failedImage) {
                let goodImage = le?.goodImage ?? false
                if (goodImage) {
                    self.tweakIcon.image = le?.image ?? UIImage(named: "tweakIcon")
                } else {
                    if index ?? 0 <= 10 {
                        DispatchQueue.global(qos: .userInteractive).async {
                            ParcilityParser.shared.setImage(bundleID: self.le?.Bundleid ?? "Error", completion: { (index, success) -> Void in
                                if (success && ((Dra1nApiParser.shared.database[index].Bundleid ?? "Error") == self.le?.Bundleid ?? "Error")) {
                                    DispatchQueue.main.async {
                                        self.tweakIcon.image = Dra1nApiParser.shared.database[index].image ?? UIImage(named: "tweakIcon")
                                    }
                                }
                            })
                        }
                    }
                }
            }
        } else {
            self.tweakIcon.image = UIImage(named: "tweakIcon")
        }
                
        self.textView.sizeToFit()
    }
 
    @IBOutlet weak var textView: ColourAwareLabel!
    @IBOutlet weak var circleView: ColourAwareLabel!
    @IBOutlet weak var tweakIcon: UIImageView!
    
}
