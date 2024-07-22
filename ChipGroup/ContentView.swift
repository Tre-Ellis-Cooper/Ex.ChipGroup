//
//  ContentView.swift
//  ChipGroup
//
//  Created by Tre Cooper on 2/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var newChipName = ""
    @State private var resizing = false
    @State private var translation = CGFloat.zero
    @State private var lastTranslation = CGFloat.zero
    @State private var chips = Chip.testSet
    
    let allowedTranslation =  CGFloat.zero ... 200
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Colors.primaryBackground
                .ignoresSafeArea(edges: .all)
            VStack(alignment: .leading, spacing: 30) {
                Heading()
                ChipSection()
            }
            .padding(25)
            TrashButton()
        }
        .foregroundColor(Colors.primaryText)
    }
}

// MARK: - View Components
extension ContentView {
    @ViewBuilder private func Border<S: InsettableShape>(
        _ InsettableShape: S,
        _ Color: Color = Colors.secondaryText
    ) -> some View {
        Color
            .clipShape(
                InsettableShape
                    .inset(by: 0.5)
                    .stroke()
            )
    }
    
    @ViewBuilder private func ChipSection() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            NewChipField()
            ResizableChipWindow()
        }
    }
    
    @ViewBuilder private func ChipView(_ chip: Chip) -> some View {
        let action = { chips.removeAll{ $0.id == chip.id } }
        
        HStack(spacing: 8) {
            Text(chip.name)
                .bold()
            Button(action: action) {
                Icons.close
                    .resizable()
                    .frame(width: 8, height: 8)
            }
        }
        .font(.caption)
        .padding(.vertical, 8)
        .padding(.horizontal, 14)
        .background(
            Colors.secondaryBackground
                .clipShape(Capsule())
        )
    }
    
    @ViewBuilder private func ChipWindow() -> some View {
        ScrollView {
            // MARK: ChipGroup
            ChipGroup(elements: chips, chipView: ChipView)
                .padding()
        }
    }
    
    @ViewBuilder private func ChipWindowAfterImage() -> some View {
        DottedBorder(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder private func DottedBorder<S: InsettableShape>(
        _ InsettableShape: S,
        _ Color: Color = Colors.secondaryText.opacity(0.2)
    ) -> some View {
        Color
            .clipShape(
                InsettableShape
                    .inset(by: 0.5)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [7]))
            )
    }
    
    @ViewBuilder private func Heading() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading) {
                Text(Strings.ex)
                    .font(.footnote.bold())
                    .opacity(0.5)
                Text(Strings.chipGroup)
                    .font(.title.bold())
            }
            Text(Strings.deploymentTarget)
                .font(.caption.bold())
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .overlay(Border(Capsule()))
        }
    }
    
    @ViewBuilder private func NewChipField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField(Strings.addChip, text: $newChipName)
                    .onSubmit(createNewChip)
                if newChipName.count > 3 {
                    Button(action: clearChipField) {
                        Icons.close
                            .resizable()
                            .frame(width: 10, height: 10)
                    }
                }
            }
            Colors.primaryText
                .frame(height: 1)
        }
        .font(.caption.bold())
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder private func ResizableBorder() -> some View {
        ZStack(alignment: .trailing) {
            Border(RoundedRectangle(cornerRadius: 12))
                .allowsHitTesting(false)
            ResizeHandle()
        }
    }
    
    @ViewBuilder private func ResizableChipWindow() -> some View {
        ZStack {
            if resizing {
                ChipWindowAfterImage()
                    .padding(.trailing, lastTranslation)
            }
            ChipWindow()
                .overlay(ResizableBorder())
                .padding(.trailing, translation)
        }
    }
    
    @ViewBuilder private func ResizeHandle() -> some View {
        let Color = resizing ?
            Colors.primaryText :
            Colors.primaryBackground
        Color
            .clipShape(Capsule())
            .overlay(Border(Capsule()))
            .overlay(ResizeIcon())
            .frame(width: 10, height: 45)
            .scaleEffect(y: resizing ? 1.10 : 1)
            .animation(.snappy, value: resizing)
            .offset(x: 5)
            .gesture(
                DragGesture(minimumDistance: .zero)
                    .onEnded(commitResize)
                    .onChanged(updateTranslation)
            )
    }
    
    @ViewBuilder private func ResizeIcon() -> some View {
        let Color = resizing ?
            Colors.primaryBackground :
            Colors.primaryText
        VStack(spacing: 3) {
            ForEach(0 ..< 5) { _ in
                Color
                    .frame(height: 1)
            }
        }
        .padding(.horizontal, 2)
    }
    
    @ViewBuilder private func TrashButton() -> some View {
        Button(action: deleteAllChips) {
            Icons.trash
                .resizable()
                .frame(width: 20, height: 25)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(
                    Colors.highlight,
                    ignoresSafeAreaEdges: .horizontal
                )
                .foregroundColor(Colors.primaryBackground)
        }
    }
}

// MARK: - Helper Functions / Behavior
extension ContentView {
    private func animateChipWindow(to value: CGFloat) {
        resizing = false
        lastTranslation = value
        withAnimation(.snappy(extraBounce: 0.1)) {
            translation = value
        }
    }
    
    private func clearChipField() {
        newChipName = Strings.empty
    }
    
    private func commitResize(_: DragGesture.Value) {
        guard translation <= allowedTranslation.upperBound else {
            animateChipWindow(to: allowedTranslation.upperBound)
            return
        }
        guard translation >= allowedTranslation.lowerBound else {
            animateChipWindow(to: allowedTranslation.lowerBound)
            return
        }
        
        resizing = false
        lastTranslation = translation
    }
    
    private func createNewChip() {
        chips.append(Chip(name: newChipName))
        clearChipField()
    }
    
    private func deleteAllChips() {
        chips = []
    }
    
    private func rubberBandValue(_ value: CGFloat) -> CGFloat {
        let limit = allowedTranslation.upperBound
        
        return value > .zero ?
            limit * (1 + log10(value/limit)) :
            -((limit * (1 + log10((-value + limit)/limit))) - limit)
    }
    
    private func updateTranslation(_ value: DragGesture.Value) {
        let delta = -value.translation.width
        let newTranslation = translation + delta
        let validTranslation = allowedTranslation ~= newTranslation
        
        resizing = true
        translation = validTranslation ?
            newTranslation : rubberBandValue(newTranslation)
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
