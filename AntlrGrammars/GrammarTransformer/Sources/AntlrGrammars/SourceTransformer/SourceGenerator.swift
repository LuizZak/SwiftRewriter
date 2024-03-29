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
            expr: memberAccessExpr("state", "_ATN")
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
            expr: memberAccessExpr("state", "_decisionToDFA")
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
            expr: memberAccessExpr("state", "_sharedContextCache")
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

        let syntax = VariableDeclSyntax(
            modifiers: ModifierListSyntax([
                declModifier(accessLevel.asTokenSyntax().withTrailingSpace())
            ]),
            letOrVarKeyword: .varKeyword().withTrailingSpace(),
            bindings: PatternBindingListSyntax([
                PatternBindingSyntax(
                    pattern: identifierPattern(identifier),
                    typeAnnotation: .init(
                        colon: .colonToken().withTrailingSpace(),
                        type: type
                    ),
                    accessor: .getter(getAccessor(
                        ReturnStmtSyntax(
                            returnKeyword: .returnKeyword().withTrailingSpace(),
                            expression: expr
                        )
                    ))
                )
            ])
        )

        return syntax
    }

    private static func makeVarDecl(
        _ accessLevel: AccessLevel,
        _ identifier: String,
        type: TypeSyntax
    ) -> VariableDeclSyntax {

        let syntax = VariableDeclSyntax(
            modifiers: ModifierListSyntax([
                declModifier(accessLevel.asTokenSyntax().withTrailingSpace())
            ]),
            letOrVarKeyword: .varKeyword().withTrailingSpace(),
            bindings: PatternBindingListSyntax([
                .init(
                    pattern: identifierPattern(identifier),
                    typeAnnotation: .init(
                        colon: .colonToken().withTrailingSpace(),
                        type: type
                    )
                ),
            ])
        )

        return syntax
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
                return .publicKeyword()
            case .internal:
                return .internalKeyword()
            case .fileprivate:
                return .fileprivateKeyword()
            case .private:
                return .privateKeyword()
            }
        }
    }
}

private func getAccessor<S: StmtSyntaxProtocol>(_ body: S) -> CodeBlockSyntax {
    let syntax = CodeBlockSyntax(
        leftBrace: .leftBraceToken().withLeadingSpace(),
        statements: CodeBlockItemListSyntax([
            .init(item: .stmt(body.asStmtSyntax))
        ]),
        rightBrace: .rightBraceToken().withLeadingTrivia(.newlines(1) + .spaces(4))
    )

    return syntax
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

            for child in next.children(viewMode: .sourceAccurate) {
                queue.append(child)
            }
        }

        return nil
    }
}
