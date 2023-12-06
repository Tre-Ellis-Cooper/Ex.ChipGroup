//
//  ChipGroupLayoutTests.swift
//  ChipGroup
//
//  Created by Tre Cooper on 2/14/22.
//

import XCTest

@testable import ChipGroup

final class ChipGroupLayoutTests: XCTestCase {
    func test_execute_layoutTraitsForChipSizes() {
        let elements = [
            Chip(id: "id.1", name: "Chip1"),
            Chip(id: "id.2", name: "Chip2"),
            Chip(id: "id.3", name: "Chip3"),
            Chip(id: "id.4", name: "Chip4"),
            Chip(id: "id.5", name: "Chip5")
        ]
        let elementSizes = [
            "id.1": CGSize(width: 20, height: 10),
            "id.2": CGSize(width: 20, height: 15),
            "id.3": CGSize(width: 30, height: 10),
            "id.4": CGSize(width: 30, height: 10),
            "id.5": CGSize(width: 10, height: 10)
        ]
        
        let allowedWidth: CGFloat = 50
        let spacing: ChipGroupLayout.Spacing = (horizontal: 5, vertical: 5)
        
        let layout = ChipGroupLayout(elements: elements)
        let traits = layout.traits(
            for: elementSizes,
            in: allowedWidth,
            with: spacing
        )

        let correctPositions = [
            "id.1": CGPoint(x: 0, y: 0),
            "id.2": CGPoint(x: 25, y: 0),
            "id.3": CGPoint(x: 0, y: 20),
            "id.4": CGPoint(x: 0, y: 35),
            "id.5": CGPoint(x: 35, y: 35),
        ]
        
        for trait in traits {
            XCTAssertEqual(
                trait.position, correctPositions[trait.id],
                "Trait doesn't have expected position value."
            )
        }
    }
}
