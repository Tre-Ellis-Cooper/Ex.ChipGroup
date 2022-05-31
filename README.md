<picture>
    <source srcset="https://user-images.githubusercontent.com/79422649/170741528-08304d35-5d8d-4593-b50d-8cfe8ac573eb.gif" media="(prefers-color-scheme: dark)">
    <source srcset="https://user-images.githubusercontent.com/79422649/170740573-bf129a0c-4031-4fdc-ba4e-dbf68c65fd6b.gif" media="(prefers-color-scheme: light)">
    <img src="https://user-images.githubusercontent.com/79422649/170740573-bf129a0c-4031-4fdc-ba4e-dbf68c65fd6b.gif" width="230" height="100">
</picture>

# ChipGroup - SwiftUI

#### Explore an example implementation of a Material-inspired ChipGroup in SwiftUI.
###### In the Example Series, I explore solutions to custom UI/UX systems and components, focusing on adaptability, testability, and efficiency.
###### Stay tuned for updates to the series:
[![Follow](https://img.shields.io/github/followers/Tre-Ellis-Cooper?style=social)](https://github.com/Tre-Ellis-Cooper)

![Repo Size](https://img.shields.io/github/repo-size/Tre-Ellis-Cooper/Ex.ChipGroup?color=green)
![Lines of Code](https://img.shields.io/tokei/lines/github/Tre-Ellis-Cooper/Ex.ChipGroup?color=green&label=lines%20of%20code)
![Last Commit](https://img.shields.io/github/last-commit/Tre-Ellis-Cooper/Ex.ChipGroup?color=C23644)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Tre'Ellis%20Cooper-blue)](https://www.linkedin.com/in/tre-ellis-cooper-629306106)

## Code Discussion
### Adaptability

To make sure this `ChipGroup` implementation could be easily adapted without changing its implementation, I opted for an initializer that resembles a `ForEach` element:
```swift
struct ChipGroup<Element: Identifiable, Chip: View>: View {
    let chipView: (Element) -> Chipa
    let elements: [Elements]

    ...
    
    init(elements: [Element],
         @ViewBuilder chipView: @escaping (Element) -> Chip) {
        self.chipView = chipView
        self.elements = elements
    }

    ...
}
```

<br>

This way, like the `ForEach`, we end up with an implementation that is decoupled from a predetermined datasource or visual treatment. We are free to provide any chip view and backing data structure we like, like so:
```swift
struct ExampleView: View {
    let elements: [Element] // Any Identifiable Collection

    var body: some View {
        ChipGroup(elements: elements) { element in
            Text(element.name) // Any view building closure
        }
    }
}
```

<br>

To make sure the `ChipGroup` worked well in various layouts, I made creative use of two components: the `Spacer` and the `GeometryReader`. The `Spacer` allows the `ChipGroup` to expand to fill the permitted width. While the `GeometryReader` provides the allowed width and the chip sizes.

Typically, to access the container attributes, we would wrap the desired component in a `GeometryReader`. In this case however, that doesn't provide the functionality you might expect. Instead I chose to place a `GeometryReader` in the background of a `Spacer` to determine the allowed width, like so:
```swift
Spacer()
    .background(
        GeometryReader { proxy in
            ...
        }
    )
```

<br>

This allowes the element to expand to fill the provided with using the `Spacer` and then providing that width using a `GeometryReader`. I used the same approach to determine the size of the chip views, so I created two custom view modifiers for readability: `relaySizeData` and `readSizeData`. These modifiers use a custom `PreferenceKey` to make a view's size available to its parents:
```swift
func readSizeData<KeyType: Hashable>(closure: @escaping ([KeyType: CGSize]) -> Void) -> some View {
    self.onPreferenceChange(SizePreference<KeyType>.self, perform: closure)
}

func relaySizeData<KeyType: Hashable>(withKey key: KeyType) -> some View {
    self.background(
        GeometryReader { proxy in
            Spacer()
                .preference(key: SizePreference<KeyType>.self, value: [key: proxy.size])
        }
    )
}
```

<br>

With access to the allowed width and chip sizes, the `ChipGroup` implementation dynamically positions its chips and therefore has an intrinsic size.

### Testability
To facilitate testability, I took some theory from the Strategy Behavioral pattern and abstracted the layout algorithm into an object:
```swift
struct ChipGroupLayout<Element: Identifiable> {
    let elements: [Element]

    ...
}
```

<br>

The `ChipGroupLayout` has a single function that accepts the layout parameters and returns an array of `ChipGroupLayout.Trait`: a simple wrapper around the supplied `Identifiable` that includes a position pointer.
```swift
struct ChipGroupLayout<Element: Identifiable> {
    ...

    func traitsForChipSizes(_ chipSizes: [Element.ID: CGSize],
                            in containerWidth: CGFloat,
                            with spacing: Spacing) -> [Trait] {
        ...
    }

    ...

    struct Trait: Identifiable {
        let element: Element
        let position: CGPoint
        
        var id: Element.ID {
            element.id
        }
    }
}
```

<br>

The `ChipGroup` element is able to call this function and use the `alignmentGuide` modifier to position the chip views according to the trait objects, like so:
```swift
struct ChipGroup<Element: Identifiable, Chip: View>: View {
    ...
    
    var body: some View {
        let layout = ChipGroupLayout(elements: elements)
        let traits = layout.traits(for: chipSizes,
                                   in: allowedWidth,
                                   with: chipSpacing)
        
        return VStack(spacing: .zero) {
            ...
            ZStack(alignment: .topLeading) {
                ForEach(layoutTraits) { trait in
                    chipView(trait.element)
                        ...
                        .alignmentGuide(.leading) { _ in -trait.position.x }
                        .alignmentGuide(.top) { _ in -trait.position.y }
                }
            }

            ...
        }

        ...
    }
```

<br>

By owning the layout algorithm, the `ChipGroupLayout` keeps the view dumb and makes the chip-positioning logic easily testable. For example:
```swift
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
```

<br>

We can test to make sure the `ChipGroupLayout` positions chips the way we would expect given any container width, chip sizes, and chip spacing. 

### Efficiency
Although the `ChipGroup` does compute the chip view positions linearly every layout pass, that seems necessary to ensure the chip view positions are always correct. 

For instance, consider an orientation change from portrait to landscape. The `ChipGroup` has no choice but to recompute its layout as more chips may be able to fit on a single line.