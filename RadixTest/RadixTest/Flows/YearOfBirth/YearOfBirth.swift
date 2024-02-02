//
//  YearOfBirth.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import Foundation

extension YearOfBirth.State {
    init() {
        internalState = .init()
        externalState = .init()
    }
}

struct YearOfBirth: Reducer {
    typealias State = TCAState<External, Internal>

    struct External: Equatable {}

    struct Internal: Equatable {
        var yearOfBirth = ""
        var isConfirmButtonDisabled = true

        @PresentationState var errorAlert: AlertState<Action>?
    }

    enum Action: Equatable {
        case yearOfBirthChanged(String)

        case didSelectConfirm

        case error(Error)

        case alert(PresentationAction<Action>)
        case alertDismissed

        case delegate(Delegate)
        enum Delegate: Equatable {
            case yearOfBirthConfimed(Int)
        }
    }

    enum Error: String, Equatable {
        case invalid

        var rawValue: String {
            switch self {
            case .invalid:
                return "Invalid year of birth. Please try again"
            }
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .yearOfBirthChanged(yearOfBirth):
                state.yearOfBirth = yearOfBirth
                state.isConfirmButtonDisabled = yearOfBirth.isEmpty || yearOfBirth.count < 4 || yearOfBirth.count > 4
                return .none

            case .delegate:
                return .none

            case .didSelectConfirm:
                guard let yearOfBirthFormatted = Int(state.yearOfBirth) else { return .none }
                return .send(.delegate(.yearOfBirthConfimed(yearOfBirthFormatted)))

            case let .error(error):
                state.errorAlert = .init(
                    title: .init("Error"),
                    message: .init(error.rawValue),
                    dismissButton: .default(.init("Ok"))
                )
                return .none

            case .alert:
                return .none
            case .alertDismissed:
                state.errorAlert = nil
                return .none
            }
        }
        .ifLet(\.$errorAlert, action: /Action.alert)
    }
}
