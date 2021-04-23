//
//  Dra1nController.swift
//  dra1n
//
//  Created by Amy While on 09/09/2020.
//

#if !jailed || targetEnvironment(simulator)
import IOKit
#endif
import Foundation


class Dra1nController {

    static let sharedServer = Dra1nServerController()
       
    static var installedVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "Error"
    }

    static var privacyPolicy: Bool {
        return true
        //return Dra1nDefaults.shared.getBool(key: "privacyPolicy")
    }
        
    class func respring() {
        let task = NSTask()
        task.setLaunchPath("/usr/bin/sbreload")
        task.launch()
    }

    static var batteryData: BatteryStats {
        let freeMemory = Dra1nController.sharedServer.freeMemory() as? Int ?? 0
        let dict = Dra1nController.sharedServer.batteryData() as? [String : Int] ?? [String : Int]()
        return BatteryStats(ram: freeMemory,
                                 dischargeCurrent: dict["dischargeCurrent"] ?? 0,
                                 cycles: dict["cycles"] ?? 0,
                                 designCapacity: dict["designCapacity"] ?? 0,
                                 maxCapacity: dict["maxCapacity"] ?? 0,
                                 currentCapacity: dict["currentCapacity"] ?? 0,
                                 temperature: dict["temperature"] ?? 0,
                                 voltage: dict["voltage"] ?? 0)
    }
    
    static var dayMonthFormat: Bool {
        Dra1nDefaults.getBool(key: "badDateFormat")
    }
}

struct BatteryStats {
    var ram: Int
    var dischargeCurrent: Int
    var cycles: Int
    var designCapacity: Int
    var maxCapacity: Int
    var currentCapacity: Int
    var temperature: Int
    var voltage: Int
}
