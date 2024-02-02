//
//  Splash.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import Foundation

extension Splash.State {
    init() {
        internalState = .init()
        externalState = .init()
    }
}

struct Splash: Reducer {
    typealias State = TCAState<External, Internal>

    struct External: Equatable {}

    struct Internal: Equatable {
        var splashText = "Radix"
    }

    enum Action: Equatable {}

    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}
