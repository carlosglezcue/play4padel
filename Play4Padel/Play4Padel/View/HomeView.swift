//
//  HomeView.swift
//  Play4Padel
//
//  Created by Carlos Gonzalez on 2/11/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query var dataMatch: [MatchData]
    @Environment(\.modelContext) private var context
    @State private var viewModel = HomeViewModel()
    
    @DeviceIdiom private var deviceIdiom
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HeaderView(
                section: "Hello",
                subsection: ""
            )
            
            ScrollView {
                LazyVStack {
                    NormalButton(
                        buttonAction: { viewModel.registerMatchAction() },
                        title: "REGISTER MATCH",
                        width: 300,
                        style: PrincipalLargeButton()
                    )
                    .padding(.top, 30)
                    
                    TextDividerSectionView(title: "• Last match")
                        .padding(.top)
                    
                    if let data = dataMatch.last {
                        MatchInfoView(
                            firstSubsection: "Result:",
                            secondSubsection: "Games won:",
                            thirdSubsection: "Date:",
                            firstData: .constant(Utils.getResultMatch(data)),
                            secondData: .constant("\(Utils.getUserDataTotalGames(data))"),
                            thirdData: .constant((data.date ?? Date()).formatted(date: .numeric, time: .omitted))
                        )
                    } else {
                        NoMatchesView(title: "There's not match yet")
                    }
                    
                    TextDividerSectionView(title: "• Last 10 matches:")
                        .padding(.top)
                    
                    if dataMatch.count >= 10 {
                        MatchInfoView(
                            firstSubsection: "Wins:",
                            secondSubsection: "Loses:",
                            thirdSubsection: "Porcentage wins:",
                            firstData: .constant("\(Utils.getWinsForTenGames(dataMatch))"),
                            secondData: .constant("\(Utils.getLosesForTenGames(dataMatch))"),
                            thirdData: .constant("\(Utils.getWinPercentageForFirstTenGames(dataMatch).formattedWithoutDecimals)%")
                        )
                    } else {
                        NoMatchesView(title: "You need to register more matches")
                    }
                    
                    TextDividerSectionView(title: "• All matches:")
                        .padding(.top)
                    
                    if dataMatch.count >= 1 {
                        MatchInfoView(
                            firstSubsection: "Wins:",
                            secondSubsection: "Loses:",
                            thirdSubsection: "Porcentage wins:",
                            firstData: .constant("\(Utils.getTotalWins(dataMatch))"),
                            secondData: .constant("\(Utils.getTotalLoses(dataMatch))"),
                            thirdData: .constant("\(Utils.getWinPercentage(dataMatch).formattedWithoutDecimals)%")
                        )
                    } else {
                        NoMatchesView(title: "You need to register a match")
                    }
                    
                    if viewModel.isVisible {
                        ReminderSubView(hideReminder: { viewModel.hideReminderAction() })
                            .padding(.top)
                    }
                }
                .padding([.horizontal, .bottom], deviceIdiom == .pad ? 200 : 30)
            }
            .scrollBounceBehavior(.basedOnSize)
            .fullScreenCover(isPresented: $viewModel.registerMatch) {
                RegisterMatchView(viewModel: $viewModel)
                    .alert( "Error saving match",
                            isPresented: $viewModel.errorToSave,
                            actions: {
                        Button("Ok", role: .none) { }
                    },
                            message: {
                        Text("Review the data you entered and try again.")
                    }
                    )
            }
        }
    }
}

#Preview(traits: .sampleData) {
    HomeView()
}
