//
//  CepheiController.swift
//  dra1n
//
//  Created by Amy While on 08/09/2020.
//

import Foundation

class CepheiController {

    static let def = UserDefaults.init(suiteName: "com.megadev.dra1n")

    static func set(key: String, object: Any) {
        def.set(object, forKey: key)
    }
    
    static func getBool(key: String) -> Bool {
        def.bool(forKey: key)
    }
    
    static func getObject(key: String) -> Any {
        def.object(forKey: key)
    }
    
    static func getInt(key: String) -> Int {
        def.integer(forKey: key)
    }
}

