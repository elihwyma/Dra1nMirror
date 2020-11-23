//
//  CepheiController.swift
//  dra1n
//
//  Created by Amy While on 08/09/2020.
//

import UIKit

class CepheiController {
    static let shared = CepheiController()

    #if jailed
    #else
    let def = HBPreferences(identifier: "com.megadev.dra1n")
    #endif
       
 
    func set(key: String, object: Any) {
        #if jailed
        UserDefaults.standard.set(object, forKey: key)
        #else
        self.def.set(object, forKey: key)
        #endif
    }
    
    func getBool(key: String) -> Bool {
        #if jailed
        return UserDefaults.standard.bool(forKey: key)
        #else
        return self.def.bool(forKey: key)
        #endif
    }
    
    func getObject(key: String) -> Any {
        #if jailed
        return UserDefaults.standard.object(forKey: key) as Any
        #else
        return self.def.object(forKey: key)
        #endif
    }
    
    func getInt(key: String) -> Int {
        #if jailed
        return UserDefaults.standard.integer(forKey: key)
        #else
        return self.def.integer(forKey: key)
        #endif
    }
}

