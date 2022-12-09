// Generated from java-escape by ANTLR 4.11.1
import Antlr4

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link ObjectiveCParser}.
 */
public protocol ObjectiveCParserListener: ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#translationUnit}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTranslationUnit(_ ctx: ObjectiveCParser.TranslationUnitContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#translationUnit}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTranslationUnit(_ ctx: ObjectiveCParser.TranslationUnitContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#topLevelDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTopLevelDeclaration(_ ctx: ObjectiveCParser.TopLevelDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#topLevelDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTopLevelDeclaration(_ ctx: ObjectiveCParser.TopLevelDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#importDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterImportDeclaration(_ ctx: ObjectiveCParser.ImportDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#importDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitImportDeclaration(_ ctx: ObjectiveCParser.ImportDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#classInterface}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassInterface(_ ctx: ObjectiveCParser.ClassInterfaceContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#classInterface}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassInterface(_ ctx: ObjectiveCParser.ClassInterfaceContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#classInterfaceName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassInterfaceName(_ ctx: ObjectiveCParser.ClassInterfaceNameContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#classInterfaceName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassInterfaceName(_ ctx: ObjectiveCParser.ClassInterfaceNameContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#categoryInterface}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCategoryInterface(_ ctx: ObjectiveCParser.CategoryInterfaceContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#categoryInterface}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCategoryInterface(_ ctx: ObjectiveCParser.CategoryInterfaceContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#classImplementation}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassImplementation(_ ctx: ObjectiveCParser.ClassImplementationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#classImplementation}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassImplementation(_ ctx: ObjectiveCParser.ClassImplementationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#classImplementationName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassImplementationName(_ ctx: ObjectiveCParser.ClassImplementationNameContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#classImplementationName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassImplementationName(_ ctx: ObjectiveCParser.ClassImplementationNameContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#categoryImplementation}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCategoryImplementation(_ ctx: ObjectiveCParser.CategoryImplementationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#categoryImplementation}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCategoryImplementation(_ ctx: ObjectiveCParser.CategoryImplementationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#className}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassName(_ ctx: ObjectiveCParser.ClassNameContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#className}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassName(_ ctx: ObjectiveCParser.ClassNameContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#superclassName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSuperclassName(_ ctx: ObjectiveCParser.SuperclassNameContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#superclassName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSuperclassName(_ ctx: ObjectiveCParser.SuperclassNameContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#genericClassParametersSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGenericClassParametersSpecifier(_ ctx: ObjectiveCParser.GenericClassParametersSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#genericClassParametersSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGenericClassParametersSpecifier(_ ctx: ObjectiveCParser.GenericClassParametersSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#superclassTypeSpecifierWithPrefixes}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSuperclassTypeSpecifierWithPrefixes(_ ctx: ObjectiveCParser.SuperclassTypeSpecifierWithPrefixesContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#superclassTypeSpecifierWithPrefixes}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSuperclassTypeSpecifierWithPrefixes(_ ctx: ObjectiveCParser.SuperclassTypeSpecifierWithPrefixesContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#protocolDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterProtocolDeclaration(_ ctx: ObjectiveCParser.ProtocolDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#protocolDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitProtocolDeclaration(_ ctx: ObjectiveCParser.ProtocolDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#protocolDeclarationSection}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterProtocolDeclarationSection(_ ctx: ObjectiveCParser.ProtocolDeclarationSectionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#protocolDeclarationSection}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitProtocolDeclarationSection(_ ctx: ObjectiveCParser.ProtocolDeclarationSectionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#protocolDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterProtocolDeclarationList(_ ctx: ObjectiveCParser.ProtocolDeclarationListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#protocolDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitProtocolDeclarationList(_ ctx: ObjectiveCParser.ProtocolDeclarationListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#classDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassDeclarationList(_ ctx: ObjectiveCParser.ClassDeclarationListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#classDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassDeclarationList(_ ctx: ObjectiveCParser.ClassDeclarationListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#classDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassDeclaration(_ ctx: ObjectiveCParser.ClassDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#classDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassDeclaration(_ ctx: ObjectiveCParser.ClassDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#protocolList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterProtocolList(_ ctx: ObjectiveCParser.ProtocolListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#protocolList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitProtocolList(_ ctx: ObjectiveCParser.ProtocolListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#propertyDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#propertyDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#propertyAttributesList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertyAttributesList(_ ctx: ObjectiveCParser.PropertyAttributesListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#propertyAttributesList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertyAttributesList(_ ctx: ObjectiveCParser.PropertyAttributesListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#propertyAttribute}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertyAttribute(_ ctx: ObjectiveCParser.PropertyAttributeContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#propertyAttribute}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertyAttribute(_ ctx: ObjectiveCParser.PropertyAttributeContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#protocolName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterProtocolName(_ ctx: ObjectiveCParser.ProtocolNameContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#protocolName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitProtocolName(_ ctx: ObjectiveCParser.ProtocolNameContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#instanceVariables}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInstanceVariables(_ ctx: ObjectiveCParser.InstanceVariablesContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#instanceVariables}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInstanceVariables(_ ctx: ObjectiveCParser.InstanceVariablesContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#visibilitySection}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVisibilitySection(_ ctx: ObjectiveCParser.VisibilitySectionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#visibilitySection}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVisibilitySection(_ ctx: ObjectiveCParser.VisibilitySectionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#accessModifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAccessModifier(_ ctx: ObjectiveCParser.AccessModifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#accessModifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAccessModifier(_ ctx: ObjectiveCParser.AccessModifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#interfaceDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInterfaceDeclarationList(_ ctx: ObjectiveCParser.InterfaceDeclarationListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#interfaceDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInterfaceDeclarationList(_ ctx: ObjectiveCParser.InterfaceDeclarationListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#classMethodDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassMethodDeclaration(_ ctx: ObjectiveCParser.ClassMethodDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#classMethodDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassMethodDeclaration(_ ctx: ObjectiveCParser.ClassMethodDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#instanceMethodDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInstanceMethodDeclaration(_ ctx: ObjectiveCParser.InstanceMethodDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#instanceMethodDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInstanceMethodDeclaration(_ ctx: ObjectiveCParser.InstanceMethodDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#methodDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMethodDeclaration(_ ctx: ObjectiveCParser.MethodDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#methodDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMethodDeclaration(_ ctx: ObjectiveCParser.MethodDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#implementationDefinitionList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterImplementationDefinitionList(_ ctx: ObjectiveCParser.ImplementationDefinitionListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#implementationDefinitionList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitImplementationDefinitionList(_ ctx: ObjectiveCParser.ImplementationDefinitionListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#classMethodDefinition}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassMethodDefinition(_ ctx: ObjectiveCParser.ClassMethodDefinitionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#classMethodDefinition}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassMethodDefinition(_ ctx: ObjectiveCParser.ClassMethodDefinitionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#instanceMethodDefinition}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInstanceMethodDefinition(_ ctx: ObjectiveCParser.InstanceMethodDefinitionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#instanceMethodDefinition}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInstanceMethodDefinition(_ ctx: ObjectiveCParser.InstanceMethodDefinitionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#methodDefinition}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMethodDefinition(_ ctx: ObjectiveCParser.MethodDefinitionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#methodDefinition}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMethodDefinition(_ ctx: ObjectiveCParser.MethodDefinitionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#methodSelector}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMethodSelector(_ ctx: ObjectiveCParser.MethodSelectorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#methodSelector}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMethodSelector(_ ctx: ObjectiveCParser.MethodSelectorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#keywordDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterKeywordDeclarator(_ ctx: ObjectiveCParser.KeywordDeclaratorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#keywordDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitKeywordDeclarator(_ ctx: ObjectiveCParser.KeywordDeclaratorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#selector}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSelector(_ ctx: ObjectiveCParser.SelectorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#selector}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSelector(_ ctx: ObjectiveCParser.SelectorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#methodType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMethodType(_ ctx: ObjectiveCParser.MethodTypeContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#methodType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMethodType(_ ctx: ObjectiveCParser.MethodTypeContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#propertyImplementation}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertyImplementation(_ ctx: ObjectiveCParser.PropertyImplementationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#propertyImplementation}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertyImplementation(_ ctx: ObjectiveCParser.PropertyImplementationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#propertySynthesizeList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertySynthesizeList(_ ctx: ObjectiveCParser.PropertySynthesizeListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#propertySynthesizeList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertySynthesizeList(_ ctx: ObjectiveCParser.PropertySynthesizeListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#propertySynthesizeItem}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPropertySynthesizeItem(_ ctx: ObjectiveCParser.PropertySynthesizeItemContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#propertySynthesizeItem}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPropertySynthesizeItem(_ ctx: ObjectiveCParser.PropertySynthesizeItemContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#dictionaryExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDictionaryExpression(_ ctx: ObjectiveCParser.DictionaryExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#dictionaryExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDictionaryExpression(_ ctx: ObjectiveCParser.DictionaryExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#dictionaryPair}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDictionaryPair(_ ctx: ObjectiveCParser.DictionaryPairContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#dictionaryPair}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDictionaryPair(_ ctx: ObjectiveCParser.DictionaryPairContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#arrayExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArrayExpression(_ ctx: ObjectiveCParser.ArrayExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#arrayExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArrayExpression(_ ctx: ObjectiveCParser.ArrayExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#boxExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBoxExpression(_ ctx: ObjectiveCParser.BoxExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#boxExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBoxExpression(_ ctx: ObjectiveCParser.BoxExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#blockParameters}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBlockParameters(_ ctx: ObjectiveCParser.BlockParametersContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#blockParameters}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBlockParameters(_ ctx: ObjectiveCParser.BlockParametersContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#blockExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBlockExpression(_ ctx: ObjectiveCParser.BlockExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#blockExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBlockExpression(_ ctx: ObjectiveCParser.BlockExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#receiver}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterReceiver(_ ctx: ObjectiveCParser.ReceiverContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#receiver}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitReceiver(_ ctx: ObjectiveCParser.ReceiverContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#messageSelector}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMessageSelector(_ ctx: ObjectiveCParser.MessageSelectorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#messageSelector}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMessageSelector(_ ctx: ObjectiveCParser.MessageSelectorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#keywordArgument}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterKeywordArgument(_ ctx: ObjectiveCParser.KeywordArgumentContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#keywordArgument}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitKeywordArgument(_ ctx: ObjectiveCParser.KeywordArgumentContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#keywordArgumentType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterKeywordArgumentType(_ ctx: ObjectiveCParser.KeywordArgumentTypeContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#keywordArgumentType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitKeywordArgumentType(_ ctx: ObjectiveCParser.KeywordArgumentTypeContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#selectorExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSelectorExpression(_ ctx: ObjectiveCParser.SelectorExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#selectorExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSelectorExpression(_ ctx: ObjectiveCParser.SelectorExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#selectorName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSelectorName(_ ctx: ObjectiveCParser.SelectorNameContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#selectorName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSelectorName(_ ctx: ObjectiveCParser.SelectorNameContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#protocolExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterProtocolExpression(_ ctx: ObjectiveCParser.ProtocolExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#protocolExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitProtocolExpression(_ ctx: ObjectiveCParser.ProtocolExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#encodeExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEncodeExpression(_ ctx: ObjectiveCParser.EncodeExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#encodeExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEncodeExpression(_ ctx: ObjectiveCParser.EncodeExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#typeVariableDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeVariableDeclarator(_ ctx: ObjectiveCParser.TypeVariableDeclaratorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#typeVariableDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeVariableDeclarator(_ ctx: ObjectiveCParser.TypeVariableDeclaratorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#throwStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterThrowStatement(_ ctx: ObjectiveCParser.ThrowStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#throwStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitThrowStatement(_ ctx: ObjectiveCParser.ThrowStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#tryBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTryBlock(_ ctx: ObjectiveCParser.TryBlockContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#tryBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTryBlock(_ ctx: ObjectiveCParser.TryBlockContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#catchStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCatchStatement(_ ctx: ObjectiveCParser.CatchStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#catchStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCatchStatement(_ ctx: ObjectiveCParser.CatchStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#synchronizedStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSynchronizedStatement(_ ctx: ObjectiveCParser.SynchronizedStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#synchronizedStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSynchronizedStatement(_ ctx: ObjectiveCParser.SynchronizedStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#autoreleaseStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAutoreleaseStatement(_ ctx: ObjectiveCParser.AutoreleaseStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#autoreleaseStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAutoreleaseStatement(_ ctx: ObjectiveCParser.AutoreleaseStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#functionDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionDeclaration(_ ctx: ObjectiveCParser.FunctionDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#functionDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionDeclaration(_ ctx: ObjectiveCParser.FunctionDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#functionDefinition}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionDefinition(_ ctx: ObjectiveCParser.FunctionDefinitionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#functionDefinition}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionDefinition(_ ctx: ObjectiveCParser.FunctionDefinitionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#functionSignature}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionSignature(_ ctx: ObjectiveCParser.FunctionSignatureContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#functionSignature}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionSignature(_ ctx: ObjectiveCParser.FunctionSignatureContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#declarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclarationList(_ ctx: ObjectiveCParser.DeclarationListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#declarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclarationList(_ ctx: ObjectiveCParser.DeclarationListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#attribute}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAttribute(_ ctx: ObjectiveCParser.AttributeContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#attribute}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAttribute(_ ctx: ObjectiveCParser.AttributeContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#attributeName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAttributeName(_ ctx: ObjectiveCParser.AttributeNameContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#attributeName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAttributeName(_ ctx: ObjectiveCParser.AttributeNameContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#attributeParameters}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAttributeParameters(_ ctx: ObjectiveCParser.AttributeParametersContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#attributeParameters}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAttributeParameters(_ ctx: ObjectiveCParser.AttributeParametersContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#attributeParameterList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAttributeParameterList(_ ctx: ObjectiveCParser.AttributeParameterListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#attributeParameterList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAttributeParameterList(_ ctx: ObjectiveCParser.AttributeParameterListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#attributeParameter}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAttributeParameter(_ ctx: ObjectiveCParser.AttributeParameterContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#attributeParameter}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAttributeParameter(_ ctx: ObjectiveCParser.AttributeParameterContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#attributeParameterAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAttributeParameterAssignment(_ ctx: ObjectiveCParser.AttributeParameterAssignmentContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#attributeParameterAssignment}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAttributeParameterAssignment(_ ctx: ObjectiveCParser.AttributeParameterAssignmentContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#functionPointer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionPointer(_ ctx: ObjectiveCParser.FunctionPointerContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#functionPointer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionPointer(_ ctx: ObjectiveCParser.FunctionPointerContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#functionPointerParameterList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionPointerParameterList(_ ctx: ObjectiveCParser.FunctionPointerParameterListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#functionPointerParameterList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionPointerParameterList(_ ctx: ObjectiveCParser.FunctionPointerParameterListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#functionPointerParameterDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionPointerParameterDeclarationList(_ ctx: ObjectiveCParser.FunctionPointerParameterDeclarationListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#functionPointerParameterDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionPointerParameterDeclarationList(_ ctx: ObjectiveCParser.FunctionPointerParameterDeclarationListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#functionPointerParameterDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionPointerParameterDeclaration(_ ctx: ObjectiveCParser.FunctionPointerParameterDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#functionPointerParameterDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionPointerParameterDeclaration(_ ctx: ObjectiveCParser.FunctionPointerParameterDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#declarationSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclarationSpecifier(_ ctx: ObjectiveCParser.DeclarationSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#declarationSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclarationSpecifier(_ ctx: ObjectiveCParser.DeclarationSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#declarationSpecifiers}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclarationSpecifiers(_ ctx: ObjectiveCParser.DeclarationSpecifiersContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#declarationSpecifiers}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclarationSpecifiers(_ ctx: ObjectiveCParser.DeclarationSpecifiersContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#declaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclaration(_ ctx: ObjectiveCParser.DeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#declaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclaration(_ ctx: ObjectiveCParser.DeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#initDeclaratorList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInitDeclaratorList(_ ctx: ObjectiveCParser.InitDeclaratorListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#initDeclaratorList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInitDeclaratorList(_ ctx: ObjectiveCParser.InitDeclaratorListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#initDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInitDeclarator(_ ctx: ObjectiveCParser.InitDeclaratorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#initDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInitDeclarator(_ ctx: ObjectiveCParser.InitDeclaratorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#declarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclarator(_ ctx: ObjectiveCParser.DeclaratorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#declarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclarator(_ ctx: ObjectiveCParser.DeclaratorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#directDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDirectDeclarator(_ ctx: ObjectiveCParser.DirectDeclaratorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#directDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDirectDeclarator(_ ctx: ObjectiveCParser.DirectDeclaratorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#blockDeclarationSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBlockDeclarationSpecifier(_ ctx: ObjectiveCParser.BlockDeclarationSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#blockDeclarationSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBlockDeclarationSpecifier(_ ctx: ObjectiveCParser.BlockDeclarationSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#typeName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeName(_ ctx: ObjectiveCParser.TypeNameContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#typeName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeName(_ ctx: ObjectiveCParser.TypeNameContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#abstractDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAbstractDeclarator(_ ctx: ObjectiveCParser.AbstractDeclaratorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#abstractDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAbstractDeclarator(_ ctx: ObjectiveCParser.AbstractDeclaratorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#directAbstractDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDirectAbstractDeclarator(_ ctx: ObjectiveCParser.DirectAbstractDeclaratorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#directAbstractDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDirectAbstractDeclarator(_ ctx: ObjectiveCParser.DirectAbstractDeclaratorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#parameterTypeList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterParameterTypeList(_ ctx: ObjectiveCParser.ParameterTypeListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#parameterTypeList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitParameterTypeList(_ ctx: ObjectiveCParser.ParameterTypeListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#parameterList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterParameterList(_ ctx: ObjectiveCParser.ParameterListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#parameterList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitParameterList(_ ctx: ObjectiveCParser.ParameterListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#parameterDeclarationList_}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterParameterDeclarationList_(_ ctx: ObjectiveCParser.ParameterDeclarationList_Context)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#parameterDeclarationList_}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitParameterDeclarationList_(_ ctx: ObjectiveCParser.ParameterDeclarationList_Context)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#parameterDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterParameterDeclaration(_ ctx: ObjectiveCParser.ParameterDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#parameterDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitParameterDeclaration(_ ctx: ObjectiveCParser.ParameterDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#typeQualifierList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeQualifierList(_ ctx: ObjectiveCParser.TypeQualifierListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#typeQualifierList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeQualifierList(_ ctx: ObjectiveCParser.TypeQualifierListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#attributeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAttributeSpecifier(_ ctx: ObjectiveCParser.AttributeSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#attributeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAttributeSpecifier(_ ctx: ObjectiveCParser.AttributeSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#atomicTypeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAtomicTypeSpecifier(_ ctx: ObjectiveCParser.AtomicTypeSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#atomicTypeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAtomicTypeSpecifier(_ ctx: ObjectiveCParser.AtomicTypeSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#fieldDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFieldDeclaration(_ ctx: ObjectiveCParser.FieldDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#fieldDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFieldDeclaration(_ ctx: ObjectiveCParser.FieldDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#structOrUnionSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStructOrUnionSpecifier(_ ctx: ObjectiveCParser.StructOrUnionSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#structOrUnionSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStructOrUnionSpecifier(_ ctx: ObjectiveCParser.StructOrUnionSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#structOrUnion}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStructOrUnion(_ ctx: ObjectiveCParser.StructOrUnionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#structOrUnion}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStructOrUnion(_ ctx: ObjectiveCParser.StructOrUnionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#structDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStructDeclarationList(_ ctx: ObjectiveCParser.StructDeclarationListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#structDeclarationList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStructDeclarationList(_ ctx: ObjectiveCParser.StructDeclarationListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#structDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStructDeclaration(_ ctx: ObjectiveCParser.StructDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#structDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStructDeclaration(_ ctx: ObjectiveCParser.StructDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#specifierQualifierList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSpecifierQualifierList(_ ctx: ObjectiveCParser.SpecifierQualifierListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#specifierQualifierList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSpecifierQualifierList(_ ctx: ObjectiveCParser.SpecifierQualifierListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#enumSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEnumSpecifier(_ ctx: ObjectiveCParser.EnumSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#enumSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEnumSpecifier(_ ctx: ObjectiveCParser.EnumSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#enumeratorList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEnumeratorList(_ ctx: ObjectiveCParser.EnumeratorListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#enumeratorList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEnumeratorList(_ ctx: ObjectiveCParser.EnumeratorListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#enumerator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEnumerator(_ ctx: ObjectiveCParser.EnumeratorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#enumerator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEnumerator(_ ctx: ObjectiveCParser.EnumeratorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#enumeratorIdentifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEnumeratorIdentifier(_ ctx: ObjectiveCParser.EnumeratorIdentifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#enumeratorIdentifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEnumeratorIdentifier(_ ctx: ObjectiveCParser.EnumeratorIdentifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#ibOutletQualifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIbOutletQualifier(_ ctx: ObjectiveCParser.IbOutletQualifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#ibOutletQualifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIbOutletQualifier(_ ctx: ObjectiveCParser.IbOutletQualifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#arcBehaviourSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArcBehaviourSpecifier(_ ctx: ObjectiveCParser.ArcBehaviourSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#arcBehaviourSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArcBehaviourSpecifier(_ ctx: ObjectiveCParser.ArcBehaviourSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#nullabilitySpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNullabilitySpecifier(_ ctx: ObjectiveCParser.NullabilitySpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#nullabilitySpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNullabilitySpecifier(_ ctx: ObjectiveCParser.NullabilitySpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#storageClassSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStorageClassSpecifier(_ ctx: ObjectiveCParser.StorageClassSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#storageClassSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStorageClassSpecifier(_ ctx: ObjectiveCParser.StorageClassSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#typePrefix}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypePrefix(_ ctx: ObjectiveCParser.TypePrefixContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#typePrefix}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypePrefix(_ ctx: ObjectiveCParser.TypePrefixContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#typeQualifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeQualifier(_ ctx: ObjectiveCParser.TypeQualifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#typeQualifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeQualifier(_ ctx: ObjectiveCParser.TypeQualifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#functionSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionSpecifier(_ ctx: ObjectiveCParser.FunctionSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#functionSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionSpecifier(_ ctx: ObjectiveCParser.FunctionSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#alignmentSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAlignmentSpecifier(_ ctx: ObjectiveCParser.AlignmentSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#alignmentSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAlignmentSpecifier(_ ctx: ObjectiveCParser.AlignmentSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#protocolQualifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterProtocolQualifier(_ ctx: ObjectiveCParser.ProtocolQualifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#protocolQualifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitProtocolQualifier(_ ctx: ObjectiveCParser.ProtocolQualifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#typeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeSpecifier(_ ctx: ObjectiveCParser.TypeSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#typeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeSpecifier(_ ctx: ObjectiveCParser.TypeSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#typeofTypeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeofTypeSpecifier(_ ctx: ObjectiveCParser.TypeofTypeSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#typeofTypeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeofTypeSpecifier(_ ctx: ObjectiveCParser.TypeofTypeSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#typedefName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypedefName(_ ctx: ObjectiveCParser.TypedefNameContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#typedefName}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypedefName(_ ctx: ObjectiveCParser.TypedefNameContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#genericTypeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGenericTypeSpecifier(_ ctx: ObjectiveCParser.GenericTypeSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#genericTypeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGenericTypeSpecifier(_ ctx: ObjectiveCParser.GenericTypeSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#genericTypeList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGenericTypeList(_ ctx: ObjectiveCParser.GenericTypeListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#genericTypeList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGenericTypeList(_ ctx: ObjectiveCParser.GenericTypeListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#genericTypeParameter}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGenericTypeParameter(_ ctx: ObjectiveCParser.GenericTypeParameterContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#genericTypeParameter}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGenericTypeParameter(_ ctx: ObjectiveCParser.GenericTypeParameterContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#scalarTypeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterScalarTypeSpecifier(_ ctx: ObjectiveCParser.ScalarTypeSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#scalarTypeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitScalarTypeSpecifier(_ ctx: ObjectiveCParser.ScalarTypeSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#fieldDeclaratorList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFieldDeclaratorList(_ ctx: ObjectiveCParser.FieldDeclaratorListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#fieldDeclaratorList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFieldDeclaratorList(_ ctx: ObjectiveCParser.FieldDeclaratorListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#fieldDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFieldDeclarator(_ ctx: ObjectiveCParser.FieldDeclaratorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#fieldDeclarator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFieldDeclarator(_ ctx: ObjectiveCParser.FieldDeclaratorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#vcSpecificModifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVcSpecificModifier(_ ctx: ObjectiveCParser.VcSpecificModifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#vcSpecificModifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVcSpecificModifier(_ ctx: ObjectiveCParser.VcSpecificModifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#gccDeclaratorExtension}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGccDeclaratorExtension(_ ctx: ObjectiveCParser.GccDeclaratorExtensionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#gccDeclaratorExtension}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGccDeclaratorExtension(_ ctx: ObjectiveCParser.GccDeclaratorExtensionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#gccAttributeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGccAttributeSpecifier(_ ctx: ObjectiveCParser.GccAttributeSpecifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#gccAttributeSpecifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGccAttributeSpecifier(_ ctx: ObjectiveCParser.GccAttributeSpecifierContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#gccAttributeList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGccAttributeList(_ ctx: ObjectiveCParser.GccAttributeListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#gccAttributeList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGccAttributeList(_ ctx: ObjectiveCParser.GccAttributeListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#gccAttribute}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGccAttribute(_ ctx: ObjectiveCParser.GccAttributeContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#gccAttribute}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGccAttribute(_ ctx: ObjectiveCParser.GccAttributeContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#pointer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPointer(_ ctx: ObjectiveCParser.PointerContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#pointer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPointer(_ ctx: ObjectiveCParser.PointerContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#pointerEntry}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPointerEntry(_ ctx: ObjectiveCParser.PointerEntryContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#pointerEntry}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPointerEntry(_ ctx: ObjectiveCParser.PointerEntryContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#macro}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMacro(_ ctx: ObjectiveCParser.MacroContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#macro}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMacro(_ ctx: ObjectiveCParser.MacroContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#arrayInitializer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArrayInitializer(_ ctx: ObjectiveCParser.ArrayInitializerContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#arrayInitializer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArrayInitializer(_ ctx: ObjectiveCParser.ArrayInitializerContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#structInitializer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStructInitializer(_ ctx: ObjectiveCParser.StructInitializerContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#structInitializer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStructInitializer(_ ctx: ObjectiveCParser.StructInitializerContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#structInitializerItem}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStructInitializerItem(_ ctx: ObjectiveCParser.StructInitializerItemContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#structInitializerItem}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStructInitializerItem(_ ctx: ObjectiveCParser.StructInitializerItemContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#initializerList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInitializerList(_ ctx: ObjectiveCParser.InitializerListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#initializerList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInitializerList(_ ctx: ObjectiveCParser.InitializerListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#staticAssertDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStaticAssertDeclaration(_ ctx: ObjectiveCParser.StaticAssertDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#staticAssertDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStaticAssertDeclaration(_ ctx: ObjectiveCParser.StaticAssertDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStatement(_ ctx: ObjectiveCParser.StatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStatement(_ ctx: ObjectiveCParser.StatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#labeledStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLabeledStatement(_ ctx: ObjectiveCParser.LabeledStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#labeledStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLabeledStatement(_ ctx: ObjectiveCParser.LabeledStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#rangeExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterRangeExpression(_ ctx: ObjectiveCParser.RangeExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#rangeExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitRangeExpression(_ ctx: ObjectiveCParser.RangeExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#compoundStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#compoundStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#selectionStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSelectionStatement(_ ctx: ObjectiveCParser.SelectionStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#selectionStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSelectionStatement(_ ctx: ObjectiveCParser.SelectionStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#switchStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSwitchStatement(_ ctx: ObjectiveCParser.SwitchStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#switchStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSwitchStatement(_ ctx: ObjectiveCParser.SwitchStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#switchBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSwitchBlock(_ ctx: ObjectiveCParser.SwitchBlockContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#switchBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSwitchBlock(_ ctx: ObjectiveCParser.SwitchBlockContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#switchSection}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSwitchSection(_ ctx: ObjectiveCParser.SwitchSectionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#switchSection}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSwitchSection(_ ctx: ObjectiveCParser.SwitchSectionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#switchLabel}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSwitchLabel(_ ctx: ObjectiveCParser.SwitchLabelContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#switchLabel}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSwitchLabel(_ ctx: ObjectiveCParser.SwitchLabelContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIterationStatement(_ ctx: ObjectiveCParser.IterationStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#iterationStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIterationStatement(_ ctx: ObjectiveCParser.IterationStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#whileStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterWhileStatement(_ ctx: ObjectiveCParser.WhileStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#whileStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitWhileStatement(_ ctx: ObjectiveCParser.WhileStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#doStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDoStatement(_ ctx: ObjectiveCParser.DoStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#doStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDoStatement(_ ctx: ObjectiveCParser.DoStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#forStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterForStatement(_ ctx: ObjectiveCParser.ForStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#forStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitForStatement(_ ctx: ObjectiveCParser.ForStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#forLoopInitializer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterForLoopInitializer(_ ctx: ObjectiveCParser.ForLoopInitializerContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#forLoopInitializer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitForLoopInitializer(_ ctx: ObjectiveCParser.ForLoopInitializerContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#forInStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterForInStatement(_ ctx: ObjectiveCParser.ForInStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#forInStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitForInStatement(_ ctx: ObjectiveCParser.ForInStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#jumpStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterJumpStatement(_ ctx: ObjectiveCParser.JumpStatementContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#jumpStatement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitJumpStatement(_ ctx: ObjectiveCParser.JumpStatementContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#expressions}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterExpressions(_ ctx: ObjectiveCParser.ExpressionsContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#expressions}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitExpressions(_ ctx: ObjectiveCParser.ExpressionsContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterExpression(_ ctx: ObjectiveCParser.ExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitExpression(_ ctx: ObjectiveCParser.ExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#assignmentExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAssignmentExpression(_ ctx: ObjectiveCParser.AssignmentExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#assignmentExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAssignmentExpression(_ ctx: ObjectiveCParser.AssignmentExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#assignmentOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAssignmentOperator(_ ctx: ObjectiveCParser.AssignmentOperatorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#assignmentOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAssignmentOperator(_ ctx: ObjectiveCParser.AssignmentOperatorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#conditionalExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterConditionalExpression(_ ctx: ObjectiveCParser.ConditionalExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#conditionalExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitConditionalExpression(_ ctx: ObjectiveCParser.ConditionalExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#logicalOrExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLogicalOrExpression(_ ctx: ObjectiveCParser.LogicalOrExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#logicalOrExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLogicalOrExpression(_ ctx: ObjectiveCParser.LogicalOrExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#logicalAndExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLogicalAndExpression(_ ctx: ObjectiveCParser.LogicalAndExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#logicalAndExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLogicalAndExpression(_ ctx: ObjectiveCParser.LogicalAndExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#bitwiseOrExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBitwiseOrExpression(_ ctx: ObjectiveCParser.BitwiseOrExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#bitwiseOrExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBitwiseOrExpression(_ ctx: ObjectiveCParser.BitwiseOrExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#bitwiseXorExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBitwiseXorExpression(_ ctx: ObjectiveCParser.BitwiseXorExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#bitwiseXorExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBitwiseXorExpression(_ ctx: ObjectiveCParser.BitwiseXorExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#bitwiseAndExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBitwiseAndExpression(_ ctx: ObjectiveCParser.BitwiseAndExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#bitwiseAndExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBitwiseAndExpression(_ ctx: ObjectiveCParser.BitwiseAndExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#equalityExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEqualityExpression(_ ctx: ObjectiveCParser.EqualityExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#equalityExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEqualityExpression(_ ctx: ObjectiveCParser.EqualityExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#equalityOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEqualityOperator(_ ctx: ObjectiveCParser.EqualityOperatorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#equalityOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEqualityOperator(_ ctx: ObjectiveCParser.EqualityOperatorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#comparisonExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterComparisonExpression(_ ctx: ObjectiveCParser.ComparisonExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#comparisonExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitComparisonExpression(_ ctx: ObjectiveCParser.ComparisonExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#comparisonOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterComparisonOperator(_ ctx: ObjectiveCParser.ComparisonOperatorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#comparisonOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitComparisonOperator(_ ctx: ObjectiveCParser.ComparisonOperatorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#shiftExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterShiftExpression(_ ctx: ObjectiveCParser.ShiftExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#shiftExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitShiftExpression(_ ctx: ObjectiveCParser.ShiftExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#shiftOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterShiftOperator(_ ctx: ObjectiveCParser.ShiftOperatorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#shiftOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitShiftOperator(_ ctx: ObjectiveCParser.ShiftOperatorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#additiveExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAdditiveExpression(_ ctx: ObjectiveCParser.AdditiveExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#additiveExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAdditiveExpression(_ ctx: ObjectiveCParser.AdditiveExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#additiveOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAdditiveOperator(_ ctx: ObjectiveCParser.AdditiveOperatorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#additiveOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAdditiveOperator(_ ctx: ObjectiveCParser.AdditiveOperatorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#multiplicativeExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMultiplicativeExpression(_ ctx: ObjectiveCParser.MultiplicativeExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#multiplicativeExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMultiplicativeExpression(_ ctx: ObjectiveCParser.MultiplicativeExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#multiplicativeOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMultiplicativeOperator(_ ctx: ObjectiveCParser.MultiplicativeOperatorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#multiplicativeOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMultiplicativeOperator(_ ctx: ObjectiveCParser.MultiplicativeOperatorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#castExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCastExpression(_ ctx: ObjectiveCParser.CastExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#castExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCastExpression(_ ctx: ObjectiveCParser.CastExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#initializer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInitializer(_ ctx: ObjectiveCParser.InitializerContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#initializer}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInitializer(_ ctx: ObjectiveCParser.InitializerContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#constantExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterConstantExpression(_ ctx: ObjectiveCParser.ConstantExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#constantExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitConstantExpression(_ ctx: ObjectiveCParser.ConstantExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#unaryExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterUnaryExpression(_ ctx: ObjectiveCParser.UnaryExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#unaryExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitUnaryExpression(_ ctx: ObjectiveCParser.UnaryExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#unaryOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterUnaryOperator(_ ctx: ObjectiveCParser.UnaryOperatorContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#unaryOperator}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitUnaryOperator(_ ctx: ObjectiveCParser.UnaryOperatorContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#postfixExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPostfixExpression(_ ctx: ObjectiveCParser.PostfixExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#postfixExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPostfixExpression(_ ctx: ObjectiveCParser.PostfixExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#primaryExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPrimaryExpression(_ ctx: ObjectiveCParser.PrimaryExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#primaryExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPrimaryExpression(_ ctx: ObjectiveCParser.PrimaryExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#postfixExpr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPostfixExpr(_ ctx: ObjectiveCParser.PostfixExprContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#postfixExpr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPostfixExpr(_ ctx: ObjectiveCParser.PostfixExprContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#argumentExpressionList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArgumentExpressionList(_ ctx: ObjectiveCParser.ArgumentExpressionListContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#argumentExpressionList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArgumentExpressionList(_ ctx: ObjectiveCParser.ArgumentExpressionListContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#argumentExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArgumentExpression(_ ctx: ObjectiveCParser.ArgumentExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#argumentExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArgumentExpression(_ ctx: ObjectiveCParser.ArgumentExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#messageExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMessageExpression(_ ctx: ObjectiveCParser.MessageExpressionContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#messageExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMessageExpression(_ ctx: ObjectiveCParser.MessageExpressionContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#constant}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterConstant(_ ctx: ObjectiveCParser.ConstantContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#constant}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitConstant(_ ctx: ObjectiveCParser.ConstantContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#stringLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStringLiteral(_ ctx: ObjectiveCParser.StringLiteralContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#stringLiteral}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStringLiteral(_ ctx: ObjectiveCParser.StringLiteralContext)
	/**
	 * Enter a parse tree produced by {@link ObjectiveCParser#identifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIdentifier(_ ctx: ObjectiveCParser.IdentifierContext)
	/**
	 * Exit a parse tree produced by {@link ObjectiveCParser#identifier}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIdentifier(_ ctx: ObjectiveCParser.IdentifierContext)
}