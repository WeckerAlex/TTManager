//
//  NPRView.swift
//  TTManager
//
//  Created by Alex Wecker on 24/12/2021.
//

import SwiftUI

struct NPRView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dataController: DataController
    @State private var searchText: String = ""
    @State var filteredList:[Club] = []
    @State var isAdvancedSearchDisplayed = false
    @AppStorage("firstName") private var firstName = ""
    @AppStorage("lastName") private var lastName = ""
    @AppStorage("club") private var club = ""
    @State private var ownColor = Color.red
    @State private var clubColor = Color.blue
    @State private var searchName = false
    @State private var searchClub = false
    @State private var searchClass = false
    @State private var nameQuery = ""
    @State private var clubQuery = ""
    @State private var classQuery = PlayerClass.C1
    
    enum PlayerClass: String, CaseIterable {
        case A1
        case A2
        case A3
        case B1
        case B2
        case B3
        case C1
        case C2
        case C3
        case D1
        case D2
        case D3
        
    }
    
    var body: some View {
        VStack {
            Text("NPR")
                .font(.headline)
                .padding()
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                    TextField("Search", text: $searchText)
                        .onChange(of: searchText){ value in
                            dataController.filterPlayer(namefilter: value)
                        }
                    Image(systemName: "chevron.down")
                        .onTapGesture {
                            isAdvancedSearchDisplayed.toggle()
                        }
                        .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                }
                .padding(5)
                .background(Color(red: 0.88, green: 0.88, blue: 0.88).cornerRadius(8.0))
                Button(action: {
                    searchText = ""
                    dataController.filterPlayer()
                }, label: {
                    Text("Cancel")
                })
            }
            .padding()
            List {
                ForEach(dataController.filteredPlayer, id: \.self) { player in
                    NPRCell(player: player)
                        .foregroundColor(getColor(name: player.name ?? "", club: player.club ?? ""))
                        .onTapGesture {
                            print((player.name ?? "no club").lowercased())
                            print(lastName + " " + firstName)
                            print(player.name!.lowercased() == (lastName + " " + firstName).lowercased())
                        }
                }
            }
            .onAppear(){
                self.ownColor = UserDefaults.standard.color(forKey: "ownColor") ?? Color.red
                self.clubColor = UserDefaults.standard.color(forKey: "clubColor") ?? Color.blue
            }
        }
        .sheet(isPresented: $isAdvancedSearchDisplayed){
            AdvancedSearch(isPresented: $isAdvancedSearchDisplayed,searchName: $searchName, searchClub: $searchClub, searchClass: $searchClass, nameQuery: $nameQuery, clubQuery: $clubQuery, classQuery: $classQuery)
        }
    }
    
    private struct NPRCell: View {
        
        var player: Player
        
        var body: some View{
            HStack {
                Text(player.ranking!)
                    .font(.headline)
                    .frame(width: 60,alignment: .center)
                    .padding(.horizontal, 2)
                VStack(alignment: .leading) {
                    Text(player.name!)
                        .font(.title3)
                    Text(player.club!)
                        .font(.footnote)
                }
                Spacer()
                Text(player.playerClass!)
            }
        }
        
    }
    
    private struct AdvancedSearch: View {
        
        @EnvironmentObject var dataController: DataController
        @Binding var isPresented: Bool
        @Binding var searchName: Bool
        @Binding var searchClub: Bool
        @Binding var searchClass: Bool
        @Binding var nameQuery: String
        @Binding var clubQuery: String
        @Binding var classQuery: PlayerClass
        
        var body: some View{
            NavigationView {
                Form {
                    Section {
                        Toggle(isOn: $searchName) {
                            Text("Name")
                        }
                        TextField("Name", text: $nameQuery, onCommit: {searchName = true})
                    }
                    Section {
                        Toggle(isOn: $searchClub) {
                            Text("Club")
                        }
                        TextField("Club", text: $clubQuery, onCommit:{searchClub = true})
                    }
                    Section {
                        Toggle(isOn: $searchClass) {
                            Text("Class")
                        }
                        Picker("", selection: $classQuery) {
                            ForEach(PlayerClass.allCases, id: \.self) { plCl in
                                Text(plCl.rawValue)
                                    .tag(plCl)
                            }
                        }
                        .onChange(of: classQuery, perform: { value in
                            searchClass = true
                        })
                    }
                    Button("Filter"){
                        dataController.filterPlayer(namefilter: searchName ? nameQuery : nil,
                                                    clubfilter: searchClub ? clubQuery : nil,
                                                    playerClassfilter: searchClass ? classQuery.rawValue : nil)
                        isPresented = false
                    }
                }
                .navigationTitle("Advanced filtering")
//                .navigationBarItems(trailing:
//                                        Button(action: {
//
//                                        }, label: { Text("Filter") }))
            }

            
        }
    }
    
    private func getColor(name: String,club clubtxt: String) -> Color {
        var col:Color = colorScheme == .dark ? .white : .black
        if (name.lowercased() == (lastName + " " + firstName).lowercased()) {
            col = ownColor
        }else{
            if clubtxt.lowercased() ==  club.lowercased(){
                col = clubColor
            }
        }
        return col
    }
    
}
