import SwiftSyntax
import SwiftSyntaxParser

/// Helper class for generating the required source constructs for rewriting
/// source files.
enum SourceGenerator {
    /// ```swift
    /// public class State {
    ///     public let _ATN: ATN = try! ATNDeserializer().deserialize(_serializedATN)
    ///
    ///     internal static var _decisionToDFA: [DFA]
    ///     internal static let _sharedContextCache = PredictionContextCache()
    ///
    ///     public init() {
    ///         var decisionToDFA = [DFA]()
    ///         let length = _ATN.getNumberOfDecisions()
    ///         for i in 0..<length {
    ///             decisionToDFA.append(DFA(_ATN.getDecisionState(i)!, i))
    ///         }
    ///         _decisionToDFA = decisionToDFA
    ///     }
    /// }
    /// ```
    static func stateClass() -> ClassDeclSyntax {
        let file = try! SyntaxParser.parse(source: """
            public class State {
                public let _ATN: ATN = try! ATNDeserializer().deserialize(_serializedATN)
                
                internal var _decisionToDFA: [DFA]
                internal let _sharedContextCache: PredictionContextCache = PredictionContextCache()
                
                public init() {
                    var decisionToDFA = [DFA]()
                    let length = _ATN.getNumberOfDecisions()
                    for i in 0..<length {
                        decisionToDFA.append(DFA(_ATN.getDecisionState(i)!, i))
                    }
                    _decisionToDFA = decisionToDFA
                }
            }
        """)

        return file.firstChildOfType(ClassDeclSyntax.self)!
    }

    /// ```swift
    /// public var _ATN: ATN {
    ///     return state._ATN
    /// }
    /// ```
    static func atnGetter() -> VariableDeclSyntax {
        makeGetter(
            .public,
            "_ATN",
            type: typeName("ATN"),
            expr: memberAccessExpr("self", "_ATN")
        )
    }

    /// ```swift
    /// internal var _decisionToDFA: [DFA] {
    ///     return state._decisionToDFA
    /// }
    /// ```
    static func decisionToDFAGetter() -> VariableDeclSyntax {
        makeGetter(
            .internal,
            "_decisionToDFA",
            type: arrayType(of: typeName("DFA")),
            expr: memberAccessExpr("self", "_decisionToDFA")
        )
    }

    /// ```swift
    /// internal var _sharedContextCache: PredictionContextCache {
    ///     return state._sharedContextCache
    /// }
    /// ```
    static func sharedContextCacheGetter() -> VariableDeclSyntax {
        makeGetter(
            .internal,
            "_sharedContextCache",
            type: typeName("PredictionContextCache"),
            expr: memberAccessExpr("self", "_sharedContextCache")
        )
    }

    /// ```swift
    /// public var state: State
    /// ```
    static func stateVarDecl() -> VariableDeclSyntax {
        makeVarDecl(
            .public,
            "state",
            type: typeName("State")
        )
    }

    /// ```swift
	/// override public convenience init(_ input: TokenStream) throws {
	/// 	try self.init(input, State())
	/// }
    /// ```
    static func parserConvenienceInit() -> DeclSyntax {
        let file = try! SyntaxParser.parse(source: """
        class C {            
            override public convenience init(_ input: TokenStream) throws {
                try self.init(input, State())
            }
        }
        """)

        return file.firstChildOfType(InitializerDeclSyntax.self)!.asDeclSyntax
    }

    /// ```swift
	/// public required init(_ input: TokenStream, _ state: State) throws {
	///     self.state = state
    /// 
	///     RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
	///     try super.init(input)
	/// 	_interp = ParserATNSimulator(self, _ATN, _decisionToDFA, _sharedContextCache)
	/// }
    /// ```
    static func parserStatefulInitializer() -> DeclSyntax {
        let file = try! SyntaxParser.parse(source: """
        class C {
            public required init(_ input: TokenStream, _ state: State) throws {
                self.state = state

                RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
                try super.init(input)
                _interp = ParserATNSimulator(self, _ATN, _decisionToDFA, _sharedContextCache)
            }
        }
        """)

        return file.firstChildOfType(InitializerDeclSyntax.self)!.asDeclSyntax
    }

    /// ```swift
	/// public required convenience init(_ input: TokenStream) {
	/// 	self.init(input, State())
	/// }
    /// ```
    static func lexerConvenienceInit() -> DeclSyntax {
        let file = try! SyntaxParser.parse(source: """
        class C {            
            public required convenience init(_ input: CharStream) {
                self.init(input, State())
            }
        }
        """)

        return file.firstChildOfType(InitializerDeclSyntax.self)!.asDeclSyntax
    }

    /// ```swift
	/// public required init(_ input: CharStream, _ state: State) {
	///     self.state = state
    /// 
	///     RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
	///     super.init(input)
	/// 	_interp = LexerATNSimulator(self, _ATN, _decisionToDFA, _sharedContextCache)
	/// }
    /// ```
    static func lexerStatefulInitializer() -> DeclSyntax {
        let file = try! SyntaxParser.parse(source: """
            class C {            
                public required init(_ input: CharStream, _ state: State) {
                    self.state = state

                    RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
                    super.init(input)
                    _interp = LexerATNSimulator(self, _ATN, _decisionToDFA, _sharedContextCache)
                }
            }
            """)

        return file.firstChildOfType(InitializerDeclSyntax.self)!.asDeclSyntax
    }

    /// ```swift
	/// override open func getATN() -> ATN {
    ///     return _ATN
    /// }
    /// ```
    static func getATNMethod() -> DeclSyntax {
        let file = try! SyntaxParser.parse(source: """
        class C {            
            override open func getATN() -> ATN {
                return _ATN
            }
        }
        """)

        return file.firstChildOfType(FunctionDeclSyntax.self)!.asDeclSyntax
    }
    
    // MARK: - Private

    private static func makeGetter(
        _ accessLevel: AccessLevel,
        _ identifier: String,
        type: TypeSyntax,
        expr: ExprSyntax
    ) -> VariableDeclSyntax {

        VariableDeclSyntax { decl in
            decl.addModifier(
                declModifier(
                    accessLevel.asTokenSyntax().withTrailingSpace()
                )
            )

            decl.useLetOrVarKeyword(SyntaxFactory.makeVarKeyword().withTrailingSpace())

            decl.addBinding(PatternBindingSyntax { builder in
                builder.usePattern(identifierPattern(identifier))
                builder.useTypeAnnotation(TypeAnnotationSyntax {
                    $0.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                    $0.useType(type)
                })
                builder.useAccessor(getAccessor(ReturnStmtSyntax { builder in
                    builder.useReturnKeyword(
                        SyntaxFactory
                            .makeReturnKeyword()
                            .withTrailingSpace()
                    )
                    builder.useExpression(expr)
                }.asStmtSyntax))
            })
        }
    }

    private static func makeVarDecl(
        _ accessLevel: AccessLevel,
        _ identifier: String,
        type: TypeSyntax
    ) -> VariableDeclSyntax {

        VariableDeclSyntax { decl in
            decl.addModifier(
                declModifier(
                    accessLevel.asTokenSyntax().withTrailingSpace()
                )
            )

            decl.useLetOrVarKeyword(SyntaxFactory.makeVarKeyword().withTrailingSpace())

            decl.addBinding(PatternBindingSyntax { builder in
                builder.usePattern(identifierPattern(identifier))
                builder.useTypeAnnotation(TypeAnnotationSyntax {
                    $0.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                    $0.useType(type)
                })
            })
        }
    }

    enum AccessLevel {
        case `open`
        case `public`
        case `internal`
        case `fileprivate`
        case `private`

        func asTokenSyntax() -> TokenSyntax {
            switch self {
            case .open:
                return identifierToken("open")
            case .public:
                return SyntaxFactory.makePublicKeyword()
            case .internal:
                return SyntaxFactory.makeInternalKeyword()
            case .fileprivate:
                return SyntaxFactory.makeFileprivateKeyword()
            case .private:
                return SyntaxFactory.makePrivateKeyword()
            }
        }
    }
}

private func getAccessor(_ body: StmtSyntax) -> Syntax {
    CodeBlockSyntax { builder in
        builder.useLeftBrace(
            SyntaxFactory.makeLeftBraceToken().withLeadingSpace()
        )
        
        let stmtList = SyntaxFactory.makeCodeBlockItemList([
            CodeBlockItemSyntax { builder in
                builder.useItem(
                    body.asSyntax
                    .withLeadingTrivia(
                        .newlines(1) + Trivia.spaces(4)
                    )
                )
            }
        ])
        
        let codeBlock = SyntaxFactory.makeCodeBlockItem(
            item: stmtList.asSyntax,
            semicolon: nil,
            errorTokens: nil
        )
        
        builder.addStatement(codeBlock)
        
        builder.useRightBrace(
            SyntaxFactory.makeRightBraceToken()
                .withLeadingTrivia(.newlines(1) + Trivia.spaces(4))
        )
    }.asSyntax
}

// MARK: - Utils

internal extension SyntaxProtocol {
    func firstChildOfType<T: SyntaxProtocol>(_ type: T.Type) -> T? {
        var queue: [SyntaxProtocol] = [self]

        while !queue.isEmpty {
            let next = queue.removeFirst()

            if let value = Syntax(next).as(T.self) {
                return value
            }

            for child in next.children {
                queue.append(child)
            }
        }

        return nil
    }
}
