## Architectural description

The tool splits the conversion process into six discrete steps, which are, whenever possible, divided into separate project targets.

```
┌─────────────┐ ┌──────────────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌──────────┐
│      1.     │ │          2.          │ │      3.     │ │      4.     │ │      5.     │ │    6.    │
│ Objective-C ├─┤ Statements parsing/  ├─┤    Type     ├─┤  Intention  ├─┤     AST     ├─┤   Code   │
│   parsing   │ │ Intention generation │ │  resolving  │ │  rewriting  │ │  rewriting  │ │  output  │
└─────────────┘ └──────────────────────┘ └─────────────┘ └─────────────┘ └─────────────┘ └──────────┘
```

All of these steps are encapsulated and run by `SwiftRewriter` within the `SwiftRewriterLib` target.

An overview of the steps taken is described bellow.

#### 1. Objective-C parsing

A mixture of tooled and manual parsing is used on input .h/.m files to parse.

The input source code is provided via an `InputSourcesProvider`-implementer provided to `SwiftRewriter.init`. This object should provide the input source code files to parse encapsulated behind objects implementing a `CodeSource` protocol. This protocol provides semantic information about the origin of a source snippet, which can be used during later steps to aid in tracing back the origin of a source code construct.

The source code is then processed by `SourcePreprocessor` objects provided to `SwiftRewriter.init`. These preprocessors have access to the raw string data for the files, and can be used to apply transformations such as comment removal or preprocessor expansion before actual parsing is done for each file.

For the tooled part, [ANTLR](http://www.antlr.org/) is used to do the heavy lifting and parse all the input source code, and a couple of more fine-grained parsing steps are performed manually with `ObjcParser` (mainly Objective-C type signature parsing).

All input parsing for a single file can be done with just an `ObjcParser` instance.

Since trees produced by ANTLR are too heavyweight and reflect a lot of the complexity of Objective-C's grammar (which itself is complex due to the necessity to parse virtually any valid Objective-C source code), the produced AST is converted into a customized AST representation that is more useful for manipulation, rooted into a base `ASTNode` class.

The source code for the AST class structure used is found inside the `GrammarModels` target, and is used throughout the rest of the process to inspect the input AST.

#### 2. Statements parsing

Parsing of Objective-C method bodies is postponed to after all files are parsed. This helps ensure we can produce a statement tree that has full visibility of all symbols and classes. This is relevant for the initial type-parsing and typealias generation steps.

Statements are parsed into a customized AST for representing Swift grammars, contained within the `SwiftAST` target.

- Unlike high level constructs such as classes and global definitions, no intermediary representation is used to represent statement AST's between Objective-C and Swift, and the source code is translated directly from the ANTLR-produced tree for the Objective-C code into a Swift AST structure, for all method bodies.

#### 2.1 Intention generation

The complete grammar tree is then analyzed and grouped up into sets of objects that encapsulate the intent of creating matching Swift source code for each object from the original Objective-C source code. This set of structures are aptly named `Intentions`, and many subtypes of intentions are present and used to fully represent the final Swift source code.

Source code statements/expressions are not split into invididual intentions; these constructs remains encapsulated behind SwiftAST trees, which are contained within `FunctionBodyIntention` instances, one for each method body.

Intentions are nested in a tree-like structure, rooted on file generation intentions:

```
File intentions
 ├ Global variable intentions
 ├ Global function intentions
 ├ Class intentions
 │ ├ Property generation intentions
 │ ├ Init generation intentions
 │ └ Method generation intentions
 ├ Struct intentions
 │ ├ Property generation intentions
 │ ├ Init generation intentions
 │ └ Method generation intentions
 └ ... etc
```

Supplementary context and historical tracking is available to allow inspection of the origin of all intentions, including manipulations by intention modifying steps described bellow.

#### 3. Type resolving

The code is inspected with a type resolver (`ExpressionTypeResolver`) to assign each expression in each statement a type. This must be done so that AST rewriting passes that are applied later have access to semantic context for expressions.

This step is redone many times later during intention and AST rewriting steps to keep the type resolving data up to date with respect to source-code transformations.

#### 4. Intention rewriting

The final collection of intentions is passed to special steps that are free to change the structure of the generated intentions before actual outputting is performed.

These steps are provided via an `IntentionPassSource` protocol provided to `SwiftRewriter.init`, which should provide an array of `IntentionPass` objects to a `SwiftRewriter` instance. These intention passes are then fed the entire source code represented by the intermediary intention collection. Intention passes are free to delete, merge, rename, or create new source-generation intentions as they see fit.

This is the step of the process in which outside code altering processors are allowed to change the resulting program's structure at a higher level. Actual method body rewriting should be done in a separate step (AST rewriting).

- Intention passes are applied serially, in the same order as the `IntentionPassSource` provides them. A type resolving step is applied between each pass, before the intentions are fed to the next intention pass.

#### 5. AST rewriting

After intention rewriting has finished altering the program's structure, special AST rewriters used solely for method bodies are applied to all methods. This allows external objects to modify the Swift AST before the final code is generated.

Expression passes are provided via an `ASTRewriterPassSource` protocol provided to `SwiftRewriter.init`, which should provide an array of `ASTRewriterPass`-subtypes, which are then individually instantiated and applied to all method bodies in parallel.

- `ASTRwriterPass` types are instantiated for each method body to be run in parallel, in the same order as they are defined in `ASTRewriterPassSource`.
    - Types are provided instead of instances to allow instantiation on a per-method basis, allowing improved guarantees of multi-threading correctness of method bodies. Do note that correctness of multi-threading is only implied for method bodies, but not to the surrounding intention context the method body is contained within.
    - In other words, don't change intentions during AST rewriting!
- Expression types are resolved again after each individual rewriter pass finishes modifying the method's body, before the AST is handed to the next pass.
    - It is the sole responsibility of the rewriter pass to notify changes to source code have been made to allow deciding whether or not to update expression type information for each function, saving time in cases no modifications where made that require type re-evaluation.

#### 6. Code output

At the final step, the code is output via the `WriterOutput`-implementer object provided to `SwiftRewriter.init`.

Code is output per-file, with `WriterOutput` implementers handling the logic to create files and provide output buffers a rewriter instance.
