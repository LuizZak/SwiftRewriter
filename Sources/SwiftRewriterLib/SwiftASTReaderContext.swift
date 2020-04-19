import SwiftAST
import TypeSystem
import KnownType
import GrammarModels
import Antlr4

public final class SwiftASTReaderContext {
    private var localsStack: [[Local]] = [[]]
    private var typeSystem: TypeSystem?
    private var typeContext: KnownType?
    private var comments: [ObjcComment]
    
    public init(typeSystem: TypeSystem?, typeContext: KnownType?, comments: [ObjcComment]) {
        self.typeSystem = typeSystem
        self.typeContext = typeContext
        self.comments = comments
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
        
        return typeSystem?.property(named: name,
                                    static: false,
                                    includeOptional: false,
                                    in: typeContext)
    }
    
    public func pushDefinitionContext() {
        localsStack.append([])
    }
    
    public func popDefinitionContext() {
        localsStack.removeLast()
    }
    
    public func popClosestCommentBefore(node: ParserRuleContext) -> ObjcComment? {
        guard let start = node.getStart() else {
            return nil
        }
        
        let location = start.sourceLocation()
        
        for (i, comment) in comments.enumerated().reversed() {
            if comment.location < location {
                comments.remove(at: i)
                return comment
            }
        }
        
        return nil
    }
    
    public func popClosestCommentAtTrailingLine(node: ParserRuleContext) -> ObjcComment? {
        guard let stop = node.getStop() else {
            return nil
        }
        
        let location = stop.sourceLocation()
        
        for (i, comment) in comments.enumerated() {
            if comment.location.line == location.line && comment.location.column > location.column {
                comments.remove(at: i)
                return comment
            }
        }
        
        return nil
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
