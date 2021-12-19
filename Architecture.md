### NOTE:

Since the frontend-related refactoring work this document is out of date, and should be updated once the frontend changes have stabilized.

---

## Architectural description

The tool splits the conversion process into six discrete steps, which are, whenever possible, divided into separate project targets.

```
┌─────────────┐ ┌──────────────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌────────────────┐ ┌──────────┐
│      1.     │ │          2.          │ │      3.     │ │      4.     │ │      5.     │ │       6.       │ │    7.    │
│ Objective-C ├─┤ Statements parsing/  ├─┤    Type     ├─┤  Intention  ├─┤     AST     ├─┤ Post-rewriting ├─┤   Code   │
│   parsing   │ │ Intention generation │ │  resolving  │ │  rewriting  │ │  rewriting  │ │   formatting   │ │  output  │
└─────────────┘ └──────────────────────┘ └─────────────┘ └─────────────┘ └─────────────┘ └────────────────┘ └──────────┘
```

All of these steps are encapsulated and run by `SwiftRewriter` within the `SwiftRewriterLib` target.

An overview of the steps taken is described bellow.

#### 1. Objective-C parsing

A mixture of tooled and manual parsing is used on input .h/.m files to parse.

The input source code is provided via an `InputSourcesProvider`-implementer provided to `SwiftRewriter.init`. This object should provide the input source code files to parse encapsulated behind objects implementing a `CodeSource` protocol. This protocol provides semantic information about the origin of a source snippet, which can be used during later steps to aid in tracing back the origin of a source code construct.

The source code is then processed by `SourcePreprocessor` objects provided to `SwiftRewriter.init`. These pre-processors have access to the raw string data for the files, and can be used to apply transformations such as comment removal or preprocessor expansion before actual parsing is done for each file.

For the tooled part, [ANTLR](http://www.antlr.org/) is used to do the heavy lifting and parse all the input source code, and a couple of more fine-grained parsing steps are performed manually with `ObjcParser` (mainly Objective-C type signature parsing).

All input parsing for a single file can be done with just an `ObjcParser` instance.

Since trees produced by ANTLR are too heavyweight and reflect a lot of the complexity of Objective-C's grammar (which itself is complex due to the necessity to parse virtually any valid Objective-C source code), the produced AST is converted into a customized AST representation that is more useful for manipulation, rooted into a base `ASTNode` class.

The source code for the AST class structure used is found inside the `GrammarModels` target, and is used throughout the rest of the process to inspect the input AST.

#### 2. Statements parsing

Parsing of Objective-C method bodies is postponed to after all files are parsed. This helps ensure we can produce a statement tree that has full visibility of all symbols and classes. This is relevant for the initial type-parsing and typealias generation steps.

Statements are parsed into a customized AST for representing Swift grammars, contained within the `SwiftAST` target.

- Unlike high level constructs such as classes and global definitions, no intermediary representation is used to represent statement AST's between Objective-C and Swift, and the source code is translated directly from the ANTLR-produced tree for the Objective-C code into a Swift AST structure, for all method bodies.

#### 2.1 Intention generation

The complete grammar tree is then analyzed and grouped up into sets of objects that encapsulate the intent of creating matching Swift source code for each object from the original Objective-C source code. These structures are aptly named `Intentions`. Many intention types are used to represent the final Swift source code that the tool will generate.

Source code statements/expressions are not split into individual intentions; these constructs remains encapsulated behind SwiftAST trees, which are contained within `FunctionBodyIntention` instances, one for each method body.

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

This step is redone many times later during intention and AST rewriting steps to keep the typing information data up to date with respect to source-code transformations.

#### 4. Intention rewriting

The final collection of intentions is passed to special steps that are free to change the structure of the generated intentions before actual outputting is performed.

These steps are represented by an `IntentionPass` protocol, which is fed to a `SwiftRewriter` via an instance of `IntentionPassSource`. These intention passes are then fed the entire source code represented by the intermediary intention collection. Intention passes are free to delete, merge, rename, or create new source-generation intentions.

This is the step of the process in which external code-altering processors are allowed to change the resulting program's structure at a higher level. Actual method body rewriting should be done in a separate step (see [AST rewriting](#ASTRewriting)).

- Intention passes are applied serially, in the same order as the `IntentionPassSource` provides them. Type resolution is invoked between each intention pass to keep the typing information up-to-date with respect to general source code transformations.

#### 5. AST Rewriting

After intention rewriting has finished altering the program's structure, special AST rewriters used solely for method bodies are applied to all methods. This allows external objects to modify the Swift AST before the final code is generated.

Expression passes are provided via an `ASTRewriterPassSource` protocol provided to `SwiftRewriter.init`, which should provide an array of `ASTRewriterPass`-subtypes, which are then individually instantiated and applied to all method bodies in parallel.

- `ASTRewriterPass` types are instantiated for each method body to be run in parallel, in the same order as they are defined in `ASTRewriterPassSource`.
    - Types are provided instead of instances to allow instantiation on a per-method basis, with the goal of improved guarantees of multi-threading correctness when manipulating all method bodies simultaneously. Do note that correctness of multi-threading is only implied for method bodies, but not to the surrounding intention context the method body is contained within.
        - In other words, don't change intentions during the AST rewriting phase.
- Expression types are resolved again after each individual rewriter pass finishes modifying the method's body, before the AST is handed to the next pass.
    - Rewriter passes must notify when changes are made via `ASTRewriterPassContext.notifyChangedTree` to allow type resolution to kick in in between rewriter passes.

#### 6. Post-rewriting formatting

At this point, a syntax tree produced by [`swift-syntax`](https://github.com/apple/swift-syntax) is produced and passed to intermediary syntax rewriters that implement `SwiftSyntaxRewriterPass`, which refine the final AST before output.

All syntax rewriters are contained in the target named `SwiftSyntaxRewriterPasses`.

#### 7. Code output

At the final step, the code is output to an implementer of `WriterOutput` fed to `SwiftRewriter.init`.

Code is output in a per-file basis.

Specifics of what files will be exported are commanded by intention passes (mainly by `FileTypeMergingIntentionPass`), such that code is produced 1:1 with original header/implementation files fed to the transpiler.
