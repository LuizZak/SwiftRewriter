import SwiftAST
import MiniLexer
import Intentions
import ObjcParser
import ObjcParserAntlr
import TypeSystem

/// Converts preprocessor directives into global variable declarations, in case
/// they represent simple constants.
public class PreprocessorDirectiveConverter {
    let parserStatePool: ObjcParserStatePool
    let typeSystem: TypeSystem
    let typeResolverInvoker: TypeResolverInvoker
    
    public init(
        parserStatePool: ObjcParserStatePool,
        typeSystem: TypeSystem,
        typeResolverInvoker: TypeResolverInvoker
    ) {
        
        self.parserStatePool = parserStatePool
        self.typeSystem = typeSystem
        self.typeResolverInvoker = typeResolverInvoker
    }
    
    public func convert(
        directive directiveString: String,
        inFile file: FileGenerationIntention
    ) -> DirectiveDeclaration? {
        
        guard let directive = Self.parseDefineDirective(directiveString) else {
            return nil
        }

        let state = parserStatePool.pull()
        defer { parserStatePool.repool(state) }
        
        guard let parser = try? state.makeMainParser(input: directive.expression) else {
            return nil
        }
        // Avoid printing parsing errors to console
        parser.parser.removeErrorListeners()
        parser.lexer.removeErrorListeners()
        guard let expressionContext = try? parser.parser.expression() else {
            return nil
        }
        
        let expression = expressionFromExpressionContext(expressionContext)
        
        guard let declaration = validateExpression(expression, fromFile: file) else {
            return nil
        }
        
        return DirectiveDeclaration(
            name: directive.identifier,
            type: declaration.type,
            expression: declaration.expression
        )
    }
    
    func expressionFromExpressionContext(_ ctx: ObjectiveCParser.ExpressionContext) -> Expression {
        let state = parserStatePool.pull()
        defer { parserStatePool.repool(state) }
        
        let astReader = SwiftASTReader(
            parserStatePool: parserStatePool,
            typeMapper: DefaultTypeMapper(typeSystem: typeSystem),
            typeParser: TypeParsing(
                state: state,
                source: StringCodeSource(source: ctx.getText())
            )
        )
        
        return astReader.parseExpression(expression: ctx)
    }
    
    func validateExpression(_ exp: Expression, fromFile file: FileGenerationIntention) -> Declaration? {
        let validator = ValidatorExpressionVisitor(typeSystem: typeSystem)
        if !validator.visitExpression(exp) {
            return nil
        }
        
        typeResolverInvoker
            .resolveGlobalExpressionType(in: exp, inFile: file, force: true)
        
        guard !exp.isErrorTyped, let resolvedType = exp.resolvedType else {
            return nil
        }
        
        return Declaration(type: resolvedType, expression: exp)
    }
    
    static func parseDefineDirective(_ directive: String) -> DefineDirective? {
        do {
            let lexer = Lexer(input: directive)
            lexer.skipWhitespace()
            try lexer.advance(expectingCurrent: "#")
            lexer.skipWhitespace()
            try lexer.consume(match: "define")
            lexer.skipWhitespace()
            
            let identifier = String(try lexer.lexIdentifier())
            // Detect and ignore macros that take in parameters
            if try lexer.peek() == "(" {
                return nil
            }
            
            let expression = String(lexer.consumeRemaining())
            
            return DefineDirective(identifier: identifier, expression: expression)
        } catch {
            return nil
        }
    }
    
    struct DefineDirective {
        var identifier: String
        var expression: String
    }
    
    struct Declaration {
        var type: SwiftType
        var expression: Expression
    }
}

/// Defines a variable declaration that was extracted from a preprocessor
/// directive
public struct DirectiveDeclaration {
    public var name: String
    public var type: SwiftType
    public var expression: Expression
    
    public init(name: String, type: SwiftType, expression: Expression) {
        self.name = name
        self.type = type
        self.expression = expression
    }
}

/// Validates that expressions can be properly converted into constant expressions
private class ValidatorExpressionVisitor: ExpressionVisitor {
    let typeSystem: TypeSystem
    
    init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
    }
    
    func visitExpression(_ expression: Expression) -> Bool {
        return expression.accept(self)
    }
    
    func visitAssignment(_ exp: AssignmentExpression) -> Bool {
        return false
    }
    
    func visitBinary(_ exp: BinaryExpression) -> Bool {
        return exp.lhs.accept(self) && exp.rhs.accept(self)
    }
    
    func visitUnary(_ exp: UnaryExpression) -> Bool {
        return exp.exp.accept(self)
    }
    
    func visitSizeOf(_ exp: SizeOfExpression) -> Bool {
        switch exp.value {
        case .type(let type):
            return typeSystem.isScalarType(type) || typeSystem.typeExists(type)
        default:
            return false
        }
    }
    
    func visitPrefix(_ exp: PrefixExpression) -> Bool {
        return exp.exp.accept(self)
    }
    
    func visitPostfix(_ exp: PostfixExpression) -> Bool {
        return exp.exp.accept(self)
    }
    
    func visitConstant(_ exp: ConstantExpression) -> Bool {
        return true
    }
    
    func visitParens(_ exp: ParensExpression) -> Bool {
        return exp.exp.accept(self)
    }
    
    func visitIdentifier(_ exp: IdentifierExpression) -> Bool {
        return true
    }
    
    func visitCast(_ exp: CastExpression) -> Bool {
        if !typeSystem.isScalarType(exp.type) {
            return false
        }
        
        return exp.exp.accept(self)
    }
    
    func visitArray(_ exp: ArrayLiteralExpression) -> Bool {
        return exp.subExpressions.reduce(true, { $0 && $1.accept(self) })
    }
    
    func visitDictionary(_ exp: DictionaryLiteralExpression) -> Bool {
        return exp.pairs.reduce(true, { $0 && $1.key.accept(self) && $1.value.accept(self) })
    }
    
    func visitBlock(_ exp: BlockLiteralExpression) -> Bool {
        return false
    }
    
    func visitTernary(_ exp: TernaryExpression) -> Bool {
        return exp.exp.accept(self) && exp.ifTrue.accept(self) && exp.ifFalse.accept(self)
    }
    
    func visitTuple(_ exp: TupleExpression) -> Bool {
        return exp.elements.reduce(true, { $0 && $1.accept(self) })
    }
    
    func visitSelector(_ exp: SelectorExpression) -> Bool {
        return false
    }
    
    func visitUnknown(_ exp: UnknownExpression) -> Bool {
        return false
    }
}
