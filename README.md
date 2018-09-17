# SwiftRewriter

[![CI Status](https://api.travis-ci.org/LuizZak/SwiftRewriter.svg?branch=swift4.2)](https://travis-ci.org/LuizZak/SwiftRewriter?branch=swift4.2)

A program that aims to aid in automatization of conversion of Objective-C code into equivalent Swift code.

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
SwiftRewriter [--colorize] [--print-expression-types] [--print-tracing-history] [--emit-objc-compatibility] [--verbose] [--num-threads <n>]
[--force-ll] [--target stdout | filedisk] [files <files...> | path <path> [--exclude-pattern <pattern>] [--include-pattern <pattern>] [--skip-confirm] [--overwrite]]

OPTIONS:
  --colorize              Pass this parameter as true to enable terminal colorization during output.
  --diagnose-file         Provides a target file path to diagnose during rewriting.
After each intention pass and after expression passes, the file is written
to the standard output for diagnosing rewriting issues.
  --emit-objc-compatibility
                          Emits '@objc' attributes on definitions, and emits NSObject subclass and NSObjectProtocol conformance on protocols.

This forces Swift to create Objective-C-compatible subclassing structures
which may increase compatibility with previous Obj-C code.
  --force-ll              Forces ANTLR parsing to use LL prediction context, instead of making an attempt at SLL first. May be more performant in some circumstances depending on complexity of original source code.
  --num-threads           Specifies the number of threads to use when performing parsing, as well as intention and expression passes. If not specified, thread allocation is defined by the system depending on usage conditions.
  --print-expression-types
                          Prints the type of each top-level resolved expression statement found in function bodies.
  --print-tracing-history
                          Prints extra information before each declaration and member about the inner logical decisions of intention passes as they change the structure of declarations.
  --target                Specifies the output target for the conversion.
Defaults to 'filedisk' if not provided.

    stdout
        Prints the conversion results to the terminal's standard output;
    
    filedisk
        Saves output of conersion to the filedisk as .swift files on the same folder as the input files.
  --verbose               Prints progress information to the console while performing a transpiling job.
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
