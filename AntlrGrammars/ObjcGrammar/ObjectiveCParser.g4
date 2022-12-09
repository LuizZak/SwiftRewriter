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

// Partly based on a C22 draft: https://www.open-std.org/JTC1/SC22/WG14/www/docs/n3054.pdf

parser grammar ObjectiveCParser;

options { tokenVocab=ObjectiveCLexer; }

translationUnit
    : topLevelDeclaration* EOF
    ;

topLevelDeclaration
    : importDeclaration
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
    : className (COLON superclassName genericClassParametersSpecifier?)? (LT protocolList GT)?
    ;

categoryInterface
    : INTERFACE
       categoryName=className LP identifier? RP (LT protocolList GT)? instanceVariables? interfaceDeclarationList?
      END
    ;

classImplementation
    : IMPLEMENTATION
       classImplementationName instanceVariables? implementationDefinitionList?
      END
    ;

classImplementationName
    : className (COLON superclassName genericClassParametersSpecifier?)?
    ;

categoryImplementation
    : IMPLEMENTATION
       categoryName=className LP identifier? RP implementationDefinitionList?
      END
    ;

className
    : identifier genericClassParametersSpecifier?
    ;

superclassName
    : identifier
    ;

genericClassParametersSpecifier
    : LT (superclassTypeSpecifierWithPrefixes (COMMA superclassTypeSpecifierWithPrefixes)*)? GT
    ;

superclassTypeSpecifierWithPrefixes
    : typePrefix* typeSpecifier pointer
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
    : CLASS classDeclaration (COMMA classDeclaration)* SEMI
    ;

classDeclaration
    : className (LT protocolList GT)?
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
    : WEAK
    | UNSAFE_UNRETAINED
    | COPY
    | GETTER ASSIGNMENT selectorName
    | SETTER ASSIGNMENT selectorName
    | nullabilitySpecifier
    | identifier
    ;

protocolName
    : LT protocolList GT
    | (COVARIANT | CONTRAVARIANT)? identifier
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
    : LP ((parameterDeclaration | VOID) (COMMA parameterDeclaration)*)? RP
    ;

blockExpression
    : BITXOR compoundStatement
    | BITXOR typeName blockParameters compoundStatement // Must have priority over typeName compoundStatement to ensure parameters aren't interpreted as an abstractDeclarator of the return type
    | BITXOR typeName compoundStatement
    | BITXOR blockParameters compoundStatement
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
    : declarationSpecifiers? declarator declarationList?
    ;

declarationList
    : declaration+
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

// TODO: Replace usages of functionPointer with declaration
functionPointer
    : declarationSpecifiers LP MUL identifier? RP LP functionPointerParameterList? RP
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

declarationSpecifier
    : storageClassSpecifier
    | typeSpecifier
    | typeQualifier
    | functionSpecifier
    | alignmentSpecifier
    | arcBehaviourSpecifier
    | nullabilitySpecifier
    | ibOutletQualifier
    | typePrefix
    ;

declarationSpecifiers
    : declarationSpecifier+
    ;

declaration
    : declarationSpecifiers initDeclaratorList? SEMI
    | staticAssertDeclaration
    ;

initDeclaratorList
    : initDeclarator (COMMA initDeclarator)*
    ;

initDeclarator
    : declarator (ASSIGNMENT initializer)?
    ;

declarator
    : pointer? directDeclarator gccDeclaratorExtension*
    ;

directDeclarator
    :   identifier
    |   LP declarator RP
    |   directDeclarator LBRACK typeQualifierList? expression? RBRACK
    |   directDeclarator LBRACK STATIC typeQualifierList? expression RBRACK
    |   directDeclarator LBRACK typeQualifierList STATIC expression RBRACK
    |   directDeclarator LBRACK typeQualifierList? MUL RBRACK
    |   directDeclarator LP parameterTypeList? RP
    |   LP BITXOR blockDeclarationSpecifier* directDeclarator RP blockParameters
    |   identifier COLON DIGITS  // bit field
    |   vcSpecificModifier identifier // Visual C Extension
    |   LP vcSpecificModifier declarator RP // Visual C Extension
    ;

blockDeclarationSpecifier
    : nullabilitySpecifier
    | arcBehaviourSpecifier
    | typeQualifier
    | typePrefix
    ;

typeName
    : declarationSpecifiers abstractDeclarator?
    ;

abstractDeclarator
    : pointer
    | pointer? directAbstractDeclarator gccDeclaratorExtension*
    ;

directAbstractDeclarator
    :   LP abstractDeclarator RP gccDeclaratorExtension*
    |   LBRACK typeQualifierList? expression? RBRACK
    |   LBRACK STATIC typeQualifierList? expression RBRACK
    |   LBRACK typeQualifierList STATIC expression RBRACK
    |   LBRACK MUL RBRACK
    |   LP parameterTypeList? RP gccDeclaratorExtension*
    |   directAbstractDeclarator LBRACK typeQualifierList? expression? RBRACK
    |   directAbstractDeclarator LBRACK STATIC typeQualifierList? expression RBRACK
    |   directAbstractDeclarator LBRACK typeQualifierList STATIC expression RBRACK
    |   directAbstractDeclarator LBRACK MUL RBRACK
    |   directAbstractDeclarator LP parameterTypeList? RP gccDeclaratorExtension*
    |   LP BITXOR blockDeclarationSpecifier* identifier? RP blockParameters
    ;

parameterTypeList
    : parameterList (COMMA ELIPSIS)?
    ;

parameterList
    : parameterDeclaration (COMMA parameterDeclaration)*
    ;

// TODO: For some reason, ANTLR 4.11.1 starts to fail parsing stand alone `parameterDeclaration` if this parser rule is removed; consider filing a bug report later.
parameterDeclarationList_
    : parameterDeclaration (COMMA parameterDeclaration)*
    ;

parameterDeclaration
    : declarationSpecifiers declarator
    | declarationSpecifiers abstractDeclarator?
    ;

typeQualifierList
    : typeQualifier+
    ;

attributeSpecifier
    : ATTRIBUTE LP LP attribute (COMMA attribute)* RP RP
    ;

atomicTypeSpecifier
    : ATOMIC_ LP typeName RP
    ;

fieldDeclaration
    : declarationSpecifiers fieldDeclaratorList macro? SEMI
    ;

structOrUnionSpecifier
    : structOrUnion attributeSpecifier* identifier? LBRACE structDeclarationList RBRACE
    | structOrUnion attributeSpecifier* identifier
    ;

structOrUnion
    : STRUCT
    | UNION
    ;

structDeclarationList
    : structDeclaration+
    ;

structDeclaration // The first two rules have priority order and cannot be simplified to one expression.
    : attributeSpecifier* specifierQualifierList fieldDeclaratorList SEMI
    | attributeSpecifier* specifierQualifierList SEMI
    | staticAssertDeclaration
    ;

specifierQualifierList
    : (typeSpecifier | typeQualifier) specifierQualifierList?
    ;

// TODO: Fix the first alt on this syntax: It accepts invalid syntax like 'enum <ident>: <type> <ident> { <fields> }'.
enumSpecifier
    : ENUM (enumName=identifier? COLON typeName)? (identifier (LBRACE enumeratorList RBRACE)? | LBRACE enumeratorList RBRACE)
    | (NS_OPTIONS | NS_ENUM) LP typeName COMMA enumName=identifier RP LBRACE enumeratorList RBRACE
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
    | CONSTEXPR
    | EXTERN
    | REGISTER
    | STATIC
    | THREAD_LOCAL_
    | TYPEDEF
    ;

typePrefix
    : BRIDGE
    | BRIDGE_TRANSFER
    | BRIDGE_RETAINED
    | BLOCK
    | INLINE
    | NS_INLINE
    | KINDOF
    | UNUSED
    ;

typeQualifier
    : CONST
    | VOLATILE
    | RESTRICT
    | ATOMIC_
    | protocolQualifier
    ;

functionSpecifier
    : (INLINE
    | NORETURN_
    | INLINE__ // GCC extension
    | STDCALL)
    | gccAttributeSpecifier
    | DECLSPEC LP identifier RP
    ;

alignmentSpecifier
    : ALIGNAS_ LP (typeName | constantExpression) RP
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
    : scalarTypeSpecifier
    | EXTENSION LP (M128 | M128D | M128I) RP
    | genericTypeSpecifier
    | atomicTypeSpecifier
    | structOrUnionSpecifier
    | enumSpecifier
    | typedefName
    | typeofTypeSpecifier
    ;

typeofTypeSpecifier
    : TYPEOF (LP expression RP) // GCC extension
    ;

typedefName
    : identifier
    ;

genericTypeSpecifier
    : identifier genericTypeList
    ;

genericTypeList
    : LT (genericTypeParameter (COMMA genericTypeParameter)*)? GT
    ;

genericTypeParameter
    : (COVARIANT | CONTRAVARIANT)? typeName
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
    | BOOL_
    | CBOOL
    | COMPLEX
    | M128
    | M128D
    | M128I
    ;

fieldDeclaratorList
    : fieldDeclarator (COMMA fieldDeclarator)*
    ;

fieldDeclarator
    : declarator
    | declarator? COLON constantExpression
    ;

vcSpecificModifier
    : (CDECL
    | CLRCALL
    | STDCALL
    | FASTCALL
    | THISCALL
    | VECTORCALL)
    ;

gccDeclaratorExtension
    : ASM LP stringLiteral+ RP
    | gccAttributeSpecifier
    ;

gccAttributeSpecifier
    : ATTRIBUTE LP LP gccAttributeList RP RP
    ;

gccAttributeList
    : gccAttribute? (COMMA gccAttribute?)*
    ;

gccAttribute
    : ~(COMMA | LP | RP) // relaxed def for "identifier or reserved word"
      (LP argumentExpressionList? RP)?
    ;

pointer
    : pointerEntry+
    ;

pointerEntry
    : (MUL) typeQualifierList? nullabilitySpecifier?
    ;

macro
    : identifier (LP (COMMA | macroArguments+=~RP)+ RP)?
    ;

arrayInitializer
    : LBRACE (expression (COMMA expression)* COMMA?)? RBRACE
    ;

structInitializer
    : LBRACE (structInitializerItem (COMMA structInitializerItem)* COMMA?)? RBRACE
    ;

structInitializerItem
    : DOT expression
    | structInitializer
    | arrayInitializer
    ;

initializerList
    : initializer (COMMA initializer)* COMMA?
    ;

staticAssertDeclaration
    : STATIC_ASSERT_ LP constantExpression COMMA stringLiteral+ RP SEMI
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
    : LBRACE (statement | declaration)* RBRACE
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
    : assignmentExpression
    | LP compoundStatement RP
    ;

assignmentExpression
    : conditionalExpression
    | unaryExpression assignmentOperator expression
    ;

assignmentOperator
    : ASSIGNMENT | MUL_ASSIGN | DIV_ASSIGN | MOD_ASSIGN | ADD_ASSIGN | SUB_ASSIGN | LSHIFT_ASSIGN | RSHIFT_ASSIGN | AND_ASSIGN | XOR_ASSIGN | OR_ASSIGN
    ;

conditionalExpression
    : logicalOrExpression (QUESTION trueExpression=expression? COLON falseExpression=conditionalExpression)?
    ;

logicalOrExpression
    : logicalAndExpression (OR logicalAndExpression)*
    ;

logicalAndExpression
    : bitwiseOrExpression (AND bitwiseOrExpression)*
    ;

bitwiseOrExpression
    : bitwiseXorExpression (BITOR bitwiseXorExpression)*
    ;

bitwiseXorExpression
    : bitwiseAndExpression (BITXOR bitwiseAndExpression)*
    ;

bitwiseAndExpression
    : equalityExpression (BITAND equalityExpression)*
    ;

equalityExpression
    : comparisonExpression (equalityOperator comparisonExpression)*
    ;
equalityOperator
    : EQUAL | NOTEQUAL
    ;

comparisonExpression
    : shiftExpression (comparisonOperator shiftExpression)*
    ;
comparisonOperator
    : LT | GT | LE | GE
    ;

shiftExpression
    : additiveExpression (shiftOperator additiveExpression)*
    ;
shiftOperator
    : LSHIFT | RSHIFT
    ;

additiveExpression
    : multiplicativeExpression (additiveOperator multiplicativeExpression)*
    ;
additiveOperator
    : ADD | SUB
    ;

multiplicativeExpression
    : castExpression (multiplicativeOperator castExpression)*
    ;
multiplicativeOperator
    : MUL | DIV | MOD
    ;

castExpression
    : EXTENSION? LP typeName RP castExpression
    | unaryExpression
    | DIGITS // for
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
    : BITAND
    | MUL
    | ADD
    | SUB
    | TILDE
    | BANG
    ;

postfixExpression
    : primaryExpression postfixExpr*
    | postfixExpression (DOT | STRUCTACCESS) identifier postfixExpr*  // TODO: get rid of property and postfix expression.
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

postfixExpr
    : LBRACK expression RBRACK
    | LP argumentExpressionList? RP
    | op=(INC | DEC)
    ;

argumentExpressionList
    : argumentExpression (COMMA argumentExpression)*
    ;

argumentExpression
    : expression
    | genericTypeSpecifier
    ;

messageExpression
    : LBRACK receiver messageSelector RBRACK
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

    | COVARIANT
    | CONTRAVARIANT
    | DEPRECATED

    | NS_INLINE
    | NS_ENUM
    | NS_OPTIONS

    | ASSIGN
    | COPY
    | GETTER
    | SETTER
    | STRONG
    | READONLY
    | READWRITE

    | IB_INSPECTABLE
    | IB_DESIGNABLE
    ;
