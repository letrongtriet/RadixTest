//
//  Int+Age.swift
//  RadixTest
//
//  Created by Triet Le on 1.2.2024.
//

import Foundation

extension Int {
    var age: Int {
        let currentYear = Calendar.current.component(.year, from: Date.now)
        return currentYear - self
    }
}
