//
//  ChipGroupLayoutTests.swift
//  ExampleChipGroup
//
//  Created by Tre Cooper on 2/14/22.
//

import XCTest

@testable import ExampleChipGroup

final class ChipGroupLayoutTests: XCTestCase {
    func test_execute_layoutTraitsForChipSizes_didSucceed() {
        let elements = [
            Element(id: "Chip1"),
            Element(id: "Chip2"),
            Element(id: "Chip3"),
            Element(id: "Chip4"),
            Element(id: "Chip5")
        ]
        let sizes = [
            "Chip1": CGSize(width: 20, height: 10),
            "Chip2": CGSize(width: 20, height: 15),
            "Chip3": CGSize(width: 30, height: 10),
            "Chip4": CGSize(width: 30, height: 10),
            "Chip5": CGSize(width: 10, height: 10)
        ]
        let correctPositions = [
            "Chip1": CGPoint(x: 0, y: 0),
            "Chip2": CGPoint(x: 25, y: 0),
            "Chip3": CGPoint(x: 0, y: 20),
            "Chip4": CGPoint(x: 0, y: 35),
            "Chip5": CGPoint(x: 35, y: 35),
        ]
        
        let layout = ChipGroupLayout(elements: elements)
        let traits = layout.traitsForChipSizes(sizes, in: 50, with: (5,5))
        
        for trait in traits {
            XCTAssertEqual(trait.position,
                           correctPositions[trait.id],
                           "Trait doesn't have expected position value.")
        }
    }
}

/// Stub identifiable element for testing.
private struct Element: Identifiable {
    let id: String
}
