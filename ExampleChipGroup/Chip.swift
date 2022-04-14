//
//  Chip.swift
//  ExampleChipGroup
//
//  Created by Tre Cooper on 4/5/22.
//

import SwiftUI

/// A struct representing an example chip element.
struct Chip: Identifiable {
    let id = UUID()
    let title: String
    let colorName = RandomChipColor
    
    private static var RandomChipColor: String {
        return [
            String.Asset.chipColor1,
            String.Asset.chipColor2,
            String.Asset.chipColor3
        ]
        .randomElement() ?? String.Asset.chipColor1
    }
}
