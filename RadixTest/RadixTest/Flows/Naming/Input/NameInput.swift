//
//  NameInput.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import Foundation

extension NameInput.State {
    init() {
        internalState = .init(inputMode: .firtname)
        externalState = .init()
    }
}

struct NameInput: Reducer {
    typealias State = TCAState<External, Internal>

    struct External: Equatable {
        var input: String = ""
    }

    struct Internal: Equatable {
        var inputMode: NameInputMode
        var isContinueButtonDisabled = true
    }

    enum Action: Equatable {
        case onAppear

        case inputChanged(String)

        case didSelectContinue

        case delegate(Delegate)
        enum Delegate: Equatable {
            case inputConfimed(String)
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isContinueButtonDisabled = state.input.isEmpty
                return .none

            case let .inputChanged(input):
                state.input = input
                state.isContinueButtonDisabled = input.isEmpty
                return .none

            case .delegate:
                return .none

            case .didSelectContinue:
                return .send(.delegate(.inputConfimed(state.input)))
            }
        }
    }
}
