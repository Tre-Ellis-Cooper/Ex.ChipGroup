//
//  View+Size.swift
//  ChipGroup
//
//  Created by Tre Cooper on 2/14/22.
//

import SwiftUI

/// Convenience extension to make providing and reading CGSize
/// data more compact and easer to read.
extension View {
    /// Adds an action to perform when the relayed size data for this
    /// view or any of it's subviews changes.
    ///
    /// - note: Use this method to read all size data associated with a particular
    ///         key type. For example, specifiying a `KeyType` of `String`
    ///         will gather all size data with a `String` key type.
    /// - parameter closure: The closure to perform with new size data.
    func readSizeData<KeyType: Hashable>(
        closure: @escaping ([KeyType: CGSize]) -> Void
    ) -> some View {
        self.onPreferenceChange(SizePreference<KeyType>.self, perform: closure)
    }
    
    /// Adds an action to perform when the relayed size data associated with the
    /// provided key changes.
    ///
    /// - parameter key: The key who's size value you wish to read.
    /// - parameter closure: The closure to perform with size data.
    func readSizeData<KeyType: Hashable>(
        forKey key: KeyType,
        closure: @escaping (CGSize) -> Void
    ) -> some View {
        self.onPreferenceChange(SizePreference<KeyType>.self) { data in
            DispatchQueue.main.async {
                closure(data[key] ?? .zero)
            }
        }
    }
    
    /// Propogates the size data for this view with the provided key.
    ///
    /// - note: Can be read using either `readSizeData` method.
    /// - parameter key: The key to associate with this view's size data.
    func relaySizeData<KeyType: Hashable>(withKey key: KeyType) -> some View {
        self.background(
            GeometryReader { proxy in
                Spacer()
                    .preference(
                        key: SizePreference<KeyType>.self,
                        value: [key: proxy.size]
                    )
            }
        )
    }
}
    
