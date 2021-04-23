//
//  PreferenceSwitch.swift
//  dra1n
//
//  Created by Amy While on 08/09/2020.
//

import UIKit

class PreferenceSwitch: UISwitch {
    
    @IBInspectable private var prefsName: String!
    @IBInspectable private var notificationName: String! = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        #if !jailed
        if !prefsName.isEmpty {
            self.isOn = Dra1nDefaults.def.object(forKey: prefsName) as? Bool ?? self.isOn
        }
        #endif
    }
    
    @objc func switchChanged() {
        if !prefsName.isEmpty {
            Dra1nDefaults.set(key: prefsName, object: self.isOn)
        }
        
        if !notificationName.isEmpty {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil)
        }
    }
}

