//
//  Onboarding.swift
//  RadixTest
//
//  Created by Triet Le on 2.2.2024.
//

import ComposableArchitecture
import Foundation

extension Onboarding.State {
    init() {
        internalState = .init()
        externalState = .init()
    }
}

struct Onboarding: Reducer {
    struct Path: Reducer {
        enum State: Equatable {
            case yearOfBirth(YearOfBirth.State)
            case firstname(NameInput.State)
            case lastname(NameInput.State)
            case nameCompletion(NameCompletion.State)
            case onboardingCompletion(OnboardingCompletion.State)
        }

        enum Action: Equatable {
            case yearOfBirth(YearOfBirth.Action)
            case firstname(NameInput.Action)
            case lastname(NameInput.Action)
            case nameCompletion(NameCompletion.Action)
            case onboardingCompletion(OnboardingCompletion.Action)
        }

        var body: some Reducer<State, Action> {
            Scope(state: /State.yearOfBirth, action: /Action.yearOfBirth) {
                YearOfBirth()
            }
            Scope(state: /State.firstname, action: /Action.firstname) {
                NameInput()
            }
            Scope(state: /State.lastname, action: /Action.lastname) {
                NameInput()
            }
            Scope(state: /State.nameCompletion, action: /Action.nameCompletion) {
                NameCompletion()
            }
            Scope(state: /State.onboardingCompletion, action: /Action.onboardingCompletion) {
                OnboardingCompletion()
            }
        }
    }

    typealias State = TCAState<External, Internal>

    struct External: Equatable {}

    struct Internal: Equatable {
        var welcomeText = "Welcome to Radix"

        var yearOfBirth: Int = -1
        var firstname: String?
        var lastname: String?

        var path = StackState<Path.State>()
    }

    enum Action: Equatable {
        case didSelectGetStarted

        case path(StackAction<Path.State, Path.Action>)

        case delegate(Delegate)
        enum Delegate: Equatable {
            case onboarded
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didSelectGetStarted:
                let yearOfBirthState: YearOfBirth.State = .init(
                    externalState: .init(),
                    internalState: .init()
                )
                let pathState: Path.State = .yearOfBirth(yearOfBirthState)
                state.path.append(
                    pathState
                )
                return .none

            case let .path(action):
                switch action {
                case let .element(id: _, action: .yearOfBirth(.delegate(.yearOfBirthConfimed(yearOfBirth)))):
                    state.yearOfBirth = yearOfBirth

                    if yearOfBirth.age >= 18 {
                        let firstnameState: NameInput.State = .init(
                            externalState: .init(),
                            internalState: .init(inputMode: .firtname)
                        )
                        let pathState: Path.State = .firstname(firstnameState)
                        state.path.append(
                            pathState
                        )
                    } else {
                        let userDetails = UserDetails(
                            yearOfBirth: state.yearOfBirth,
                            firstname: nil,
                            lastname: nil
                        )
                        let onboardingCompletionState: OnboardingCompletion.State = .init(
                            externalState: .init(userDetails: userDetails),
                            internalState: .init()
                        )
                        let pathState: Path.State = .onboardingCompletion(onboardingCompletionState)
                        state.path.append(
                            pathState
                        )
                    }

                    return .none

                case let .element(id: _, action: .firstname(.delegate(.inputConfimed(firstname)))):
                    state.firstname = firstname
                    let lastnameState: NameInput.State = .init(
                        externalState: .init(),
                        internalState: .init(inputMode: .lastname)
                    )
                    let pathState: Path.State = .lastname(lastnameState)
                    state.path.append(
                        pathState
                    )
                    return .none

                case let .element(id: _, action: .lastname(.delegate(.inputConfimed(lastname)))):
                    state.lastname = lastname

                    if let firstname = state.firstname, let lastname = state.lastname {
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
                    let userDetails = UserDetails(
                        yearOfBirth: state.yearOfBirth,
                        firstname: state.firstname,
                        lastname: state.lastname
                    )
                    let onboardingCompletionState: OnboardingCompletion.State = .init(
                        externalState: .init(userDetails: userDetails),
                        internalState: .init()
                    )
                    let pathState: Path.State = .onboardingCompletion(onboardingCompletionState)
                    state.path.append(
                        pathState
                    )
                    return .none

                case .element(id: _, action: .onboardingCompletion(.delegate(.getStarted))):
                    return .send(.delegate(.onboarded))

                default:
                    return .none
                }

            case .delegate:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
