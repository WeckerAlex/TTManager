//
//  MatchDetails.swift
//  TTManager
//
//  Created by Alex Wecker on 10/01/2022.
//

import SwiftUI

struct MatchDetails: View {
    
    @State var match: Match
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        VStack{
            MatchInfoView(match: match)
            List {
                Text("Same Day")
                    .bold()
                Section{
                    ForEach(dataController.matchesday, id: \.self) { match in
                        MatchCell(match: match)
                    }
                }
                Text("Player Statistics")
                    .bold()
                Section{
                    ForEach(dataController.matchesSinglePlayer, id: \.self) { match in
                        MatchCell(match: match)
                    }
                }
            }
        }
        .onAppear() {
            dataController.filterMatch(filterDay: match.day!, filterPlayer: match.nameOther!)
        }
    }
    
    private struct MatchInfoView: View {
        
        @State var match: Match
        
        var body: some View{
            HStack {
                VStack(alignment: .leading){
                    Text(match.date ?? "")
                    Text(match.competition ?? "")
                    Text(match.day ?? "")
                }
                VStack(alignment: .leading){
                    Text(match.match ?? "")
                    Text(match.nameOther ?? "")
                    HStack{
                        Text((match.classSelf ?? "") + " vs. " + (match.classOther ?? ""))
                        Spacer()
                        Text(match.score ?? "")
                        Spacer()
                        Text(match.points ?? "")
                            .foregroundColor((Float(match.points ?? "0") ?? 0 < 0) ? .red : (Float(match.points ?? "0") ?? 0 > 0) ? .green : .black)
                    }
                    
                }
            }
            .padding()
        }
    }
}
