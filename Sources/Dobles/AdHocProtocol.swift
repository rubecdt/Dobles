// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces a protocol with all the struct methods defined in the attached definition as requirements
///
/// This was designed for applying the Doubles pattern for dependency injection, suitable for mocking data.
/// Given the following code,
///	```swift
///     @AdHocProtocol
///		struct NabooQueen {
///		func wear(_ outfit: Dressing = .ceremonial) -> DressedQueen {
///			   // Implementation
///		   }
///		}
///	```
/// the generated expansion is
///	```swift
///		protocol NabooQueenDoubleProtocol {
///			func wear(_ outfit: Dressing) -> DressedQueen
///		}
///	```
///

@attached(peer, names: suffixed(DoubleProtocol))
@attached(extension)
public macro AdHocProtocol() = #externalMacro(module: "DoblesMacros", type: "AdHocProtocolMacro")
