//
//  ContentView.swift
//  ExampleChipGroup
//
//  Created by Tre Cooper on 2/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var newTitle = ""
    @State private var chips = [
        Chip(title: String.Display.exampleChip)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text(String.Display.exampleChipGroup)
                    .font(.title2.bold())
                TitleField()
                ChipContainer()
            }
            .padding(20)
        }
        .foregroundColor(.textColor)
        .background(
            Color.backgroundColor
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    @ViewBuilder private func ChipContainer() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(String.Display.chips)
                    .font(.headline.bold())
                Spacer()
                DeleteButton()
            }
            // MARK: ChipGroup
            ChipGroup(elements: chips, chipView: ChipView)
        }
    }
    
    @ViewBuilder private func ChipView(_ chip: Chip) -> some View {
        Text(chip.title)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.backgroundColor)
            .background(
                Color(chip.colorName)
                    .clipShape(Capsule())
            )
    }
    
    @ViewBuilder private func TitleField() -> some View {
        let onCommit: () -> Void = {
            chips.append(.init(title: newTitle))
            newTitle = ""
        }
        
        VStack(alignment: .leading, spacing: 12) {
            Text(verbatim: String.Display.title)
                .font(.headline.bold())
            HStack {
                TextField(String.Display.enterChipTitle,
                          text: $newTitle,
                          onCommit: onCommit)
                if !newTitle.isEmpty {
                    let action: () -> Void = { newTitle = "" }
                    
                    Button(action: action) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                }
            }
            Color.textColor
                .frame(height: 1.5)
        }
    }
    
    @ViewBuilder private func DeleteButton() -> some View {
        let action: () -> Void = { chips = [] }
        let gradient = Gradient(
            colors: [.white.opacity(0.05), .black.opacity(0.05)]
        )
        
        Button(action: action) {
            Image(systemName: "trash")
                .resizable()
                .frame(width: 16.0, height: 18.0)
                .padding(14)
                .font(.system(size: 16.0, weight: .semibold))
                .foregroundColor(.textColor)
                .background(
                    LinearGradient(
                        gradient: gradient,
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                    .clipShape(Circle())
                )
                .background(
                    Color.backgroundColor
                        .clipShape(Circle())
                )
                .background(
                    Color.white.opacity(0.1)
                        .clipShape(Circle())
                        .offset(x: -2.0, y: -2.0)
                        .blur(radius: 2.0)
                )
                .background(
                    Color.black.opacity(0.2)
                        .clipShape(Circle())
                        .offset(x: 2.0, y: 2.0)
                        .blur(radius: 2.0)
                )
        }
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
