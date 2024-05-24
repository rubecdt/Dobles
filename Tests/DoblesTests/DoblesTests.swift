import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(AdHocProtocolMacro)
import TestingMacrosMacros

let adHocMacro: [String: Macro.Type] = [
	"AdHocProtocol": AdHocProtocolMacro.self
]
#endif

final class AdHocMacrosTests: XCTestCase {
	
	func testMacro() throws {
		#if canImport(TestingMacrosMacros)
		assertMacroExpansion(
					"""
					@AdHocProtocol
					struct Hola {
					func hs(_ sd: Int = 2) -> Int {}
					}
					""",
				expandedSource: """
					struct Hola {
					func hs(_ sd: Int = 2) -> Int {}
					}
					
					protocol HolaProtocol {
						func hs(_ sd: Int ) -> Int
					}
					"""
//					
//					extension Hola : HolaProtocol {
//					}
//					"""
,
				macros: adHocMacro)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
}
