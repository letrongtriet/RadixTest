//
//  NameCompletion.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import Foundation

extension NameCompletion.State {
    init() {
        internalState = .init()
        externalState = .init(lastname: "First Name", firstname: "Last Name")
    }
}

struct NameCompletion: Reducer {
    typealias State = TCAState<External, Internal>

    struct External: Equatable {
        var lastname: String
        var firstname: String
    }

    struct Internal: Equatable {}

    enum Action: Equatable {
        case didSelectContinue

        case delegate(Delegate)
        enum Delegate: Equatable {
            case onContinue
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didSelectContinue:
                return .send(.delegate(.onContinue))
            case .delegate:
                return .none
            }
        }
    }
}
