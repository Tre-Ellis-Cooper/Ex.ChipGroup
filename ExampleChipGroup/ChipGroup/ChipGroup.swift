//
//  ChipGroup.swift
//  ExampleChipGroup
//
//  Created by Tre Cooper on 2/14/22.
//

import SwiftUI

/// A view representing a chip group.
///
/// - note: Dynamically line wraps the provided chip elements according
///         to the allowed width. Only allows left-alignment
struct ChipGroup<Element: Identifiable, Chip: View>: View {
    @State private var sizes = [Element.ID: CGSize]()
    @State private var width = CGFloat.zero
    
    private var spacing = (CGFloat(5), CGFloat(10))
    
    let chipView: (Element) -> Chip
    let layout: ChipGroupLayout<Element>
    
    init(elements: [Element],
         @ViewBuilder chipView: @escaping (Element) -> Chip) {
        self.chipView = chipView
        self.layout = .init(elements: elements)
    }
    
    var body: some View {
        let layoutTraits = layout
            .traitsForChipSizes(sizes, in: width, with: spacing)
        
        return VStack(spacing: .zero) {
            Spacer()
                .frame(height: .zero)
                .frame(maxWidth: .infinity)
                .relaySizeData(withKey: "chip-group-size")
            ZStack(alignment: .topLeading) {
                ForEach(layoutTraits) { trait in
                    chipView(trait.element)
                        .relaySizeData(withKey: trait.element.id)
                        .alignmentGuide(.leading) { _ in -trait.position.x }
                        .alignmentGuide(.top) { _ in -trait.position.y }
                }
            }
            .frame(
                minWidth: .zero,
                maxWidth: .infinity,
                alignment: .leading
            )
        }
        .readSizeData { sizes = $0 }
        .readSizeData(forKey: "chip-group-size") { width = $0.width }
    }
    
    /// Sets the spacing between chips within this chip group element.
    ///
    /// For example, this is how you would set the spacing for a
    /// ChipGroup element.
    ///
    ///     var body: some View {
    ///         ChipGroup(elements: [Identifiable], chipView: ChipView.init)
    ///             .chipSpacing(horizontal: 5, vertical: 10)
    ///     }
    ///
    /// - parameter horizontal: The horizontal spacing desired.
    /// - parameter vertical: The vertical spacing desired.
    func chipSpacing(horizontal: CGFloat, vertical: CGFloat) -> Self {
        var mutableSelf = self
        
        mutableSelf.spacing = (horizontal, vertical)
        return mutableSelf
    }
}
