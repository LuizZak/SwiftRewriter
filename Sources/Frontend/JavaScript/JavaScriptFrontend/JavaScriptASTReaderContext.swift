import Antlr4
import Utils
import SwiftAST
import GrammarModelBase
import JsGrammarModels
import KnownType
import TypeSystem

public final class JavaScriptASTReaderContext {
    private var source: Source
    private var localsStack: [[Local]] = [[]]
    private var typeSystem: TypeSystem?
    private var typeContext: KnownType?

    public let commentApplier: SwiftASTCommentApplier
    public let options: JavaScriptASTReaderOptions
    
    public init(
        source: Source,
        typeSystem: TypeSystem?,
        typeContext: KnownType?,
        comments: [RawCodeComment],
        options: JavaScriptASTReaderOptions
    ) {
        self.source = source
        self.typeSystem = typeSystem
        self.typeContext = typeContext
        self.options = options
        self.commentApplier = SwiftASTCommentApplier(comments: comments)
    }

    public func sourceCode(for rule: ParserRuleContext) -> Substring? {
        guard let start = rule.getStart()?.getStartIndex() else {
            return nil
        }
        guard let end = rule.getStop()?.getStopIndex() else {
            return nil
        }

        return source.substring(inCharRange: start..<end)
    }
    
    public func define(localNamed name: String, storage: ValueStorage) {
        guard !localsStack.isEmpty else {
            fatalError("No definition contexts available to define local variable in")
        }
        
        let local = Local(name: name, storage: storage)
        
        localsStack[localsStack.count - 1].append(local)
    }
    
    public func localNamed(_ name: String) -> Local? {
        for stackLevel in localsStack.reversed() {
            if let local = stackLevel.first(where: { $0.name == name }) {
                return local
            }
        }
        
        return nil
    }
    
    public func typePropertyOrFieldNamed(_ name: String) -> KnownMember? {
        guard let typeContext = typeContext else {
            return nil
        }
        
        if let field = typeSystem?.field(named: name, static: false, in: typeContext) {
            return field
        }
        
        return typeSystem?.property(
            named: name,
            static: false,
            includeOptional: false,
            in: typeContext
        )
    }
    
    public func pushDefinitionContext() {
        localsStack.append([])
    }
    
    public func popDefinitionContext() {
        localsStack.removeLast()
    }

    /// Convenience for `commentApplier.applyComments(to:_:)`
    public func applyComments(to statement: Statement, _ rule: ParserRuleContext) {
        commentApplier.applyComments(to: statement, rule)
    }

    /// Convenience for `commentApplier.applyOverlappingComments(to:_:)`
    public func applyOverlappingComments(to statement: Statement, _ rule: ParserRuleContext) {
        commentApplier.applyOverlappingComments(to: statement, rule)
    }
    
    public struct Local {
        public var name: String
        public var storage: ValueStorage
    }
}
