//
//  NameInputMode.swift
//  RadixTest
//
//  Created by Triet Le on 2.2.2024.
//

import Foundation

enum NameInputMode: Equatable {
    case firtname
    case lastname
}

extension NameInputMode {
    var placeholder: String {
        switch self {
        case .firtname:
            "Enter your first name here..."
        case .lastname:
            "Enter your last name here..."
        }
    }
}
