//
//  RadixTestApp.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import SwiftUI

@main
struct RadixTestApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: .init(
                    initialState: .init(),
                    reducer: { AppReducer() }
                )
            )
        }
    }
}
