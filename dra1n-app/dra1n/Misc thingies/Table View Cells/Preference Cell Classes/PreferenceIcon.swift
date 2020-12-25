//
//  PreferenceIcon.swift
//  dra1n
//
//  Created by Amy While on 10/09/2020.
//

import UIKit

class PreferenceIcon: UIImageView {
    
    @IBInspectable private var imageName: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        
        self.setIcon()
    }
    
    @objc func setIcon() {
        if let image = UIImage(named: imageName) {
            self.image = image
        } else {
            if let url = URL(string: "https://github.com/\(imageName).png") {
                DispatchQueue.global(qos: .utility).async {
                    do {
                        let image = UIImage(data: try Data(contentsOf: url))
                        if image != nil {
                            DispatchQueue.main.async {
                                self.image = image
                            }
                        }
                    } catch {
                        return
                    }
                }
            }
        }
    }
    
}
