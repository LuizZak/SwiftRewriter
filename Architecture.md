## Architectural description

The tool splits the conversion process into a couple of discrete steps, which are mostly divided into separate targets:

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

The input source code is provided via an `InputSourcesProvider`-implementer provided during a construction of a `SwiftRewriter` instance. This object should provide the input source code files to parse encapsulated behind objects implementing a `CodeSource` protocol.

For the tooled part, [ANTLR](http://www.antlr.org/) is used to do the heavy lifting job of parsing all the input source code, and a couple of more fine-grained parsing steps are performed manually with `ObjcParser`.

All input parsing for a single file can be done with just an `ObjcParser` instance.

Since the tree produced by ANTLR is too heavyweight and a reflection of the complexity of the original grammar file (which itself is complex due to the necessity to parse virtually any valid Objective-C code), the produced AST is converted into a customized AST tree representation that is more useful for manipulation. The source code for the AST tree produced is contained within `GrammarModels`, and is used throught the project to inspect the AST.

#### 2. Statements parsing

Parsing of Objective-C method bodies is postponed to after all files are parsed. This helps ensure we can produce a statement tree that has full visibility of all symbols and classes. This is relevant for the initial type-parsing and typealias generation steps.

Statements are parsed into a customized AST for representing Swift grammars, contained within the `SwiftAST` target.

#### 2.1 Intention generation

The complete grammar tree is then converted into sets of objects that encapsulate the intent of creating matching Swift source code/structures for each object from the original Objective-C source code. These set of structures are aptly named `Intentions`, and many intention classes are present and are used to fully represent the resulting source-code, structurally speaking.

Intentions are not used to split individual code statements/expressions; this source code remains encapsulated behind SwiftAST trees.

Intentions are nested in a tree-like fashion, rooted on a file-generation intention.

```
File intention
 ├ Class intention
 │ ├ Property generation intention
 │ ├ Init generation intention
 │ └ Method generation intention
 ├ Struct intention
 │ ├ Property generation intention
 │ ├ Init generation intention
 │ └ Method generation intention
 └ ... etc
```

Supplementary context and historical tracking is available to allow inspection of origin for each intention, and any manipulation performed on them by intention rewriting steps.

#### 3. Type resolving

The code is inspected with a customized type resolver to assign each expression in each statement a resulting type. This must be done so that upcoming AST rewriting passes have access to a useful semantic context for expressions.

This step is actually redone many times each time the AST is rewriten by an intention or AST pass.

#### 4. Intention rewriting

The final collection of intentions is passed to a special step that allows rewriting the structure of the generated source code before actual outputting is performed.

These steps are provided via an `IntentionPassSource` protocol provided during `SwiftRewriter.init`, which should provide an array of `IntentionPass` objects to a `SwiftRewriter` instance. These intention passes are then fed the entire source code represented by the intermediary intention collection. Intention passes are free to delete, merge, rename, or create new source-generation intentions as they see fit.

This is the step of the process in which outside code altering processors are allowed to change the resulting program's structure at a higher level. Actual method body rewriting should be done in a separate step (AST rewriting).

- Intention passes are applied serially, in the same order as the `IntentionPassSource` provides them. A type resolving step is applied between each pass, before the intentions are fed to the next intention pass.

#### 5. AST rewriting

After intention rewriting has finished altering the program's structure, special AST rewriters used solely for method bodies are applied to all methods in all files to generate. This allows external objects to apply customized logic to rewrite the original AST into more correct Swift source code.

Expression passes are provided via an `ASTRewriterPassSource` protocol provided during `SwiftRewriter.init`, which should provide an array of `ASTRewriterPass`-subtypes, which are then individually instantiated and applied to all method bodies in parallel.

- `ASTRwriterPass` types are instantiated for each method body to be run in parallel, in the same order as they are defined in `ASTRewriterPassSource`. This is done to improve guarantees about multi-threading modification of method bodies.
- Expression types for a method are resolved after each individual rewriter pass finishes modifying the method's body.

#### 6. Code output

At the final step, the code is output via the `WriterOutput`-implementer object provided during `SwiftRewriter.init`.

Code is output per-file, with `WriterOutput` implementers handling the logic to create files and provide output buffers a rewriter instance.
