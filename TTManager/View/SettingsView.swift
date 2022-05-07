//
//  ProfileView.swift
//  TTManager
//
//  Created by Alex Wecker on 24/12/2021.
//

import SwiftUI

struct SettingsView: View {
    
//    @State private var firstNametext = ""
//    @State private var lastNametext = ""
//    @State private var licenceNumbertext = ""
    @AppStorage("firstName") private var firstName = ""
    @AppStorage("lastName") private var lastName = ""
    @AppStorage("licenceNumber") private var licenceNumber = ""
//    @AppStorage("club") private var club = ""
//    @AppStorage("progress") private var progress = ""
//    @AppStorage("class") private var currentclass = ""
//    @AppStorage("placeNPR") private var placeNPR = ""
    @State private var ownColor = UserDefaults.standard.color(forKey: "ownColor") ?? Color.red
    @State private var clubColor = UserDefaults.standard.color(forKey: "clubColor") ?? Color.blue
    
    @ObservedObject var settingvm: SettingVM
    
    var body: some View {
        VStack {
            Text("Settings").font(.headline).padding()
            Form {
                Section(header:Text("PROFILE")){
                    TextField("First name",
                              text: $firstName,
                              onCommit: {
                                settingvm.lookupPerName(name: lastName + " " + firstName)
                              })
                    TextField("Last name",
                              text: $lastName,
                              onCommit: {
                                settingvm.lookupPerName(name: lastName + " " + firstName)
                              })
                    TextField("Licence Number",
                              text: $licenceNumber,
                              onCommit: {
                                settingvm.lookupPerLicenceNumber(licenceNumber: licenceNumber)
                              })
                }
                Section(header:Text("NPR Settings")){
                    ColorPicker("Own color", selection: $ownColor, supportsOpacity: false)
                        .onChange(of: ownColor, perform: { value in
                            UserDefaults.standard.set(value, forKey: "ownColor")
                        })
                    ColorPicker("Club color", selection: $clubColor, supportsOpacity: false)
                        .onChange(of: clubColor, perform: { value in
                            UserDefaults.standard.set(value, forKey: "clubColor")
                        })
                }
            }
        }
    }
    
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(settingvm: SettingVM())
//    }
//}
