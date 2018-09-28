import class Foundation.OperationQueue
import SwiftAST
import Antlr4
import GrammarModels
import ObjcParserAntlr
import ObjcParser

/// Options for an AST writer invocation
public struct ASTWriterOptions {
    /// Default settings instance
    public static let `default` = ASTWriterOptions()
    
    /// If `true`, when outputting expression statements, print the resulting type
    /// of the expression before the expression statement as a comment for inspection.
    public var outputExpressionTypes: Bool
    
    /// If `true`, when outputting final intentions, print any history information
    /// tracked on its `IntentionHistory` property before the intention's declaration
    /// as a comment for inspection.
    public var printIntentionHistory: Bool
    
    /// If `true`, `@objc` attributes and `: NSObject` are emitted for declarations
    /// during output.
    ///
    /// This may increase compatibility with previous Objective-C code when compiled
    /// and executed.
    public var emitObjcCompatibility: Bool
    
    /// Number of concurrent threads to use when saving files.
    public var numThreads: Int
    
    public init(outputExpressionTypes: Bool = false,
                printIntentionHistory: Bool = false,
                emitObjcCompatibility: Bool = false,
                numThreads: Int = OperationQueue.defaultMaxConcurrentOperationCount) {
        
        self.outputExpressionTypes = outputExpressionTypes
        self.printIntentionHistory = printIntentionHistory
        self.emitObjcCompatibility = emitObjcCompatibility
        self.numThreads = numThreads
    }
}

/// Main frontend class for converting Objective-C into Swift AST and printing
/// Swift AST as well
class SwiftASTWriter {
    let options: ASTWriterOptions
    let typeMapper: TypeMapper
    let typeSystem: TypeSystem
    
    init(options: ASTWriterOptions, typeMapper: TypeMapper, typeSystem: TypeSystem) {
        self.options = options
        self.typeMapper = typeMapper
        self.typeSystem = typeSystem
    }
    
    public func write(compoundStatement: CompoundStatement, into target: RewriterOutputTarget) {
        let rewriter =
            StatementWriter(options: options, target: target, typeMapper: typeMapper,
                            typeSystem: typeSystem)
        
        rewriter.visitStatement(compoundStatement)
    }
    
    public func write(expression: Expression, into target: RewriterOutputTarget) {
        let rewriter =
            ExpressionWriter(options: options, target: target, typeMapper: typeMapper,
                             typeSystem: typeSystem)
        
        rewriter.rewrite(expression)
    }
    
    public func rewrite(compoundStatement: ObjectiveCParser.CompoundStatementContext,
                        typeParser: TypeParsing, into target: RewriterOutputTarget) {
        
        let reader = SwiftASTReader(typeMapper: typeMapper, typeParser: typeParser)
        
        let result = reader.parseStatements(compoundStatement: compoundStatement)
        write(compoundStatement: result, into: target)
    }
    
    public func rewrite(expression: ObjectiveCParser.ExpressionContext,
                        typeParser: TypeParsing, into target: RewriterOutputTarget) {
        
        let reader = SwiftASTReader(typeMapper: typeMapper, typeParser: typeParser)
        
        let result = reader.parseExpression(expression: expression)
        write(expression: result, into: target)
    }
}

internal class ExpressionWriter: ExpressionVisitor {
    typealias ExprResult = Void
    
    let options: ASTWriterOptions
    let target: RewriterOutputTarget
    let typeMapper: TypeMapper
    let typeSystem: TypeSystem
    
    init(options: ASTWriterOptions,
         target: RewriterOutputTarget,
         typeMapper: TypeMapper,
         typeSystem: TypeSystem) {
        
        self.options = options
        self.target = target
        self.typeMapper = typeMapper
        self.typeSystem = typeSystem
    }
    
    func rewrite(_ expression: Expression) {
        visitExpression(expression)
    }
    
    func visitExpression(_ expression: Expression) {
        visitExpression(expression, parens: false)
    }
    
    private func visitExpression(_ expression: Expression, parens: Bool) {
        if parens {
            target.outputInline("(")
        }
        
        expression.accept(self)
        
        if parens {
            target.outputInline(")")
        }
    }
    
    func visitAssignment(_ exp: AssignmentExpression) {
        visitExpression(exp.lhs)
        
        if exp.op.requiresSpacing {
            target.outputInline(" \(exp.op.description) ")
        } else {
            target.outputInline("\(exp.op.description)")
        }
        
        visitExpression(exp.rhs)
    }
    
    func visitBinary(_ exp: BinaryExpression) {
        visitExpression(exp.lhs)
        
        if exp.op.requiresSpacing {
            target.outputInline(" \(exp.op.description) ")
        } else {
            target.outputInline("\(exp.op.description)")
        }
        
        visitExpression(exp.rhs)
    }
    
    func visitUnary(_ exp: UnaryExpression) {
        target.outputInline(exp.op.description)
        visitExpression(exp.exp, parens: exp.exp.requiresParens)
    }
    
    func visitSizeOf(_ exp: SizeOfExpression) {
        switch exp.value {
        case .type(let type):
            target.outputInline("MemoryLayout<")
            target.outputInline(typeMapper.typeNameString(for: type))
            target.outputInline(">.size")
            
        case .expression(let exp):
            if case let .metatype(innerType)? = exp.resolvedType {
                target.outputInline("MemoryLayout<")
                target.outputInline(typeMapper.typeNameString(for: innerType))
                target.outputInline(">.size")
            } else {
                target.outputInline("MemoryLayout.size(ofValue: ")
                exp.unwrappingParens.accept(self)
                target.outputInline(")")
            }
        }
    }
    
    func visitPrefix(_ exp: PrefixExpression) {
        target.outputInline(exp.op.description)
        visitExpression(exp.exp, parens: exp.exp.requiresParens)
    }
    
    func visitPostfix(_ exp: PostfixExpression) {
        visitExpression(exp.exp, parens: exp.exp.requiresParens)
        
        switch exp.op.optionalAccessKind {
        case .none:
            break
        case .forceUnwrap:
            target.outputInline("!")
        case .safeUnwrap:
            target.outputInline("?")
        }
        
        switch exp.op {
        case let member as MemberPostfix:
            target.outputInline(".")
            target.outputInline(member.name, style: .memberName)
            
        case let subscription as SubscriptPostfix:
            target.outputInline("[")
            visitExpression(subscription.expression)
            target.outputInline("]")
            
        case let functionCall as FunctionCallPostfix:
            var arguments = functionCall.arguments
            
            var trailingClosure: Expression?
            // If the last argument is a block type, close the
            // parameters list earlier and use the block as a
            // trailing closure.
            if arguments.last?.expression is BlockLiteralExpression {
                trailingClosure = arguments.last?.expression
                arguments.removeLast()
            }
            
            // No need to emit parenthesis if a trailing closure
            // is present as the only argument of the function
            if !arguments.isEmpty || trailingClosure == nil {
                target.outputInline("(")
                
                commaSeparated(arguments) { arg in
                    if let label = arg.label {
                        target.outputInline(label)
                        target.outputInline(": ")
                    }
                    
                    visitExpression(arg.expression)
                }
                
                target.outputInline(")")
            }
            
            // Emit trailing closure now, if present
            if let trailingClosure = trailingClosure {
                // Nicer spacing
                target.outputInline(" ")
                visitExpression(trailingClosure)
            }
            
        default:
            target.outputInline("/* Unsupported postfix operation type \(type(of: exp.op)) */")
        }
    }
    
    func visitConstant(_ exp: ConstantExpression) {
        let constant = exp.constant
        
        switch constant {
        case .int, .float:
            target.outputInline(constant.description, style: .numberLiteral)
            
        case .nil:
            target.outputInline(constant.description, style: .keyword)
            
        case .string:
            target.outputInline(constant.description, style: .stringLiteral)
            
        default:
            target.outputInline(constant.description)
        }
    }
    
    func visitParens(_ exp: ParensExpression) {
        target.outputInline("(")
        visitExpression(exp.exp)
        target.outputInline(")")
    }
    
    func visitIdentifier(_ exp: IdentifierExpression) {
        let identifier = exp.identifier
        
        if identifier == "self" || identifier == "super" {
            target.outputInline(identifier, style: .keyword)
        } else {
            target.outputInline(identifier)
        }
    }
    
    func visitCast(_ exp: CastExpression) {
        visitExpression(exp.exp)
        
        let typeName = typeMapper.typeNameString(for: exp.type)
        
        target.outputInline(" ")
        if exp.isOptionalCast {
            target.outputInline("as?", style: .keyword)
        } else {
            target.outputInline("as", style: .keyword)
        }
        target.outputInline(" ")
        target.outputInline("\(typeName)", style: .typeName)
    }
    
    func visitArray(_ exp: ArrayLiteralExpression) {
        target.outputInline("[")
        
        commaSeparated(exp.items) { exp in
            visitExpression(exp)
        }
        
        target.outputInline("]")
    }
    
    func visitDictionary(_ exp: DictionaryLiteralExpression) {
        if exp.pairs.isEmpty {
            target.outputInline("[:]")
            return
        }
        
        target.outputInline("[")
        
        commaSeparated(exp.pairs) { value in
            visitExpression(value.key)
            target.outputInline(": ")
            visitExpression(value.value)
        }
        
        target.outputInline("]")
    }
    
    func visitTernary(_ exp: TernaryExpression) {
        visitExpression(exp.exp)
        target.outputInline(" ? ")
        visitExpression(exp.ifTrue)
        target.outputInline(" : ")
        visitExpression(exp.ifFalse)
    }
    
    func visitBlock(_ exp: BlockLiteralExpression) {
        let parameters = exp.parameters
        let returnType = exp.returnType
        let body = exp.body
        
        let visitor =
            StatementWriter(options: options, target: target, typeMapper: typeMapper,
                            typeSystem: typeSystem)
        
        // Print signature
        target.outputInline("{")
        
        // Avoid emitting block signature if block's expected type matches it's
        // actual signature
        if exp.expectedType != exp.resolvedType {
            target.outputInline(" (")
            for (i, param) in parameters.enumerated() {
                if i > 0 {
                    target.outputInline(", ")
                }
                
                target.outputInline(param.name)
                target.outputInline(": ")
                target.outputInline(typeMapper.typeNameString(for: param.type), style: .typeName)
            }
            target.outputInline(")")
            
            target.outputInline(" -> ")
            target.outputInline(typeMapper.typeNameString(for: returnType), style: .typeName)
            
            target.outputInline(" in", style: .keyword)
        }
        
        if body.isEmpty {
            target.outputLineFeed()
            target.outputIdentation()
            target.outputInline("}")
            return
        }
        
        target.outputLineFeed()
        
        target.idented {
            // Print each statement now
            for statement in body.statements {
                visitor.visitStatement(statement)
            }
        }
        
        target.outputIdentation()
        target.outputInline("}")
    }
    
    func visitUnknown(_ exp: UnknownExpression) {
        target.outputInline("/*", style: .comment)
        target.outputInline(exp.context.description, style: .comment)
        target.outputInline("*/", style: .comment)
    }
    
    private func commaSeparated<T>(_ values: [T], do block: (T) -> Void) {
        for (i, value) in values.enumerated() {
            if i > 0 {
                target.outputInline(", ")
            }
            
            block(value)
        }
    }
}

internal class StatementWriter: StatementVisitor {
    public typealias StmtResult = Void
    
    let options: ASTWriterOptions
    let target: RewriterOutputTarget
    let typeMapper: TypeMapper
    let typeSystem: TypeSystem
    
    init(options: ASTWriterOptions,
         target: RewriterOutputTarget,
         typeMapper: TypeMapper,
         typeSystem: TypeSystem) {
        
        self.options = options
        self.target = target
        self.typeMapper = typeMapper
        self.typeSystem = typeSystem
    }
    
    func visitStatement(_ statement: Statement) {
        if let label = statement.label {
            target.output(line: "// \(label):")
        }
        
        statement.accept(self)
    }
    
    func visitSemicolon(_ stmt: SemicolonStatement) {
        target.output(line: ";")
    }
    
    func visitUnknown(_ stmt: UnknownStatement) {
        target.output(line: "/*", style: .comment)
        target.output(line: stmt.context.description, style: .comment)
        target.output(line: "*/", style: .comment)
    }
    
    func visitCompound(_ compound: CompoundStatement) {
        visitCompound(compound, lineFeedAfter: true)
    }
    
    func visitCompound(_ compound: CompoundStatement, lineFeedAfter: Bool) {
        target.outputInline(" {")
        target.outputLineFeed()
        target.increaseIdentation()
        
        compound.statements.forEach(visitStatement)
        
        target.decreaseIdentation()
        if lineFeedAfter {
            target.output(line: "}")
        } else {
            target.outputIdentation()
            target.outputInline("}")
        }
    }
    
    func visitIf(_ stmt: IfStatement) {
        visitIf(stmt, withIdent: true)
    }
    
    func visitIf(_ stmt: IfStatement, withIdent: Bool) {
        if withIdent {
            target.outputIdentation()
        }
        target.outputInlineWithSpace("if", style: .keyword)
        
        if let pattern = stmt.pattern {
            emitLetPattern(pattern)
        }
        
        emitExpr(stmt.exp)
        
        visitCompound(stmt.body, lineFeedAfter: stmt.elseBody == nil)
        
        if let elseBody = stmt.elseBody {
            target.outputInline(" else", style: .keyword)
            
            if elseBody.statements.count == 1, let ifStmt = elseBody.statements[0].asIf {
                target.outputInline(" ")
                visitIf(ifStmt, withIdent: false)
            } else {
                visitCompound(elseBody)
            }
        }
    }
    
    func visitWhile(_ stmt: WhileStatement) {
        target.outputIdentation()
        target.outputInlineWithSpace("while", style: .keyword)
        emitExpr(stmt.exp)
        
        visitCompound(stmt.body)
    }
    
    func visitSwitch(_ stmt: SwitchStatement) {
        let exp = stmt.exp
        let cases = stmt.cases
        let def = stmt.defaultCase
        
        target.outputIdentation()
        target.outputInlineWithSpace("switch", style: .keyword)
        emitExpr(exp)
        target.outputInline(" {")
        target.outputLineFeed()
        
        for cs in cases {
            target.outputIdentation()
            target.outputInlineWithSpace("case", style: .keyword)
            for (i, pattern) in cs.patterns.enumerated() {
                if i > 0 {
                    target.outputInline(", ")
                }
                emitPattern(pattern)
            }
            target.outputInline(":")
            target.outputLineFeed()
            
            target.idented {
                for stmt in cs.statements {
                    visitStatement(stmt)
                }
            }
        }
        
        if let def = def {
            target.outputIdentation()
            target.outputInline("default", style: .keyword)
            target.outputInline(":")
            target.outputLineFeed()
            
            target.idented {
                for stmt in def {
                    visitStatement(stmt)
                }
            }
        }
        
        if cases.isEmpty && def == nil {
            target.outputLineFeed()
        }
        
        target.output(line: "}")
    }
    
    func visitDoWhile(_ stmt: DoWhileStatement) {
        target.outputIdentation()
        target.outputInline("repeat", style: .keyword)
        visitCompound(stmt.body, lineFeedAfter: false)
        target.outputInlineWithSpace(" while", style: .keyword)
        emitExpr(stmt.exp)
        target.outputLineFeed()
    }
    
    func visitFor(_ stmt: ForStatement) {
        target.outputIdentation()
        target.outputInlineWithSpace("for", style: .keyword)
        emitPattern(stmt.pattern)
        target.outputInline(" in ", style: .keyword)
        emitExpr(stmt.exp)
        
        visitCompound(stmt.body)
    }
    
    func visitDo(_ stmt: DoStatement) {
        target.outputIdentation()
        target.outputInline("do", style: .keyword)
        visitCompound(stmt.body)
    }
    
    func visitDefer(_ stmt: DeferStatement) {
        target.outputIdentation()
        target.outputInline("defer", style: .keyword)
        visitCompound(stmt.body)
    }
    
    func visitReturn(_ stmt: ReturnStatement) {
        if let exp = stmt.exp {
            target.outputIdentation()
            target.outputInline("return ", style: .keyword)
            emitExpr(exp)
            target.outputLineFeed()
        } else {
            target.output(line: "return", style: .keyword)
        }
    }
    
    func visitContinue(_ stmt: ContinueStatement) {
        target.output(line: "continue", style: .keyword)
    }
    
    func visitBreak(_ stmt: BreakStatement) {
        target.output(line: "break", style: .keyword)
    }

    func visitFallthrough(_ stmt: FallthroughStatement) {
        target.output(line: "fallthrough", style: .keyword)
    }
    
    func visitExpressions(_ stmt: ExpressionsStatement) {
        for exp in stmt.expressions {
            if options.outputExpressionTypes {
                emitExprType(exp)
            }
            
            target.outputIdentation()
            emitExpr(exp)
            target.outputLineFeed()
        }
    }
    
    func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) {
        func emitDeclaration(_ declaration: StatementVariableDeclaration) {
            let typeString = typeMapper.typeNameString(for: declaration.type)
            
            target.outputInline(declaration.identifier)
            
            let shouldEmitType =
                declaration
                    .initialization
                    .map { shouldEmitTypeSignature(forInitVal: $0, varType: declaration.type) }
                    ?? true
            
            if shouldEmitType {
                // Type signature
                target.outputInline(": ")
                target.outputInline(typeString, style: .typeName)
            }
            
            if let initial = declaration.initialization {
                target.outputInline(" = ")
                
                emitExpr(initial)
            }
        }
        
        if stmt.decl.isEmpty {
            return
        }
        
        let ownership = stmt.decl[0].ownership
        
        target.outputIdentation()
        
        if ownership != .strong {
            target.outputInlineWithSpace(ownership.rawValue, style: .keyword)
        }
        target.outputInlineWithSpace(stmt.decl[0].isConstant ? "let" : "var", style: .keyword)
        
        for (i, decl) in stmt.decl.enumerated() {
            if i > 0 {
                target.outputInline(", ")
            }
            
            emitDeclaration(decl)
        }
        
        target.outputLineFeed()
    }
    
    private func emitLetPattern(_ pattern: Pattern) {
        target.outputInlineWithSpace("let", style: .keyword)
        emitPattern(pattern)
        target.outputInline(" = ")
    }
    
    private func emitPattern(_ pattern: Pattern) {
        switch pattern.simplified {
        case .expression(let exp):
            emitExpr(exp)
        case .tuple(let patterns):
            target.outputInline("(")
            for (i, pattern) in patterns.enumerated() {
                if i > 0 {
                    target.outputInline(", ")
                }
                emitPattern(pattern)
            }
            target.outputInline(")")
        case .identifier(let ident):
            target.outputInline(ident)
        }
    }
    
    private func emitExprType(_ exp: Expression) {
        target.output(line: "// type: \(exp.resolvedType?.description ?? "<nil>")", style: .comment)
    }
    
    private func emitExpr(_ exp: Expression) {
        let rewriter =
            ExpressionWriter(options: options, target: target, typeMapper: typeMapper,
                             typeSystem: typeSystem)
        
        rewriter.rewrite(exp)
    }
    
    private func shouldEmitTypeSignature(forInitVal exp: Expression, varType: SwiftType) -> Bool {
        if exp.isErrorTyped && typeSystem.isNumeric(varType) {
            return true
        }
        
        if case .block? = exp.resolvedType {
            return true
        }
        
        if !exp.isLiteralExpression {
            return false
        }
        
        if let type = exp.resolvedType {
            switch type {
            case .int, .float:
                return true
            case .optional, .implicitUnwrappedOptional, .nullabilityUnspecified:
                return true
            default:
                break
            }
        }
        
        switch deduceType(from: exp) {
        case .int, .float, .nil:
            return true
        default:
            return false
        }
    }
    
    /// Attempts to make basic deductions about an expression's resulting type.
    /// Used only for deciding whether to infer types for variable definitions
    /// with initial values.
    private func deduceType(from exp: Expression) -> DeducedType {
        if let constant = exp.asConstant?.constant {
            if constant.isInteger {
                return .int
            }
            switch constant {
            case .float:
                return .float
            case .boolean:
                return .bool
            case .string:
                return .string
            case .nil:
                return .nil
            default:
                break
            }
            return .other
        } else if let binary = exp.asBinary {
            return deduceType(binary)
        } else if let assignment = exp.asAssignment {
            return deduceType(from: assignment.rhs)
        } else if let parens = exp.asParens {
            return deduceType(from: parens.exp)
        } else if exp is PrefixExpression || exp is UnaryExpression {
            let op = exp.asPrefix?.op ?? exp.asUnary?.op
            
            switch op {
            case .some(.negate):
                return .bool
            case .some(.bitwiseNot):
                return .int
                
            // Pointer types
            case .some(.multiply), .some(.bitwiseAnd):
                return .other
                
            default:
                return .other
            }
        } else if let ternary = exp.asTernary {
            let lhsType = deduceType(from: ternary.ifTrue)
            if lhsType == deduceType(from: ternary.ifFalse) {
                return lhsType
            }
            
            return .other
        }
        
        return .other
    }
    
    private func deduceType(_ binary: BinaryExpression) -> StatementWriter.DeducedType {
        let lhs = binary.lhs
        let op = binary.op
        let rhs = binary.rhs
        
        switch op.category {
        case .arithmetic, .bitwise:
            let lhsType = deduceType(from: lhs)
            let rhsType = deduceType(from: rhs)
            
            // Arithmetic and bitwise operators keep operand types, if they
            // are the same.
            if lhsType == rhsType {
                return lhsType
            }
            
            // Float takes precedence over ints on arithmetic operators
            if op.category == .arithmetic {
                switch (lhsType, rhsType) {
                case (.float, .int), (.int, .float):
                    return .float
                default:
                    break
                }
            } else if op.category == .bitwise {
                // Bitwise operators always cast the result to integers, if
                // one of the operands is an integer
                switch (lhsType, rhsType) {
                case (_, .int), (.int, _):
                    return .int
                default:
                    break
                }
            }
            
            return .other
            
        case .assignment:
            return deduceType(from: rhs)
            
        case .comparison:
            return .bool
            
        case .logical:
            return .bool
            
        case .nullCoalesce, .range:
            return .other
        }
    }
    
    private enum DeducedType {
        case int
        case float
        case bool
        case string
        case `nil`
        case other
    }
}
