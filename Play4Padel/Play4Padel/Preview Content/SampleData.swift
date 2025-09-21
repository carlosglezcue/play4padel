//
//  SampleData.swift
//  Play4Padel
//
//  Created by Carlos Gonzalez on 2/11/24.
//

import SwiftUI
import SwiftData

struct SampleData: PreviewModifier {
    static func makeSharedContext() async throws -> Context {
        let schema = Schema([MatchData.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        
        let firstMatch = MatchData(
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
        
        let secondMatch = MatchData(
            id: UUID(),
            date: Calendar.current.date(byAdding: .month, value: -1, to: .now),
            firstUserSet: 3,
            secondUserSet: 2,
            totalUserGames: 5,
            firstRivalSet: 6,
            secondRivalSet: 6,
            totalRivalGames: 12,
            isVictory: false,
            position: .drive,
            courtType: .outdoor,
            calories: 900,
            totalMatchTime: 4500.0
        )
        
        let thirdMatch = MatchData(
            id: UUID(),
            date: Calendar.current.date(byAdding: .month, value: -1, to: .now),
            firstUserSet: 6,
            secondUserSet: 6,
            totalUserGames: 12,
            firstRivalSet: 2,
            secondRivalSet: 3,
            totalRivalGames: 5,
            isVictory: true,
            position: .drive,
            courtType: .outdoor,
            calories: 900,
            totalMatchTime: 4500.0
        )
        
        let fourthMatch = MatchData(
            id: UUID(),
            date: Calendar.current.date(byAdding: .month, value: -1, to: .now),
            firstUserSet: 6,
            secondUserSet: 6,
            totalUserGames: 12,
            firstRivalSet: 2,
            secondRivalSet: 3,
            totalRivalGames: 5,
            isVictory: true,
            position: .drive,
            courtType: .outdoor,
            calories: 900,
            totalMatchTime: 4500.0
        )
        
        let fifthMatch = MatchData(
            id: UUID(),
            date: Calendar.current.date(byAdding: .month, value: -1, to: .now),
            firstUserSet: 6,
            secondUserSet: 6,
            totalUserGames: 12,
            firstRivalSet: 2,
            secondRivalSet: 3,
            totalRivalGames: 5,
            isVictory: true,
            position: .drive,
            courtType: .outdoor,
            calories: 900,
            totalMatchTime: 4500.0
        )
        container.mainContext.insert(firstMatch)
        container.mainContext.insert(secondMatch)
        container.mainContext.insert(thirdMatch)
        container.mainContext.insert(fourthMatch)
        container.mainContext.insert(fifthMatch)
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
