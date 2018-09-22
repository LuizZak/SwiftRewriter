# SwiftRewriter

[![CI Status](https://api.travis-ci.org/LuizZak/SwiftRewriter.svg?branch=swift4.2)](https://travis-ci.org/LuizZak/SwiftRewriter?branch=swift4.2)

A program that aims to aid in automatization of conversion of Objective-C code into equivalent Swift code.

For information about how it's structured, see the [Architecture](Architecture.md) page.

#### Requirements

Xcode 10.0 & Swift 4.2

#### Usage

- From the working directory execute as follow:

```bash
swift run -c=release SwiftRewriter --colorize --target stdout files /path/to/MyClass.h /path/to/MyClass.m
```

###### Ommit `--colorize` to produce a clean string proper for saving to a file

- Run `swift run SwiftRewriter --help` flag to print usage information.

Usage:

```
USAGE: SwiftRewriter [--colorize|-c] [--print-expression-types|-t] [--print-tracing-history|-h] [--emit-objc-compatibility|-o] [--verbose|-v] [--num-threads|-t <n>] [--force-ll|-ll] [--target|-w stdout | filedisk] [files <files...> | path <path> [--exclude-pattern|-e <pattern>] [--include-pattern|-i <pattern>] [--skip-confirm|-s] [--overwrite|-o]]

OPTIONS:
  --colorize, -c          Pass this parameter as true to enable terminal colorization during output.
  --diagnose-file, -d     Provides a target file path to diagnose during rewriting.
After each intention pass and after expression passes, the file is written
to the standard output for diagnosing rewriting issues.
  --emit-objc-compatibility, -o
                          Emits '@objc' attributes on definitions, and emits NSObject subclass and NSObjectProtocol conformance on protocols.

This forces Swift to create Objective-C-compatible subclassing structures
which may increase compatibility with previous Obj-C code.
  --force-ll, -ll         Forces ANTLR parsing to use LL prediction context, instead of making an attempt at SLL first. May be more performant in some circumstances depending on complexity of original source code.
  --num-threads, -t       Specifies the number of threads to use when performing parsing, as well as intention and expression passes. If not specified, thread allocation is defined by the system depending on usage conditions.
  --print-expression-types, -e
                          Prints the type of each top-level resolved expression statement found in function bodies.
  --print-tracing-history, -p
                          Prints extra information before each declaration and member about the inner logical decisions of intention passes as they change the structure of declarations.
  --target, -w            Specifies the output target for the conversion.
Defaults to 'filedisk' if not provided.

    stdout
        Prints the conversion results to the terminal's standard output;
    
    filedisk
        Saves output of conersion to the filedisk as .swift files on the same folder as the input files.
  --verbose, -v           Prints progress information to the console while performing a transpiling job.
  --help                  Display available options

SUBCOMMANDS:
  files                   Converts one or more series of .h/.m files to Swift.
  path                    Examines a path and collects all .h/.m files to convert, before presenting a prompt to confirm conversion of files.
```

The program should output the contents of the files you pass into the standard output.

Example:

MyClass.h:
```objc
@interface MyClass : NSObject
@property (nonnull) NSString *name;
@property (nonnull) NSString *surname;

- (nonnull instancetype)initWithName:(nonnull NSString*)name surname:(nonnull NSString*)surname;
- (void)printMyName;
@end
```

MyClass.m:
```objc
@implementation MyClass
- (instancetype)initWithName:(NSString*)name surname:(NSString*)surname {
    self = [super init];
    if(self) {
        self.name = name;
        self.surname = surname;
    }
    return self;
}
- (void)printMyName {
    NSLog(@"%@ %@", self.name, self.surname);
}
@end
```

SwiftRewriter will output the given Swift code:

```swift
class MyClass: NSObject {
    var name: String
    var surname: String
    
    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
        super.init()
    }
    func printMyName() {
        NSLog("%@ %@", self.name, self.surname)
    }
}
```

#### Project goals

This is mostly a side project of mine to train my Swift and architecture chops. That being said, there are a couple of main goals that I have in mind going forward with this:

SwiftRewriter should:

1. Always produce valid Swift syntax as output (not necessarily _semantically_ valid, though);
2. Try to produce code that functions as close as possible to the original Objective-C source, with no surprises;
3. Try to do as much as possible of the tedious laborious work of converting syntax and getting it ready for the user to make the last manual changes that will inevitably be necessary;
4. Whenever possible, make automatic, semantically correct transformations that will save the user some time from doing it manually later;
5. Be extensible, as far as writing a new syntax/type-structure transformation pass is concerned. (for more info on transformation passes, see aformentioned [Architecture document page](Architecture.md))

Some other libraries and resources that are also concerned with automating the process of converting Objective-C to Swift to some degree include that I think are worth mentioning:

- [Yahoo's Objc2Swift](https://github.com/yahoojapan/objc2swift) makes language transformations, but it has shortcomings as far as making large transpilations go: Its grammar implementation lacks modern Objective-C features (such as generic types), and it makes no semantic transformations, doing AST conversions only. Main inspiration for writing this tool, I just thought augmenting it with a more modern Objective-C syntax and some semantical awareness would be nifty.

- [Objc2Swift.js](http://okaxaki.github.io/objc2swift/index.html) is a more fully-fledged, nifty converter that is semantically-aware and attempts to produce working code while respecting semantics, but it does not currently support emitting Swift 3 and 4-compatible code.

- [Swiftify](https://objectivec2swift.com/) is a comercial product which does many high and low-level transformations, producing code that appears to be (I haven't tested it much, tbh) nearly fully-functioning Swift code.
