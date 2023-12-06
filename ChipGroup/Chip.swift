//
//  Chip.swift
//  ChipGroup
//
//  Created by Tre Cooper on 4/5/22.
//

import SwiftUI

/// A struct representing an example chip element.
struct Chip: Identifiable {
    let id: String
    let name: String
    
    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - Test Data
extension Chip {
    static let testSet = [
        Chip(name: "#swiftui"),
        Chip(name: "#ios"),
        Chip(name: "#codetoinspire"),
        Chip(name: "#iosdevelopment"),
        Chip(name: "#uiux"),
        Chip(name: "#xcode"),
        Chip(name: "#frontend"),
        Chip(name: "#swift"),
        Chip(name: "#appdevelopment")
    ]
}
