import XCTest

@testable import AntlrGrammars

class LexerTransformerTests: XCTestCase {
    func testValidate() throws {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestLexer: SomeLexerClass {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                public required init(_ input: CharStream) {}
                override open func getATN() -> ATN { return TestLexer._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = LexerTransformer(filePath: stubFilePath)

        try sut.validate(fileIOStub)
    }

    func testValidate_skipsIfStateClassIsPresent() throws {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestLexer: Lexer {
                public class State { }
                // internal static var _decisionToDFA: [DFA]
                // internal static let _sharedContextCache = PredictionContextCache()
                // public required init(_ input: CharStream) {}
                // override open func getATN() -> ATN { return TestLexer._ATN }
                // public static let _ATN: ATN
            }
            """))
        
        let sut = LexerTransformer(filePath: stubFilePath)

        try sut.validate(fileIOStub)
    }

    func testValidate_missing_lexerClass() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            // Not a class
            struct TestLexer1: Lexer {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                public required init(_ input: CharStream) {}
                override open func getATN() -> ATN { return TestLexer._ATN }
                public static let _ATN: ATN
            }

            // Does not inherit from 'Lexer' class
            open class TestLexer2 {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                public required init(_ input: CharStream) {}
                override open func getATN() -> ATN { return TestLexer._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = LexerTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testValidate_missing_decisionToDFA() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestLexer: Lexer {
                // internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                public required init(_ input: CharStream) {}
                override open func getATN() -> ATN { return TestLexer._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = LexerTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testValidate_missing_sharedContextCache() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestLexer: Lexer {
                internal static var _decisionToDFA: [DFA]
                // internal static let _sharedContextCache = PredictionContextCache()
                public required init(_ input: CharStream) {}
                override open func getATN() -> ATN { return TestLexer._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = LexerTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testValidate_missing_init() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestLexer: Lexer {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                // public required init(_ input: CharStream) {}
                override open func getATN() -> ATN { return TestLexer._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = LexerTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testValidate_missing_getATN() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestLexer: Lexer {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                public required init(_ input: CharStream) {}
                // override open func getATN() -> ATN { return TestLexer._ATN }
                public static let _ATN: ATN
            }
            """))
        
        let sut = LexerTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testValidate_missing_ATN() {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestLexer: Lexer {
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                public required init(_ input: CharStream) {}
                override open func getATN() -> ATN { return TestLexer._ATN }
                // public static let _ATN: ATN
            }
            """))
        
        let sut = LexerTransformer(filePath: stubFilePath)

        XCTAssertThrowsError(try sut.validate(fileIOStub))
    }

    func testTransform() throws {
        let formatter = SwiftFormatterTransformer()

        let fileIOStub = FileIOTypeStub(stubRead: .string(stubLexerFile))

        let sut = LexerTransformer(filePath: stubFilePath)

        let result = try sut.transform(fileIOStub, formatter: formatter)
        let text = result.description

        diffTest(expected: """
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestLexer: Lexer {

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

                public static let SHARP = 1, CODE = 2

                public static let COMMENTS_CHANNEL = 2
                public static let DIRECTIVE_MODE = 1
                public static let channelNames: [String] = ["DEFAULT_TOKEN_CHANNEL"]

                public static let modeNames: [String] = ["DEFAULT_MODE"]

                public static let ruleNames: [String] = ["SHARP"]

                private static let _LITERAL_NAMES: [String?] = [nil]
                private static let _SYMBOLIC_NAMES: [String?] = [nil, "SHARP"]
                public static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

                override open func getVocabulary() -> Vocabulary { return TestLexer.VOCABULARY }

                public required convenience init(_ input: CharStream) { self.init(input, State()) }

                public required init(_ input: CharStream, _ state: State) {
                    self.state = state

                    RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
                    super.init(input)
                    _interp = LexerATNSimulator(self, _ATN, _decisionToDFA, _sharedContextCache)
                }

                override open func getGrammarFileName() -> String { return "TestLexer.g4" }

                override open func getRuleNames() -> [String] { return TestLexer.ruleNames }

                override open func getSerializedATN() -> [Int] { return TestLexer._serializedATN }

                override open func getChannelNames() -> [String] { return TestLexer.channelNames }

                override open func getModeNames() -> [String] { return TestLexer.modeNames }

                override open func getATN() -> ATN { return _ATN }

                static let _serializedATN: [Int] = [1, 2, 3, 4]
            }

            """)
            .diff(text)
    }

    func testTransform_skipsIfStateClassIsPresent() throws {
        let fileIOStub = FileIOTypeStub(stubRead: .string("""
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestLexer: Lexer {
                public class State { }
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                public required init(_ input: CharStream) {}
                override open func getATN() -> ATN { return TestLexer._ATN }
                public static let _ATN: ATN
            }
            """))
        let sut = LexerTransformer(filePath: stubFilePath)

        let result = try sut.transform(fileIOStub)

        let text = result.description
        diffTest(expected: """
            // Generated from java-escape by ANTLR 4.11.1
            import Antlr4

            open class TestLexer: Lexer {
                public class State { }
                internal static var _decisionToDFA: [DFA]
                internal static let _sharedContextCache = PredictionContextCache()
                public required init(_ input: CharStream) {}
                override open func getATN() -> ATN { return TestLexer._ATN }
                public static let _ATN: ATN
            }
            """)
            .diff(text)
    }
}

private let stubFilePath: URL = URL(fileURLWithPath: "/any/path")
private let stubLexerFile: String = """
    // Generated from java-escape by ANTLR 4.11.1
    import Antlr4

    open class TestLexer: Lexer {

        internal static var _decisionToDFA: [DFA] = {
            var decisionToDFA = [DFA]()
            let length = TestLexer._ATN.getNumberOfDecisions()
            for i in 0..<length {
                    decisionToDFA.append(DFA(TestLexer._ATN.getDecisionState(i)!, i))
            }
            return decisionToDFA
        }()

        internal static let _sharedContextCache = PredictionContextCache()

        public
        static let SHARP=1, CODE=2

        public
        static let COMMENTS_CHANNEL=2
        public
        static let DIRECTIVE_MODE=1
        public
        static let channelNames: [String] = [
            "DEFAULT_TOKEN_CHANNEL"
        ]

        public
        static let modeNames: [String] = [
            "DEFAULT_MODE"
        ]

        public
        static let ruleNames: [String] = [
            "SHARP"
        ]

        private static let _LITERAL_NAMES: [String?] = [
            nil
        ]
        private static let _SYMBOLIC_NAMES: [String?] = [
            nil, "SHARP"
        ]
        public
        static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)


        override open
        func getVocabulary() -> Vocabulary {
            return TestLexer.VOCABULARY
        }

        public
        required init(_ input: CharStream) {
            RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
            super.init(input)
            _interp = LexerATNSimulator(self, TestLexer._ATN, TestLexer._decisionToDFA, TestLexer._sharedContextCache)
        }

        override open
        func getGrammarFileName() -> String { return "TestLexer.g4" }

        override open
        func getRuleNames() -> [String] { return TestLexer.ruleNames }

        override open
        func getSerializedATN() -> [Int] { return TestLexer._serializedATN }

        override open
        func getChannelNames() -> [String] { return TestLexer.channelNames }

        override open
        func getModeNames() -> [String] { return TestLexer.modeNames }

        override open
        func getATN() -> ATN { return TestLexer._ATN }

        static let _serializedATN:[Int] = [
            1,2,3,4
        ]

        public
        static let _ATN: ATN = try! ATNDeserializer().deserialize(_serializedATN)
    }
    """
