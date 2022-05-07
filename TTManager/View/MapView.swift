//
//  MapView.swift
//  TTManager
//
//  Created by Alex Wecker on 24/12/2021.
//

import SwiftUI
import MapKit
import CoreData

struct MapView: View {
    
    @EnvironmentObject var dataController: DataController
    @State private var searchText: String = ""
    @State private var mapRegion = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: 49.828483,
                                                                                    longitude: 6.1254578),
                                                      span: MKCoordinateSpan(latitudeDelta: 0.2,
                                                                             longitudeDelta: 0.8))
    @State var isShowing = false
    @State private var club: Club? = nil
    
    var body: some View {
        VStack {
            Text("Map").font(.headline).padding()
            Button(action: {
                club = nil
                self.isShowing = true
            }, label: { SearchButton() })
                .padding()
            Map(coordinateRegion: $mapRegion, annotationItems: dataController.filteredclubs) { club in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: club.latitude,
                                                                 longitude: club.longitude)) {
                    MapMarker(isDetailsShowing: $isShowing)
                        .onTapGesture {
                            self.club = club
                            isShowing = true
                        }
                }
            }
        }
        .popover(isPresented: $isShowing, content: {
            modalcontent()
        })
    }
    
    @ViewBuilder func modalcontent()-> some View {
        if club == nil {
            MapSearchView(isShowing: $isShowing, searchText: $searchText)
        } else {
            ClubDetailsView(club: club!, isShowing: $isShowing)
        }
    }
}

struct MapMarker: View {
    
    @Binding var isDetailsShowing:Bool
    
    var body: some View{
        Circle()
            .stroke(Color.red, lineWidth: 5)
            .frame(width: 20, height: 20)
    }
    
}
struct SearchButton: View {
    
    var body: some View{
        Text("Search Club")
    }
    
}
