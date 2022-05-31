//
//  ContentView.swift
//  ChipGroup
//
//  Created by Tre Cooper on 2/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var newTitle = ""
    @State private var focused = false
    @State private var chips = [
        Chip(title: String.Display.exampleChip)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                Header()
                VStack(alignment: .leading, spacing: 12) {
                    TitleField()
                    ChipContainer()
                }
            }
            .padding(20)
        }
        .foregroundColor(.textColor)
        .background(
            Color.backgroundColor
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    @ViewBuilder private func ClearFieldButton() -> some View {
        let action: () -> Void = { newTitle = "" }
        
        Button(action: action) {
            Image(systemName: String.AssetKey.closeIcon)
                .resizable()
                .frame(width: 13, height: 13)
        }
    }
    
    @ViewBuilder private func ClearChipButton() -> some View {
        let action: () -> Void = { chips = [] }
        let disabled = chips.isEmpty
        
        Button(action: action) {
            Label(String.Display.clearAll,
                  systemImage: String.AssetKey.trashIcon)
        }
        .foregroundColor(Color.altHightlightColor)
        .opacity(disabled ? 0.4 : 1)
        .disabled(disabled)
    }
    
    @ViewBuilder private func ChipContainer() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(String.Display.chips)
                Spacer()
                ClearChipButton()
            }
            .font(.footnote.bold())

            // MARK: ChipGroup
            ChipGroup(elements: chips, chipView: ChipView)
                .padding()
                .background(
                    Color.altBackgroundColor
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                )
        }
    }
    
    @ViewBuilder private func ChipView(_ chip: Chip) -> some View {
        HStack(spacing: 6) {
            Text(chip.title)
                .bold()
            Color.textColor.opacity(0.2)
                .frame(width: 1)
            Text("\(chip.title.count)")
                .opacity(0.5)
        }
        .font(.caption)
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
            Capsule()
                .stroke(Color.textColor.opacity(0.2), lineWidth: 0.7)
        )
    }
    
    @ViewBuilder private func Header() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            VStack(alignment: .leading, spacing: 2) {
                Text(String.Display.ex)
                    .font(.footnote.bold())
                    .padding(.leading, 2)
                    .opacity(0.5)
                Text(String.Display.chipGroup)
                    .font(.title.bold())
            }
            Text(String.Display.deploymentTarget)
                .environment(\.colorScheme, .light)
                .font(.caption.bold())
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(
                    Color.highlightColor
                        .clipShape(Capsule())
                )
                
        }
    }
    
    @ViewBuilder private func TitleField() -> some View {
        let onCommit: () -> Void = {
            chips.append(.init(title: newTitle))
            newTitle = ""
        }
        
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField(String.Display.addChip,
                          text: $newTitle,
                          onCommit: onCommit)
                if !newTitle.isEmpty {
                    ClearFieldButton()
                }
            }
            Color.textColor.opacity(0.4)
                .frame(height: 0.5)
        }
        .padding(20)
        .font(.caption.bold())
        .background(
            Color.altBackgroundColor
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
            ContentView()
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
