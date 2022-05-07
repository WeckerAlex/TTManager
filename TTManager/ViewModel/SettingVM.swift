//
//  ProfileVM.swift
//  TTManager
//
//  Created by Alex Wecker on 24/12/2021.
//

import SwiftUI

class SettingVM: ObservableObject {
    
    init(dc: DataController) {
        self.dc = dc
    }
    
    var nm = NetworkManager()
    var dc:DataController
    @AppStorage("firstName") private var firstName = ""
    @AppStorage("lastName") private var lastName = ""
    @AppStorage("licenceNumber") private var licenceNumber = ""
    @AppStorage("club") private var club = ""
    @AppStorage("progress") private var progress = ""
    @AppStorage("currentclass") private var currentclass = ""
    @AppStorage("placeNPR") private var placeNPR = ""
    @AppStorage("registered") private var registered = false;
    @AppStorage("lastLookup") private var lastLookup = Date().description;
    
    func lookupPerName(name: String) {
        print(name)
        nm.performlookup(method: "Name", info: name, handler: savePlayer)
    }
    
    func lookupPerLicenceNumber(licenceNumber: String) {
        nm.performlookup(method: "LN", info: licenceNumber, handler: savePlayer)
    }
    
    func savePlayer(infos: PlayerInformation) -> Void {
        // save the retrieved data to the UserDefaults
        firstName = infos.firstName
        lastName = infos.lastName
        licenceNumber = infos.licenceNumber
        club = infos.club
        progress = infos.progress
        currentclass = infos.currentclass
        placeNPR = infos.placeNPR
        registered = true
        lastLookup = Date().description
        //retrieve the Matches
        dc.initMatchesData()
    }
}
