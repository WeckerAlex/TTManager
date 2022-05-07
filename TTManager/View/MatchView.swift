//
//  MatchView.swift
//  TTManager
//
//  Created by Alex Wecker on 24/12/2021.
//

import SwiftUI

struct MatchView: View {
    
    @EnvironmentObject var dataController: DataController
    @State private var searchText = ""
    
    var body: some View {
        VStack{
            Text("Matches").font(.headline).padding()
            InformationView()
            NavigationView {
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                            TextField("Search", text: $searchText)
                        }
                        .padding(5)
                        .background(Color(red: 0.88, green: 0.88, blue: 0.88).cornerRadius(8.0))
                        Button(action: {
                            searchText = ""
                        }, label: {
                            Text("Cancel")
                        })
                    }
                    .padding(7)
                    List{
                        ForEach(searchResults, id: \.self) { match in
                            NavigationLink(
                                destination: MatchDetails(match: match),
                                label: {
                                    MatchCell(match: match)
                                })
                        }
                    }.listStyle(PlainListStyle())
                }
                .navigationBarTitle("Details", displayMode: .inline)
                .navigationBarHidden(true)
            }
        }
    }
    
    var searchResults: [Match] {
        if searchText.isEmpty {
            return dataController.matches
        } else {
            return dataController.matches.filter { $0.nameOther!.contains(searchText) }
        }
    }
    
    private struct InformationView: View {
        
        @AppStorage("firstName") private var firstName = ""
        @AppStorage("lastName") private var lastName = ""
        @AppStorage("licenceNumber") private var licenceNumber = ""
        @AppStorage("club") private var club = ""
        @AppStorage("progress") private var progress = ""
        @AppStorage("currentclass") private var currentclass = ""
        @AppStorage("placeNPR") private var placeNPR = ""
        
        var body: some View{
            VStack {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(firstName + " " + lastName)
                }
                HStack {
                    Text("Club:")
                    Spacer()
                    Text(club)
                }
                HStack {
                    Text("Status:")
                    Spacer()
                    Text(currentclass + " " + progress)
                }
                HStack {
                    Text("Place NPR:")
                    Spacer()
                    Text(placeNPR)
                }
            }
            .padding()
        }
    }
    
}
