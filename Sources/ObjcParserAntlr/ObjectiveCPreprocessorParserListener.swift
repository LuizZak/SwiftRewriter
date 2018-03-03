// Generated from /Users/luizfernandosilva/Documents/git/grammars-v4-master/objc/two-step-processing/ObjectiveCPreprocessorParser.g4 by ANTLR 4.7
import Antlr4

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link ObjectiveCPreprocessorParser}.
 */
public protocol ObjectiveCPreprocessorParserListener: ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link ObjectiveCPreprocessorParser#objectiveCDocument}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterObjectiveCDocument(_ ctx: ObjectiveCPreprocessorParser.ObjectiveCDocumentContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCPreprocessorParser#objectiveCDocument}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitObjectiveCDocument(_ ctx: ObjectiveCPreprocessorParser.ObjectiveCDocumentContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCPreprocessorParser#text}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterText(_ ctx: ObjectiveCPreprocessorParser.TextContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCPreprocessorParser#text}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitText(_ ctx: ObjectiveCPreprocessorParser.TextContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCPreprocessorParser#code}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCode(_ ctx: ObjectiveCPreprocessorParser.CodeContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCPreprocessorParser#code}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCode(_ ctx: ObjectiveCPreprocessorParser.CodeContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorImport}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorImport(_ ctx: ObjectiveCPreprocessorParser.PreprocessorImportContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorImport}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorImport(_ ctx: ObjectiveCPreprocessorParser.PreprocessorImportContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorConditional}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorConditional(_ ctx: ObjectiveCPreprocessorParser.PreprocessorConditionalContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorConditional}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorConditional(_ ctx: ObjectiveCPreprocessorParser.PreprocessorConditionalContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorDef}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorDef(_ ctx: ObjectiveCPreprocessorParser.PreprocessorDefContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorDef}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorDef(_ ctx: ObjectiveCPreprocessorParser.PreprocessorDefContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorPragma}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorPragma(_ ctx: ObjectiveCPreprocessorParser.PreprocessorPragmaContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorPragma}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorPragma(_ ctx: ObjectiveCPreprocessorParser.PreprocessorPragmaContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorError}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorError(_ ctx: ObjectiveCPreprocessorParser.PreprocessorErrorContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorError}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorError(_ ctx: ObjectiveCPreprocessorParser.PreprocessorErrorContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorWarning}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorWarning(_ ctx: ObjectiveCPreprocessorParser.PreprocessorWarningContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorWarning}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorWarning(_ ctx: ObjectiveCPreprocessorParser.PreprocessorWarningContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorDefine}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorDefine(_ ctx: ObjectiveCPreprocessorParser.PreprocessorDefineContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorDefine}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorDefine(_ ctx: ObjectiveCPreprocessorParser.PreprocessorDefineContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCPreprocessorParser#directive_text}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDirective_text(_ ctx: ObjectiveCPreprocessorParser.Directive_textContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCPreprocessorParser#directive_text}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDirective_text(_ ctx: ObjectiveCPreprocessorParser.Directive_textContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorParenthesis}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorParenthesis(_ ctx: ObjectiveCPreprocessorParser.PreprocessorParenthesisContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorParenthesis}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorParenthesis(_ ctx: ObjectiveCPreprocessorParser.PreprocessorParenthesisContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorNot}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorNot(_ ctx: ObjectiveCPreprocessorParser.PreprocessorNotContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorNot}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorNot(_ ctx: ObjectiveCPreprocessorParser.PreprocessorNotContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorBinary}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorBinary(_ ctx: ObjectiveCPreprocessorParser.PreprocessorBinaryContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorBinary}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorBinary(_ ctx: ObjectiveCPreprocessorParser.PreprocessorBinaryContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorConstant}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorConstant(_ ctx: ObjectiveCPreprocessorParser.PreprocessorConstantContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorConstant}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorConstant(_ ctx: ObjectiveCPreprocessorParser.PreprocessorConstantContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorConditionalSymbol}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorConditionalSymbol(_ ctx: ObjectiveCPreprocessorParser.PreprocessorConditionalSymbolContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorConditionalSymbol}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorConditionalSymbol(_ ctx: ObjectiveCPreprocessorParser.PreprocessorConditionalSymbolContext)
	/**
	 * Enter a parse tree produced by the {@code preprocessorDefined}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreprocessorDefined(_ ctx: ObjectiveCPreprocessorParser.PreprocessorDefinedContext)
	/**
	 * Exit a parse tree produced by the {@code preprocessorDefined}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreprocessorDefined(_ ctx: ObjectiveCPreprocessorParser.PreprocessorDefinedContext)
}