import GrammarModels
import ObjcParserAntlr
import ObjcParser
import Antlr4
import SwiftAST

public protocol SwiftStatementASTReaderDelegate: AnyObject {
    func swiftStatementASTReader(
        reportAutoTypeDeclaration varDecl: VariableDeclarationsStatement,
        declarationAtIndex index: Int
    )
}

public final class SwiftStatementASTReader: ObjectiveCParserBaseVisitor<Statement> {
    public typealias Parser = ObjectiveCParser
    
    var expressionReader: SwiftExprASTReader
    var context: SwiftASTReaderContext
    public weak var delegate: SwiftStatementASTReaderDelegate?
    
    public init(
        expressionReader: SwiftExprASTReader,
        context: SwiftASTReaderContext,
        delegate: SwiftStatementASTReaderDelegate?
    ) {

        self.expressionReader = expressionReader
        self.context = context
        self.delegate = delegate
    }

    private func makeVarDeclarationExtractor() -> VarDeclarationExtractor {
        VarDeclarationExtractor(
            expressionReader: expressionReader,
            context: context,
            delegate: delegate
        )
    }
    
    public override func visitDeclaration(_ ctx: ObjectiveCParser.DeclarationContext) -> Statement? {
        let extractor = makeVarDeclarationExtractor()
        
        return ctx.accept(extractor)
    }
    
    public override func visitLabeledStatement(_ ctx: ObjectiveCParser.LabeledStatementContext) -> Statement? {
        guard let stmt = ctx.statement()?.accept(self), let label = ctx.identifier() else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        stmt.label = label.getText()
        
        return stmt
    }
    
    public override func visitStatement(_ ctx: Parser.StatementContext) -> Statement? {
        if let cpd = ctx.compoundStatement(), let compound = cpd.accept(compoundStatementVisitor()) {
            return compound
        }
        
        let comments = context.popClosestCommentsBefore(rule: ctx).map { $0.string.trimmingWhitespace() }
        
        context.pushDefinitionContext()
        defer { context.popDefinitionContext() }
        
        let stmt = acceptFirst(
            from: ctx.selectionStatement(),
            ctx.iterationStatement(),
            ctx.expressions(),
            ctx.jumpStatement(),
            ctx.synchronizedStatement(),
            ctx.autoreleaseStatement(),
            ctx.labeledStatement()
        ) ?? .unknown(UnknownASTContext(context: ctx.getText()))
        
        stmt.comments = comments
        stmt.trailingComment = context.popClosestCommentAtTrailingLine(node: ctx)?.string.trimmingWhitespace()
        
        return stmt
    }
    
    public override func visitExpressions(_ ctx: Parser.ExpressionsContext) -> Statement? {
        // Detect variable declarations that where parsed as 'lhs * rhs' top-level
        // expressions
        if let result = makeVarDeclarationExtractor().visitExpressions(ctx) {
            return result
        }

        let expressions = ctx.expression().compactMap { $0.accept(expressionReader) }
        
        return .expressions(expressions)
    }
    
    public override func visitCompoundStatement(_ ctx: Parser.CompoundStatementContext) -> Statement? {
        guard let compound = ctx.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        return compound
    }
    
    // MARK: @synchronized / @autoreleasepool
    public override func visitSynchronizedStatement(_ ctx: Parser.SynchronizedStatementContext) -> Statement? {
        guard let expression = ctx.expression()?.accept(expressionReader) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let compoundStatement = ctx.compoundStatement()?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        let doBody: CompoundStatement = []
        
        // Generate an equivalent locking structure as follows:
        
        // do {
        //   let _lockTarget = <expression>
        //   objc_sync_enter(_lockTarget)
        //   defer {
        //     objc_sync_exit(_lockTarget)
        //   }
        //   <statements>
        // }
        
        let lockIdent = "_lockTarget"
        doBody.statements.append(
            .variableDeclaration(identifier: lockIdent, type: .any,
                                 ownership: .strong, isConstant: true,
                                 initialization: expression)
        )
        
        doBody.statements.append(
            Statement.expression(
                Expression
                    .identifier("objc_sync_enter")
                    .call([.unlabeled(.identifier(lockIdent))])
            )
        )
        doBody.statements.append(
            .defer([
                Statement.expression(
                    Expression
                        .identifier("objc_sync_exit")
                        .call([.unlabeled(.identifier(lockIdent))])
                )
            ])
        )
        
        doBody.statements.append(contentsOf: compoundStatement.statements.map { $0.copy() })
        
        return .do(doBody)
    }
    
    public override func visitAutoreleaseStatement(_ ctx: Parser.AutoreleaseStatementContext) -> Statement? {
        guard let compoundStatement = ctx.compoundStatement()?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        let expression =
            Expression
                .identifier("autoreleasepool")
                .call([.unlabeled(.block(body: compoundStatement))])
        
        return .expression(expression)
    }
    
    // MARK: - return / continue / break
    public override func visitJumpStatement(_ ctx: Parser.JumpStatementContext) -> Statement? {
        if ctx.RETURN() != nil {
            return .return(ctx.expression()?.accept(expressionReader))
        }
        if ctx.CONTINUE() != nil {
            return .continue()
        }
        if ctx.BREAK() != nil {
            return .break()
        }
        
        return .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    // MARK: - if / switch
    public override func visitSelectionStatement(_ ctx: Parser.SelectionStatementContext) -> Statement? {
        if let switchStmt = ctx.switchStatement() {
            return visitSwitchStatement(switchStmt)
        }
        
        guard let expressions = ctx.expressions()?.expression().compactMap({ $0.accept(expressionReader) }) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let body = ctx.ifBody?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        let expr: Expression
        if expressions.count == 1 {
            expr = expressions[0]
        } else {
            // Synthesize a block expression that returns the last expression
            // result
            let block: Expression =
                .block(parameters: [],
                       return: .bool,
                       body: [.expressions(Array(expressions.dropLast())),
                              .return(expressions.last!)])
            
            expr = .parens(block.call())
        }
        
        let elseStmt = ctx.elseBody?.accept(compoundStatementVisitor())
        
        return .if(expr, body: body, else: elseStmt)
    }
    
    public override func visitSwitchStatement(_ ctx: Parser.SwitchStatementContext) -> Statement? {
        guard let exp = ctx.expression()?.accept(expressionReader) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        var cases: [SwitchCase] = []
        var def: [Statement]?
        
        if let sections = ctx.switchBlock()?.switchSection() {
            for section in sections {
                context.pushDefinitionContext()
                defer { context.popDefinitionContext() }
                
                let labels = section.switchLabel()
                let isDefaultCase = labels.contains { $0.rangeExpression() == nil }
                
                var statements = section.statement().compactMap { $0.accept(self) }
                
                if statements.count == 1, let stmt = statements[0].asCompound {
                    statements = stmt.statements
                }
                
                // Append a default fallthrough, in case the last statement is
                // not a jump stmt to somewhere else (`return`, `continue` or
                // `break`)
                let hasBreak = statements.last?.isUnconditionalJump ?? false
                if !hasBreak && !isDefaultCase {
                    statements.append(.fallthrough)
                }
                
                // Default case
                if isDefaultCase {
                    def = statements
                } else {
                    let expr =
                        labels
                            .compactMap { $0.rangeExpression() }
                            .compactMap { label in
                                label.accept(expressionReader)
                            }
                    
                    let c =
                        SwitchCase(patterns: expr.map { .expression($0) },
                                   statements: statements)
                    
                    cases.append(c)
                }
            }
        }
        
        // If no default is present, always emit a `default: break` statement,
        // since switches in Swift must be exhaustive
        if def == nil {
            def = [.break()]
        }
        
        return .switch(exp, cases: cases, default: def)
    }
    
    // MARK: - while / do-while / for / for-in
    public override func visitIterationStatement(_ ctx: Parser.IterationStatementContext) -> Statement? {
        acceptFirst(from: ctx.whileStatement(),
                    ctx.doStatement(),
                    ctx.forStatement(),
                    ctx.forInStatement())
            ?? .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    public override func visitWhileStatement(_ ctx: Parser.WhileStatementContext) -> Statement? {
        guard let expr = ctx.expression()?.accept(expressionReader) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let body = ctx.statement()?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        return .while(expr, body: body)
    }
    
    public override func visitDoStatement(_ ctx: ObjectiveCParser.DoStatementContext) -> Statement? {
        guard let expr = ctx.expression()?.accept(expressionReader) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let body = ctx.statement()?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        return .doWhile(expr, body: body)
    }
    
    public override func visitForStatement(_ ctx: Parser.ForStatementContext) -> Statement? {
        let generator = ForStatementGenerator(reader: self, context: context)
        
        return generator.generate(ctx)
    }
    
    public override func visitForInStatement(_ ctx: Parser.ForInStatementContext) -> Statement? {
        guard let identifier = ctx.typeVariableDeclarator()?.accept(VarDeclarationIdentifierNameExtractor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let expression = ctx.expression()?.accept(expressionReader) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let body = ctx.statement()?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        return .for(.identifier(identifier.getText()), expression, body: body)
    }
    
    // MARK: - Helper methods
    func compoundStatementVisitor() -> CompoundStatementVisitor {
        CompoundStatementVisitor(expressionReader: expressionReader,
                                 context: context,
                                 delegate: delegate)
    }
    
    private func acceptFirst(from rules: ParserRuleContext?...) -> Statement? {
        for rule in rules {
            if let expr = rule?.accept(self) {
                return expr
            }
        }
        
        return nil
    }
    
    // MARK: - Compound statement visitor
    class CompoundStatementVisitor: ObjectiveCParserBaseVisitor<CompoundStatement> {
        var expressionReader: SwiftExprASTReader
        var context: SwiftASTReaderContext
        weak var delegate: SwiftStatementASTReaderDelegate?
        
        init(expressionReader: SwiftExprASTReader,
             context: SwiftASTReaderContext,
             delegate: SwiftStatementASTReaderDelegate?) {

            self.expressionReader = expressionReader
            self.context = context
            self.delegate = delegate
        }
        
        override func visitStatement(_ ctx: Parser.StatementContext) -> CompoundStatement? {
            if let compoundStatement = ctx.compoundStatement() {
                return compoundStatement.accept(self)
            }
            
            let reader =
                SwiftStatementASTReader(expressionReader: expressionReader,
                                        context: context,
                                        delegate: delegate)
            
            reader.expressionReader = expressionReader
            
            if let stmt = reader.visitStatement(ctx) {
                return CompoundStatement(statements: [stmt])
            }
            
            return nil
        }
        
        override func visitCompoundStatement(_ ctx: Parser.CompoundStatementContext) -> CompoundStatement? {
            context.pushDefinitionContext()
            defer { context.popDefinitionContext() }
            
            let reader =
                SwiftStatementASTReader(expressionReader: expressionReader,
                                        context: context,
                                        delegate: delegate)
            
            reader.expressionReader = expressionReader
            
            let rules: [ParserRuleContext] = ctx.children?.compactMap {
                $0 as? ParserRuleContext
            } ?? []
            
            return CompoundStatement(statements: rules.map { stmt -> Statement in
                let unknown = UnknownStatement.unknown(UnknownASTContext(context: stmt.getText()))
                
                if let stmt = stmt as? Parser.StatementContext {
                    return reader.visitStatement(stmt) ?? unknown
                }
                if let declaration = stmt as? Parser.DeclarationContext {
                    return reader.visitDeclaration(declaration) ?? unknown
                }
                
                return unknown
            }.flatMap { stmt -> [Statement] in
                // Free compound blocks cannot be declared in Swift
                if let inner = stmt.asCompound {
                    // Label the first statement with the compound's label, as
                    // well
                    inner.statements.first?.label = stmt.label
                    
                    return inner.statements
                }
                
                return [stmt]
            })
        }
    }
    
    // MARK: - Variable declaration extractor visitor
    fileprivate class VarDeclarationExtractor: ObjectiveCParserBaseVisitor<Statement> {
        var expressionReader: SwiftExprASTReader
        var context: SwiftASTReaderContext
        weak var delegate: SwiftStatementASTReaderDelegate?
        
        init(
            expressionReader: SwiftExprASTReader,
            context: SwiftASTReaderContext,
            delegate: SwiftStatementASTReaderDelegate?
        ) {

            self.expressionReader = expressionReader
            self.context = context
            self.delegate = delegate
        }
        
        override func visitForLoopInitializer(_ ctx: Parser.ForLoopInitializerContext) -> Statement? {
            guard let initDeclaratorList = ctx.initDeclaratorList() else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            guard let declSpecifiers = ctx.declarationSpecifiers() else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            var declarations: [StatementVariableDeclaration] = []

            let types = expressionReader.typeParser.parseObjcTypes(in: declSpecifiers, initDeclaratorList: initDeclaratorList)

            let initDeclarators = initDeclaratorList.initDeclarator()

            for (type, initDeclarator) in zip(types, initDeclarators) {
                guard let directDeclarator = initDeclarator.declarator()?.directDeclarator() else {
                    continue
                }
                guard let identifier = directDeclarator.identifier()?.getText() else {
                    continue
                }
                
                let expr = initDeclarator.initializer()?.expression()?.accept(expressionReader)
                
                let swiftType = expressionReader.typeMapper.swiftType(forObjcType: type)
                
                let ownership = evaluateOwnershipPrefix(inType: type)
                let isConstant = _isConstant(fromType: type)
                
                let declaration = StatementVariableDeclaration(
                    identifier: identifier,
                    type: swiftType,
                    ownership: ownership,
                    isConstant: isConstant,
                    initialization: expr
                )
                declarations.append(declaration)

                context.define(localNamed: identifier, storage: declaration.storage)
            }

            let varDeclStmt = Statement.variableDeclarations(declarations)

            reportAutotypeDeclarations(in: varDeclStmt)

            return varDeclStmt
        }

        override func visitStatement(_ ctx: ObjectiveCParser.StatementContext) -> Statement? {
            return ctx.expressions()?.accept(self)
        }

        override func visitExpressions(_ ctx: ObjectiveCParser.ExpressionsContext) -> Statement? {
            // Detect variable declarations that where parsed as multiplication
            // expressions due to ambiguities in the parser.
            let expressions = ctx.expression()
            guard !expressions.isEmpty else {
                return nil
            }
                        
            if let result = tryMapPointerDeclaration(ctx) {
                return result
            }
            if let result = tryMapIdProtocolList(ctx) {
                return result
            }

            return nil
        }

        override func visitDeclaration(_ ctx: ObjectiveCParser.DeclarationContext) -> Statement? {
            guard let declarationSpecifiers = ctx.declarationSpecifiers() else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }

            let declarations: [StatementVariableDeclaration]

            if let initDeclaratorList = ctx.initDeclaratorList() {
                declarations = self.declarations(
                    from: declarationSpecifiers,
                    initDeclaratorList: initDeclaratorList
                )
            } else {
                declarations = self.declarations(
                    from: declarationSpecifiers
                )
            }

            let varDeclStmt = Statement.variableDeclarations(declarations)
            
            varDeclStmt.comments = context
                .popClosestCommentsBefore(rule: ctx)
                .map { $0.string.trimmingWhitespace() }
            
            varDeclStmt.trailingComment = context
                .popClosestCommentAtTrailingLine(node: ctx)?
                .string.trimmingWhitespace()

            reportAutotypeDeclarations(in: varDeclStmt)
            
            return varDeclStmt
        }

        private func declarations(
            from declarationSpecifiers: ObjectiveCParser.DeclarationSpecifiersContext
        ) -> [StatementVariableDeclaration] {

            var declarations: [StatementVariableDeclaration] = []

            guard let identifier = VarDeclarationIdentifierNameExtractor.extract(from: declarationSpecifiers)?.getText() else {
                return []
            }

            guard
                let type = expressionReader
                    .typeParser
                    .parseObjcType(in: declarationSpecifiers)
            else {
                return []
            }
            
            let swiftType = expressionReader.typeMapper.swiftType(forObjcType: type)
            
            let ownership = evaluateOwnershipPrefix(inType: type)
            let isConstant = _isConstant(fromType: type)
            
            let declaration = StatementVariableDeclaration(
                identifier: identifier,
                type: swiftType,
                ownership: ownership,
                isConstant: isConstant,
                initialization: nil
            )
            declarations.append(declaration)

            context.define(localNamed: identifier, storage: declaration.storage)

            return declarations
        }

        private func declarations(
            from declarationSpecifiers: ObjectiveCParser.DeclarationSpecifiersContext,
            initDeclaratorList: ObjectiveCParser.InitDeclaratorListContext
        ) -> [StatementVariableDeclaration] {

            var declarations: [StatementVariableDeclaration] = []

            for initDeclarator in initDeclaratorList.initDeclarator() {
                guard let declarator = initDeclarator.declarator() else {
                    continue
                }
                guard let identifier = VarDeclarationIdentifierNameExtractor.extract(from: declarator)?.getText() else {
                    continue
                }
                guard
                    let type = expressionReader
                        .typeParser
                        .parseObjcType(
                            in: declarationSpecifiers,
                            declarator: declarator
                        )
                else {
                    continue
                }
                
                let expr = initDeclarator.initializer()?.expression()?.accept(expressionReader)
                
                let swiftType = expressionReader.typeMapper.swiftType(forObjcType: type)
                
                let ownership = evaluateOwnershipPrefix(inType: type)
                let isConstant = _isConstant(fromType: type)
                
                let declaration = StatementVariableDeclaration(
                    identifier: identifier,
                    type: swiftType,
                    ownership: ownership,
                    isConstant: isConstant,
                    initialization: expr
                )
                declarations.append(declaration)

                context.define(localNamed: identifier, storage: declaration.storage)
            }

            return declarations
        }

        private func declaration(
            objcType: ObjcType,
            identifier: String
        ) -> StatementVariableDeclaration {

            let swiftType = expressionReader.typeMapper.swiftType(forObjcType: objcType)

            return declaration(swiftType: swiftType, identifier: identifier)
        }

        private func declaration(
            swiftType: SwiftType,
            identifier: String
        ) -> StatementVariableDeclaration {

            let declaration = StatementVariableDeclaration(
                identifier: identifier,
                type: swiftType,
                initialization: nil
            )

            return declaration
        }

        /// Tries to map a top-level expression if it matches the form `A * B`.
        private func tryMapPointerDeclaration(
            _ ctx: ObjectiveCParser.ExpressionsContext
        ) -> Statement? {
            let expressions = ctx.expression()
            guard !expressions.isEmpty else {
                return nil
            }

            // Ensure all expressions can be properly parsed first
            let parsedExps = expressions.compactMap { $0.accept(expressionReader) }
            guard parsedExps.count == expressions.count else {
                return nil
            }

            let parsedExp = parsedExps[0]

            guard let binaryExpression = parsedExp.asBinary, binaryExpression.op == .multiply else {
                return nil
            }
            
            guard let typeName = binaryExpression.lhs.asIdentifier else {
                return nil
            }
            let baseTypeName: ObjcType = .typeName(typeName.identifier)

            guard
                let firstDeclarator = asObjcTypeDeclarator(binaryExpression.rhs, baseType: baseTypeName)
            else {
                return nil
            }

            // For every subsequent expression past the first comma, consider
            // the transformation only if they are all type-convertible to
            // Objective-C.
            guard parsedExps.dropFirst().allSatisfy({ asObjcTypeDeclarator($0, baseType: baseTypeName) != nil }) else {
                return nil
            }

            var declarations: [StatementVariableDeclaration] = []

            let declarators: [(String, ObjcType)] =
                [firstDeclarator]
                    + parsedExps.compactMap({ asObjcTypeDeclarator($0, baseType: baseTypeName) })
            
            for (i, (identifier, baseType)) in declarators.enumerated() {
                // First identifier is a pointer to 'typeName', the remaining
                // identifiers are all values of type 'typeName'
                var type: ObjcType = baseType
                if i == 0 {
                    type = .nullabilitySpecified(
                        specifier: .nullUnspecified,
                        .pointer(type)
                    )
                }

                let declaration = self.declaration(
                    objcType: type,
                    identifier: identifier
                )

                context.define(localNamed: identifier, storage: declaration.storage)
                declarations.append(declaration)
            }

            let varDeclStmt = Statement.variableDeclarations(declarations)
            
            varDeclStmt.comments = context
                .popClosestCommentsBefore(rule: ctx)
                .map { $0.string.trimmingWhitespace() }
            
            varDeclStmt.trailingComment = context
                .popClosestCommentAtTrailingLine(node: ctx)?
                .string.trimmingWhitespace()

            reportAutotypeDeclarations(in: varDeclStmt)
            
            return varDeclStmt
        }
        
        /// Tries to map a top-level expression if it matches the form `id < A > a`
        /// or `id < A, B > a` etc. as a declaration of a variable with a type of
        /// a protocol composition.
        private func tryMapIdProtocolList(
            _ ctx: ObjectiveCParser.ExpressionsContext
        ) -> Statement? {

            // Tokenize the expression list for easier parsing
            enum Token: Hashable {
                case id
                case ident(String)
                case lessThan
                case greaterThan

                var identString: String? {
                    switch self {
                    case .ident(let ident):
                        return ident
                    default:
                        return nil
                    }
                }
                var isIdent: Bool {
                    identString != nil
                }
            }

            class TokenizingVisitor: BaseSyntaxNodeVisitor {
                var tokens: [Token] = []
                var isValid = true

                override func visitExpression(_ exp: Expression) {
                    switch exp {
                    case is BinaryExpression, is IdentifierExpression:
                        super.visitExpression(exp)
                    default:
                        isValid = false
                    }
                }

                override func visitStatement(_ stmt: Statement) {
                    guard stmt.asExpressions != nil else {
                        isValid = false
                        return
                    }

                    super.visitStatement(stmt)
                }
                
                override func visitBinary(_ exp: BinaryExpression) {
                    visitExpression(exp.lhs)

                    switch exp.op {
                    case .lessThan where !tokens.contains(.lessThan) && !tokens.contains(.greaterThan):
                        tokens.append(.lessThan)
                    case .greaterThan where tokens.contains(.lessThan) && !tokens.contains(.greaterThan) && tokens.last != .lessThan:
                        tokens.append(.greaterThan)
                    default:
                        isValid = false
                    }

                    visitExpression(exp.rhs)
                }

                override func visitIdentifier(_ exp: IdentifierExpression) {
                    defer { super.visitIdentifier(exp) }

                    if exp.identifier == "id" {
                        tokens.append(.id)
                    } else {
                        tokens.append(.ident(exp.identifier))
                    }
                }
            }

            let visitor = TokenizingVisitor()
            
            let expressions = ctx.expression()
            let parsedExps = expressions.compactMap { $0.accept(expressionReader) }

            // Tokenize expressions
            for exp in parsedExps {
                exp.accept(visitor)
            }

            guard visitor.isValid else {
                return nil
            }

            let tokens = visitor.tokens
            // Tokens should be in the format:
            // 'id' '<' ident+ '>' ident+
            guard tokens.count >= 5, tokens[0] == .id, tokens[1] == .lessThan else {
                return nil
            }

            // Fetch identifier tokens between '<' and '>'; any remaining identifier
            // is considered to be a declarator for a variable.

            let split = tokens.dropFirst(2/*= 'id <' tokens */).split(separator: .greaterThan)
            guard split.count == 2 else {
                return nil
            }

            let protocolTokens = split[0]
            let identifierTokens = split[1]

            guard
                !protocolTokens.isEmpty && protocolTokens.allSatisfy(\.isIdent),
                !identifierTokens.isEmpty && identifierTokens.allSatisfy(\.isIdent)
            else {
                return nil
            }

            let protocolList = protocolTokens.compactMap(\.identString)
            let identifierList = identifierTokens.compactMap(\.identString)

            let objcType = ObjcType.id(protocols: protocolList)

            var declarations: [StatementVariableDeclaration] = []

            for identifier in identifierList {
                let declaration = self.declaration(
                    objcType: objcType,
                    identifier: identifier
                )

                context.define(localNamed: identifier, storage: declaration.storage)
                declarations.append(declaration)
            }
            
            let varDeclStmt = Statement.variableDeclarations(declarations)
            
            varDeclStmt.comments = context
                .popClosestCommentsBefore(rule: ctx)
                .map { $0.string.trimmingWhitespace() }
            
            varDeclStmt.trailingComment = context
                .popClosestCommentAtTrailingLine(node: ctx)?
                .string.trimmingWhitespace()

            reportAutotypeDeclarations(in: varDeclStmt)
            
            return varDeclStmt
        }

        private func reportAutotypeDeclarations(in declarationStatement: VariableDeclarationsStatement) {
            guard let delegate = delegate else {
                return
            }
            
            for (i, decl) in declarationStatement.decl.enumerated()
                where decl.type == .typeName("__auto_type") {
                    
                delegate.swiftStatementASTReader(
                    reportAutoTypeDeclaration: declarationStatement,
                    declarationAtIndex: i
                )
            }
        }

        /// Attempts to convert a Swift expression into an Objective-C declarator
        /// based on how that expression tokenizes in C.
        ///
        /// Requires that the expression tree ends in at least one identifier
        /// so that can be used as a base declarator identifier.
        private func asObjcTypeDeclarator(_ exp: Expression, baseType: ObjcType) -> (String, ObjcType)? {
            switch exp {
            case let exp as IdentifierExpression:
                // <identifier declarator>
                return (exp.identifier, baseType)

            case let exp as PostfixExpression:
                guard let (ident, superType) = asObjcTypeDeclarator(exp.exp, baseType: baseType) else {
                    return nil
                }
                
                switch exp.op {
                // <base declarator>[<fixed array size (integer)>]
                case let subOp as SubscriptPostfix:
                    guard subOp.subExpressions.count == 1 else {
                        return nil
                    }
                    guard let sub = subOp.subExpressions[0].asConstant else {
                        return nil
                    }
                    guard let integerValue = sub.constant.integerValue, integerValue >= 0 else {
                        return nil
                    }

                    return (ident, .fixedArray(superType, length: integerValue))

                default:
                    return nil
                }
            default:
                return nil
            }
        }
    }
}

private class ForStatementGenerator {
    typealias Parser = ObjectiveCParser
    
    var reader: SwiftStatementASTReader
    var context: SwiftASTReaderContext
    
    init(reader: SwiftStatementASTReader, context: SwiftASTReaderContext) {
        self.reader = reader
        self.context = context
    }
    
    func generate(_ ctx: Parser.ForStatementContext) -> Statement {
        
        guard let compoundStatement = ctx.statement()?.accept(reader.compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        // Do a trickery here: We bloat the loop by unrolling it into a plain while
        // loop that is compatible with the original for-loop's behavior
        
        // for(<initExprs>; <condition>; <iteration>)
        let varDeclExtractor = SwiftStatementASTReader.VarDeclarationExtractor(
            expressionReader: reader.expressionReader,
            context: context,
            delegate: reader.delegate
        )
        
        let initExpr =
            ctx.forLoopInitializer()?
                .accept(varDeclExtractor)
        
        let condition = ctx.expression()?.accept(reader.expressionReader)
        
        // for(<loop>; <condition>; <iteration>)
        let iteration = ctx.expressions()?.accept(reader)
        
        // Try to come up with a clean for-in loop with a range
        if let initExpr = initExpr, let condition = condition, let iteration = iteration {
            let result = genSimplifiedFor(
                initExpr: initExpr,
                condition: condition,
                iteration: iteration,
                body: compoundStatement
            )
            
            if let result = result {
                return result
            }
        }
        
        return genWhileLoop(initExpr, condition, iteration, compoundStatement, ctx)
    }
    
    private func genWhileLoop(
        _ initExpr: Statement?,
        _ condition: Expression?,
        _ iteration: Statement?,
        _ compoundStatement: CompoundStatement,
        _ ctx: ForStatementGenerator.Parser.ForStatementContext
    ) -> Statement {
        
        // Come up with a while loop, now
        
        // Loop body
        let body = CompoundStatement()
        if let iteration = iteration {
            body.statements.append(.defer([iteration]))
        }
        
        body.statements.append(contentsOf: compoundStatement.statements.map { $0.copy() })
        
        let whileBody = Statement.while(
            condition ?? .constant(true),
            body: body
        )
        
        // Loop init (pre-loop)
        let bodyWithWhile: Statement
        if let expStmt = ctx.forLoopInitializer()?.expressions()?.accept(reader) {
            let body = CompoundStatement()
            body.statements.append(expStmt)
            body.statements.append(whileBody)
            
            bodyWithWhile = body
        } else if let initExpr = initExpr {
            let body = CompoundStatement()
            body.statements.append(initExpr)
            body.statements.append(whileBody)
            
            bodyWithWhile = body
        } else {
            bodyWithWhile = whileBody
        }
        
        return bodyWithWhile
    }
    
    private func genSimplifiedFor(
        initExpr: Statement,
        condition: Expression,
        iteration: Statement,
        body compoundStatement: CompoundStatement
    ) -> Statement? {
        
        // Search for inits like 'int i = <value>'
        guard let decl = initExpr.asVariableDeclaration?.decl, decl.count == 1 else {
            return nil
        }
        let loopVar = decl[0]
        if loopVar.type != .int {
            return nil
        }
        guard let loopStart = (loopVar.initialization as? ConstantExpression)?.constant else {
            return nil
        }
        
        // Look for conditions of the form 'i < <value>'
        guard let binary = condition.asBinary else {
            return nil
        }
        
        let op = binary.op
        guard binary.lhs.asIdentifier?.identifier == loopVar.identifier else {
            return nil
        }
        
        guard op == .lessThan || op == .lessThanOrEqual else {
            return nil
        }
        
        // Look for loop iterations of the form 'i++'
        guard let exps = iteration.asExpressions?.expressions, exps.count == 1 else {
            return nil
        }
        guard exps[0].asAssignment ==
            .assignment(lhs: .identifier(loopVar.identifier), op: .addAssign, rhs: .constant(1)) else {
                return nil
        }
        
        // Check if the loop variable is not being modified within the loop's
        // body
        if ASTAnalyzer(compoundStatement).isLocalMutated(localName: loopVar.identifier) {
            return nil
        }
        
        let loopEnd: Expression
        let counter = loopCounter(in: binary.rhs)
        
        switch counter {
        case let .literal(int, type)?:
            loopEnd = .constant(.int(int, type))
            
        case .local(let local)?:
            // Check if the local is not modified within the loop's body
            if !local.storage.isConstant {
                if ASTAnalyzer(compoundStatement).isLocalMutated(localName: local.name) {
                    return nil
                }
            }
            
            loopEnd = .identifier(local.name)
            
        case let .propertyAccess(local, member)?:
            if ASTAnalyzer(compoundStatement).isLocalMutated(localName: local.name) {
                return nil
            }
            
            loopEnd = Expression.identifier(local.name).dot(member)
            
        case nil:
            return nil
        }
        
        // All good! Simplify now.
        let rangeOp: SwiftOperator = op == .lessThan ? .openRange : .closedRange
        
        return .for(.identifier(loopVar.identifier),
                    .binary(lhs: .constant(loopStart),
                            op: rangeOp,
                            rhs: loopEnd),
                    body: compoundStatement)
    }
    
    func loopCounter(in expression: Expression) -> LoopCounter? {
        switch expression {
        case let constant as ConstantExpression:
            switch constant.constant {
            case let .int(value, type):
                return .literal(value, type)
            default:
                return nil
            }
            
        case let ident as IdentifierExpression:
            if let local = context.localNamed(ident.identifier) {
                return .local(local)
            }
            
        case let postfix as PostfixExpression:
            guard let identifier = postfix.exp.asIdentifier else {
                return nil
            }
            guard let member = postfix.op.asMember else {
                return nil
            }
            guard let local = context.localNamed(identifier.identifier) else {
                return nil
            }
            
            return .propertyAccess(local, property: member.name)
            
        default:
            return nil
        }
        
        return nil
    }
    
    enum LoopCounter {
        case literal(Int, Constant.IntegerType)
        case local(SwiftASTReaderContext.Local)
        case propertyAccess(SwiftASTReaderContext.Local, property: String)
    }
}

private class ASTAnalyzer {
    let node: SyntaxNode
    
    init(_ node: SyntaxNode) {
        self.node = node
    }
    
    func isLocalMutated(localName: String) -> Bool {
        var sequence: AnySequence<Expression>
        
        switch node {
        case let exp as Expression:
            sequence = expressions(in: exp, inspectBlocks: true)
            
        case let stmt as Statement:
            sequence = expressions(in: stmt, inspectBlocks: true)
            
        default:
            return false
        }
        
        return sequence.contains { exp in
            exp.asAssignment?.lhs.asIdentifier?.identifier == localName
        }
    }
}

private func expressions(in statement: Statement, inspectBlocks: Bool) -> AnySequence<Expression> {
    let sequence =
        SyntaxNodeSequence(node: statement,
                           inspectBlocks: inspectBlocks)
    
    return AnySequence(sequence.lazy.compactMap { $0 as? Expression })
}

private func expressions(in expression: Expression, inspectBlocks: Bool) -> AnySequence<Expression> {
    let sequence =
        SyntaxNodeSequence(node: expression,
                           inspectBlocks: inspectBlocks)
    
    return AnySequence(sequence.lazy.compactMap { $0 as? Expression })
}

internal func _isConstant(fromType type: ObjcType) -> Bool {
    switch type {
    case .qualified(let inner, let qualifiers):
        if qualifiers.contains(.const) {
            return true
        }

        return _isConstant(fromType: inner)

    case .pointer(_, let qualifiers, _):
        return qualifiers.contains(.const)
    case .specified(_, let inner):
        return _isConstant(fromType: inner)

    default:
        return false
    }
}

internal func evaluateOwnershipPrefix(
    inType type: ObjcType,
    property: PropertyDefinition? = nil
) -> Ownership {
    
    var ownership: Ownership = .strong
    if !type.isPointer {
        // We don't have enough information at statement parsing time to conclude
        // that an __auto_type declaration does not resolve in fact to a pointer.
        // Keep ownership modifiers for now
        if case .specified(_, .typeName("__auto_type")) = type {
            // skip return
        } else {
            return .strong
        }
    }
    
    switch type {
    case .specified(let specifiers, _):
        if specifiers.last == .weak {
            ownership = .weak
        } else if specifiers.last == .unsafeUnretained {
            ownership = .unownedUnsafe
        }
    default:
        break
    }
    
    // Search in property
    if let property = property {
        if let modifiers = property.attributesList?.keywordAttributes {
            if modifiers.contains("weak") {
                ownership = .weak
            } else if modifiers.contains("unsafe_unretained") {
                ownership = .unownedUnsafe
            } else if modifiers.contains("assign") {
                ownership = .unownedUnsafe
            }
        }
    }
    
    return ownership
}
