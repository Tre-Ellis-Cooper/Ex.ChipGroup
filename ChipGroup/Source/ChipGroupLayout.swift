//
//  ChipGroupLayout.swift
//  ChipGroup
//
//  Created by Tre Cooper on 4/5/22.
//

import CoreGraphics

/// An object housing the chip group layout logic.
///
/// - note: This object was inspired by an UICollectionViewLayout object.
///         It was created to allow the layout logic itself to be completely
///         testable in a vacuum. See `ChipGroupLayoutTests.swift`.
struct ChipGroupLayout<Element: Identifiable> {
    let elements: [Element]
    
    /// Returns the chip group layout traits for the provided dimensions.
    ///
    /// - parameter chipSizes: A dictionary of the element sizes.
    /// - parameter containerWidth: The width of the container.
    /// - parameter spacing: The desired spacing between chips.
    /// - returns: An array representing each element and it's laidout position.
    func traits(
        for chipSizes: [Element.ID: CGSize],
        in containerWidth: CGFloat,
        with spacing: Spacing
    ) -> [Trait] {
        var pointer = CGPoint.zero
        var lineHeight = CGFloat.zero
        var traits: [Trait] = []
        
        for element in elements {
            let size = chipSizes[element.id] ?? .zero
            let newline = pointer.x + size.width > containerWidth
            
            if newline {
                pointer.x = .zero
                pointer.y += lineHeight + spacing.vertical
                lineHeight = .zero
            }

            traits.append(Trait(element: element, position: pointer))
            pointer.x += size.width + spacing.horizontal
            lineHeight = max(lineHeight, size.height)
        }
        
        return traits
    }
    
    // MARK: - ChipGroupLayout.Spacing
    typealias Spacing = (horizontal: CGFloat, vertical: CGFloat)
    
    // MARK: - ChipGroupLayout.Trait
    /// An object representing the layout traits of a chip element.
    struct Trait: Identifiable {
        let element: Element
        let position: CGPoint
        
        var id: Element.ID {
            element.id
        }
    }
}
