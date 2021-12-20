// Generated from JavaScriptParser.g4 by ANTLR 4.9.3
import Antlr4

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link JavaScriptParser}.
 */
public protocol JavaScriptParserListener: ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#program}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterProgram(_ ctx: JavaScriptParser.ProgramContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#program}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitProgram(_ ctx: JavaScriptParser.ProgramContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#sourceElement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSourceElement(_ ctx: JavaScriptParser.SourceElementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#sourceElement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSourceElement(_ ctx: JavaScriptParser.SourceElementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStatement(_ ctx: JavaScriptParser.StatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStatement(_ ctx: JavaScriptParser.StatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#block}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBlock(_ ctx: JavaScriptParser.BlockContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#block}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBlock(_ ctx: JavaScriptParser.BlockContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#statementList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStatementList(_ ctx: JavaScriptParser.StatementListContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#statementList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStatementList(_ ctx: JavaScriptParser.StatementListContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#importStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterImportStatement(_ ctx: JavaScriptParser.ImportStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#importStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitImportStatement(_ ctx: JavaScriptParser.ImportStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#importFromBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterImportFromBlock(_ ctx: JavaScriptParser.ImportFromBlockContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#importFromBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitImportFromBlock(_ ctx: JavaScriptParser.ImportFromBlockContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#moduleItems}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterModuleItems(_ ctx: JavaScriptParser.ModuleItemsContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#moduleItems}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitModuleItems(_ ctx: JavaScriptParser.ModuleItemsContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#importDefault}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterImportDefault(_ ctx: JavaScriptParser.ImportDefaultContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#importDefault}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitImportDefault(_ ctx: JavaScriptParser.ImportDefaultContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#importNamespace}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterImportNamespace(_ ctx: JavaScriptParser.ImportNamespaceContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#importNamespace}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitImportNamespace(_ ctx: JavaScriptParser.ImportNamespaceContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#importFrom}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterImportFrom(_ ctx: JavaScriptParser.ImportFromContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#importFrom}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitImportFrom(_ ctx: JavaScriptParser.ImportFromContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#aliasName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAliasName(_ ctx: JavaScriptParser.AliasNameContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#aliasName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAliasName(_ ctx: JavaScriptParser.AliasNameContext)
	/**
	 * Enter a parse tree produced by the {@code ExportDeclaration}
	 * labeled alternative in {@link JavaScriptParser#exportStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterExportDeclaration(_ ctx: JavaScriptParser.ExportDeclarationContext)
	/**
	 * Exit a parse tree produced by the {@code ExportDeclaration}
	 * labeled alternative in {@link JavaScriptParser#exportStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitExportDeclaration(_ ctx: JavaScriptParser.ExportDeclarationContext)
	/**
	 * Enter a parse tree produced by the {@code ExportDefaultDeclaration}
	 * labeled alternative in {@link JavaScriptParser#exportStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterExportDefaultDeclaration(_ ctx: JavaScriptParser.ExportDefaultDeclarationContext)
	/**
	 * Exit a parse tree produced by the {@code ExportDefaultDeclaration}
	 * labeled alternative in {@link JavaScriptParser#exportStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitExportDefaultDeclaration(_ ctx: JavaScriptParser.ExportDefaultDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#exportFromBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterExportFromBlock(_ ctx: JavaScriptParser.ExportFromBlockContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#exportFromBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitExportFromBlock(_ ctx: JavaScriptParser.ExportFromBlockContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#declaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclaration(_ ctx: JavaScriptParser.DeclarationContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#declaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclaration(_ ctx: JavaScriptParser.DeclarationContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#variableStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVariableStatement(_ ctx: JavaScriptParser.VariableStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#variableStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVariableStatement(_ ctx: JavaScriptParser.VariableStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#variableDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVariableDeclarationList(_ ctx: JavaScriptParser.VariableDeclarationListContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#variableDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVariableDeclarationList(_ ctx: JavaScriptParser.VariableDeclarationListContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#variableDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVariableDeclaration(_ ctx: JavaScriptParser.VariableDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#variableDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVariableDeclaration(_ ctx: JavaScriptParser.VariableDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#emptyStatement_}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEmptyStatement_(_ ctx: JavaScriptParser.EmptyStatement_Context)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#emptyStatement_}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEmptyStatement_(_ ctx: JavaScriptParser.EmptyStatement_Context)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#expressionStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterExpressionStatement(_ ctx: JavaScriptParser.ExpressionStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#expressionStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitExpressionStatement(_ ctx: JavaScriptParser.ExpressionStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#ifStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIfStatement(_ ctx: JavaScriptParser.IfStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#ifStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIfStatement(_ ctx: JavaScriptParser.IfStatementContext)
	/**
	 * Enter a parse tree produced by the {@code DoStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDoStatement(_ ctx: JavaScriptParser.DoStatementContext)
	/**
	 * Exit a parse tree produced by the {@code DoStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDoStatement(_ ctx: JavaScriptParser.DoStatementContext)
	/**
	 * Enter a parse tree produced by the {@code WhileStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterWhileStatement(_ ctx: JavaScriptParser.WhileStatementContext)
	/**
	 * Exit a parse tree produced by the {@code WhileStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitWhileStatement(_ ctx: JavaScriptParser.WhileStatementContext)
	/**
	 * Enter a parse tree produced by the {@code ForStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterForStatement(_ ctx: JavaScriptParser.ForStatementContext)
	/**
	 * Exit a parse tree produced by the {@code ForStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitForStatement(_ ctx: JavaScriptParser.ForStatementContext)
	/**
	 * Enter a parse tree produced by the {@code ForInStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterForInStatement(_ ctx: JavaScriptParser.ForInStatementContext)
	/**
	 * Exit a parse tree produced by the {@code ForInStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitForInStatement(_ ctx: JavaScriptParser.ForInStatementContext)
	/**
	 * Enter a parse tree produced by the {@code ForOfStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterForOfStatement(_ ctx: JavaScriptParser.ForOfStatementContext)
	/**
	 * Exit a parse tree produced by the {@code ForOfStatement}
	 * labeled alternative in {@link JavaScriptParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitForOfStatement(_ ctx: JavaScriptParser.ForOfStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#varModifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVarModifier(_ ctx: JavaScriptParser.VarModifierContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#varModifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVarModifier(_ ctx: JavaScriptParser.VarModifierContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#continueStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterContinueStatement(_ ctx: JavaScriptParser.ContinueStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#continueStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitContinueStatement(_ ctx: JavaScriptParser.ContinueStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#breakStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBreakStatement(_ ctx: JavaScriptParser.BreakStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#breakStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBreakStatement(_ ctx: JavaScriptParser.BreakStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#returnStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterReturnStatement(_ ctx: JavaScriptParser.ReturnStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#returnStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitReturnStatement(_ ctx: JavaScriptParser.ReturnStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#yieldStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterYieldStatement(_ ctx: JavaScriptParser.YieldStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#yieldStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitYieldStatement(_ ctx: JavaScriptParser.YieldStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#withStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterWithStatement(_ ctx: JavaScriptParser.WithStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#withStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitWithStatement(_ ctx: JavaScriptParser.WithStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#switchStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSwitchStatement(_ ctx: JavaScriptParser.SwitchStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#switchStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSwitchStatement(_ ctx: JavaScriptParser.SwitchStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#caseBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCaseBlock(_ ctx: JavaScriptParser.CaseBlockContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#caseBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCaseBlock(_ ctx: JavaScriptParser.CaseBlockContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#caseClauses}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCaseClauses(_ ctx: JavaScriptParser.CaseClausesContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#caseClauses}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCaseClauses(_ ctx: JavaScriptParser.CaseClausesContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#caseClause}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCaseClause(_ ctx: JavaScriptParser.CaseClauseContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#caseClause}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCaseClause(_ ctx: JavaScriptParser.CaseClauseContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#defaultClause}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDefaultClause(_ ctx: JavaScriptParser.DefaultClauseContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#defaultClause}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDefaultClause(_ ctx: JavaScriptParser.DefaultClauseContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#labelledStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLabelledStatement(_ ctx: JavaScriptParser.LabelledStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#labelledStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLabelledStatement(_ ctx: JavaScriptParser.LabelledStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#throwStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterThrowStatement(_ ctx: JavaScriptParser.ThrowStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#throwStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitThrowStatement(_ ctx: JavaScriptParser.ThrowStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#tryStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTryStatement(_ ctx: JavaScriptParser.TryStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#tryStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTryStatement(_ ctx: JavaScriptParser.TryStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#catchProduction}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCatchProduction(_ ctx: JavaScriptParser.CatchProductionContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#catchProduction}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCatchProduction(_ ctx: JavaScriptParser.CatchProductionContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#finallyProduction}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFinallyProduction(_ ctx: JavaScriptParser.FinallyProductionContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#finallyProduction}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFinallyProduction(_ ctx: JavaScriptParser.FinallyProductionContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#debuggerStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDebuggerStatement(_ ctx: JavaScriptParser.DebuggerStatementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#debuggerStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDebuggerStatement(_ ctx: JavaScriptParser.DebuggerStatementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#functionDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionDeclaration(_ ctx: JavaScriptParser.FunctionDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#functionDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionDeclaration(_ ctx: JavaScriptParser.FunctionDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#classDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassDeclaration(_ ctx: JavaScriptParser.ClassDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#classDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassDeclaration(_ ctx: JavaScriptParser.ClassDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#classTail}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassTail(_ ctx: JavaScriptParser.ClassTailContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#classTail}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassTail(_ ctx: JavaScriptParser.ClassTailContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#classElement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassElement(_ ctx: JavaScriptParser.ClassElementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#classElement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassElement(_ ctx: JavaScriptParser.ClassElementContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#methodDefinition}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMethodDefinition(_ ctx: JavaScriptParser.MethodDefinitionContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#methodDefinition}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMethodDefinition(_ ctx: JavaScriptParser.MethodDefinitionContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#formalParameterList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFormalParameterList(_ ctx: JavaScriptParser.FormalParameterListContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#formalParameterList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFormalParameterList(_ ctx: JavaScriptParser.FormalParameterListContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#formalParameterArg}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFormalParameterArg(_ ctx: JavaScriptParser.FormalParameterArgContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#formalParameterArg}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFormalParameterArg(_ ctx: JavaScriptParser.FormalParameterArgContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#lastFormalParameterArg}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLastFormalParameterArg(_ ctx: JavaScriptParser.LastFormalParameterArgContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#lastFormalParameterArg}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLastFormalParameterArg(_ ctx: JavaScriptParser.LastFormalParameterArgContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#functionBody}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionBody(_ ctx: JavaScriptParser.FunctionBodyContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#functionBody}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionBody(_ ctx: JavaScriptParser.FunctionBodyContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#sourceElements}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSourceElements(_ ctx: JavaScriptParser.SourceElementsContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#sourceElements}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSourceElements(_ ctx: JavaScriptParser.SourceElementsContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#arrayLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArrayLiteral(_ ctx: JavaScriptParser.ArrayLiteralContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#arrayLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArrayLiteral(_ ctx: JavaScriptParser.ArrayLiteralContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#elementList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterElementList(_ ctx: JavaScriptParser.ElementListContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#elementList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitElementList(_ ctx: JavaScriptParser.ElementListContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#arrayElement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArrayElement(_ ctx: JavaScriptParser.ArrayElementContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#arrayElement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArrayElement(_ ctx: JavaScriptParser.ArrayElementContext)
	/**
	 * Enter a parse tree produced by the {@code PropertyExpressionAssignment}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertyExpressionAssignment(_ ctx: JavaScriptParser.PropertyExpressionAssignmentContext)
	/**
	 * Exit a parse tree produced by the {@code PropertyExpressionAssignment}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertyExpressionAssignment(_ ctx: JavaScriptParser.PropertyExpressionAssignmentContext)
	/**
	 * Enter a parse tree produced by the {@code ComputedPropertyExpressionAssignment}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterComputedPropertyExpressionAssignment(_ ctx: JavaScriptParser.ComputedPropertyExpressionAssignmentContext)
	/**
	 * Exit a parse tree produced by the {@code ComputedPropertyExpressionAssignment}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitComputedPropertyExpressionAssignment(_ ctx: JavaScriptParser.ComputedPropertyExpressionAssignmentContext)
	/**
	 * Enter a parse tree produced by the {@code FunctionProperty}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionProperty(_ ctx: JavaScriptParser.FunctionPropertyContext)
	/**
	 * Exit a parse tree produced by the {@code FunctionProperty}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionProperty(_ ctx: JavaScriptParser.FunctionPropertyContext)
	/**
	 * Enter a parse tree produced by the {@code PropertyGetter}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertyGetter(_ ctx: JavaScriptParser.PropertyGetterContext)
	/**
	 * Exit a parse tree produced by the {@code PropertyGetter}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertyGetter(_ ctx: JavaScriptParser.PropertyGetterContext)
	/**
	 * Enter a parse tree produced by the {@code PropertySetter}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertySetter(_ ctx: JavaScriptParser.PropertySetterContext)
	/**
	 * Exit a parse tree produced by the {@code PropertySetter}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertySetter(_ ctx: JavaScriptParser.PropertySetterContext)
	/**
	 * Enter a parse tree produced by the {@code PropertyShorthand}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertyShorthand(_ ctx: JavaScriptParser.PropertyShorthandContext)
	/**
	 * Exit a parse tree produced by the {@code PropertyShorthand}
	 * labeled alternative in {@link JavaScriptParser#propertyAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertyShorthand(_ ctx: JavaScriptParser.PropertyShorthandContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#propertyName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertyName(_ ctx: JavaScriptParser.PropertyNameContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#propertyName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertyName(_ ctx: JavaScriptParser.PropertyNameContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#arguments}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArguments(_ ctx: JavaScriptParser.ArgumentsContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#arguments}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArguments(_ ctx: JavaScriptParser.ArgumentsContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#argument}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArgument(_ ctx: JavaScriptParser.ArgumentContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#argument}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArgument(_ ctx: JavaScriptParser.ArgumentContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#expressionSequence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterExpressionSequence(_ ctx: JavaScriptParser.ExpressionSequenceContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#expressionSequence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitExpressionSequence(_ ctx: JavaScriptParser.ExpressionSequenceContext)
	/**
	 * Enter a parse tree produced by the {@code TemplateStringExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTemplateStringExpression(_ ctx: JavaScriptParser.TemplateStringExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code TemplateStringExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTemplateStringExpression(_ ctx: JavaScriptParser.TemplateStringExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code TernaryExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTernaryExpression(_ ctx: JavaScriptParser.TernaryExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code TernaryExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTernaryExpression(_ ctx: JavaScriptParser.TernaryExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code LogicalAndExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLogicalAndExpression(_ ctx: JavaScriptParser.LogicalAndExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code LogicalAndExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLogicalAndExpression(_ ctx: JavaScriptParser.LogicalAndExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code PowerExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPowerExpression(_ ctx: JavaScriptParser.PowerExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code PowerExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPowerExpression(_ ctx: JavaScriptParser.PowerExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code PreIncrementExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreIncrementExpression(_ ctx: JavaScriptParser.PreIncrementExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code PreIncrementExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreIncrementExpression(_ ctx: JavaScriptParser.PreIncrementExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code ObjectLiteralExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterObjectLiteralExpression(_ ctx: JavaScriptParser.ObjectLiteralExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code ObjectLiteralExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitObjectLiteralExpression(_ ctx: JavaScriptParser.ObjectLiteralExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code MetaExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMetaExpression(_ ctx: JavaScriptParser.MetaExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code MetaExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMetaExpression(_ ctx: JavaScriptParser.MetaExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code InExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInExpression(_ ctx: JavaScriptParser.InExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code InExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInExpression(_ ctx: JavaScriptParser.InExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code LogicalOrExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLogicalOrExpression(_ ctx: JavaScriptParser.LogicalOrExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code LogicalOrExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLogicalOrExpression(_ ctx: JavaScriptParser.LogicalOrExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code NotExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNotExpression(_ ctx: JavaScriptParser.NotExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code NotExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNotExpression(_ ctx: JavaScriptParser.NotExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code PreDecreaseExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPreDecreaseExpression(_ ctx: JavaScriptParser.PreDecreaseExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code PreDecreaseExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPreDecreaseExpression(_ ctx: JavaScriptParser.PreDecreaseExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code ArgumentsExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArgumentsExpression(_ ctx: JavaScriptParser.ArgumentsExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code ArgumentsExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArgumentsExpression(_ ctx: JavaScriptParser.ArgumentsExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code AwaitExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAwaitExpression(_ ctx: JavaScriptParser.AwaitExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code AwaitExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAwaitExpression(_ ctx: JavaScriptParser.AwaitExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code ThisExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterThisExpression(_ ctx: JavaScriptParser.ThisExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code ThisExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitThisExpression(_ ctx: JavaScriptParser.ThisExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code FunctionExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionExpression(_ ctx: JavaScriptParser.FunctionExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code FunctionExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionExpression(_ ctx: JavaScriptParser.FunctionExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code UnaryMinusExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterUnaryMinusExpression(_ ctx: JavaScriptParser.UnaryMinusExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code UnaryMinusExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitUnaryMinusExpression(_ ctx: JavaScriptParser.UnaryMinusExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code AssignmentExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAssignmentExpression(_ ctx: JavaScriptParser.AssignmentExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code AssignmentExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAssignmentExpression(_ ctx: JavaScriptParser.AssignmentExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code PostDecreaseExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPostDecreaseExpression(_ ctx: JavaScriptParser.PostDecreaseExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code PostDecreaseExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPostDecreaseExpression(_ ctx: JavaScriptParser.PostDecreaseExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code TypeofExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeofExpression(_ ctx: JavaScriptParser.TypeofExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code TypeofExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeofExpression(_ ctx: JavaScriptParser.TypeofExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code InstanceofExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInstanceofExpression(_ ctx: JavaScriptParser.InstanceofExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code InstanceofExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInstanceofExpression(_ ctx: JavaScriptParser.InstanceofExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code UnaryPlusExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterUnaryPlusExpression(_ ctx: JavaScriptParser.UnaryPlusExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code UnaryPlusExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitUnaryPlusExpression(_ ctx: JavaScriptParser.UnaryPlusExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code DeleteExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeleteExpression(_ ctx: JavaScriptParser.DeleteExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code DeleteExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeleteExpression(_ ctx: JavaScriptParser.DeleteExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code ImportExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterImportExpression(_ ctx: JavaScriptParser.ImportExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code ImportExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitImportExpression(_ ctx: JavaScriptParser.ImportExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code EqualityExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEqualityExpression(_ ctx: JavaScriptParser.EqualityExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code EqualityExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEqualityExpression(_ ctx: JavaScriptParser.EqualityExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code BitXOrExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBitXOrExpression(_ ctx: JavaScriptParser.BitXOrExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code BitXOrExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBitXOrExpression(_ ctx: JavaScriptParser.BitXOrExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code SuperExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSuperExpression(_ ctx: JavaScriptParser.SuperExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code SuperExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSuperExpression(_ ctx: JavaScriptParser.SuperExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code MultiplicativeExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMultiplicativeExpression(_ ctx: JavaScriptParser.MultiplicativeExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code MultiplicativeExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMultiplicativeExpression(_ ctx: JavaScriptParser.MultiplicativeExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code BitShiftExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBitShiftExpression(_ ctx: JavaScriptParser.BitShiftExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code BitShiftExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBitShiftExpression(_ ctx: JavaScriptParser.BitShiftExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code ParenthesizedExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterParenthesizedExpression(_ ctx: JavaScriptParser.ParenthesizedExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code ParenthesizedExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitParenthesizedExpression(_ ctx: JavaScriptParser.ParenthesizedExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code AdditiveExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAdditiveExpression(_ ctx: JavaScriptParser.AdditiveExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code AdditiveExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAdditiveExpression(_ ctx: JavaScriptParser.AdditiveExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code RelationalExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterRelationalExpression(_ ctx: JavaScriptParser.RelationalExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code RelationalExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitRelationalExpression(_ ctx: JavaScriptParser.RelationalExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code PostIncrementExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPostIncrementExpression(_ ctx: JavaScriptParser.PostIncrementExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code PostIncrementExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPostIncrementExpression(_ ctx: JavaScriptParser.PostIncrementExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code YieldExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterYieldExpression(_ ctx: JavaScriptParser.YieldExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code YieldExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitYieldExpression(_ ctx: JavaScriptParser.YieldExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code BitNotExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBitNotExpression(_ ctx: JavaScriptParser.BitNotExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code BitNotExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBitNotExpression(_ ctx: JavaScriptParser.BitNotExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code NewExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNewExpression(_ ctx: JavaScriptParser.NewExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code NewExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNewExpression(_ ctx: JavaScriptParser.NewExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code LiteralExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLiteralExpression(_ ctx: JavaScriptParser.LiteralExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code LiteralExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLiteralExpression(_ ctx: JavaScriptParser.LiteralExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code ArrayLiteralExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArrayLiteralExpression(_ ctx: JavaScriptParser.ArrayLiteralExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code ArrayLiteralExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArrayLiteralExpression(_ ctx: JavaScriptParser.ArrayLiteralExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code MemberDotExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMemberDotExpression(_ ctx: JavaScriptParser.MemberDotExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code MemberDotExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMemberDotExpression(_ ctx: JavaScriptParser.MemberDotExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code ClassExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassExpression(_ ctx: JavaScriptParser.ClassExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code ClassExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassExpression(_ ctx: JavaScriptParser.ClassExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code MemberIndexExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMemberIndexExpression(_ ctx: JavaScriptParser.MemberIndexExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code MemberIndexExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMemberIndexExpression(_ ctx: JavaScriptParser.MemberIndexExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code IdentifierExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIdentifierExpression(_ ctx: JavaScriptParser.IdentifierExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code IdentifierExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIdentifierExpression(_ ctx: JavaScriptParser.IdentifierExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code BitAndExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBitAndExpression(_ ctx: JavaScriptParser.BitAndExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code BitAndExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBitAndExpression(_ ctx: JavaScriptParser.BitAndExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code BitOrExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBitOrExpression(_ ctx: JavaScriptParser.BitOrExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code BitOrExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBitOrExpression(_ ctx: JavaScriptParser.BitOrExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code AssignmentOperatorExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAssignmentOperatorExpression(_ ctx: JavaScriptParser.AssignmentOperatorExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code AssignmentOperatorExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAssignmentOperatorExpression(_ ctx: JavaScriptParser.AssignmentOperatorExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code VoidExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVoidExpression(_ ctx: JavaScriptParser.VoidExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code VoidExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVoidExpression(_ ctx: JavaScriptParser.VoidExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code CoalesceExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCoalesceExpression(_ ctx: JavaScriptParser.CoalesceExpressionContext)
	/**
	 * Exit a parse tree produced by the {@code CoalesceExpression}
	 * labeled alternative in {@link JavaScriptParser#singleExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCoalesceExpression(_ ctx: JavaScriptParser.CoalesceExpressionContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#assignable}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAssignable(_ ctx: JavaScriptParser.AssignableContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#assignable}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAssignable(_ ctx: JavaScriptParser.AssignableContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#objectLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterObjectLiteral(_ ctx: JavaScriptParser.ObjectLiteralContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#objectLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitObjectLiteral(_ ctx: JavaScriptParser.ObjectLiteralContext)
	/**
	 * Enter a parse tree produced by the {@code FunctionDecl}
	 * labeled alternative in {@link JavaScriptParser#anonymousFunction}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionDecl(_ ctx: JavaScriptParser.FunctionDeclContext)
	/**
	 * Exit a parse tree produced by the {@code FunctionDecl}
	 * labeled alternative in {@link JavaScriptParser#anonymousFunction}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionDecl(_ ctx: JavaScriptParser.FunctionDeclContext)
	/**
	 * Enter a parse tree produced by the {@code AnonymousFunctionDecl}
	 * labeled alternative in {@link JavaScriptParser#anonymousFunction}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAnonymousFunctionDecl(_ ctx: JavaScriptParser.AnonymousFunctionDeclContext)
	/**
	 * Exit a parse tree produced by the {@code AnonymousFunctionDecl}
	 * labeled alternative in {@link JavaScriptParser#anonymousFunction}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAnonymousFunctionDecl(_ ctx: JavaScriptParser.AnonymousFunctionDeclContext)
	/**
	 * Enter a parse tree produced by the {@code ArrowFunction}
	 * labeled alternative in {@link JavaScriptParser#anonymousFunction}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArrowFunction(_ ctx: JavaScriptParser.ArrowFunctionContext)
	/**
	 * Exit a parse tree produced by the {@code ArrowFunction}
	 * labeled alternative in {@link JavaScriptParser#anonymousFunction}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArrowFunction(_ ctx: JavaScriptParser.ArrowFunctionContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#arrowFunctionParameters}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArrowFunctionParameters(_ ctx: JavaScriptParser.ArrowFunctionParametersContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#arrowFunctionParameters}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArrowFunctionParameters(_ ctx: JavaScriptParser.ArrowFunctionParametersContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#arrowFunctionBody}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArrowFunctionBody(_ ctx: JavaScriptParser.ArrowFunctionBodyContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#arrowFunctionBody}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArrowFunctionBody(_ ctx: JavaScriptParser.ArrowFunctionBodyContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#assignmentOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAssignmentOperator(_ ctx: JavaScriptParser.AssignmentOperatorContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#assignmentOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAssignmentOperator(_ ctx: JavaScriptParser.AssignmentOperatorContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#literal}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLiteral(_ ctx: JavaScriptParser.LiteralContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#literal}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLiteral(_ ctx: JavaScriptParser.LiteralContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#templateStringLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTemplateStringLiteral(_ ctx: JavaScriptParser.TemplateStringLiteralContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#templateStringLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTemplateStringLiteral(_ ctx: JavaScriptParser.TemplateStringLiteralContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#templateStringAtom}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTemplateStringAtom(_ ctx: JavaScriptParser.TemplateStringAtomContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#templateStringAtom}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTemplateStringAtom(_ ctx: JavaScriptParser.TemplateStringAtomContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#numericLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNumericLiteral(_ ctx: JavaScriptParser.NumericLiteralContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#numericLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNumericLiteral(_ ctx: JavaScriptParser.NumericLiteralContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#bigintLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBigintLiteral(_ ctx: JavaScriptParser.BigintLiteralContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#bigintLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBigintLiteral(_ ctx: JavaScriptParser.BigintLiteralContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#getter}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGetter(_ ctx: JavaScriptParser.GetterContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#getter}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGetter(_ ctx: JavaScriptParser.GetterContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#setter}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSetter(_ ctx: JavaScriptParser.SetterContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#setter}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSetter(_ ctx: JavaScriptParser.SetterContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#identifierName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIdentifierName(_ ctx: JavaScriptParser.IdentifierNameContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#identifierName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIdentifierName(_ ctx: JavaScriptParser.IdentifierNameContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#identifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIdentifier(_ ctx: JavaScriptParser.IdentifierContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#identifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIdentifier(_ ctx: JavaScriptParser.IdentifierContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#reservedWord}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterReservedWord(_ ctx: JavaScriptParser.ReservedWordContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#reservedWord}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitReservedWord(_ ctx: JavaScriptParser.ReservedWordContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#keyword}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterKeyword(_ ctx: JavaScriptParser.KeywordContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#keyword}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitKeyword(_ ctx: JavaScriptParser.KeywordContext)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#let_}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLet_(_ ctx: JavaScriptParser.Let_Context)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#let_}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLet_(_ ctx: JavaScriptParser.Let_Context)
	/**
	 * Enter a parse tree produced by {@link JavaScriptParser#eos}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEos(_ ctx: JavaScriptParser.EosContext)
	/**
	 * Exit a parse tree produced by {@link JavaScriptParser#eos}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEos(_ ctx: JavaScriptParser.EosContext)
}