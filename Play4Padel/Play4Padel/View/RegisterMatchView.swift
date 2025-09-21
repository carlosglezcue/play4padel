//
//  RegisterMatchView.swift
//  Play4Padel
//
//  Created by Carlos Gonzalez on 2/11/24.
//

import SwiftUI

struct RegisterMatchView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @DeviceIdiom private var deviceIdiom
    
    @Binding var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                HeaderView(
                    section: "Add result:",
                    subsection: ""
                )
                
                Spacer()
                
                Button {
                    dismiss()
                    viewModel.restarMatchValue()
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                        .foregroundColor(.onlyBlack)
                }
                .padding(.trailing)
            }
            .background(.principal)
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(.darkBlack, lineWidth: 1)
                    .fill(.boxDark)
                    .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    RegisterSetsSection(
                        userSet: $viewModel.userFirstSet,
                        rivalSet: $viewModel.rivalFirstSet,
                        title: "First Set:"
                    )
                    
                    RegisterSetsSection(
                        userSet: $viewModel.userSecondSet,
                        rivalSet: $viewModel.rivalSecondSet,
                        title: "Second Set:"
                    )
                    
                    RegisterSetsSection(
                        userSet: $viewModel.userThirdSet,
                        rivalSet: $viewModel.rivalThirdSet,
                        title: "Third Set:"
                    )
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("Position played:")
                        Spacer()
                        Menu {
                            ForEach([PlayerPositionType.backhand, PlayerPositionType.drive, PlayerPositionType.both], id: \.self) { position in
                                Button(position.rawValue) {
                                    viewModel.positionSelected = position
                                }
                            }
                        } label: {
                            Text(viewModel.positionSelected == .none ? "Select position" : viewModel.positionSelected.toView())
                                .foregroundStyle(viewModel.positionSelected == .none ? .gray : .primary)
                        }
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("Court Type:")
                        Spacer()
                        Menu {
                            ForEach([TypeCourt.indoor, TypeCourt.outdoor], id: \.self) { type in
                                Button(type.rawValue) {
                                    viewModel.courtTypeSelected = type
                                }
                            }
                        } label: {
                            Text(viewModel.courtTypeSelected == .none ? "Select court" : viewModel.courtTypeSelected.toView())
                                .foregroundStyle(viewModel.courtTypeSelected == .none ? .gray : .primary)
                        }
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        DatePicker(
                            "Date:",
                            selection: $viewModel.dateInfo,
                            in: ...Date.now,
                            displayedComponents: .date
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .padding(.horizontal, deviceIdiom == .pad ? 200 : 0)
            
            HStack {
                NormalButton(
                    buttonAction: { viewModel.saveMatchAction(context) },
                    title: "Save",
                    width: 100,
                    style: PrincipalButton()
                )
                
                Spacer()
                
                NormalButton(
                    buttonAction: {
                        dismiss()
                        viewModel.restarMatchValue()
                    },
                    title: "Cancel",
                    width: 100,
                    style: CancelButton()
                )
            }
            .padding(.bottom, 40)
            .padding(.horizontal, deviceIdiom == .pad ? 350 : 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.boxDark)
        .dismissKeyboardOnTapGesture()
    }
}

#Preview {
RegisterMatchView(viewModel: .constant(HomeViewModel())
    )
}
