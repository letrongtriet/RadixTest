//
//  NamingMain.swift
//  RadixTest
//
//  Created by Triet Le on 12.2.2024.
//

import ComposableArchitecture
import Foundation

struct NamingMain: Reducer {
    struct Root: Reducer {
        enum Option {
            case firstname, lastname, nameCompletion
        }

        enum State: Equatable {
            case firstname(NameInput.State)
            case lastname(NameInput.State)
            case nameCompletion(NameCompletion.State)
        }

        enum Action: Equatable {
            case firstname(NameInput.Action)
            case lastname(NameInput.Action)
            case nameCompletion(NameCompletion.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: /State.firstname, action: /Action.firstname) {
                NameInput()
            }
            Scope(state: /State.lastname, action: /Action.lastname) {
                NameInput()
            }
            Scope(state: /State.nameCompletion, action: /Action.nameCompletion) {
                NameCompletion()
            }
        }
    }

    struct ObserveState: Equatable {
        var rootState: Root.State

        init(state: State) {
            rootState = state.rootState
        }
    }

    struct State: Equatable {
        var root: Root.Option = .firstname

        var firstname: String = ""
        var lastname: String = ""

        var rootState: Root.State {
            get {
                switch root {
                case .firstname:
                    return .firstname(firstnameState)
                case .lastname:
                    return .lastname(lastnameState)
                case .nameCompletion:
                    return .nameCompletion(nameCompletionState)
                }
            }
            set {
                print("new root state value \(newValue)")
                switch newValue {
                case let .firstname(firstnameState):
                    self.firstnameState = firstnameState
                case let .lastname(lastnameState):
                    self.lastnameState = lastnameState
                case let .nameCompletion(nameCompletionState):
                    self.nameCompletionState = nameCompletionState
                }
            }
        }

        var firstnameState: NameInput.State {
            get {
                NameInput.State(
                    externalState: .init(input: firstname),
                    internalState: firstnameInternal
                )
            }
            set {
                firstname = newValue.input
                firstnameInternal = newValue.internalState
            }
        }
        var firstnameInternal: NameInput.Internal = .init(inputMode: .firtname)

        var lastnameState: NameInput.State {
            get {
                NameInput.State(
                    externalState: .init(input: lastname),
                    internalState: lastnameInternal
                )
            }
            set {
                lastname = newValue.input
                lastnameInternal = newValue.internalState
            }
        }
        var lastnameInternal: NameInput.Internal = .init(inputMode: .lastname)

        var nameCompletionState: NameCompletion.State {
            get {
                NameCompletion.State(
                    externalState: .init(
                        lastname: firstname,
                        firstname: lastname
                    ),
                    internalState: nameCompletionInternal
                )
            }
            set {
                nameCompletionInternal = newValue.internalState
            }
        }
        var nameCompletionInternal: NameCompletion.Internal = .init()
    }

    enum Action: Equatable {
        case root(Root.Action)

        case delegate(Delegate)
        enum Delegate: Equatable {
            case namingCompleted(String, String) // firstname, lastname
        }
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.rootState, action: /Action.root) {
            Root()
        }
        Reduce<State, Action> { (state: inout State, action: Action) -> Effect<Action> in
            switch action {
            case let .root(rootAction):
                switch rootAction {
                case let .firstname(.delegate(.inputConfimed(firstname))):
                    state.firstname = firstname
                    state.root = .lastname
                    return .none

                case let .lastname(.delegate(.inputConfimed(lastname))):
                    state.lastname = lastname
                    state.root = .nameCompletion
                    return .none

                case .nameCompletion(.delegate(.onContinue)):
                    return .send(.delegate(.namingCompleted(state.firstname, state.lastname)))

                default:
                    return .none
                }

            default:
                return .none
            }
        }
    }
}
