import XCTest

@testable import AntlrGrammars

class ParserTransformerTests: XCTestCase {
    func testValidate() throws {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestParser: Parser {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                override public init(_ input: TokenStream) throws {}
                override open func getATN() -> ATN { return TestParser._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = ParserTransformer(filePath: stubFilePath)

        try sut.validate(fileIOStub)
    }

    func testValidate_skipsIfStateClassIsPresent() throws {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestParser: Parser {
                public class State {}
                // internal static var _decisionToDFA: [DFA]
                // internal static let _sharedContextCache = PredictionContextCache()
                // override public init(_ input: TokenStream) throws {}
                // override open func getATN() -> ATN { return TestParser._ATN }
                // public static let _ATN: ATN
            }
            """))
        
        let sut = ParserTransformer(filePath: stubFilePath)

        try sut.validate(fileIOStub)
    }

    func testValidate_missing_lexerClass() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            // Not a class
            struct TestParser1: Parser {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                override public init(_ input: TokenStream) throws {}
                override open func getATN() -> ATN { return TestParser._ATN }
                public static let _ATN: ATN
            }

            // Does not inherit from 'Lexer' class
            open class TestParser2 {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                override public init(_ input: TokenStream) throws {}
                override open func getATN() -> ATN { return TestParser._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = ParserTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testValidate_missing_decisionToDFA() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestParser: Parser {
                // internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                override public init(_ input: TokenStream) throws {}
                override open func getATN() -> ATN { return TestParser._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = ParserTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testValidate_missing_sharedContextCache() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestParser: Parser {
                internal static var _decisionToDFA: [DFA]
                // internal static let _sharedContextCache = PredictionContextCache()
                override public init(_ input: TokenStream) throws {}
                override open func getATN() -> ATN { return TestParser._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = ParserTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testValidate_missing_init() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestParser: Parser {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                // override public init(_ input: TokenStream) throws {}
                override open func getATN() -> ATN { return TestParser._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = ParserTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testValidate_missing_getATN() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestParser: Parser {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                override public init(_ input: TokenStream) throws {}
                // override open func getATN() -> ATN { return TestParser._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = ParserTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testValidate_missing_ATN() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestParser: Parser {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                override public init(_ input: TokenStream) throws {}
                override open func getATN() -> ATN { return TestParser._ATN }
                // public static let _ATN: ATN
            }
            """))
        
        let sut = ParserTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testTransform() throws {
        let formatter = SwiftFormatterTransformer()
        let fileIOStub = FileIOTypeStub(stubRead: .string(stubParserFile))
        let sut = ParserTransformer(filePath: stubFilePath)

        let result = try sut.transform(fileIOStub, formatter: formatter)

        let text = result.description
        diffTest(expected: """
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestParser: Parser {

                public class State {
                    public let _ATN: ATN = try! ATNDeserializer().deserialize(_serializedATN)
                    internal var _decisionToDFA: [DFA]
                    internal let _sharedContextCache: PredictionContextCache = PredictionContextCache()
                    public init() {
                        var decisionToDFA = [DFA]()
                        let length = _ATN.getNumberOfDecisions()
                        for i in 0..<length { decisionToDFA.append(DFA(_ATN.getDecisionState(i)!, i)) }
                        _decisionToDFA = decisionToDFA
                    }
                }

                public var _ATN: ATN { return self._ATN }

                internal var _decisionToDFA: [DFA] { return self._decisionToDFA }

                internal var _sharedContextCache: PredictionContextCache { return self._sharedContextCache }

                public var state: State

                public enum Tokens: Int { case EOF = -1 }

                public static let RULE_objectiveCDocument = 0

                public static let ruleNames: [String] = ["objectiveCDocument"]

                private static let _LITERAL_NAMES: [String?] = [nil, "'#'"]
                private static let _SYMBOLIC_NAMES: [String?] = [nil, "SHARP"]
                public static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

                override open func getGrammarFileName() -> String { return "java-escape" }

                override open func getRuleNames() -> [String] { return ObjectiveCPreprocessorParser.ruleNames }

                override open func getSerializedATN() -> [Int] {
                    return ObjectiveCPreprocessorParser._serializedATN
                }

                override open func getATN() -> ATN { return _ATN }

                override open func getVocabulary() -> Vocabulary {
                    return ObjectiveCPreprocessorParser.VOCABULARY
                }

                override public convenience init(_ input: TokenStream) throws { try self.init(input, State()) }

                public required init(_ input: TokenStream, _ state: State) throws {
                    self.state = state

                    RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
                    try super.init(input)
                    _interp = ParserATNSimulator(self, _ATN, _decisionToDFA, _sharedContextCache)
                }

                func dummyMethod() {
                    abc()
                    def()
                }

                static let _serializedATN: [Int] = [1, 2, 3, 4]
            }

            """)
            .diff(text)
    }

    func testTransform_skipsIfStateClassIsPresent() throws {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestParser: Parser {
                public class State {}
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                override public init(_ input: TokenStream) throws {}
                override open func getATN() -> ATN { return TestParser._ATN }
                public static let _ATN: ATN
            }
            """))
        let sut = ParserTransformer(filePath: stubFilePath)

        let result = try sut.transform(fileIOStub)

        let text = result.description
        diffTest(expected: """
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestParser: Parser {
                public class State {}
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                override public init(_ input: TokenStream) throws {}
                override open func getATN() -> ATN { return TestParser._ATN }
                public static let _ATN: ATN
            }
            """)
            .diff(text)
    }
}

private let stubFilePath: URL = URL(fileURLWithPath: "/any/path")
private let stubParserFile: String = """
    // Generated from java-escape by ANTLR 4.11.1
    import Antlr4

    open class TestParser: Parser {

        internal static var _decisionToDFA: [DFA] = {
            var decisionToDFA = [DFA]()
            let length = ObjectiveCPreprocessorParser._ATN.getNumberOfDecisions()
            for i in 0..<length {
                decisionToDFA.append(DFA(ObjectiveCPreprocessorParser._ATN.getDecisionState(i)!, i))
            }
            return decisionToDFA
        }()

        internal static let _sharedContextCache = PredictionContextCache()

        public
        enum Tokens: Int {
            case EOF = -1
        }

        public
        static let RULE_objectiveCDocument = 0

        public
        static let ruleNames: [String] = ["objectiveCDocument"]

        private static let _LITERAL_NAMES: [String?] = [nil, "'#'"]
        private static let _SYMBOLIC_NAMES: [String?] = [nil, "SHARP"]
        public
        static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

        override open
        func getGrammarFileName() -> String { return "java-escape" }

        override open
        func getRuleNames() -> [String] { return ObjectiveCPreprocessorParser.ruleNames }

        override open
        func getSerializedATN() -> [Int] { return ObjectiveCPreprocessorParser._serializedATN }

        override open
        func getATN() -> ATN { return ObjectiveCPreprocessorParser._ATN }

        override open func getVocabulary() -> Vocabulary { return ObjectiveCPreprocessorParser.VOCABULARY }

        override public
        init(_ input:TokenStream) throws {
            RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
            try super.init(input)
            _interp = ParserATNSimulator(self,ObjectiveCPreprocessorParser._ATN,ObjectiveCPreprocessorParser._decisionToDFA, ObjectiveCPreprocessorParser._sharedContextCache)
        }

        func dummyMethod() {
            var _prevctx: Preprocessor_expressionContext = _localctx
            abc()
            _prevctx = _localctx
            def()
        }

        static let _serializedATN:[Int] = [1,2,3,4]

        public
        static let _ATN = try! ATNDeserializer().deserialize(_serializedATN)
    }
    """
