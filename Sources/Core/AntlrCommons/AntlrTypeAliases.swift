import Antlr4

#if true

public typealias DFAParser = DFA
public typealias DFALexer = DFA
public typealias ATNConfigSetParser = ATNConfigSet

#else

public typealias DFAParser = DFA<ParserATNConfig>
public typealias DFALexer = DFA<LexerATNConfig>
public typealias ATNConfigSetParser = ATNConfigSet<ParserATNConfig>

#endif
