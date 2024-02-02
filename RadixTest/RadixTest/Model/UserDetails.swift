//
//  UserDetails.swift
//  RadixTest
//
//  Created by Triet Le on 2.2.2024.
//

import Foundation

struct UserDetails: Codable, Equatable {
    let yearOfBirth: Int
    let firstname: String?
    let lastname: String?
}
