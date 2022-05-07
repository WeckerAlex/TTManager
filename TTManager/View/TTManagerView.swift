//
//  ContentView.swift
//  TTManager
//
//  Created by Alex Wecker on 17/12/2021.
//

import SwiftUI

struct TTManagerView: View {
    
    @State var registrationStatus = !(UserDefaults.standard.bool(forKey: "registered"))
    @ObservedObject var settingvm: SettingVM
    
    var body: some View {
        TabView{
            MatchView()
                .tabItem {
                    Image(systemName: "arrowtriangle.right.and.line.vertical.and.arrowtriangle.left")
                    Text("Matches")
                }
            MapView(/*mapVM: mapviewModel*/)
                .tabItem {
                    Image(systemName: "map")
                    Text("Sports Halls")
                }
                //.environmentObject(moc)
            NPRView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("NPR")
                }
            SettingsView(settingvm: settingvm)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .alert(isPresented: $registrationStatus) {
            Alert(title: Text("Identification"), message: Text("Plese go to the Settings tab to identify yourself"))
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let profileVM = ProfileVM()
//        let matchVM = MatchVM()
//        let mapVM = MapVM()
//        let nprVM = NPRVM()
//        TTManagerView(profileviewModel: profileVM,
//                      matchviewModel: matchVM,
//                      mapviewModel: mapVM,
//                      nprviewModel: nprVM)
//    }
//}
