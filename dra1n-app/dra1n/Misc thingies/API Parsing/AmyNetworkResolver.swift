//
//  AmyNetworkResolver.swift
//  Aemulo
//
//  Created by Amy on 23/03/2021.
//  Copyright © 2021 Amy While. All rights reserved.
//

import UIKit

final class AmyNetworkResolver {
    
    static let shared = AmyNetworkResolver()
    
    var cacheDirectory: URL {
        FileManager.default.documentDirectory.appendingPathComponent("Cache")
    }
    
    init() {
        if !cacheDirectory.dirExists {
            try? FileManager.default.createDirectory(atPath: cacheDirectory.absoluteString, withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    class public func dict(url: String?, method: String = "GET", headers: [String: String] = [:], _ completion: @escaping ((_ success: Bool, _ dict: [String: Any]?) -> Void)) {
        guard let surl = url,
              let url = URL(string: surl) else { return completion(false, nil) }
        AmyNetworkResolver.dict(url: url, method: method, headers: headers) { success, dict -> Void in
            return completion(success, dict)
        }
    }
    
    class public func dict(url: URL, method: String = "GET", headers: [String: String] = [:], _ completion: @escaping ((_ success: Bool, _ dict: [String: Any]?) -> Void)) {
        AmyNetworkResolver.request(url: url, method: method, headers: headers) { success, data in
            guard success,
                  let data = data else { return completion(false, nil) }
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] ?? [String: Any]()
                return completion(true, dict)
            } catch {}
            return completion(false, nil)
        }
    }
    
    class public func array(url: String?, method: String = "GET", headers: [String: String] = [:], _ completion: @escaping ((_ success: Bool, _ array: [[String: Any]]?) -> Void)) {
        guard let surl = url,
              let url = URL(string: surl) else { return completion(false, nil) }
        AmyNetworkResolver.array(url: url, method: method, headers: headers) { success, array -> Void in
            return completion(success, array)
        }
    }
    
    class public func array(url: URL, method: String = "GET", headers: [String: String] = [:], _ completion: @escaping ((_ success: Bool, _ array: [[String: Any]]?) -> Void)) {
        AmyNetworkResolver.request(url: url, method: method, headers: headers) { success, data in
            guard success,
                  let data = data else { return completion(false, nil) }
            do {
                let array = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] ?? [[String: Any]]()
                return completion(true, array)
            } catch {}
            return completion(false, nil)
        }
    }
    
    class private func request(url: URL, method: String = "GET", headers: [String: String] = [:], _ completion: @escaping ((_ success: Bool, _ data: Data?) -> Void)) {
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = method
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        let task = URLSession.shared.dataTask(with: request) { data, _, _ -> Void in
            if let data = data {
                completion(true, data)
            }
            return completion(false, nil)
        }
        task.resume()
    }
    
    internal func image(_ url: String, method: String = "GET", headers: [String: String] = [:], cache: Bool = true, _ completion: @escaping ((_ refresh: Bool, _ image: UIImage?) -> Void)) -> UIImage? {
        guard let url = URL(string: url) else { completion(false, nil); return nil }
        return self.image(url, method: method, headers: headers, cache: cache) { refresh, image in
            completion(refresh, image)
        }
    }
    
    internal func image(_ url: URL, method: String = "GET", headers: [String: String] = [:], cache: Bool = true, _ completion: @escaping ((_ refresh: Bool, _ image: UIImage?) -> Void)) -> UIImage? {
        let encoded = url.absoluteString.toBase64
        let path = cacheDirectory.appendingPathComponent("\(encoded).png")
        if path.exists {
            if let data = try? Data(contentsOf: path) {
                if let image = UIImage(data: data) {
                    if cache {
                        if let attr = try? FileManager.default.attributesOfItem(atPath: path.path),
                           let date = attr[FileAttributeKey.modificationDate] as? Date {
                            var yes = DateComponents()
                            yes.day = -1
                            let yesterday = Calendar.current.date(byAdding: yes, to: Date()) ?? Date()
                            if date > yesterday {
                                completion(false, nil)
                            }
                        }
                    }
                    return image
                }
            }
        }
        
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = method
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        let task = URLSession.shared.dataTask(with: request) { data, _, _ -> Void in
            if let data = data,
               let image = UIImage(data: data) {
                completion(true, image)
                if cache {
                    try? data.write(to: path)
                }
            }
        }
        task.resume()
        return nil
    }
}

extension String {

    var fromBase64: String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    var toBase64: String {
        return Data(self.utf8).base64EncodedString()
    }

}

extension FileManager {

    var documentDirectory: URL {
        urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension URL {

    var exists: Bool {
        FileManager.default.fileExists(atPath: path)
    }

    var dirExists: Bool {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    func contents() throws -> [URL] {
        try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil)
    }

    var implicitContents: [URL] {
        (try? contents()) ?? []
    }
}
