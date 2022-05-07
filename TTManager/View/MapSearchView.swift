//
//  MapSearchView.swift
//  TTManager
//
//  Created by Alex Wecker on 24/12/2021.
//

import SwiftUI

struct MapSearchView: View {

    @EnvironmentObject var dataController: DataController
    @Binding var isShowing: Bool
    @Binding var searchText: String
    @State var filteredList:[Club] = []
    
    
    var body: some View {
            NavigationView {
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                            TextField("Search", text: $searchText)
                                .onChange(of: searchText){ value in
                                    dataController.filterClub(filter: value)
                                }
                        }
                        .padding(5)
                        .background(Color(red: 0.88, green: 0.88, blue: 0.88).cornerRadius(8.0))
                        Button(action: {
                            searchText = ""
                        }, label: {
                            Text("Cancel")
                        })
                    }
                    .padding([.horizontal,.top])
                    FilteredList(filter: searchText, isShowing: $isShowing)
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.isShowing = false
                                }, label: { Text("Done") }))
        }
    }
    
    struct FilteredList: View {
        @EnvironmentObject var dataController: DataController
        @Binding var isShowing: Bool
        
        init(filter: String, isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }
        
        var body: some View {
            List {
                ForEach(dataController.filteredclubs, id: \.self) { club in
                    NavigationLink(destination: ClubDetailsView(club: club, isShowing: $isShowing)) {
                        Text(club.name ?? "Unknown club")
                    }
                }
            }
            .navigationBarTitle("Clubs", displayMode: .inline)
        }
    }
}
    
    
//    func searchResults() -> [Club] {
//        if searchText.isEmpty {
//            return vm.locations
//        } else {
//            return vm.locations.filter { $0.club.name.lowercased().contains(searchText.lowercased()) }
//        }
//    }



