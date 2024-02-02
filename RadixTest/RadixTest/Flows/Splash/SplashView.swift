//
//  SplashView.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import ComposableArchitecture
import SwiftUI

struct SplashView: View {
    let store: StoreOf<Splash>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text(verbatim: viewStore.splashText)
                .font(.largeTitle)
        }
    }
}

#Preview {
    SplashView(
        store: .init(
            initialState: .init(),
            reducer: { Splash() }
        )
    )
}
