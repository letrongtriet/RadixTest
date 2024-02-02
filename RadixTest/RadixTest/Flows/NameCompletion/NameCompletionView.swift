//
//  NameCompletionView.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import SwiftUI

struct NameCompletionView: View {
    let store: StoreOf<NameCompletion>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()

                Text("Hi, \(viewStore.firstname) \(viewStore.lastname)")
                    .font(.headline)

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
                .padding([.bottom, .horizontal])
            }
        }
    }
}

#Preview {
    NameCompletionView(
        store: .init(
            initialState: .init(),
            reducer: { NameCompletion() }
        )
    )
}
