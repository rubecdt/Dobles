//
//  File.swift
//  
//
//  Created by Usuario invitado on 24/5/24.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AdHocProtocolPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		AdHocProtocolMacro.self
	]
}
