//
//  colourScheme.swift
//  dra1n
//
//  Created by Amy While on 13/08/2020.
//

import Foundation
import UIKit

public var customBackground: UIColor {
    var colour: UIColor!
    let oledMode = CepheiController.shared.getBool(key: "oledMode")
    
    if #available(iOS 13, *) { colour = .systemGray6 } else { colour = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.00) }
    if (oledMode) { colour = .black }
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return colour
            } else {
                return .systemGray6
            }
        }
    } else {
        return colour
    }
}

public var customGray5: UIColor {
    var colour: UIColor!
    if #available(iOS 13, *) { colour = .systemGray5 } else { colour = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.00) }
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return colour
            } else {
                return .systemGray5
            }
        }
    } else {
        return colour
    }
}

public var textColour: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if (traitCollection.userInterfaceStyle == .dark) {
                return .white
            } else {
                return .black
            }
        }
    } else {
        return .white
    }
}

public var dra1nColour: UIColor {
    UIColor(red: 0.753, green: 0.537, blue: 0.855, alpha: 1)
}
