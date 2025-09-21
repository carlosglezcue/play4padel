//
//  RegisterSection.swift
//  Play4Padel
//
//  Created by Carlos Gonzalez on 2/11/24.
//

import SwiftUI

struct RegisterSetsSection: View {
    
    @Binding var userSet: String
    @Binding var rivalSet: String
    let title: LocalizedStringKey
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
            TextField("", text: $userSet)
                .font(.callout)
                .foregroundStyle(.gray)
                .textFieldStyle(.roundedBorder)
                .frame(width: 50)
                .keyboardType(.numberPad)
            Text("-")
            TextField("", text: $rivalSet)
                .font(.callout)
                .foregroundStyle(.gray)
                .textFieldStyle(.roundedBorder)
                .frame(width: 50)
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    RegisterSetsSection(
        userSet: .constant(""),
        rivalSet: .constant(""),
        title: "First Set:"
    )
}
