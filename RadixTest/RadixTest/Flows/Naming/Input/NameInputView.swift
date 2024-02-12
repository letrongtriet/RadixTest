//
//  NameInputView.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import SwiftUI

struct NameInputView: View {
    let store: StoreOf<NameInput>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()

                TextField(
                    viewStore.inputMode.placeholder,
                    text: viewStore.binding(
                        get: \.input,
                        send: NameInput.Action.inputChanged
                    )
                )
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .keyboardType(.alphabet)

                Spacer()

                Button {
                    viewStore.send(.didSelectContinue)
                } label: {
                    HStack {
                        Spacer()
                        Text("Continue")
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
                .disabled(viewStore.isContinueButtonDisabled)
            }
            .padding(.horizontal)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    NameInputView(
        store: .init(
            initialState: .init(),
            reducer: { NameInput() }
        )
    )
}
