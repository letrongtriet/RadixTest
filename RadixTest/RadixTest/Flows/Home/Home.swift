//
//  Home.swift
//  RadixTest
//
//  Created by Triet Le on 2.2.2024.
//

import ComposableArchitecture
import Foundation

extension Home.State {
    init() {
        internalState = .init()
        externalState = .init()
    }
}

struct Home: Reducer {
    @Dependency(\.userDetailsClient) private var userDetailsClient

    struct Path: Reducer {
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

        var body: some Reducer<State, Action> {
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

    typealias State = TCAState<External, Internal>

    struct External: Equatable {}

    struct Internal: Equatable {
        var path = StackState<Path.State>()

        var userDetails: UserDetails?

        var tempFirstName: String?
        var tempLastName: String?
    }

    enum Action: Equatable {
        case task
        case didSelectChangeName

        case path(StackAction<Path.State, Path.Action>)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .task:
                state.userDetails = userDetailsClient.getUserDetails()
                return .none

            case .didSelectChangeName:
                if let firstname = state.userDetails?.firstname {
                    let firstnameState: NameInput.State = .init(
                        externalState: .init(),
                        internalState: .init(inputMode: .firtname, input: firstname)
                    )
                    let pathState: Path.State = .firstname(firstnameState)
                    state.path.append(
                        pathState
                    )
                }

                return .none

            case let .path(action):
                switch action {
                case let .element(id: _, action: .firstname(.delegate(.inputConfimed(firstname)))):
                    state.tempFirstName = firstname
                    
                    if let lastname = state.userDetails?.lastname {
                        let lastnameState: NameInput.State = .init(
                            externalState: .init(),
                            internalState: .init(inputMode: .lastname, input: lastname)
                        )
                        let pathState: Path.State = .lastname(lastnameState)
                        state.path.append(
                            pathState
                        )
                    }

                    return .none

                case let .element(id: _, action: .lastname(.delegate(.inputConfimed(lastname)))):
                    state.tempLastName = lastname

                    if let firstname = state.tempFirstName, let lastname = state.tempLastName {
                        let nameCompletionState: NameCompletion.State = .init(
                            externalState: .init(),
                            internalState: .init(
                                lastname: firstname,
                                firstname: lastname
                            )
                        )
                        let pathState: Path.State = .nameCompletion(nameCompletionState)
                        state.path.append(
                            pathState
                        )
                    }

                    return .none

                case .element(id: _, action: .nameCompletion(.delegate(.onContinue))):
                    if let old = state.userDetails {
                        let userDetails = UserDetails(
                            yearOfBirth: old.yearOfBirth,
                            firstname: state.tempFirstName,
                            lastname: state.tempLastName
                        )
                        userDetailsClient.storeUserDetails(userDetails)
                        state.userDetails = userDetails
                    }
                    state.path = .init()
                    return .none

                default:
                    return .none
                }
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
