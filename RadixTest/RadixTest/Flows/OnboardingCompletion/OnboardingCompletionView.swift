//
//  OnboardingCompletionView.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import SwiftUI

struct OnboardingCompletionView: View {
    let store: StoreOf<OnboardingCompletion>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text(verbatim: viewStore.welcomeText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .onAppear {
                    viewStore.send(.onAppear)
                }
        }
    }
}

#Preview {
    OnboardingCompletionView(
        store: .init(
            initialState: .init(),
            reducer: { OnboardingCompletion() }
        )
    )
}
