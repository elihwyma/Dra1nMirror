//
//  dra1nApiParser.swift
//  dra1n
//
//  Created by Amy While on 24/08/2020.
//

import UIKit
import Foundation

struct DatabaseObject {
    var image: UIImage?
    var goodImage: Bool?
    var badImage: Bool?
    var Bundleid: String?
    var flag: Int?
    var author: String?
    var warns: Int?
    var ratio: Int?
    var hide: Bool?
    var time: Date?
    var name: String?
    
    init(image: UIImage? = nil,
         goodImage: Bool? = nil,
         badImage: Bool? = nil,
         Bundleid: String? = nil,
         flag: Int? = nil,
         author: String? = nil,
         warns: Int? = nil,
         ratio: Int? = nil,
         hide: Bool? = nil,
         time: Date? = nil,
         name: String? = nil) {
        
        self.image = image
        self.goodImage = goodImage
        self.badImage = badImage
        self.Bundleid = Bundleid
        self.flag = flag
        self.author = author
        self.warns = warns
        self.ratio = ratio
        self.hide = hide
        self.time = time
        self.name = name
    }
}

class Dra1nApiParser {
    
    let disallowedBundles = [
        "com.hackyouriphone",
        "ru.rj",
        "ru.rejail",
        "org.mr",
        "org.cydia.kiimo",
        "iosgods",
        "localiapstore",
        "cydown",
        "cracktool",
        "cydiakk"
    ]
    
    var database = [DatabaseObject]()
    var tweakNames = [String]()
    var randomIndexes = [Int]()

    var isFucked = false
    
    static let shared = Dra1nApiParser()
    
    class func meta() {
        //self.postCulprits()
        preCulpriting()
        tweakListPosting()
    }
    
    func register() {
        NotificationCenter.default.addObserver(self, selector: #selector(setup), name: NSNotification.Name(rawValue: "PrivacyPolicy"), object: nil)
    }
    
    @objc func setup() {
        if Dra1nController.privacyPolicy {
            DispatchQueue.global(qos: .utility).async {
                if self.database.count == 0 {
                    self.refresh(completion: { (success) -> Void in
                        self.isFucked = success
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DatabaseLoad"), object: nil)
                    })
                }

                
            }
        }
    }
    
    
    typealias refreshCompletion = (_ success: Bool) -> Void
    func refresh(completion: @escaping refreshCompletion) {
        if (!Dra1nController.privacyPolicy) { return }
        if let url = URL(string: databaseURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(Dra1nController.installedVersion, forHTTPHeaderField: "tweakVersion")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                if let data = data {
                    do {
                        
                        let uwu = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]] ?? [[String : Any]]()
                        let owo = (uwu as NSArray).sortedArray(using: [NSSortDescriptor(key: "warns", ascending: false)]) as? [[String : Any]] ?? [[String : Any]]()
                        
                        #if staff
                        for tweak in owo {
                            let le = DatabaseObject(Bundleid: (tweak["Bundleid"] as? String ?? "Error"), flag: (tweak["flag"] as? Int ?? 0), warns: (tweak["warns"] as? Int ?? 0))
                            self.database.append(le)
                            self.tweakNames.append(le.Bundleid ?? "Error")
                        }
                        #else
                        for tweak in owo {
                            
                                let le = DatabaseObject(Bundleid: (tweak["Bundleid"] as? String ?? "Error"), flag: (tweak["flag"] as? Int ?? 0), warns: (tweak["warns"] as? Int ?? 0) ,  ratio: (tweak["ratio"] as? Int ?? 0))
                                self.database.append(le)
                                self.tweakNames.append(le.Bundleid ?? "Error")
                            
                        }
                        #endif

                        
                        var tempArray = [String]()
                        while (tempArray.count != 10) {
                            let tempName = self.tweakNames.randomElement() ?? ""
                            if (!tempArray.contains(tempName)) {
                                tempArray.append(tempName)
                                let index = self.tweakNames.firstIndex(of: tempName) ?? 0
                                self.randomIndexes.append(index)
                           
                            }
                        }

                        completion(true)
               
                    } catch { completion(false) }
                    
                }
            }
            task.resume()
        }
    }
    
    #if staff
    func generateRandomDate(daysBack: Int)-> Date?{
            let day = arc4random_uniform(UInt32(daysBack))+1
            let hour = arc4random_uniform(23)
            let minute = arc4random_uniform(59)
            
            let today = Date(timeIntervalSinceNow: 0)
            let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            var offsetComponents = DateComponents()
            offsetComponents.day = -1 * Int(day - 1)
            offsetComponents.hour = -1 * Int(hour)
            offsetComponents.minute = -1 * Int(minute)
            
            let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
            return randomDate
    }
    #endif
    
    class func checkForUpdate(_ completion: @escaping ((_ show: Bool, _ text: String, _ icon: String, _ link: String) -> Void)) {
        var update = false
        var text = "An update is available for Dra1n"
        var icon = "icloud.and.arrow.down"
        var link = "cydia://url/https://cydia.saurik.com/api/share#?package=com.amymega.dra1n"
        let headers: [String: String] = [
            "tweakVersion" : Dra1nController.installedVersion
        ]
        AmyNetworkResolver.dict(url: "https://\(endpoint()).dra1n.app/v1/update", headers: headers) { success, dict in
            guard success,
                  let dict = dict else { return completion(false, text, icon, link) }
            update = dict["UpdateAvailable"] as? String != Dra1nController.installedVersion ||
                dict["isAnnouncement"] as? Int == 1
            if let remoteText = dict["UpdateText"] as? String { text = remoteText }
            if let remoteImage = dict["UpdateImage"] as? String { icon = remoteImage }
            if let remoteLink = dict["url"] as? String { link = remoteLink }
            return completion(update, text, icon, link)
        }
    }
    
    class func getTutInfo() {
        let headers: [String: String] = [
            "tweakVersion" : Dra1nController.installedVersion
        ]
        AmyNetworkResolver.dict(url: "https://\(endpoint()).dra1n.app/v1/tutorial-info", headers: headers) { success, dict in
            // Parse the JSON here
        }
    }
    
    
    
    func postCulprits() {
        if (Dra1nController.privacyPolicy) {
            var array = CepheiController.getObject(key: "CulpritLog") as? [[String : Any]] ?? [[String : Any]]()
            for (index, element) in array.enumerated() {
                
                let tweak = element["culrpit"] as? String ?? "Unknown Cause"
                for item in self.disallowedBundles { if tweak.contains(item) { return } }
                let posted = element["posted"] as? Int ?? 0
       
                if (((tweak != "Unknown Cause") || (tweak != "")) && (posted == 0)) {
                    let url = "https://\(endpoint()).dra1n.app/v1/post/\(tweak)"
                    let noTPlease = url.replacingOccurrences(of: "\t", with: "")
                    let encoded = noTPlease.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                    if let url = URL(string: encoded ?? "") {
                        var request = URLRequest(url: url)
                        request.httpMethod = "GET"
                        request.setValue(Dra1nController.installedVersion, forHTTPHeaderField: "tweakVersion")
                        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                                if let data = data {
                                    let decoder = JSONDecoder()
                                    if let json = try? decoder.decode(postResponse.self, from: data) {
                                        if ((json.Response) != nil) {
                                            if (json.Response == "Success") {
                                                var dict = element
                                                dict["posted"] = true
                                                array[index] = dict
                                                CepheiController.set(key: "CulpritLog", object: array)
                                            }
                                        }
                                    }
                                }
                            }
                        task.resume()
                        }
                    }
            }
        }
    }
    
    class func preCulpriting() {
        if !Dra1nController.privacyPolicy || !CepheiController.getBool(key: "hasOnboardedPost") { return }
        let headers: [String: String] = [
            "tweakVersion": Dra1nController.installedVersion
        ]
        AmyNetworkResolver.array(url: "https://\(endpoint()).dra1n.app/V1/tweaks/", headers: headers) { success, array in
            guard success,
                  let array = array else { return }
            let tweakList = CepheiController.getObject(key: "TweakList") as? [String] ?? [String]()
            var whoops = [String]()
            var culpritList = CepheiController.getObject(key: "CulpritLog") as? [[String : Any]] ?? [[String : Any]]()
            
            for yeet in tweakList {
                if (!yeet.contains("gsc.")) {
                    let noTPlease = yeet.replacingOccurrences(of: "\t", with: "")
                    whoops.append(noTPlease)
                }
            }
            
            for tweak in array {
                let checkingCulprit = tweak["Bundleid"] as? String ?? ""
                let flag = tweak["flag"] as? Int ?? 0
                if flag == 3 {
                    if (whoops.contains(checkingCulprit)) {
                        var dict = [String : Any]()
                        dict["time"] = NSDate()
                        dict["culrpit"] = checkingCulprit
                        dict["posted"] = true
                        culpritList.append(dict)
                    }
                }
            }
            
            CepheiController.set(key: "hasOnboardedPost", object: true)
            CepheiController.set(key: "CulpritLog", object: culpritList)
        }
    }
    
    class func tweakListPosting() {
        var listToPost: [String] = CepheiController.getBool(key: "TweakPost") ? [String]() :
            (CepheiController.getObject(key: "TweakList") as? [String] ?? [String]()).map({$0.replacingOccurrences(of: "\t", with: "")})
        
        var newTweakList = CepheiController.getObject(key: "UpdatedNewTweaks") as? [[String : Any]] ?? [[String : Any]]()
        for (index, tweak) in newTweakList.enumerated() {
            if !(tweak["posted"] as? Bool ?? false) {
                listToPost.append((tweak["tweak"] as? String ?? "").replacingOccurrences(of: "\t", with: ""))
                newTweakList[index]["posted"] = true
            }
        }
        if listToPost.isEmpty { return }
        
        guard let data = try? JSONSerialization.data(withJSONObject: listToPost, options: []),
              let json = String(data: data, encoding: String.Encoding.utf8) else {
            return
        }
        let headers: [String: String] = [
            "tweakVersion": Dra1nController.installedVersion,
            "tweaklist": json
        ]
        AmyNetworkResolver.dict(url: "https://\(endpoint()).dra1n.app/v1/tweaklist/", headers: headers) { success, _ in
            if success {
                CepheiController.set(key: "UpdatedNewTweaks", object: newTweakList)
                CepheiController.set(key: "TweakPost", object: true)
            }
        }
    }
}
