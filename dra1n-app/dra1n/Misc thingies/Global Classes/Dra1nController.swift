//
//  Dra1nController.swift
//  dra1n
//
//  Created by Amy While on 09/09/2020.
//

#if !jailed
import IOKit
#endif
import Foundation


class Dra1nController {
    static let shared = Dra1nController()
    static let sharedServer = Dra1nServerController()
   
    typealias MGCopyAnswerFunc = @convention(c) (CFString) -> CFString
    
    var installedVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "Error"
    }

    var privacyPolicy: Bool {
        return CepheiController.shared.getBool(key: "privacyPolicy")
    }
    
    func respring() {
        let task = NSTask()
        task.setLaunchPath("/usr/bin/sbreload")
        task.launch()
    }
    
    func BatteryData() -> [String : Int] {
        
        let freeMemory = Dra1nController.sharedServer.freeMemory() as? Int ?? 0
        let dict = Dra1nController.sharedServer.batteryData() as? [String : Int] ?? [String : Int]()
        
        let someDict:[String : Int] = [
            "ram" : freeMemory,
            "dischargeCurrent" : dict["dischargeCurrent"] ?? 0,
            "cycles" : dict["cycles"] ?? 0,
            "designCapacity" : dict["designCapacity"] ?? 0,
            "maxCapacity" : dict["maxCapacity"] ?? 0,
            "currentCapacity" : dict["currentCapacity"] ?? 0,
            "temperature" : dict["temperature"] ?? 0,
            "voltage" : dict["voltage"] ?? 0
        ]
                
        return someDict
    }
    
    var dayMonthFormat: Bool {
        if CepheiController.shared.getBool(key: "badDateFormat") {
            return true
        } else {
            return false
        }
    }

}
