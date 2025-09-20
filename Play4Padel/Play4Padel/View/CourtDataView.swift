//
//  CourtDataView.swift
//  Play4Padel
//
//  Created by Carlos Gonzalez on 2/11/24.
//

import SwiftUI

struct CourtDataView: View {
    
    @Environment(\.dismiss) var dismiss
    let match: MatchData
    
    var body: some View {
        VStack {
            PadelCourt2DView()
        }
        .navigationTitle("Court Details")
    }
}

#Preview {
    CourtDataView(
        match: MatchData(
            id: UUID(),
            date: .now,
            firstUserSet: 4,
            secondUserSet: 6,
            thirdUserSet: 6,
            totalUserGames: 16,
            firstRivalSet: 6,
            secondRivalSet: 3,
            thirdRivalSet: 3,
            totalRivalGames: 12,
            isVictory: true,
            position: .backhand,
            courtType: .indoor,
            calories: 1300,
            totalMatchTime: 5400.0
        )
    )
}
