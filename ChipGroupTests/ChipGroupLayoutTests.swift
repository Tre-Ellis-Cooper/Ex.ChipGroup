//
//  ChipGroupLayoutTests.swift
//  ChipGroup
//
//  Created by Tre Cooper on 2/14/22.
//

import XCTest

@testable import ExampleChipGroup

final class ChipGroupLayoutTests: XCTestCase {
    func test_execute_layoutTraitsForChipSizes() {
        let elements = [
            Chip(title: "Chip1"),
            Chip(title: "Chip2"),
            Chip(title: "Chip3"),
            Chip(title: "Chip4"),
            Chip(title: "Chip5")
        ]
        let elementSizes = [
            "Chip1": CGSize(width: 20, height: 10),
            "Chip2": CGSize(width: 20, height: 15),
            "Chip3": CGSize(width: 30, height: 10),
            "Chip4": CGSize(width: 30, height: 10),
            "Chip5": CGSize(width: 10, height: 10)
        ]
        
        let allowedWidth: CGFloat = 50
        let spacing: ChipGroupLayout.Spacing = (horizontal: 5, vertical: 5)
        
        let layout = ChipGroupLayout(elements: elements)
        let traits = layout.traits(for: elementSizes,
                                   in: allowedWidth,
                                   with: spacing)

        let correctPositions = [
            "Chip1": CGPoint(x: 0, y: 0),
            "Chip2": CGPoint(x: 25, y: 0),
            "Chip3": CGPoint(x: 0, y: 20),
            "Chip4": CGPoint(x: 0, y: 35),
            "Chip5": CGPoint(x: 35, y: 35),
        ]
        
        for trait in traits {
            XCTAssertEqual(trait.position,
                           correctPositions[trait.id],
                           "Trait doesn't have expected position value.")
        }
    }
}
