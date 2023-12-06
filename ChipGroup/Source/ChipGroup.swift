//
//  ChipGroup.swift
//  ChipGroup
//
//  Created by Tre Cooper on 2/14/22.
//

import SwiftUI

/// A view representing a chip group.
///
/// - note: Dynamically line wraps the provided chip elements according
///         to the allowed width. Only allows left-alignment
struct ChipGroup<Element: Identifiable, Chip: View>: View {
    let chipView: (Element) -> Chip
    let elements: [Element]
    
    @State private var chipSizes = [Element.ID: CGSize]()
    @State private var allowedWidth = CGFloat.zero
    
    private var allowedWidthKey = "allowed-width-key"
    private var chipSpacing: ChipGroupLayout.Spacing = (5, 10)
    
    init(elements: [Element],
         @ViewBuilder chipView: @escaping (Element) -> Chip) {
        self.chipView = chipView
        self.elements = elements
    }
    
    var body: some View {
        let traits = ChipGroupLayout(elements: elements)
            .traits(for: chipSizes, in: allowedWidth, with: chipSpacing)
        
        return VStack(spacing: .zero) {
            Spacer()
                .frame(height: .zero)
                .frame(maxWidth: .infinity)
                .relaySizeData(withKey: allowedWidthKey)
            ZStack(alignment: .topLeading) {
                ForEach(traits) { trait in
                    chipView(trait.element)
                        .relaySizeData(withKey: trait.element.id)
                        .fixedSize(horizontal: false, vertical: true)
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
        .readSizeData { chipSizes = $0 }
        .readSizeData(forKey: allowedWidthKey) { allowedWidth = $0.width }
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
        
        mutableSelf.chipSpacing = (horizontal, vertical)
        return mutableSelf
    }
}
