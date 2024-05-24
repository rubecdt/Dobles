# AdHocProtocol Macro

## Overview

`AdHocProtocol` is a Swift macro designed to facilitate the Doubles pattern for dependency injection, making it suitable for mocking data. This macro generates a protocol with all the struct methods defined in the attached definition as requirements.

## Example

Given a `struct` or `class` like this:

```swift
@AdHocProtocol
struct NabooQueen {
	func wear(_ outfit: Dressing = .ceremonial) -> DressedQueen {
        // Implementación
    }
}
```

The macro expands to:

```swift
protocol NabooQueenDoubleProtocol {
	func wear(_ outfit: Dressing) -> DressedQueen
}
```

## Installation

To use the `AdHocProtocol` macro in your project, follow these steps:

### 1. Add the Dependency

Add the following dependency to your `Package.swift` file:

```swift
// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "YourProjectName",
	platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
	products: [
		.library(
			name: "YourProjectName",
			targets: ["YourTargetName"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/rubecdt/Dobles.git", from: "0.0.0"),
	],
	targets: [
		.target(
			name: "YourTargetName",
			dependencies: ["Dobles"]
		),
		.testTarget(
			name: "YourTargetNameTests",
			dependencies: ["YourTargetName"]
		),
	]
)
```

### 2. Import the Macro

In the files where you want to use the macro, import the `DoblesMacros` module:

```swift
import Dobles
```

## Usage

Apply the `@AdHocProtocol` macro to your structs or classes to automatically generate the corresponding protocol. This is particularly useful for creating mock implementations for testing or previewing purposes.

Note that you can always avoid the inclusion of any method belonging to the attached type in the generated protocol by defining it inside an extension. In fact, only the methods inside the type's declaration will be included as protocol members.

### Example

Here is a complete example:

```swift
import Dobles

@AdHocProtocol
struct NabooQueen {
	func wear(_ outfit: Dressing = .ceremonial) -> DressedQueen {
        // Implementación
    }
}
```

The above code will automatically generate:

```swift
protocol NabooQueenDoubleProtocol {
	func wear(_ outfit: Dressing) -> DressedQueen
}
```

## Contributing

Contributions to the `AdHocProtocol` macro are welcome! Please open an issue or submit a pull request on GitHub.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

Special thanks to the Swift community and the contributors to [SwiftSyntax](https://github.com/apple/swift-syntax).
