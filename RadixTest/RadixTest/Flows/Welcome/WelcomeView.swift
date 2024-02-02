//
//  WelcomeView.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import SwiftUI

struct WelcomeView: View {
    let store: StoreOf<Welcome>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()

                Text(verbatim: viewStore.welcomeText)
                    .font(.title)

                Spacer()

                Button {
                    viewStore.send(.didSelectGetStarted)
                } label: {
                    HStack {
                        Spacer()
                        Text("Get Started")
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
    WelcomeView(
        store: .init(
            initialState: .init(),
            reducer: { Welcome() }
        )
    )
}
