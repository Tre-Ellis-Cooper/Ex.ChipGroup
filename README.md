<picture>
    <source srcset="../../../Ex.Media/blob/develop/ChipGroup/ChipGroupDemo-Dark.gif" media="(prefers-color-scheme: dark)">
    <source srcset="../../../Ex.Media/blob/develop/ChipGroup/ChipGroupDemo-Light.gif" media="(prefers-color-scheme: light)">
    <img src="../../../Ex.Media/blob/develop/ChipGroup/ChipGroupDemo-Light.gif" align="left" width="345" height="460">
</picture>

<img src="../../../Ex.Media/blob/develop/Misc/Spacer.png" width="428" height="0">

<picture>
    <!-- Original: 950 x 130 | Adjusted: 1/2 @ 90% -->
    <source srcset="../../../Ex.Media/blob/develop/ChipGroup/ChipGroupLogo-Dark.png" media="(prefers-color-scheme: dark)">
    <source srcset="../../../Ex.Media/blob/develop/ChipGroup/ChipGroupLogo-Light.png" media="(prefers-color-scheme: light)">
    <img src="../../../Ex.Media/blob/develop/ChipGroup/ChipGroupLogo-Light.png" width="428" height="59">
</picture>

#### Explore an example, Material-inspired ChipGroup.
###### In the Example Series, we engineer solutions to custom UI/UX <br> systems and components, focusing on production quality code.
###### Stay tuned for updates to the series:
[![Follow](https://img.shields.io/github/followers/Tre-Ellis-Cooper?style=social)](https://github.com/Tre-Ellis-Cooper)

<br>

[![LinkedIn](https://img.shields.io/static/v1?style=social&logo=linkedin&label=LinkedIn&message=Tre%27Ellis%20Cooper)](https://www.linkedin.com/in/tre-ellis-cooper-629306106/)&nbsp;
[![Twitter](https://img.shields.io/static/v1?style=social&logo=x&label=Twitter&message=@_cooperlative)](https://www.twitter.com/_cooperlative/)<br>
[![Instagram](https://img.shields.io/static/v1?style=social&logo=instagram&label=Instagram&message=@_cooperlative)](https://www.instagram.com/_cooperlative/)

<br>

![Repo Size](https://img.shields.io/github/repo-size/Tre-Ellis-Cooper/Ex.ChipGroup?color=green)&nbsp;
![Last Commit](https://img.shields.io/github/last-commit/Tre-Ellis-Cooper/Ex.ChipGroup?color=C23644)

<br>

## Usage

#### Using the ChipGroup is easy:
* Initialize a ChipGroup with a collection of `Identifiable` elements and a closure to convert each element into your desired `View`.
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

Try adding the `Source` directory to your project to use the chip group in your app!

## Exploration

<details>
    
<summary>Code Design</summary>

### Code Design

To make sure the `ChipGroup` could be easily adapted without changing its implementation, I opted for an initializer that resembles the `ForEach` element:
```swift
struct ChipGroup<Element: Identifiable, Chip: View>: View {
    let chipView: (Element) -> Chip
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

This way, like the `ForEach`, we end up with an implementation decoupled from any predetermined data source or visual treatment. We are free to provide any chip view and backing data structure we like:
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

Two components help to ensure that the `ChipGroup` works properly in any layout: `Spacer` and `GeometryReader`. The `Spacer` forces the `ChipGroup` to expand to fill its container horizontally. While the `GeometryReader` provides the container width and the chip sizes for logic.

Typically, we would wrap our component in a `GeometryReader` to access the container size. However, that doesn't provide what we expect if the element happens to be in a `ScrollView`. Instead, I placed a `GeometryReader` in the background of a `Spacer` to determine the allowed width, like so:
```swift
Spacer()
    .background(
        GeometryReader { proxy in
            ...
        }
    )
```

<br>

This forces the `ChipGroup` to expand to fill its container and then exposes the container width using a `GeometryReader`.

I rely on the same approach to determine the size of the chip views, so I created two reusable view modifiers for readability that encapsulate this approach: `relaySizeData` and `readSizeData`. These modifiers use a custom `PreferenceKey` to make the view's size available to parent views:
```swift
func readSizeData<KeyType: Hashable>(
    closure: @escaping ([KeyType: CGSize]
) -> Void) -> some View {
    self.onPreferenceChange(SizePreference<KeyType>.self, perform: closure)
}

func relaySizeData<KeyType: Hashable>(withKey key: KeyType) -> some View {
    self.background(
        GeometryReader { proxy in
            Spacer()
                .preference(
                    key: SizePreference<KeyType>.self, 
                    value: [key: proxy.size]
                )
        }
    )
}
```

<br>

By using these modifiers to access the container width and chip sizes, the `ChipGroup` can dynamically position its chips and maintain an intrinsic height:
```swift
struct ChipGroup<Element: Identifiable, Chip: View>: View {
    let chipView: (Element) -> Chip
    let elements: [Element]
    
    @State private var chipSizes = [Element.ID: CGSize]()
    @State private var allowedWidth = CGFloat.zero

    ...
    
    var body: some View {
        let traits = ChipGroupLayout(elements: elements)
            .traits(for: chipSizes, in: allowedWidth, with: chipSpacing)
        
        return VStack(spacing: .zero) {
            Spacer()
                ...
                .relaySizeData(withKey: allowedWidthKey)
            ZStack(alignment: .topLeading) {
                ForEach(traits) { trait in
                    chipView(trait.element)
                        ...
                        .relaySizeData(withKey: trait.element.id)
                        .alignmentGuide(.leading) { _ in -trait.position.x }
                        .alignmentGuide(.top) { _ in -trait.position.y }
                }
            }

            ...
        }
        .readSizeData { chipSizes = $0 }
        .readSizeData(forKey: allowedWidthKey) { allowedWidth = $0.width }
    }
    
    ...
}
```

After walking through how the ChipGroup is built, would you agree it's easy to use and adapt to different use cases!? Check out the `Code Testing` section for more information on the `ChipGroupLayout` object.

</details>

<details>

<summary>Code Testing</summary>
    
### Code Testing

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

    func traitsForChipSizes(
        _ chipSizes: [Element.ID: CGSize],
        in containerWidth: CGFloat,
        with spacing: Spacing
    ) -> [Trait] {
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

The `ChipGroup` element calls this function and uses the `alignmentGuide` modifier to position the chip views according to the trait objects, like so:
```swift
struct ChipGroup<Element: Identifiable, Chip: View>: View {
    ...
    
    var body: some View {
        let layout = ChipGroupLayout(elements: elements)
        let traits = layout.traits(
            for: chipSizes,
            in: allowedWidth,
            with: chipSpacing
        )
        
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

By owning the layout algorithm, the `ChipGroupLayout` keeps the `ChipGroup` view dumb and makes the chip-positioning logic easily testable. For example:
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

</details>

###### Do you agree that the design is adaptative and easy to use? Have any questions, comments, or just want to give feedback? Share your ideas with me on social media:
[![LinkedIn](https://img.shields.io/static/v1?style=social&logo=linkedin&label=LinkedIn&message=Tre%27Ellis%20Cooper)](https://www.linkedin.com/in/tre-ellis-cooper-629306106/)&nbsp;
[![Twitter](https://img.shields.io/static/v1?style=social&logo=x&label=Twitter&message=@_cooperlative)](https://www.twitter.com/_cooperlative/)&nbsp;
[![Instagram](https://img.shields.io/static/v1?style=social&logo=instagram&label=Instagram&message=@_cooperlative)](https://www.instagram.com/_cooperlative/)
