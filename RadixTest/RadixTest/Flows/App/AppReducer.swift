//
//  AppReducer.swift
//  RadixTest
//
//  Created by Triet Le on 2.2.2024.
//

import ComposableArchitecture
import Foundation

struct AppReducer: Reducer {
    @Dependency(\.userDetailsClient) private var userDetailsClient

    enum State: Equatable {
        case splash(Splash.State)
        case onboarding(Onboarding.State)
        case home(Home.State)

        init() {
            self = State.splash(.init())
        }
    }

    enum Action {
        case splash(Splash.Action)
        case onboarding(Onboarding.Action)
        case home(Home.Action)
        case onAppear
    }

    var body: some Reducer<State, Action> {
        Reduce<State, Action> { (state: inout State, action: Action) -> Effect<Action> in
            switch action {
            case .onAppear:
                if userDetailsClient.isUserOnboarded() {
                    state = State.home(.init())
                } else {
                    state = State.onboarding(.init())
                }
                
                return .none

            case .onboarding(.delegate(.onboarded)):
                state = State.home(.init())
                return .none

            default:
                return .none
            }
        }
        ._printChanges()
        .ifCaseLet(/State.splash, action: /Action.splash) {
            Splash()
        }
        .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
            Onboarding()
        }
        .ifCaseLet(/State.home, action: /Action.home) {
            Home()
        }
    }
}
