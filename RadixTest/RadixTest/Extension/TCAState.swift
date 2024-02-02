//
//  TCAState.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import Foundation

@dynamicMemberLookup
struct TCAState<External: Equatable, Internal: Equatable>: Equatable {
    var externalState: External
    var internalState: Internal

    subscript<Value>(
        dynamicMember keyPath: WritableKeyPath<External, Value>
    ) -> Value {
        get { self.externalState[keyPath: keyPath] }
        set { self.externalState[keyPath: keyPath] = newValue }
    }

    subscript<Value>(
        dynamicMember keyPath: WritableKeyPath<Internal, Value>
    ) -> Value {
        get { self.internalState[keyPath: keyPath] }
        set { self.internalState[keyPath: keyPath] = newValue }
    }
}
