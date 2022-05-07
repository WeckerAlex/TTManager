//
//  PlayerInformation.swift
//  TTManager
//
//  Created by Alex Wecker on 09/01/2022.
//

import Foundation

struct PlayerInformation: Decodable {
    let firstName: String
    let lastName: String
    let licenceNumber: String
    let club: String
    let progress: String
    let currentclass: String
    let placeNPR: String
}
