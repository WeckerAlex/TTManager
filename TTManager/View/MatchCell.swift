//
//  MatchCell.swift
//  TTManager
//
//  Created by Alex Wecker on 10/01/2022.
//

import SwiftUI

struct MatchCell: View {
    
    @Environment(\.colorScheme) var colorScheme
    var match: Match
    
    var body: some View{
        HStack {
            VStack {
                Text(match.date ?? "")
                Text(match.day ?? "")
            }
            VStack(alignment: .leading){
                Text(match.nameOther ?? "")
                HStack{
                    Text(match.classOther ?? "")
                    Spacer()
                    Text(match.score ?? "")
                    Spacer()
                    Text(match.points ?? "")
                        .foregroundColor((Float(match.points ?? "0") ?? 0 < 0) ? .red : (Float(match.points ?? "0") ?? 0 > 0) ? .green : (colorScheme == .dark ? .white : .black))
                }
                
            }
        }
    }
    
}
