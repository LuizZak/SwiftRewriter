import Antlr4
import ObjcParserAntlr

extension ParserRuleContext: ParseTreeContextable {
    
}

/// Protocol for parser rules
public struct Contextable<Base> {
    /// Base object to extend.
    public let base: Base
    
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type for a parse tree that features extra computable state
public protocol ParseTreeContextable {
    /// Extended type
    associatedtype CompatibleType
    
    /// Context extensions.
    static var context: Contextable<CompatibleType>.Type { get }
    
    /// Context extensions.
    var context: Contextable<CompatibleType> { get }
}

public extension ParseTreeContextable {
    /// Context extensions.
    public static var context: Contextable<Self>.Type {
        get {
            return Contextable<Self>.self
        }
    }
    
    /// Context extensions.
    public var context: Contextable<Self> {
        get {
            return Contextable(self)
        }
    }
}

/// Describes the contained scope of a declaration
public enum ContainmentScope {
    case global
    case `class`
    case local
}
