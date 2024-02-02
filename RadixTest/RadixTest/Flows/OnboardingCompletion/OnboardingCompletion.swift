//
//  OnboardingCompletion.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import Foundation

extension OnboardingCompletion.State {
    init() {
        internalState = .init()
        externalState = .init(userDetails: .init(yearOfBirth: 2002, firstname: nil, lastname: nil))
    }
}

struct OnboardingCompletion: Reducer {
    @Dependency(\.continuousClock) var clock
    @Dependency(\.userDetailsClient) private var userDetailsClient

    typealias State = TCAState<External, Internal>

    struct External: Equatable {
        var userDetails: UserDetails
    }

    struct Internal: Equatable {
        var welcomeText = "Welcome onboard.\nWe are preparing cool stuffs for you..."
    }

    enum Action: Equatable {
        case onAppear

        case delegate(Delegate)
        enum Delegate: Equatable {
            case getStarted
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [userDetails = state.userDetails] send in
                    userDetailsClient.setUserOnboarded()
                    userDetailsClient.storeUserDetails(userDetails)
                    
                    try await clock.sleep(for: .seconds(3))
                    
                    await send(.delegate(.getStarted))
                }
            case .delegate:
                return .none
            }
        }
    }
}

