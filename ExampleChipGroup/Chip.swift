//
//  Chip.swift
//  ExampleChipGroup
//
//  Created by Tre Cooper on 4/5/22.
//

import SwiftUI

/// A struct representing an example chip element.
struct Chip {
    let title: String
}

extension Chip: Identifiable {
    var id: String { title }
}
