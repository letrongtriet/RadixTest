//
//  OnboardingView.swift
//  RadixTest
//
//  Created by Triet Le on 2.2.2024.
//

import ComposableArchitecture
import SwiftUI

struct OnboardingView: View {
    let store: StoreOf<Onboarding>

    var body: some View {
        NavigationStackStore(
            self.store.scope(state: \.path, action: Onboarding.Action.path)
        ) {
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
        } destination: { (state: Onboarding.Path.State) in
            switch state {
            case .yearOfBirth:
                CaseLet(
                    /Onboarding.Path.State.yearOfBirth,
                    action: Onboarding.Path.Action.yearOfBirth,
                    then: YearOfBirthView.init(store:)
                )
            case .namingMain:
                CaseLet(
                    /Onboarding.Path.State.namingMain,
                    action: Onboarding.Path.Action.namingMain,
                    then: NamingMainView.init(store:)
                )
            case .onboardingCompletion:
                CaseLet(
                    /Onboarding.Path.State.onboardingCompletion,
                    action: Onboarding.Path.Action.onboardingCompletion,
                    then: OnboardingCompletionView.init(store:)
                )
            }
        }
    }
}

#Preview {
    OnboardingView(
        store: .init(
            initialState: .init(),
            reducer: { Onboarding() }
        )
    )
}
