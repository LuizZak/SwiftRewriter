import SwiftAST

// TODO: Detect indirect super-type calling (i.e. `[aVarWithSuperAssociatedWithinIt method]`)
/// Mandatory intention pass that applies some necessary code changes to compile,
/// like override detection.
class MandatoryIntentionPass: IntentionPass {
    var context: IntentionPassContext!
    
    func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        self.context = context
        
        for file in intentionCollection.fileIntentions() {
            applyOnFile(file)
        }
    }
    
    func applyOnFile(_ file: FileGenerationIntention) {
        for type in file.typeIntentions {
            applyOnType(type)
        }
    }
    
    func applyOnType(_ type: TypeGenerationIntention) {
        if type.kind != .class {
            return
        }
        
        for method in type.methods {
            guard let body = method.body else {
                continue
            }
            
            let selector = method.selector
            
            let sequence =
                SyntaxNodeSequence(statement: body.body, inspectBlocks: true)
                    .lazy.compactMap { $0 as? Expression }
            
            for expression in sequence {
                guard let postfix = expression.asPostfix else {
                    continue
                }
                guard let memberPostfix = postfix.exp.asPostfix else {
                    continue
                }
                guard memberPostfix.exp == .identifier("super") else {
                    continue
                }
                guard let member = memberPostfix.member else {
                    continue
                }
                guard let methodCall = postfix.functionCall else {
                    continue
                }
                
                if methodCall.selectorWith(methodName: member.name) == selector {
                    method.isOverride = true
                    break
                }
            }
        }
    }
}
