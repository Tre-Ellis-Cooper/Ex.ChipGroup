//
//  String+Constants.swift
//  ExampleChipGroup
//
//  Created by Tre Cooper on 4/6/22.
//

import Foundation

/// An extension housing string constants.
extension String {
    enum Display {
        static var ex = "Ex."
        static var chipGroup = "ChipGroup - SwiftUI"
        static var chips = "Chips"
        static var clearAll = "All Clear"
        static var addChip = "+ Add chip"
        static var exampleChip = "Example Chip"
        static var deploymentTarget = "Target: iOS \(String.Utility.minimumOS)"
    }
    
    enum AssetKey {
        static var altBackgroundColor = "AltBackgroundColor"
        static var backgroundColor = "BackgroundColor"
        static var altHighlightColor = "AltHighlightColor"
        static var highlightColor = "HighlightColor"
        static var textColor = "TextColor"
        static var closeIcon = "x.circle"
        static var trashIcon = "trash"
    }
    
    enum Utility {
        static var notAvailable = "N/A"
        static var minimumOS: String {
            guard let plist = Bundle.main.infoDictionary,
                  let target = plist["MinimumOSVersion"] as? String else {
                return notAvailable
            }
            
            return target
        }
    }
}
