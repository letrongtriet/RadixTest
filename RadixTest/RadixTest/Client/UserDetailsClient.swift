//
//  UserDetailsClient.swift
//  RadixTest
//
//  Created by Triet Le on 2.2.2024.
//

import Dependencies
import Foundation

private enum UserDefaultsKey: String {
    case userOnboarded
    case userDetails
}

struct UserDetailsClient {
    var setUserOnboarded: @Sendable () -> Void
    var isUserOnboarded: @Sendable () -> Bool
    var storeUserDetails: @Sendable (UserDetails) -> Void
    var getUserDetails: @Sendable () -> UserDetails?
}

// - MARK: Composable Architecture `@Dependency` key support

extension UserDetailsClient: DependencyKey {
    static let liveValue = UserDetailsClient(
        setUserOnboarded: {
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.userOnboarded.rawValue)
        },
        isUserOnboarded: {
            UserDefaults.standard.bool(forKey: UserDefaultsKey.userOnboarded.rawValue)
        },
        storeUserDetails: { userDetails in
            if let encoded = try? JSONEncoder().encode(userDetails) {
                UserDefaults.standard.setValue(encoded, forKey: UserDefaultsKey.userDetails.rawValue)
            }
        },
        getUserDetails: {
            if let data = UserDefaults.standard.object(forKey: UserDefaultsKey.userDetails.rawValue) as? Data {
                let userDetails = try? JSONDecoder().decode(UserDetails.self, from: data)
                return userDetails
            }
            return nil
        }
    )
    static let testValue = UserDetailsClient(
        setUserOnboarded: {
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.userOnboarded.rawValue)
        },
        isUserOnboarded: {
            UserDefaults.standard.bool(forKey: UserDefaultsKey.userOnboarded.rawValue)
        },
        storeUserDetails: { userDetails in
            if let encoded = try? JSONEncoder().encode(userDetails) {
                UserDefaults.standard.setValue(encoded, forKey: UserDefaultsKey.userDetails.rawValue)
            }
        },
        getUserDetails: {
            if let data = UserDefaults.standard.object(forKey: UserDefaultsKey.userDetails.rawValue) as? Data {
                let userDetails = try? JSONDecoder().decode(UserDetails.self, from: data)
                return userDetails
            }
            return nil
        }
    )
}

extension DependencyValues {
    var userDetailsClient: UserDetailsClient {
        get { self[UserDetailsClient.self] }
        set { self[UserDetailsClient.self] = newValue }
    }
}
