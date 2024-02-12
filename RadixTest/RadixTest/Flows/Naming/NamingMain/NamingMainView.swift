//
//  NamingMainView.swift
//  RadixTest
//
//  Created by Triet Le on 12.2.2024.
//

import ComposableArchitecture
import SwiftUI

struct NamingMainView: View {
    let store: StoreOf<NamingMain>

    var body: some View {
        SwitchStore(store.scope(state: \.rootState, action: NamingMain.Action.root), content: { state in
            switch state {
            case .firstname:
                CaseLet(/NamingMain.Root.State.firstname, action: NamingMain.Root.Action.firstname) {
                    NameInputView(store: $0)
                }

            case .lastname:
                CaseLet(/NamingMain.Root.State.lastname, action: NamingMain.Root.Action.lastname) {
                    NameInputView(store: $0)
                }

            case .nameCompletion:
                CaseLet(/NamingMain.Root.State.nameCompletion, action: NamingMain.Root.Action.nameCompletion) {
                    NameCompletionView(store: $0)
                }
            }
        })
    }
}

#Preview {
    NamingMainView(
        store: .init(
            initialState: .init(),
            reducer: { NamingMain() }
        )
    )
}
