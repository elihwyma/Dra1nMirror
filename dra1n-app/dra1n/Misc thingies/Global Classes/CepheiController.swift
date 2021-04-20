//
//  CepheiController.swift
//  dra1n
//
//  Created by Amy While on 08/09/2020.
//

import Foundation

class CepheiController {

    #if jailed
    static let def = UserDefaults.standard
    #else
    static let def = HBPreferences(identifier: "com.megadev.dra1n")
    #endif
       
 
    static func set(key: String, object: Any) {
        #if jailed
        UserDefaults.standard.set(object, forKey: key)
        #else
        def.set(object, forKey: key)
        #endif
    }
    
    static func getBool(key: String) -> Bool {
        #if jailed
        return UserDefaults.standard.bool(forKey: key)
        #else
        return def.bool(forKey: key)
        #endif
    }
    
    static func getObject(key: String) -> Any {
        #if jailed
        return UserDefaults.standard.object(forKey: key) as Any
        #else
        return def.object(forKey: key)
        #endif
    }
    
    static func getInt(key: String) -> Int {
        #if jailed
        return UserDefaults.standard.integer(forKey: key)
        #else
        return def.integer(forKey: key)
        #endif
    }
}

