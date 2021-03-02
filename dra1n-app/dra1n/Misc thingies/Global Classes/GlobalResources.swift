//
//  GlobalResources.swift
//  dra1n
//
//  Created by Amy While on 05/08/2020.
//

import Foundation

struct UpdateResponse: Decodable {
    let UpdateAvailable: String!
    let UpdateText: String!
    let UpdateImage: String!
    let isAnnouncement: Int?
    let url: String!
}

struct postResponse: Decodable {
    let Response: String!
}

struct boop: Decodable {
    let purchased: Bool!
}

struct megaCoolPreCulprits: Decodable {
    let Bundleid: String!
    let warns: Int!
    let flag: Int!
}

let sandboxed = false

func endpoint() -> String {
    if (sandboxed) {
        return "sandbox"
    } else {
        return "api"
    }
}

public var databaseURL: String {
    #if staff
    return "https://\(endpoint()).dra1n.app/v1/all/tweaks"
    #else
    return "https://\(endpoint()).dra1n.app/V1/tweaks/"
    #endif
}

var leMtoTheB = false
var leFishe = false
