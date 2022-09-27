/*
Objective-C grammar.
The MIT License (MIT).
Copyright (c) 2016-2017, Alex Petuschak (alex@swiftify.io).
Copyright (c) 2016-2017, Ivan Kochurkin (kvanttt@gmail.com).
Converted to ANTLR 4 by Terence Parr; added @property and a few others.
Updated June 2014, Carlos Mejia.  Fix try-catch, add support for @( @{ @[ and blocks
June 2008 Cedric Cuche

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

parser grammar ObjectiveCParser;

options { tokenVocab=ObjectiveCLexer; }

translationUnit
    : topLevelDeclaration* EOF
    ;

topLevelDeclaration
    : importDeclaration
    | functionDeclaration
    | declaration
    | classInterface
    | classImplementation
    | categoryInterface
    | categoryImplementation
    | protocolDeclaration
    | protocolDeclarationList
    | classDeclarationList
    | functionDefinition
    ;

importDeclaration
    : IMPORT identifier SEMI
    ;

classInterface
    : IB_DESIGNABLE?
      INTERFACE
       classInterfaceName instanceVariables? interfaceDeclarationList?
      END
    ;

classInterfaceName
    : className (COLON superclassName)? (LT protocolList GT)?
    | className (COLON genericSuperclassName)? (LT protocolList GT)?
    ;

categoryInterface
    : INTERFACE
       categoryName=className LP identifier? RP (LT protocolList GT)? instanceVariables? interfaceDeclarationList?
      END
    ;

classImplementation
    : IMPLEMENTATION
       classImplementatioName instanceVariables? implementationDefinitionList?
      END
    ;

classImplementatioName
    : className (COLON superclassName)?
    | className (COLON genericSuperclassName)?
    ;

categoryImplementation
    : IMPLEMENTATION
       categoryName=className LP identifier RP implementationDefinitionList?
      END
    ;

className
    : identifier ((LT protocolList GT) | genericsSpecifier)?
    ;

superclassName
    : identifier
    ;

genericSuperclassName
    : identifier genericSuperclassSpecifier
    ;

genericTypeSpecifier
    : identifier ((LT protocolList GT) | genericsSpecifier)
    ;

genericSuperclassSpecifier
    : LT (superclassTypeSpecifierWithPrefixes (COMMA superclassTypeSpecifierWithPrefixes)*)? GT
    ;

superclassTypeSpecifierWithPrefixes
    : typePrefix* typeSpecifier pointer?
    ;

protocolDeclaration
    : PROTOCOL
       protocolName (LT protocolList GT)? protocolDeclarationSection*
      END
    ;

protocolDeclarationSection
    : modifier=(REQUIRED | OPTIONAL) interfaceDeclarationList*
    | interfaceDeclarationList+
    ;

protocolDeclarationList
    : PROTOCOL protocolList SEMI
    ;

classDeclarationList
    : CLASS className (COMMA className)* SEMI
    ;

protocolList
    : protocolName (COMMA protocolName)*
    ;

propertyDeclaration
    : PROPERTY (LP propertyAttributesList RP)? ibOutletQualifier? IB_INSPECTABLE? fieldDeclaration
    ;

propertyAttributesList
    : propertyAttribute (COMMA propertyAttribute)*
    ;

propertyAttribute
    : ATOMIC
    | NONATOMIC
    | STRONG
    | WEAK
    | RETAIN
    | ASSIGN
    | UNSAFE_UNRETAINED
    | COPY
    | READONLY
    | READWRITE
    | GETTER ASSIGNMENT identifier
    | SETTER ASSIGNMENT identifier COLON
    | nullabilitySpecifier
    | identifier
    ;

protocolName
    : LT protocolList GT
    | (COVARIANT | CONTRAVARIANT)?  identifier
    ;

instanceVariables
    : LBRACE visibilitySection* RBRACE
    ;

visibilitySection
    : accessModifier fieldDeclaration*
    | fieldDeclaration+
    ;

accessModifier
    : PRIVATE
    | PROTECTED
    | PACKAGE
    | PUBLIC
    ;

interfaceDeclarationList
    : (declaration
    | classMethodDeclaration
    | instanceMethodDeclaration
    | propertyDeclaration
    | functionDeclaration)+
    ;

classMethodDeclaration
    : ADD methodDeclaration
    ;

instanceMethodDeclaration
    : SUB methodDeclaration
    ;

methodDeclaration
    : methodType? methodSelector attributeSpecifier* macro? SEMI
    ;

implementationDefinitionList
    : (functionDefinition
    | declaration
    | classMethodDefinition
    | instanceMethodDefinition
    | propertyImplementation
    )+;

classMethodDefinition
    : ADD methodDefinition
    ;

instanceMethodDefinition
    : SUB methodDefinition
    ;

methodDefinition
    : methodType? methodSelector initDeclaratorList? SEMI? attributeSpecifier? compoundStatement SEMI?
    ;

methodSelector
    : selector
    | keywordDeclarator+ (COMMA ELIPSIS)?
    ;

keywordDeclarator
    : selector? COLON methodType* arcBehaviourSpecifier? identifier
    ;

selector
    : identifier
    | RETURN
    | SWITCH
    | IF
    | ELSE
    | DEFAULT
    ;

methodType
    : LP typeName RP
    ;

propertyImplementation
    : SYNTHESIZE propertySynthesizeList SEMI
    | DYNAMIC propertySynthesizeList SEMI
    ;

propertySynthesizeList
    : propertySynthesizeItem (COMMA propertySynthesizeItem)*
    ;

propertySynthesizeItem
    : identifier (ASSIGNMENT identifier)?
    ;

blockType
    : nullabilitySpecifier? typeSpecifier nullabilitySpecifier? LP '^' (nullabilitySpecifier | typeSpecifier)? RP blockParameters?
    ;

genericsSpecifier
    : LT (typeSpecifierWithPrefixes (COMMA typeSpecifierWithPrefixes)*)? GT
    ;

typeSpecifierWithPrefixes
    : typePrefix* typeSpecifier pointer?
    ;

dictionaryExpression
    : AT LBRACE (dictionaryPair (COMMA dictionaryPair)* COMMA?)? RBRACE
    ;

dictionaryPair
    : castExpression COLON expression
    ;

arrayExpression
    : AT LBRACK (expressions COMMA?)? RBRACK
    ;

boxExpression
    : AT LP expression RP
    | AT (constant | identifier)
    ;

blockParameters
    : LP ((typeVariableDeclaratorOrName | VOID) (COMMA typeVariableDeclaratorOrName)*)? RP
    ;

typeVariableDeclaratorOrName
    : typeVariableDeclarator
    | typeName
    ;

blockExpression
    : '^' typeSpecifier? nullabilitySpecifier? blockParameters? compoundStatement
    ;

messageExpression
    : LBRACK receiver messageSelector RBRACK
    ;

receiver
    : expression
    | genericTypeSpecifier
    ;

messageSelector
    : selector
    | keywordArgument+
    ;

keywordArgument
    : selector? COLON keywordArgumentType (COMMA keywordArgumentType)*
    ;

keywordArgumentType
    : expressions nullabilitySpecifier? (LBRACE initializerList RBRACE)?
    ;

selectorExpression
    : SELECTOR LP selectorName RP
    ;

selectorName
    : selector
    | (selector? COLON)+
    ;

protocolExpression
    : PROTOCOL LP protocolName RP
    ;

encodeExpression
    : ENCODE LP typeName RP
    ;

typeVariableDeclarator
    : declarationSpecifiers declarator
    ;

throwStatement
    : THROW LP identifier RP
    | THROW expression
    ;

tryBlock
    : TRY tryStatement=compoundStatement catchStatement* (FINALLY finallyStatement=compoundStatement)?
    ;

catchStatement
    : CATCH LP typeVariableDeclarator RP compoundStatement
    ;

synchronizedStatement
    : SYNCHRONIZED LP expression RP compoundStatement
    ;

autoreleaseStatement
    : AUTORELEASEPOOL compoundStatement
    ;

functionDeclaration
    : functionSignature SEMI
    ;

functionDefinition
    : functionSignature compoundStatement
    ;

functionSignature
    : declarationSpecifiers? identifier (LP parameterList? RP) attributeSpecifier?
    ;

attribute
    : attributeName attributeParameters?
    ;

attributeName
    : CONST
    | identifier
    ;

attributeParameters
    : LP attributeParameterList? RP
    ;

attributeParameterList
    : attributeParameter (COMMA attributeParameter)*
    ;

attributeParameter
    : attribute
    | constant
    | stringLiteral
    | attributeParameterAssignment
    ;

attributeParameterAssignment
    : attributeName ASSIGNMENT (constant | attributeName | stringLiteral)
    ;

declaration
    : functionCallExpression
    | functionPointer SEMI
    | enumDeclaration
    | varDeclaration
    | typedefDeclaration
    ;

functionPointer
    : declarationSpecifiers LP '*' identifier? RP LP functionPointerParameterList? RP
    ;

functionPointerParameterList
    : functionPointerParameterDeclarationList (COMMA ELIPSIS)?
    ;

functionPointerParameterDeclarationList
    : functionPointerParameterDeclaration (COMMA functionPointerParameterDeclaration)*
    ;

functionPointerParameterDeclaration
    : (declarationSpecifiers | functionPointer) declarator?
    | VOID
    ;

functionCallExpression
    : attributeSpecifier? identifier attributeSpecifier? LP directDeclarator RP SEMI
    ;

enumDeclaration
    : attributeSpecifier? TYPEDEF? enumSpecifier identifier? SEMI
    ;

varDeclaration
    : (declarationSpecifiers initDeclaratorList | declarationSpecifiers) SEMI
    ;

typedefDeclaration
    : attributeSpecifier? TYPEDEF (declarationSpecifiers typeDeclaratorList | declarationSpecifiers) macro? SEMI
    | attributeSpecifier? TYPEDEF functionPointer SEMI
    ;

typeDeclaratorList
    : declarator (COMMA declarator)*
    ;

declarationSpecifiers
    : (storageClassSpecifier
    | attributeSpecifier
    | arcBehaviourSpecifier
    | nullabilitySpecifier
    | ibOutletQualifier
    | typePrefix
    | typeQualifier
    | typeSpecifier)+
    ;

attributeSpecifier
    : '__attribute__' LP LP attribute (COMMA attribute)* RP RP
    ;

initDeclaratorList
    : initDeclarator (COMMA initDeclarator)*
    ;

initDeclarator
    : declarator (ASSIGNMENT initializer)?
    ;

structOrUnionSpecifier
    : (STRUCT | UNION) attributeSpecifier* (identifier | identifier? LBRACE fieldDeclaration+ RBRACE)
    ;

fieldDeclaration
    : specifierQualifierList fieldDeclaratorList macro? SEMI
    | functionPointer SEMI
    ;

specifierQualifierList
    : (arcBehaviourSpecifier
    | nullabilitySpecifier
    | ibOutletQualifier
    | typePrefix
    | typeQualifier
    | typeSpecifier)+
    ;

ibOutletQualifier
    : IB_OUTLET_COLLECTION LP identifier RP
    | IB_OUTLET
    ;

arcBehaviourSpecifier
    : WEAK_QUALIFIER
    | STRONG_QUALIFIER
    | AUTORELEASING_QUALIFIER
    | UNSAFE_UNRETAINED_QUALIFIER
    ;

nullabilitySpecifier
    : NULL_UNSPECIFIED
    | NULLABLE
    | NONNULL
    | NULL_RESETTABLE
    ;

storageClassSpecifier
    : AUTO
    | REGISTER
    | STATIC
    | EXTERN
    ;

typePrefix
    : BRIDGE
    | BRIDGE_TRANSFER
    | BRIDGE_RETAINED
    | BLOCK
    | INLINE
    | NS_INLINE
    | KINDOF
    ;

typeQualifier
    : CONST
    | VOLATILE
    | RESTRICT
    | protocolQualifier
    ;

protocolQualifier
    : IN
    | OUT
    | INOUT
    | BYCOPY
    | BYREF
    | ONEWAY
    ;

typeSpecifier
    : scalarTypeSpecifier pointer?
    | typeofExpression
    | KINDOF? genericTypeSpecifier pointer?
    | structOrUnionSpecifier pointer?
    | enumSpecifier
    | KINDOF? identifier pointer?
    ;

scalarTypeSpecifier
    : VOID
    | CHAR
    | SHORT
    | INT
    | LONG
    | FLOAT
    | DOUBLE
    | SIGNED
    | UNSIGNED
    ;

typeofExpression
    : TYPEOF (LP expression RP)
    ;

fieldDeclaratorList
    : fieldDeclarator (COMMA fieldDeclarator)*
    ;

fieldDeclarator
    : declarator
    | declarator? COLON constant
    ;

enumSpecifier
    : ENUM (identifier? COLON typeName)? (identifier (LBRACE enumeratorList RBRACE)? | LBRACE enumeratorList RBRACE)
    | (NS_OPTIONS | NS_ENUM) LP typeName COMMA identifier RP LBRACE enumeratorList RBRACE
    ;

enumeratorList
    : enumerator (COMMA enumerator)* COMMA?
    ;

enumerator
    : enumeratorIdentifier (ASSIGNMENT expression)?
    ;

enumeratorIdentifier
    : identifier
    ;

directDeclarator
    : (identifier | LP declarator RP) declaratorSuffix* attributeSpecifier?
    | LP BITXOR nullabilitySpecifier? identifier? RP blockParameters
    | LP MUL nullabilitySpecifier? identifier? RP blockParameters
    ;

declaratorSuffix
    : LBRACK constantExpression? RBRACK
    ;

parameterList
    : parameterDeclarationList (COMMA ELIPSIS)?
    ;

pointer
    : '*' declarationSpecifiers? pointer?
    ;

macro
    : identifier (LP primaryExpression (COMMA primaryExpression)* RP)?
    ;

arrayInitializer
    : LBRACE (expression (COMMA expression)* COMMA?)? RBRACE
    ;

structInitializer
    : LBRACE (structInitializerItem (COMMA structInitializerItem)* COMMA?)? RBRACE
    ;

structInitializerItem
    : '.' expression
    | structInitializer
    | arrayInitializer
    ;

initializerList
    : initializer (COMMA initializer)* COMMA?
    ;

typeName
    : specifierQualifierList abstractDeclarator?
    | blockType
    ;

abstractDeclarator
    : pointer abstractDeclarator?
    | LP abstractDeclarator? RP abstractDeclaratorSuffix+
    | (LBRACK constantExpression? RBRACK)+
    ;

abstractDeclaratorSuffix
    : LBRACK constantExpression? RBRACK
    | LP parameterDeclarationList? RP
    ;

parameterDeclarationList
    : parameterDeclaration (COMMA parameterDeclaration)*
    ;

parameterDeclaration
    : declarationSpecifiers declarator
    | functionPointer
    | VOID
    ;

declarator
    : pointer? directDeclarator
    ;

statement
    : labeledStatement SEMI?
    | compoundStatement SEMI?
    | selectionStatement SEMI?
    | iterationStatement SEMI?
    | jumpStatement SEMI
    | synchronizedStatement SEMI?
    | autoreleaseStatement SEMI?
    | throwStatement SEMI
    | tryBlock SEMI?
    | expressions SEMI
    | SEMI
    ;

labeledStatement
    : identifier COLON statement
    ;

rangeExpression
    :  expression (ELIPSIS expression)?
    ;

compoundStatement
    : LBRACE (declaration | statement)* RBRACE
    ;

selectionStatement
    : IF LP expressions RP ifBody=statement (ELSE elseBody=statement)?
    | switchStatement
    ;

switchStatement
    : SWITCH LP expression RP switchBlock
    ;

switchBlock
    : LBRACE switchSection* RBRACE
    ;

switchSection
    : switchLabel+ statement+
    ;

switchLabel
    : CASE (rangeExpression | LP rangeExpression RP) COLON
    | DEFAULT COLON
    ;

iterationStatement
    : whileStatement
    | doStatement
    | forStatement
    | forInStatement
    ;

whileStatement
    : WHILE LP expression RP statement
    ;

doStatement
    : DO statement WHILE LP expression RP SEMI
    ;

forStatement
    : FOR LP forLoopInitializer? SEMI expression? SEMI expressions? RP statement
    ;

forLoopInitializer
    : declarationSpecifiers initDeclaratorList
    | expressions
    ;

forInStatement
    : FOR LP typeVariableDeclarator IN expression? RP statement
    ;

jumpStatement
    : GOTO identifier
    | CONTINUE
    | BREAK
    | RETURN expression?
    ;

expressions
    : expression (COMMA expression)*
    ;

expression
    : castExpression

    | expression op=(MUL | DIV | MOD) expression
    | expression op=(ADD | SUB) expression
    | expression (LT LT | GT GT) expression
    | expression op=(LE | GE | LT | GT) expression
    | expression op=(NOTEQUAL | EQUAL) expression
    | expression op=BITAND expression
    | expression op=BITXOR expression
    | expression op=BITOR expression
    | expression op=AND expression
    | expression op=OR expression

    | expression QUESTION trueExpression=expression? COLON falseExpression=expression

    | unaryExpression assignmentOperator assignmentExpression=expression
    | LP compoundStatement RP
    ;

assignmentOperator
    : ASSIGNMENT | '*=' | '/=' | '%=' | '+=' | '-=' | '<<=' | '>>=' | '&=' | '^=' | '|='
    ;

castExpression
    : unaryExpression
    | (LP typeName RP) (castExpression | initializer)
    ;

initializer
    : expression
    | arrayInitializer
    | structInitializer
    ;

constantExpression
    : identifier
    | constant
    ;

unaryExpression
    : postfixExpression
    | SIZEOF (unaryExpression | LP typeSpecifier RP)
    | op=(INC | DEC) unaryExpression
    | unaryOperator castExpression
    ;

unaryOperator
    : '&'
    | '*'
    | ADD
    | SUB
    | '~'
    | BANG
    ;

postfixExpression
    : primaryExpression postfixExpr*
    | postfixExpression (DOT | STRUCTACCESS) identifier postfixExpr*  // TODO: get rid of property and postfix expression.
    ;

postfixExpr
    : LBRACK expression RBRACK
    | LP argumentExpressionList? RP
    | LP (COMMA | macroArguments+=~RP)+ RP
    | op=(INC | DEC)
    ;

argumentExpressionList
    : argumentExpression (COMMA argumentExpression)*
    ;

argumentExpression
    : expression
    | genericTypeSpecifier
    ;

primaryExpression
    : identifier
    | constant
    | stringLiteral
    | LP expression RP
    | messageExpression
    | selectorExpression
    | protocolExpression
    | encodeExpression
    | dictionaryExpression
    | arrayExpression
    | boxExpression
    | blockExpression
    ;

constant
    : HEX_LITERAL
    | OCTAL_LITERAL
    | BINARY_LITERAL
    | (ADD | SUB)? DECIMAL_LITERAL
    | (ADD | SUB)? FLOATING_POINT_LITERAL
    | CHARACTER_LITERAL
    | NIL
    | NULL
    | YES
    | NO
    | TRUE
    | FALSE
    ;

stringLiteral
    : (STRING_START (STRING_VALUE | STRING_NEWLINE)* STRING_END)+
    ;

identifier
    : IDENTIFIER

    | BOOL
    | Class
    | BYCOPY
    | BYREF
    | ID
    | IMP
    | IN
    | INOUT
    | ONEWAY
    | OUT
    | PROTOCOL_
    | SEL
    | SELF
    | SUPER
    | ATOMIC
    | NONATOMIC
    | RETAIN

    | AUTORELEASING_QUALIFIER
    | BLOCK
    | BRIDGE_RETAINED
    | BRIDGE_TRANSFER
    | COVARIANT
    | CONTRAVARIANT
    | DEPRECATED
    | KINDOF
    | UNUSED

    | NS_INLINE
    | NS_ENUM
    | NS_OPTIONS

    | NULL_UNSPECIFIED
    | NULLABLE
    | NONNULL
    | NULL_RESETTABLE

    | ASSIGN
    | COPY
    | GETTER
    | SETTER
    | STRONG
    | READONLY
    | READWRITE
    | WEAK
    | UNSAFE_UNRETAINED

    | IB_OUTLET
    | IB_OUTLET_COLLECTION
    | IB_INSPECTABLE
    | IB_DESIGNABLE
    ;
