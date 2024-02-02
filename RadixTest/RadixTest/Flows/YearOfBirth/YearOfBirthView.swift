//
//  YearOfBirthView.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import SwiftUI

struct YearOfBirthView: View {
    let store: StoreOf<YearOfBirth>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()

                TextField(
                    "Enter your year of birth here...",
                    text: viewStore.binding(
                        get: \.yearOfBirth,
                        send: YearOfBirth.Action.yearOfBirthChanged
                    )
                )
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .keyboardType(.numberPad)

                Spacer()

                Button {
                    viewStore.send(.didSelectConfirm)
                } label: {
                    HStack {
                        Spacer()
                        Text("Confirm")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                    .padding(.vertical)
                    .background(Color.blue.opacity(0.7))
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.bottom)
                .disabled(viewStore.isConfirmButtonDisabled)
            }
            .padding(.horizontal)
        }
        .alert(
            store: self.store.scope(state: \.$errorAlert, action: {
                .alert($0)
            })
        )
    }
}

#Preview {
    YearOfBirthView(
        store: .init(
            initialState: .init(),
            reducer: { YearOfBirth() }
        )
    )
}
