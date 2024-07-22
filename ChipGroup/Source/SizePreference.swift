//
//  SizePreference.swift
//  ChipGroup
//
//  Created by Tre Cooper on 4/5/22.
//

import SwiftUI

/// A preference key that allows the propogation of CGSize data
/// witin the SwiftUI view hierarchy.
struct SizePreference<KeyType: Hashable>: PreferenceKey {
    typealias Value = [KeyType: CGSize]
    
    static var defaultValue: Value { [:] }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}
