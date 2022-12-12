import Antlr4
import Utils
import SwiftAST
import GrammarModelBase
import ObjcGrammarModels
import KnownType
import TypeSystem

public final class ObjectiveCASTReaderContext {
    private var localsStack: [[Local]] = [[]]
    private var typeSystem: TypeSystem?
    private var typeContext: KnownType?
    private var comments: [RawCodeComment]
    
    public init(typeSystem: TypeSystem?, typeContext: KnownType?, comments: [RawCodeComment]) {
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
    
    public func popClosestCommentBefore(rule: ParserRuleContext) -> RawCodeComment? {
        guard let start = rule.getStart() else {
            return nil
        }
        
        let location = start.sourceLocation()
        
        for (i, comment) in comments.enumerated().reversed() where comment.location < location {
            comments.remove(at: i)
            return comment
        }
        
        return nil
    }
    
    public func popClosestCommentsBefore(rule: ParserRuleContext) -> [RawCodeComment] {
        var comments: [RawCodeComment] = []
        while let comment = popClosestCommentBefore(rule: rule) {
            comments.append(comment)
        }
        
        return comments.reversed()
    }
    
    public func popCommentsOverlapping(rule: ParserRuleContext) -> [RawCodeComment] {
        guard let start = rule.getStart(), let stop = rule.getStop() else {
            return []
        }

        let range = SourceRange(
            forStart: start.sourceLocation(),
            end: stop.sourceLocation()
        )

        var result: [RawCodeComment] = []
        
        for (i, comment) in comments.enumerated().reversed() {
            if range.contains(comment.location) {
                result.append(
                    comments.remove(at: i)
                )
            }
        }
        
        return result
    }
    
    public func popClosestCommentAtTrailingLine(node: ParserRuleContext) -> RawCodeComment? {
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
