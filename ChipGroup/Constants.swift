//
//  Constants.swift
//  ChipGroup
//
//  Created by Tre Cooper on 4/6/22.
//

import SwiftUI

typealias Strings = Constants.Strings
typealias Colors = Constants.Assets.Colors
typealias Icons = Constants.Assets.Icons

/// An enum housing general constants for the example app.
enum Constants {
    enum Strings {
        static let empty = ""
        static let ex = "Ex."
        static let chipGroup = "ChipGroup"
        static let addChip = "+ Add New Chip"
        static let exampleChip = "Example Chip"
        static let deploymentTarget = "Target: iOS \(Utility.minimumOS)"
    }
    
    enum Assets {
        enum Keys {
            static let highlightColor = "HighlightColor"
            static let primaryBackgroundColor = "PrimaryBackgroundColor"
            static let primaryTextColor = "PrimaryTextColor"
            static let secondaryBackgroundColor = "SecondaryBackgroundColor"
            static let secondaryTextColor = "SecondaryTextColor"
            
            static let closeIcon = "xmark"
            static let trashIcon = "trash.fill"
        }
        
        enum Colors {
            static let highlight = Color(Keys.highlightColor)
            static let primaryBackground = Color(Keys.primaryBackgroundColor)
            static let primaryText = Color(Keys.primaryTextColor)
            static let secondaryBackground = Color(Keys.secondaryBackgroundColor)
            static let secondaryText = Color(Keys.secondaryTextColor)
        }
        
        enum Icons {
            static let close = Image(systemName: Keys.closeIcon)
            static let trash = Image(systemName: Keys.trashIcon)
        }
    }
    
    enum Utility {
        static let notAvailable = "N/A"
        static let minimumOSKey = "MinimumOSVersion"
        static let minimumOS = Bundle.main.infoDictionary?[minimumOSKey]
            as? String ?? notAvailable
    }
}
