//
//  TTManagerApp.swift
//  TTManager
//
//  Created by Alex Wecker on 17/12/2021.
//

import SwiftUI

@main
struct TTManagerApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            let profileVM = SettingVM(dc: dataController)
            TTManagerView(settingvm: profileVM)
                .environmentObject(dataController)
        }
    }
}
