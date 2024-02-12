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
            case namingMain(NamingMain.State)
        }

        enum Action: Equatable {
            case namingMain(NamingMain.Action)
        }

        var body: some Reducer<State, Action> {
            Scope(state: /State.namingMain, action: /Action.namingMain) {
                NamingMain()
            }
        }
    }

    typealias State = TCAState<External, Internal>

    struct External: Equatable {}

    struct Internal: Equatable {
        var path = StackState<Path.State>()
        var userDetails: UserDetails?
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
                if let firstname = state.userDetails?.firstname, let lastname = state.userDetails?.lastname {
                    let namingMainSate: NamingMain.State = .init(firstname: firstname, lastname: lastname)
                    let pathState: Path.State = .namingMain(namingMainSate)
                    state.path.append(
                        pathState
                    )
                }
                return .none

            case let .path(action):
                switch action {
                case let .element(id: _, action: .namingMain(.delegate(.namingCompleted(firstname, lastname)))):
                    if let old = state.userDetails {
                        let userDetails = UserDetails(
                            yearOfBirth: old.yearOfBirth,
                            firstname: firstname,
                            lastname: lastname
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
