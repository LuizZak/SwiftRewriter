public class DictionaryLiteralExpression: Expression {
    private var _subExpressions: [Expression] = []
    
    public var pairs: [ExpressionDictionaryPair] {
        didSet {
            oldValue.forEach { $0.key.parent = nil; $0.value.parent = nil }
            pairs.forEach { $0.key.parent = self; $0.value.parent = self }
            
            _subExpressions = pairs.flatMap { [$0.key, $0.value] }
        }
    }
    
    public override var subExpressions: [Expression] {
        return _subExpressions
    }
    
    public override var description: String {
        if pairs.isEmpty {
            return "[:]"
        }
        
        return "[" + pairs.map { $0.description }.joined(separator: ", ") + "]"
    }
    
    public init(pairs: [ExpressionDictionaryPair]) {
        self.pairs = pairs
        
        super.init()
        
        pairs.forEach { $0.key.parent = self; $0.value.parent = self }
        _subExpressions = pairs.flatMap { [$0.key, $0.value] }
    }
    
    public override func copy() -> DictionaryLiteralExpression {
        return DictionaryLiteralExpression(pairs: pairs.map { $0.copy() }).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitDictionary(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as DictionaryLiteralExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: DictionaryLiteralExpression, rhs: DictionaryLiteralExpression) -> Bool {
        return lhs.pairs == rhs.pairs
    }
}
public extension Expression {
    public var asDictionary: DictionaryLiteralExpression? {
        return cast()
    }
}

public struct ExpressionDictionaryPair: Equatable {
    public var key: Expression
    public var value: Expression
    
    public init(key: Expression, value: Expression) {
        self.key = key
        self.value = value
    }
    
    public func copy() -> ExpressionDictionaryPair {
        return ExpressionDictionaryPair(key: key.copy(), value: value.copy())
    }
}

extension ExpressionDictionaryPair: CustomStringConvertible {
    public var description: String {
        return key.description + ": " + value.description
    }
}
