# SwiftRewriter

A program that aims to aid in automatization of conversion of Objective-C code into equivalent Swift code.

#### Requirements

Xcode Version 9.3 beta (9Q98q) & Swift 4.1

#### Usage

From the working directory execute as follow:

```bash
swift run -c=release SwiftRewriter --colorize files /path/to/MyClass.h /path/to/MyClass.m
```

###### Ommit `--colorize` to produce a clean string proper for saving to a file

The program should output the contents of the files you pass into the standard output.

Example:

MyClass.h:
```objc
@interface MyClass : NSObject
@property (nonnull) NSString *name;
@property (nonnull) NSString *surname;

- (void)printMyName;
@end
```

MyClass.m:
```objc
@implementation MyClass
- (void)printMyName {
    NSLog(@"%@ %@", self.name, self.surname);
}
@end
```

SwiftRewriter will output the given Swift code:

```swift
@objc
class MyClass: NSObject {
    @objc var name: String
    @objc var surname: String
    
    @objc
    func printMyName() {
        NSLog("%@ %@", self.name, self.surname)
    }
}
```
