import Foundation
import SwiftAST
import Intentions
import MiniLexer
import Utils
import GrammarModels

/// Verifies the #import directives on every file and convert them to the appropriate
/// Swift lib import declaration.
public class ImportDirectiveIntentionPass: IntentionPass {
    private var context: IntentionPassContext!
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        self.context = context
        
        for file in intentionCollection.fileIntentions() {
            applyOnFile(file: file)
        }
    }
    
    private func applyOnFile(file: FileGenerationIntention) {
        // Filter out imports
        let objcImports = parseObjcImports(in: file.preprocessorDirectives)
        
        let imports: [String] = mapImports(objcImports)
        
        file.importDirectives = imports
    }
    
    private func mapImports(_ objc: [ObjcImportDecl]) -> [String] {
        var modules: [String] = []
        
        // For "#import <Framework/Framework.h>" paths, import "Framework" directly
        for imp in objc {
            if imp.pathComponents.count == 1 {
                modules.append((imp.pathComponents[0] as NSString).deletingPathExtension)
            } else if imp.pathComponents.count == 2 {
                // "Framework/Framework.h" => "Framework" (+ ".h")
                if imp.pathComponents[0] + ".h" == imp.pathComponents[1] {
                    modules.append(imp.pathComponents[0])
                }
            }
        }
        
        return modules
    }
    
    private func parseObjcImports(in directives: [ObjcPreprocessorDirective]) -> [ObjcImportDecl] {
        var imports: [ObjcImportDecl] = []
        
        for directive in directives {
            do {
                let lexer = Lexer(input: directive.string)
                
                // "#import <[PATH]>"
                try lexer.advance(expectingCurrent: "#"); lexer.skipWhitespace()
                
                guard lexer.advanceIf(equals: "import") else { continue }
                
                lexer.skipWhitespace()
                
                // Extract "<[PATH]>" now, e.g. "<UIKit/UIKit.h>" -> "UIKit/UIKit.h"
                try lexer.advance(expectingCurrent: "<")
                let path = lexer.consume(until: { $0 == ">"})
                
                imports.append(ObjcImportDecl(path: String(path)))
            } catch {
                // Ignore silently
            }
        }
        
        return imports
    }
    
    private struct ObjcImportDecl {
        var path: String
        var pathComponents: [String] {
            (path as NSString).pathComponents
        }
    }
}
