//
//  Welcome.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import Foundation

extension Welcome.State {
    init() {
        internalState = .init()
        externalState = .init()
    }
}

struct Welcome: Reducer {
    typealias State = TCAState<External, Internal>

    struct External: Equatable {}

    struct Internal: Equatable {
        var welcomeText = "Welcome to Radix"
    }

    enum Action: Equatable {
        case didSelectGetStarted

        case delegate(Delegate)
        enum Delegate: Equatable {
            case getStarted
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didSelectGetStarted:
                return .send(.delegate(.getStarted))
            case .delegate:
                return .none
            }
        }
    }
}
