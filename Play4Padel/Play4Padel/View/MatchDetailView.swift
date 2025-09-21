//
//  MatchDetailView.swift
//  Play4Padel
//
//  Created by Carlos Gonzalez on 2/11/24.
//

import SwiftUI

struct MatchDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: MatchDetailViewModel
    
    @DeviceIdiom private var deviceIdiom
    
    var body: some View {
        VStack {
            ScrollView {
                HStack(spacing: 2) {
                    Text("Date: ")
                        .font(.body)
                    
                    Text(viewModel.match.date?.formatted(date: .long, time: .omitted) ?? .empty)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding()
                
                Group {
                    HStack {
                        Text("My Team")
                            .underline()
                            .font(.title3)
                            .bold()
                        
                        Spacer()
                        
                        Text("Rivals")
                            .underline()
                            .font(.title3)
                            .bold()
                            .padding(.trailing, 10)
                    }
                    .padding()
                    
                    DetailInfoMatchComponent(
                        dataType: "First Set",
                        teamData: viewModel.match.firstUserSet ?? .zero,
                        rivalData: viewModel.match.firstRivalSet ?? .zero
                    )
                    
                    DetailInfoMatchComponent(
                        dataType: "Second Set",
                        teamData: viewModel.match.secondUserSet ?? .zero,
                        rivalData: viewModel.match.secondRivalSet ?? .zero
                    )
                    
                    DetailInfoMatchComponent(
                        dataType: "Third Set",
                        teamData: viewModel.match.thirdUserSet ?? .zero,
                        rivalData: viewModel.match.thirdRivalSet ?? .zero
                    )
                    
                    DetailInfoMatchComponent(
                        dataType: "Total Games",
                        teamData: Utils.getUserDataTotalGames(viewModel.match),
                        rivalData: Utils.getRivalDataTotalGames(viewModel.match)
                    )
                    
                    DetailVictoryInfoComponent(
                        dataType: "Result",
                        isVictory: viewModel.match.isVictory ?? false
                    )
                }
                .padding(.horizontal, deviceIdiom == .pad ? 200 : 0)
                
                PersonalMatchInfoView(
                    firstData: "\((viewModel.match.calories ?? .zero).formattedWithoutDecimals) cal",
                    secondData: "\((viewModel.match.heartRate ?? .zero).formattedWithoutDecimals) Hr/min",
                    thirdData: "\((viewModel.match.distance ?? .zero).formattedWithoutDecimals) km",
                    match: viewModel.match
                )
                .padding()
                .padding(.horizontal, deviceIdiom == .pad ? 200 : 0)
                
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
        .navigationTitle("Matches Details")
    }
}

#Preview {
    MatchDetailView(
        viewModel: MatchDetailViewModel(
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
    )
}
