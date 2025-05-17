//
//  HomeViewModel.swift
//  Play4Padel
//
//  Created by Carlos Gonzalez on 2/11/24.
//

import SwiftUI
import SwiftData

@Observable
final class HomeViewModel {
    
    // MARK: - Properties
    var registerMatch: Bool = false
    var userFirstSet: String = .empty
    var userSecondSet: String = .empty
    var userThirdSet: String = .empty
    var rivalFirstSet: String = .empty
    var rivalSecondSet: String = .empty
    var rivalThirdSet: String = .empty
    var dateInfo: Date = .now
    var courtTypeSelected: TypeCourt = .none
    var positionSelected: PlayerPositionType = .none
    var isVisible: Bool = true
    var errorToSave: Bool = false
    
    // MARK: - Functions
    
    private func getUserTotalGamesInMatch() -> Int {
        let firstSet = Int(userFirstSet) ?? .zero
        let secondSet = Int(userSecondSet) ?? .zero
        let thirdSet = Int(userThirdSet) ?? .zero
        return firstSet + secondSet + thirdSet
    }
    
    private func getRivalTotalGamesInMatch() -> Int {
        let firstSet = Int(rivalFirstSet) ?? .zero
        let secondSet = Int(rivalSecondSet) ?? .zero
        let thirdSet = Int(rivalThirdSet) ?? .zero
        return firstSet + secondSet + thirdSet
    }
    
    private func getVictory() -> Bool {
        return getUserTotalGamesInMatch() > getRivalTotalGamesInMatch()
    }
    
    private func saveMatchData(_ context: ModelContext) {
        let newMatchData = MatchData(
            id: UUID(),
            firstUserSet: Int(userFirstSet),
            secondUserSet: Int(userSecondSet),
            thirdUserSet: Int(userThirdSet),
            totalUserGames: getUserTotalGamesInMatch(),
            firstRivalSet: Int(rivalFirstSet),
            secondRivalSet: Int(rivalSecondSet),
            thirdRivalSet: Int(rivalThirdSet),
            totalRivalGames: getRivalTotalGamesInMatch(),
            isVictory: getVictory(),
            position: positionSelected.toData(),
            courtType: courtTypeSelected.toData()
        )
        
        context.insert(newMatchData)
        registerMatch = false
    }
    
    // MARK: - Actions
    
    func registerMatchAction() {
        registerMatch.toggle()
    }
    
    func saveMatchAction(_ context: ModelContext) {
        
        let firstUserSet = Int(userFirstSet) ?? .zero
        let secondUserSet = Int(userSecondSet) ?? .zero
        let thirdUserSet = Int(userThirdSet) ?? .zero
        let firstRivalSet = Int(rivalFirstSet) ?? .zero
        let secondRivalSet = Int(rivalSecondSet) ?? .zero
        let thirdRivalSet = Int(rivalThirdSet) ?? .zero
        
        let firsSetCorrect: Bool = firstUserSet <= 7 && firstRivalSet <= 7 && firstUserSet != firstRivalSet
        let secondSetCorrect: Bool = secondUserSet <= 7 && secondRivalSet <= 7 && secondUserSet != secondRivalSet
        let thirdSetCorrect: Bool = thirdUserSet <= 7 && thirdRivalSet <= 7
        let lastSetCorrect: Bool = thirdUserSet != thirdRivalSet || (thirdUserSet == .zero && thirdRivalSet == .zero)
        
        if firsSetCorrect && secondSetCorrect && thirdSetCorrect && lastSetCorrect {
            saveMatchData(context)
        } else {
            errorToSave = true
        }
    }
    
    func hideReminderAction() {
        isVisible.toggle()
    }
    
    func restarMatchValue() {
        userFirstSet = .empty
        userSecondSet = .empty
        userThirdSet = .empty
        rivalFirstSet = .empty
        rivalSecondSet = .empty
        rivalThirdSet = .empty
        dateInfo = .now
        courtTypeSelected = .none
        positionSelected = .none
    }
}
