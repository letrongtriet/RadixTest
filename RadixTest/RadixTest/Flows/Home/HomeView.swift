//
//  HomeView.swift
//  RadixTest
//
//  Created by Triet Le on 2.2.2024.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    let store: StoreOf<Home>

    var body: some View {
        NavigationStackStore(
            self.store.scope(state: \.path, action: Home.Action.path)
        ) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Spacer()

                    Text(verbatim: "\(viewStore.userDetails?.yearOfBirth ?? -1)")
                        .font(.title)

                    if let firstname = viewStore.userDetails?.firstname, let lastname = viewStore.userDetails?.lastname {
                        Text(verbatim: "\(firstname) \(lastname)")
                            .font(.title)
                    }

                    Spacer()

                    if (viewStore.userDetails?.yearOfBirth.age ?? -1) >= 18 {
                        Button {
                            viewStore.send(.didSelectChangeName)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Update name")
                                    .font(.headline)
                                    .foregroundStyle(Color.white)
                                Spacer()
                            }
                            .padding(.vertical)
                            .background(Color.blue.opacity(0.7))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .padding([.bottom, .horizontal])
                    }
                }
                .task {
                    viewStore.send(.task)
                }
            }
        } destination: { (state: Home.Path.State) in
            switch state {
            case .firstname:
                CaseLet(
                    /Home.Path.State.firstname,
                    action: Home.Path.Action.firstname,
                    then: NameInputView.init(store:)
                )
            case .lastname:
                CaseLet(
                    /Home.Path.State.lastname,
                    action: Home.Path.Action.lastname,
                    then: NameInputView.init(store:)
                )
            case .nameCompletion:
                CaseLet(
                    /Home.Path.State.nameCompletion,
                    action: Home.Path.Action.nameCompletion,
                    then: NameCompletionView.init(store:)
                )
            }
        }
    }
}

#Preview {
    HomeView(
        store: .init(
            initialState: .init(),
            reducer: { Home() }
        )
    )
}