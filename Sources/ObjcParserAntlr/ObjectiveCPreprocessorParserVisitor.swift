// Generated from /Users/luizfernandosilva/Documents/git/grammars-v4-master/objc/two-step-processing/ObjectiveCPreprocessorParser.g4 by ANTLR 4.7
import Antlr4

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link ObjectiveCPreprocessorParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
open class ObjectiveCPreprocessorParserVisitor<T>: ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link ObjectiveCPreprocessorParser#objectiveCDocument}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitObjectiveCDocument(_ ctx: ObjectiveCPreprocessorParser.ObjectiveCDocumentContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link ObjectiveCPreprocessorParser#text}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitText(_ ctx: ObjectiveCPreprocessorParser.TextContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link ObjectiveCPreprocessorParser#code}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitCode(_ ctx: ObjectiveCPreprocessorParser.CodeContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorImport}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorImport(_ ctx: ObjectiveCPreprocessorParser.PreprocessorImportContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorConditional}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorConditional(_ ctx: ObjectiveCPreprocessorParser.PreprocessorConditionalContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorDef}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorDef(_ ctx: ObjectiveCPreprocessorParser.PreprocessorDefContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorPragma}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorPragma(_ ctx: ObjectiveCPreprocessorParser.PreprocessorPragmaContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorError}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorError(_ ctx: ObjectiveCPreprocessorParser.PreprocessorErrorContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorWarning}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorWarning(_ ctx: ObjectiveCPreprocessorParser.PreprocessorWarningContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorDefine}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#directive}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorDefine(_ ctx: ObjectiveCPreprocessorParser.PreprocessorDefineContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link ObjectiveCPreprocessorParser#directive_text}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitDirective_text(_ ctx: ObjectiveCPreprocessorParser.Directive_textContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorParenthesis}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorParenthesis(_ ctx: ObjectiveCPreprocessorParser.PreprocessorParenthesisContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorNot}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorNot(_ ctx: ObjectiveCPreprocessorParser.PreprocessorNotContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorBinary}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorBinary(_ ctx: ObjectiveCPreprocessorParser.PreprocessorBinaryContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorConstant}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorConstant(_ ctx: ObjectiveCPreprocessorParser.PreprocessorConstantContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorConditionalSymbol}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorConditionalSymbol(_ ctx: ObjectiveCPreprocessorParser.PreprocessorConditionalSymbolContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code preprocessorDefined}
	 * labeled alternative in {@link ObjectiveCPreprocessorParser#preprocessor_expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreprocessorDefined(_ ctx: ObjectiveCPreprocessorParser.PreprocessorDefinedContext) -> T{
	 	fatalError(#function + " must be overridden")
	}

}