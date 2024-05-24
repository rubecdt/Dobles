import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics


public struct AdHocProtocolMacro: PeerMacro, ExtensionMacro {
	private static let protocolSuffix = "DoubleProtocol"
	
	public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
		guard let groupedDecl = declaration.asProtocol(DeclGroupSyntax.self),
			  declaration.is(StructDeclSyntax.self) || declaration.is(ClassDeclSyntax.self),
			  let declName = declaration.asProtocol(NamedDeclSyntax.self)?.name.text
			   else {
			let invalidDeclError = Diagnostic(node: node, message: AdHocError.notAStructNorClass)
			context.diagnose(invalidDeclError)
			return []
		}
		
		let protocolName = "\(declName)\(Self.protocolSuffix)"
		
		let functionSignatures: [FunctionDeclSyntax] = groupedDecl.memberBlock.members.compactMap{ member in
			guard let funcDecl = member.decl.as(FunctionDeclSyntax.self) else { return nil }
				let signatureWithoutDefaults = removeDefaultValues(from: funcDecl.signature)
				let newFuncDecl = funcDecl.with(\.signature, signatureWithoutDefaults).with(\.body, nil)
				return newFuncDecl
		}
		
		let protocolDecl = DeclSyntax( try ProtocolDeclSyntax("protocol \(raw: protocolName)", membersBuilder: {
			MemberBlockItemListSyntax(
				functionSignatures.compactMap { funcDecl in
					MemberBlockItemSyntax(decl: DeclSyntax(funcDecl))
				}
			)
		}))
		
		return [protocolDecl]
	}
	
	public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
		guard let structDecl = declaration.as(StructDeclSyntax.self) else {
			return []
		}
		return []
		// TODO: Fix protocol conformance
//		let protocolName = "\(structDecl.name.text)\(Self.protocolSuffix)"
//		
//		let extDecl = try ExtensionDeclSyntax("extension \(structDecl.name): \(raw: protocolName)") {
//			
//		}
//		return [extDecl]
	}
	
	@usableFromInline
	static func removeDefaultValues(from signature: FunctionSignatureSyntax) -> FunctionSignatureSyntax {
		let newInput = signature.parameterClause.parameters.map { parameter in
			parameter.with(\.defaultValue, nil)
		}
		return signature
			.with(\.parameterClause,
				   signature.parameterClause
				.with(\.parameters, FunctionParameterListSyntax(newInput)))
	}
}

public enum AdHocError: String, DiagnosticMessage {
	
	public var diagnosticID: MessageID {
		   MessageID(domain: "Dobles", id: rawValue)
	   }
	
	public var severity: DiagnosticSeverity { .error }
	
	case notAStructNorClass
	
	public var message: String {
		switch self {
		case .notAStructNorClass: "@AdHocProtocol macro can only be applied to a class or structure"
		}
	}
}
