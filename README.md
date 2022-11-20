# SwiftRewriter

| Platform | Build Status |
|----------|--------|
| macOS    | [![Build Status](https://dev.azure.com/luiz-fs/SwiftRewriter/_apis/build/status/LuizZak.SwiftRewriter?branchName=master&jobName=macOS)](https://dev.azure.com/luiz-fs/SwiftRewriter/_build/latest?definitionId=3&branchName=master) |
| Linux    | [![Build Status](https://dev.azure.com/luiz-fs/SwiftRewriter/_apis/build/status/LuizZak.SwiftRewriter?branchName=master&jobName=Linux)](https://dev.azure.com/luiz-fs/SwiftRewriter/_build/latest?definitionId=3&branchName=master) |

[![codecov](https://codecov.io/gh/LuizZak/SwiftRewriter/branch/master/graph/badge.svg?token=xoSZNXwFLG)](https://codecov.io/gh/LuizZak/SwiftRewriter)

A program that aims to aid in automatization of conversion of Objective-C code into equivalent Swift code.

An experimental WIP JavaScript frontend is also available.

For information about how it's structured, see the [Architecture](Architecture.md) page.

#### Example

Given the following files:

MyClass.h:
```objc
/// A simple class to store names
@interface MyClass : NSObject
/// First name
@property (nonnull) NSString *name;
/// Last name
@property (nonnull) NSString *surname;

- (nonnull instancetype)initWithName:(nonnull NSString*)name surname:(nonnull NSString*)surname;
/// Prints the full name to the standard output
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

Running SwiftRewriter as shown:

```bash
$ swift run SwiftRewriter files --colorize --target stdout MyClass.h MyClass.m
```

will produce the following Swift file in the standard output:

```swift
/// A simple class to store names
class MyClass: NSObject {
    /// First name
    var name: String
    /// Last name
    var surname: String

    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
        super.init()
    }

    /// Prints the full name to the standard output
    func printMyName() {
        NSLog("%@ %@", self.name, self.surname)
    }
}
```

#### Requirements

Xcode 14 & Swift 5.7.1

#### Usage

- From the working directory execute as follows:

```bash
$ swift run -c=release SwiftRewriter files --colorize --target stdout /path/to/MyClass.h /path/to/MyClass.m
```

- To convert a directory containing Objective-C files (recursively), saving resulting .swift files to disk, execute as follows:

```bash
$ swift run -c=release SwiftRewriter path /path/to/project/
```

- Run `swift run SwiftRewriter --help` to print the full reference of command line arguments SwiftRewriter accepts. Reference also available bellow (for `path` subcommand):

Usage:

```
OVERVIEW: 
Main frontend API for SwiftRewriter. Allows selection of specific source language modes.

USAGE: SwiftRewriter <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  objc (default)          Objective-C code conversion frontend
  js                      JavaScript code conversion frontend [EXPERIMENTAL]

  See 'SwiftRewriter help <subcommand>' for detailed help.
```

Objective-C frontend command arguments:

`> swift run SwiftRewriter objc path --help`

```
OVERVIEW: 

Examines a path and collects all .h/.m files to convert, before presenting a prompt to confirm conversion of files.

USAGE: SwiftRewriter path <options>

ARGUMENTS:
  <path>                  Path to the project to inspect 

OPTIONS:
  -e, --exclude-pattern <exclude-pattern>
                          Provides a file pattern for excluding matches from the initial Objective-C files search. Pattern is applied to the full path. 
  -i, --include-pattern <include-pattern>
                          Provides a pattern for including matches from the initial Objective-C files search. Pattern is applied to the full path. --exclude-pattern takes priority over --include-pattern
                          matches. 
  -s, --skip-confirm      Skips asking for confirmation prior to parsing. 
  -o, --overwrite         Overwrites any .swift file with a matching output name on the target path. 
  -c, --colorize          Pass this parameter as true to enable terminal colorization during output. 
  -e, --print-expression-types
                          Prints the type of each top-level resolved expression statement found in function bodies. 
  -p, --print-tracing-history
                          Prints extra information before each declaration and member about the inner logical decisions of intention passes as they change the structure of declarations. 
  -v, --verbose           Prints progress information to the console while performing a transpiling job. 
  -t, --num-threads <num-threads>
                          Specifies the number of threads to use when performing parsing, as well as intention and expression passes. If not specified, thread allocation is defined by the system
                          depending on usage conditions. 
  --force-ll              Forces ANTLR parsing to use LL prediction context, instead of making an attempt at SLL first. May be more performant in some circumstances depending on complexity of original
                          source code. 
  --emit-objc-compatibility
                          Emits '@objc' attributes on definitions, and emits NSObject subclass and NSObjectProtocol conformance on protocols.

                          This forces Swift to create Objective-C-compatible subclassing structures
                          which may increase compatibility with previous Obj-C code. 
  --diagnose-file <diagnose-file>
                          Provides a target file path to diagnose during rewriting.
After each intention pass and after expression passes, the file is written
                          to the standard output for diagnosing rewriting issues. 
  -w, --target <target>   Specifies the output target for the conversion.
Defaults to 'filedisk' if not provided.

    stdout
        Prints the conversion results to the terminal's standard output;
    
                              filedisk
                                  Saves output of conversion to the filedisk as .swift files on the same folder as the input files. 
  -f, --follow-imports    Follows #import declarations in files in order to parse other relevant files. 
  -h, --help              Show help information.
```

The program should output the contents of the files you pass into the standard output.

#### Project goals

This is mostly a side project of mine to train my Swift and architecture chops. That being said, there are a couple of main goals that I have in mind going forward with this:

SwiftRewriter should:

1. Always produce valid Swift syntax as output (not necessarily _semantically_ valid, though);
2. Try to produce code that functions as close as possible to the original Objective-C source, with no surprises;
3. Try to do as much as possible of the tedious laborious work of converting syntax and getting it ready for the user to make the last manual changes that will inevitably be necessary;
4. Whenever possible, make automatic, semantically correct transformations that will save the user some time from doing it manually later;
5. Be extensible, as far as writing a new syntax/type-structure transformation pass is concerned. (for more info on transformation passes, see aforementioned [Architecture document page](Architecture.md))

Some other libraries and resources that are also concerned with automating the process of converting Objective-C to Swift to some degree include that I think are worth mentioning:

- [Yahoo's Objc2Swift](https://github.com/yahoojapan/objc2swift) makes language transformations, but it has shortcomings as far as making large transpilations go: Its grammar implementation lacks modern Objective-C features (such as generic types), and it makes no semantic transformations, doing AST conversions only. Main inspiration for writing this tool, I just thought augmenting it with a more modern Objective-C syntax and some semantical awareness would be nifty.

- [Objc2Swift.js](http://okaxaki.github.io/objc2swift/index.html) is a more fully-fledged, nifty converter that is semantically-aware and attempts to produce working code while respecting semantics, but it does not currently support emitting Swift 3, 4 and 5-compatible code.

- [Swiftify](https://objectivec2swift.com/) is a comercial product which does many high and low-level transformations, producing code that appears to be (I haven't tested it much, tbh) nearly fully-functioning Swift code.
