// Generated from JavaScriptParser.g4 by ANTLR 4.9.3
import Antlr4

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link JavaScriptParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
open class JavaScriptParserVisitor<T>: ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#program}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitProgram(_ ctx: JavaScriptParser.ProgramContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#sourceElement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitSourceElement(_ ctx: JavaScriptParser.SourceElementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#statement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitStatement(_ ctx: JavaScriptParser.StatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#block}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitBlock(_ ctx: JavaScriptParser.BlockContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#statementList}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitStatementList(_ ctx: JavaScriptParser.StatementListContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#importStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitImportStatement(_ ctx: JavaScriptParser.ImportStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#importFromBlock}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitImportFromBlock(_ ctx: JavaScriptParser.ImportFromBlockContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#moduleItems}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitModuleItems(_ ctx: JavaScriptParser.ModuleItemsContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#importDefault}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitImportDefault(_ ctx: JavaScriptParser.ImportDefaultContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#importNamespace}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitImportNamespace(_ ctx: JavaScriptParser.ImportNamespaceContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#importFrom}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitImportFrom(_ ctx: JavaScriptParser.ImportFromContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#aliasName}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitAliasName(_ ctx: JavaScriptParser.AliasNameContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ExportDeclaration}
	 * labeled alternative in {@link JavaScriptParser#exportStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitExportDeclaration(_ ctx: JavaScriptParser.ExportDeclarationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ExportDefaultDeclaration}
	 * labeled alternative in {@link JavaScriptParser#exportStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitExportDefaultDeclaration(_ ctx: JavaScriptParser.ExportDefaultDeclarationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#exportFromBlock}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitExportFromBlock(_ ctx: JavaScriptParser.ExportFromBlockContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#declaration}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitDeclaration(_ ctx: JavaScriptParser.DeclarationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#variableStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitVariableStatement(_ ctx: JavaScriptParser.VariableStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#variableDeclarationList}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitVariableDeclarationList(_ ctx: JavaScriptParser.VariableDeclarationListContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#variableDeclaration}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitVariableDeclaration(_ ctx: JavaScriptParser.VariableDeclarationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#emptyStatement_}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitEmptyStatement_(_ ctx: JavaScriptParser.EmptyStatement_Context) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#expressionStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitExpressionStatement(_ ctx: JavaScriptParser.ExpressionStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#ifStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitIfStatement(_ ctx: JavaScriptParser.IfStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code DoStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitDoStatement(_ ctx: JavaScriptParser.DoStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code WhileStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitWhileStatement(_ ctx: JavaScriptParser.WhileStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ForStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitForStatement(_ ctx: JavaScriptParser.ForStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ForInStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitForInStatement(_ ctx: JavaScriptParser.ForInStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ForOfStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitForOfStatement(_ ctx: JavaScriptParser.ForOfStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#varModifier}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitVarModifier(_ ctx: JavaScriptParser.VarModifierContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#continueStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitContinueStatement(_ ctx: JavaScriptParser.ContinueStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#breakStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitBreakStatement(_ ctx: JavaScriptParser.BreakStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#returnStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitReturnStatement(_ ctx: JavaScriptParser.ReturnStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#yieldStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitYieldStatement(_ ctx: JavaScriptParser.YieldStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#withStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitWithStatement(_ ctx: JavaScriptParser.WithStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#switchStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitSwitchStatement(_ ctx: JavaScriptParser.SwitchStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#caseBlock}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitCaseBlock(_ ctx: JavaScriptParser.CaseBlockContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#caseClauses}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitCaseClauses(_ ctx: JavaScriptParser.CaseClausesContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#caseClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitCaseClause(_ ctx: JavaScriptParser.CaseClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#defaultClause}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitDefaultClause(_ ctx: JavaScriptParser.DefaultClauseContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#labelledStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitLabelledStatement(_ ctx: JavaScriptParser.LabelledStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#throwStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitThrowStatement(_ ctx: JavaScriptParser.ThrowStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#tryStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTryStatement(_ ctx: JavaScriptParser.TryStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#catchProduction}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitCatchProduction(_ ctx: JavaScriptParser.CatchProductionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#finallyProduction}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitFinallyProduction(_ ctx: JavaScriptParser.FinallyProductionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#debuggerStatement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitDebuggerStatement(_ ctx: JavaScriptParser.DebuggerStatementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#functionDeclaration}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitFunctionDeclaration(_ ctx: JavaScriptParser.FunctionDeclarationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#classDeclaration}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitClassDeclaration(_ ctx: JavaScriptParser.ClassDeclarationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#classTail}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitClassTail(_ ctx: JavaScriptParser.ClassTailContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#classElement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitClassElement(_ ctx: JavaScriptParser.ClassElementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#methodDefinition}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitMethodDefinition(_ ctx: JavaScriptParser.MethodDefinitionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#formalParameterList}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitFormalParameterList(_ ctx: JavaScriptParser.FormalParameterListContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#formalParameterArg}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitFormalParameterArg(_ ctx: JavaScriptParser.FormalParameterArgContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#lastFormalParameterArg}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitLastFormalParameterArg(_ ctx: JavaScriptParser.LastFormalParameterArgContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#functionBody}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitFunctionBody(_ ctx: JavaScriptParser.FunctionBodyContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#sourceElements}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitSourceElements(_ ctx: JavaScriptParser.SourceElementsContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#arrayLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitArrayLiteral(_ ctx: JavaScriptParser.ArrayLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#elementList}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitElementList(_ ctx: JavaScriptParser.ElementListContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#arrayElement}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitArrayElement(_ ctx: JavaScriptParser.ArrayElementContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code PropertyExpressionAssignment}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPropertyExpressionAssignment(_ ctx: JavaScriptParser.PropertyExpressionAssignmentContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ComputedPropertyExpressionAssignment}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitComputedPropertyExpressionAssignment(_ ctx: JavaScriptParser.ComputedPropertyExpressionAssignmentContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code FunctionProperty}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitFunctionProperty(_ ctx: JavaScriptParser.FunctionPropertyContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code PropertyGetter}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPropertyGetter(_ ctx: JavaScriptParser.PropertyGetterContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code PropertySetter}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPropertySetter(_ ctx: JavaScriptParser.PropertySetterContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code PropertyShorthand}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPropertyShorthand(_ ctx: JavaScriptParser.PropertyShorthandContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#propertyName}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPropertyName(_ ctx: JavaScriptParser.PropertyNameContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#arguments}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitArguments(_ ctx: JavaScriptParser.ArgumentsContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#argument}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitArgument(_ ctx: JavaScriptParser.ArgumentContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#expressionSequence}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitExpressionSequence(_ ctx: JavaScriptParser.ExpressionSequenceContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code TemplateStringExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTemplateStringExpression(_ ctx: JavaScriptParser.TemplateStringExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code TernaryExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTernaryExpression(_ ctx: JavaScriptParser.TernaryExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code LogicalAndExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitLogicalAndExpression(_ ctx: JavaScriptParser.LogicalAndExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code PowerExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPowerExpression(_ ctx: JavaScriptParser.PowerExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code PreIncrementExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreIncrementExpression(_ ctx: JavaScriptParser.PreIncrementExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ObjectLiteralExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitObjectLiteralExpression(_ ctx: JavaScriptParser.ObjectLiteralExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code MetaExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitMetaExpression(_ ctx: JavaScriptParser.MetaExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code InExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitInExpression(_ ctx: JavaScriptParser.InExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code LogicalOrExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitLogicalOrExpression(_ ctx: JavaScriptParser.LogicalOrExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code NotExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitNotExpression(_ ctx: JavaScriptParser.NotExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code PreDecreaseExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPreDecreaseExpression(_ ctx: JavaScriptParser.PreDecreaseExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ArgumentsExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitArgumentsExpression(_ ctx: JavaScriptParser.ArgumentsExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code AwaitExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitAwaitExpression(_ ctx: JavaScriptParser.AwaitExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ThisExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitThisExpression(_ ctx: JavaScriptParser.ThisExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code FunctionExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitFunctionExpression(_ ctx: JavaScriptParser.FunctionExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code UnaryMinusExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitUnaryMinusExpression(_ ctx: JavaScriptParser.UnaryMinusExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code AssignmentExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitAssignmentExpression(_ ctx: JavaScriptParser.AssignmentExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code PostDecreaseExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPostDecreaseExpression(_ ctx: JavaScriptParser.PostDecreaseExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code TypeofExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTypeofExpression(_ ctx: JavaScriptParser.TypeofExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code InstanceofExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitInstanceofExpression(_ ctx: JavaScriptParser.InstanceofExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code UnaryPlusExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitUnaryPlusExpression(_ ctx: JavaScriptParser.UnaryPlusExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code DeleteExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitDeleteExpression(_ ctx: JavaScriptParser.DeleteExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ImportExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitImportExpression(_ ctx: JavaScriptParser.ImportExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code EqualityExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitEqualityExpression(_ ctx: JavaScriptParser.EqualityExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code BitXOrExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitBitXOrExpression(_ ctx: JavaScriptParser.BitXOrExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code SuperExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitSuperExpression(_ ctx: JavaScriptParser.SuperExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code MultiplicativeExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitMultiplicativeExpression(_ ctx: JavaScriptParser.MultiplicativeExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code BitShiftExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitBitShiftExpression(_ ctx: JavaScriptParser.BitShiftExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ParenthesizedExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitParenthesizedExpression(_ ctx: JavaScriptParser.ParenthesizedExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code AdditiveExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitAdditiveExpression(_ ctx: JavaScriptParser.AdditiveExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code RelationalExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitRelationalExpression(_ ctx: JavaScriptParser.RelationalExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code PostIncrementExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPostIncrementExpression(_ ctx: JavaScriptParser.PostIncrementExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code YieldExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitYieldExpression(_ ctx: JavaScriptParser.YieldExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code BitNotExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitBitNotExpression(_ ctx: JavaScriptParser.BitNotExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code NewExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitNewExpression(_ ctx: JavaScriptParser.NewExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code LiteralExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitLiteralExpression(_ ctx: JavaScriptParser.LiteralExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ArrayLiteralExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitArrayLiteralExpression(_ ctx: JavaScriptParser.ArrayLiteralExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code MemberDotExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitMemberDotExpression(_ ctx: JavaScriptParser.MemberDotExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ClassExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitClassExpression(_ ctx: JavaScriptParser.ClassExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code MemberIndexExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitMemberIndexExpression(_ ctx: JavaScriptParser.MemberIndexExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code IdentifierExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitIdentifierExpression(_ ctx: JavaScriptParser.IdentifierExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code BitAndExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitBitAndExpression(_ ctx: JavaScriptParser.BitAndExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code BitOrExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitBitOrExpression(_ ctx: JavaScriptParser.BitOrExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code AssignmentOperatorExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitAssignmentOperatorExpression(_ ctx: JavaScriptParser.AssignmentOperatorExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code VoidExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitVoidExpression(_ ctx: JavaScriptParser.VoidExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code CoalesceExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitCoalesceExpression(_ ctx: JavaScriptParser.CoalesceExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#assignable}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitAssignable(_ ctx: JavaScriptParser.AssignableContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#objectLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitObjectLiteral(_ ctx: JavaScriptParser.ObjectLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code FunctionDecl}
	 * labeled alternative in {@link JavaScriptParser#anonymousFunction}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitFunctionDecl(_ ctx: JavaScriptParser.FunctionDeclContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code AnonymousFunctionDecl}
	 * labeled alternative in {@link JavaScriptParser#anonymousFunction}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitAnonymousFunctionDecl(_ ctx: JavaScriptParser.AnonymousFunctionDeclContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code ArrowFunction}
	 * labeled alternative in {@link JavaScriptParser#anonymousFunction}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitArrowFunction(_ ctx: JavaScriptParser.ArrowFunctionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#arrowFunctionParameters}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitArrowFunctionParameters(_ ctx: JavaScriptParser.ArrowFunctionParametersContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#arrowFunctionBody}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitArrowFunctionBody(_ ctx: JavaScriptParser.ArrowFunctionBodyContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#assignmentOperator}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitAssignmentOperator(_ ctx: JavaScriptParser.AssignmentOperatorContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#literal}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitLiteral(_ ctx: JavaScriptParser.LiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#templateStringLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTemplateStringLiteral(_ ctx: JavaScriptParser.TemplateStringLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#templateStringAtom}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTemplateStringAtom(_ ctx: JavaScriptParser.TemplateStringAtomContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#numericLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitNumericLiteral(_ ctx: JavaScriptParser.NumericLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#bigintLiteral}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitBigintLiteral(_ ctx: JavaScriptParser.BigintLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#getter}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitGetter(_ ctx: JavaScriptParser.GetterContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#setter}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitSetter(_ ctx: JavaScriptParser.SetterContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#identifierName}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitIdentifierName(_ ctx: JavaScriptParser.IdentifierNameContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#identifier}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitIdentifier(_ ctx: JavaScriptParser.IdentifierContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#reservedWord}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitReservedWord(_ ctx: JavaScriptParser.ReservedWordContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#keyword}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitKeyword(_ ctx: JavaScriptParser.KeywordContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#let_}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitLet_(_ ctx: JavaScriptParser.Let_Context) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link JavaScriptParser#eos}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitEos(_ ctx: JavaScriptParser.EosContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

}