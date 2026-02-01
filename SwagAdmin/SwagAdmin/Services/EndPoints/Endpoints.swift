//
//  SwagApp.swift
//  Swag
//
//  Created by Kazim Ahmad on 13/01/2026.
//

import Foundation
//MARK: the end points for app as enum to play around with the different version numbers and base urls
var version = "" // or some cases a version number as v1, v2 etc

struct NewObjectId: Codable {
    let id: Int
}

//MARK: can define according to the environments
let baseURLString = "http://127.0.0.1:5000/"
