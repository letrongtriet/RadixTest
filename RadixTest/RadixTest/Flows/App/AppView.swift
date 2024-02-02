//
//  AppView.swift
//  RadixTest
//
//  Created by Triet Le on 2.2.2024.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: StoreOf<AppReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            getRootView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        viewStore.send(.onAppear)
                    }
                }
        }
    }

    @ViewBuilder
    func getRootView() -> some View {
        SwitchStore(store) {
            switch $0 {
            case .splash:
                CaseLet(/AppReducer.State.splash, action: AppReducer.Action.splash) {
                    SplashView(store: $0)
                }
            case .onboarding:
                CaseLet(/AppReducer.State.onboarding, action: AppReducer.Action.onboarding) {
                    OnboardingView(store: $0)
                }
            case .home:
                CaseLet(/AppReducer.State.home, action: AppReducer.Action.home) {
                    HomeView(store: $0)
                }
            }
        }
    }
}

#Preview {
    AppView(
        store: .init(
            initialState: .init(),
            reducer: { AppReducer() }
        )
    )
}
