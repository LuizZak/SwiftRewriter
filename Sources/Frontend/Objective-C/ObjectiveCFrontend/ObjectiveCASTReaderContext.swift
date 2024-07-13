import Antlr4
import Utils
import SwiftAST
import GrammarModelBase
import ObjcGrammarModels
import SwiftRewriterLib
import KnownType
import TypeSystem

public final class ObjectiveCASTReaderContext {
    private var localsStack: [[Local]] = [[]]
    private var typeSystem: TypeSystem?
    private var typeContext: KnownType?
    
    public let commentApplier: SwiftASTCommentApplier
    
    public init(
        typeSystem: TypeSystem?,
        typeContext: KnownType?,
        comments: [RawCodeComment]
    ) {

        self.typeSystem = typeSystem
        self.typeContext = typeContext
        self.commentApplier = .init(comments: comments)
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

private extension Token {
    func sourceLocation() -> SourceLocation {
        let line = getLine()
        let col = getCharPositionInLine() + 1
        let char = getStartIndex()
        
        return SourceLocation(line: line, column: col, utf8Offset: char)
    }
}
