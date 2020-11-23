//
//  ParcilityParser.swift
//  dra1n
//
//  Created by Amy While on 06/08/2020.
//

import Foundation
import UIKit

public class ParcilityParser {
    
    static let shared = ParcilityParser()
    
    typealias yeet = (_ index: Int, _ success: Bool) -> Void
    func grabStruct(bundleID: String, completion: @escaping yeet) {
        let index = Dra1nApiParser.shared.tweakNames.firstIndex(of: bundleID) ?? 0
        if let url = URL(string: "https://api.parcility.co/db/package/\(bundleID)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                if let data = data {
                    do {
                        let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] ?? [String : Any]()
                        let depictionData = jsonObj["data"] as? [String : Any] ?? [String : Any]()
 
                        Dra1nApiParser.shared.database[index].author = depictionData["Author"] as? String ?? "Error"
                        Dra1nApiParser.shared.database[index].name = depictionData["Name"] as? String ?? "Error"

                        completion(index, true)
                    } catch { completion(0, false) }
                    
                } else { completion(0, false) }
            }
            task.resume()
        }
    }
    
    typealias setImageResponse = (_ index: Int, _ success: Bool) -> Void
    func setImage(bundleID: String, completion: @escaping setImageResponse) {
        let index = Dra1nApiParser.shared.tweakNames.firstIndex(of: bundleID) ?? 0
        
        if let url = URL(string: "https://api.parcility.co/db/package/\(bundleID)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                if let data = data {
                    do {
                        let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] ?? [String : Any]()
                        let depictionData = jsonObj["data"] as? [String : Any] ?? [String : Any]()
                        let image: String = depictionData["Icon"] as? String ?? "Error"
                        Dra1nApiParser.shared.database[index].author = depictionData["Author"] as? String ?? "Error"
                        Dra1nApiParser.shared.database[index].name = depictionData["Name"] as? String ?? "Error"
                        if let url = URL(string: image) {
                            do {
                                let leImage = UIImage(data: try Data(contentsOf: url))
                                Dra1nApiParser.shared.database[index].image = leImage
                                Dra1nApiParser.shared.database[index].goodImage = true
                                
                                completion(index, true)
                                
                            } catch {
                                Dra1nApiParser.shared.database[index].badImage = true
                                completion(0, false)
                            }
                        }
                    } catch {
                        Dra1nApiParser.shared.database[index].badImage = true
                        completion(0, false)
                    }
                }
            }
            task.resume()
        }
    }
}
