import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class SwiftRewriter_MultiFilesTests: XCTestCase {
    
    func testReadmeSampleMerge() {
        assertThat()
            .file(name: "MyClass.h",
            """
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
            """)
            .file(name: "MyClass.m",
            """
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
            """)
            .translatesToSwift("""
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
            // End of file MyClass.swift
            """)
    }
    
    func testEmittingHeaderWhenMissingImplementation() {
        assertThat()
            .file(name: "objc.h",
            """
            @interface MyClass
            - (void)myMethod;
            @end
            """)
            .translatesToSwift(
            """
            class MyClass {
                func myMethod() {
                }
            }
            // End of file objc.swift
            """)
    }
    
    func testAvoidEmittingHeaderWhenImplementationExists() {
        assertThat()
            .file(name: "objc.h",
            """
            @interface MyClass
            - (void)myMethod;
            @end
            """)
            .file(name: "objc.m",
            """
            @implementation MyClass
            - (void)myMethod {
            }
            @end
            """)
            .translatesToSwift(
            """
            class MyClass {
                func myMethod() {
                }
            }
            // End of file objc.swift
            """)
    }
    
    func testProcessAssumeNonnullAcrossFiles() {
        assertThat()
            .file(name: "objc.h",
            """
            NS_ASSUME_NONNULL_BEGIN
            @interface MyClass
            @property NSString *property;
            - (id)myMethod:(NSString*)parameter;
            @end
            NS_ASSUME_NONNULL_END
            """)
            .file(name: "objc.m",
            """
            @implementation MyClass
            - (id)myMethod:(NSString*)parameter {
            }
            @end
            """)
            .translatesToSwift(
            """
            class MyClass {
                var property: String
            
                func myMethod(_ parameter: String) -> AnyObject {
                }
            }
            // End of file objc.swift
            """)
    }
    
    func testClassCategory() {
        assertThat()
            .file(name: "MyClass.h",
            """
            @interface MyClass
            - (void)originalMethod;
            @end
            """)
            .file(name: "MyClass.m",
            """
            @implementation MyClass
            - (void)originalMethod {
            }
            @end
            """)
            .file(name: "MyClass+Ext.h",
            """
            @interface MyClass (Extension)
            - (void)fromExtension;
            - (void)fromExtensionInterfaceOnly;
            @end
            """)
            .file(name: "MyClass+Ext.m",
            """
            @implementation MyClass (Extension)
            - (void)fromExtension {
            }
            @end
            """)
            .translatesToSwift(
            """
            // MARK: - Extension
            extension MyClass {
                func fromExtension() {
                }
                func fromExtensionInterfaceOnly() {
                }
            }
            // End of file MyClass+Ext.swift
            class MyClass {
                func originalMethod() {
                }
            }
            // End of file MyClass.swift
            """)
    }
    
    /// When merging categories in .h/.m files, try to group them by matching
    /// category name on the resulting .swift file, such that `extension`s are
    /// declared for each combined category name.
    func testMergingCategoriesTakeCategoryNameInConsideration() {
        assertThat()
            .file(name: "Class.h",
            """
            @interface MyClass
            @end
            """)
            .file(name: "Class.m",
            """
            @implementation MyClass
            @end
            """)
            .file(name: "Class+Ext.h",
            """
            @interface MyClass (Ext1)
            - (void)f1;
            @end
            @interface MyClass (Ext2)
            - (void)f2;
            @end
            """)
            .file(name: "Class+Ext.m",
            """
            @implementation MyClass (Ext1)
            - (void)f1 {
                stmt1();
            }
            @end
            @implementation MyClass (Ext2)
            - (void)f2 {
                stmt2();
            }
            @end
            """)
            .translatesToSwift("""
            // MARK: - Ext1
            extension MyClass {
                func f1() {
                    stmt1()
                }
            }
            // MARK: - Ext2
            extension MyClass {
                func f2() {
                    stmt2()
                }
            }
            // End of file Class+Ext.swift
            class MyClass {
            }
            // End of file Class.swift
            """)
    }
    
    func testRespectsOrderingOfImplementation() {
        // Tests that when coming up with the ordering of the method definitions
        // within a file, try to stick with the ordering of the methods as they
        // are on the @implementation for the class.
        assertThat()
            .file(name: "file.h",
            """
            @interface MyClass
            - (void)doOtherThing;
            - (void)doThing;
            @end
            """)
            .file(name: "file.m",
            """
            @implementation MyClass
            - (instancetype)initWithThing:(id)thing {
            }
            - (void)doThing {
            }
            - (void)doOtherThing {
            }
            @end
            """)
            .translatesToSwift("""
            class MyClass {
                init(thing: AnyObject!) {
                }

                func doThing() {
                }
                func doOtherThing() {
                }
            }
            // End of file file.swift
            """)
    }
    
    func testTypeLookupsHappenAfterAllSourceCodeIsParsed() {
        assertThat()
            .file(name: "A.h",
            """
            typedef NS_ENUM(NSString*, AnEnum) {
                AnEnumCase1
            };
            
            B *globalB;
            @interface A
            {
                B* ivarB;
            }
            // Should translate to 'B', and not 'UnsafeMutablePointer<B>!'
            @property (nonnull) B *b;
            - (B*)takesB:(B*)b;
            - (instancetype)initWithB:(B*)b;
            @end
            """)
            .file(name: "B.h",
            """
            @interface B
            @end
            """)
            .translatesToSwift("""
            enum AnEnum: String {
                case AnEnumCase1
            }
            
            var globalB: B!
            
            class A {
                private var ivarB: B!
                // Should translate to 'B', and not 'UnsafeMutablePointer<B>!'
                var b: B
            
                init(b: B!) {
                }

                func takesB(_ b: B!) -> B! {
                }
            }
            // End of file A.swift
            class B {
            }
            // End of file B.swift
            """)
    }
    
    func testChainCallRespondsToSelectorWithReproCase() {
        assertThat()
            .file(name: "A.h",
            """
            #pragma mark - Delegate
            @class Class;
            @protocol Delegate <NSObject>
            - (void)delegateMethod:(nonnull Class*)cls;
            @end

            @interface Class : UIView
            @property (weak, nullable) id<Delegate> delegate;
            @end

            NS_ASSUME_NONNULL_END
            """)
            .file(name: "A.m", """
            @implementation Class
            #pragma mark - Calculation methods
            - (void)method
            {
                (self.delegate);
                [self.delegate respondsToSelector:@selector(delegateMethod:)];
                if([self.delegate respondsToSelector:@selector(delegateMethod:)])
                {
                    [self.delegate delegateMethod:self];
                }
            }
            @end
            """)
            .translatesToSwift("""
            // Preprocessor directives found in file:
            // #pragma mark - Delegate
            // #pragma mark - Calculation methods
            protocol Delegate {
                func delegateMethod(_ cls: Class)
            }

            class Class: UIView {
                weak var delegate: Delegate?
            
                func method() {
                    // type: Delegate?
                    self.delegate
                    // type: Bool?
                    self.delegate?.responds(to: Selector("delegateMethod:"))
            
                    if self.delegate?.responds(to: Selector("delegateMethod:")) == true {
                        // type: Void?
                        self.delegate?.delegateMethod(self)
                    }
                }
            }
            // End of file A.swift
            """, options: SwiftSyntaxOptions.default.with(\.outputExpressionTypes, true))
    }
    
    func testPreserversAssumesNonnullContextAfterMovingDeclarationsFromHeaderToImplementation() {
        assertThat()
            .file(name: "A.h", """
            NS_ASSUME_NONNULL_BEGIN
            typedef void(^errorBlock)(NSString *param);
            NS_ASSUME_NONNULL_END
            """)
            .file(name: "A.m", """
            @interface A
            @end
            """)
            .translatesToSwift("""
            typealias errorBlock = (String) -> Void

            class A {
            }
            // End of file A.swift
            """)
    }
    
    func testMergeNullabilityOfBlockTypes() {
        assertThat()
            .file(name: "A.h", """
            NS_ASSUME_NONNULL_BEGIN
            @interface A
            - (void)method:(void(^)(NSString*))param;
            @end
            NS_ASSUME_NONNULL_END
            """)
            .file(name: "A.m", """
            @implementation A
            - (void)method:(void(^)(NSString*))param {
            }
            @end
            """)
            .translatesToSwift("""
            class A {
                func method(_ param: (String) -> Void) {
                }
            }
            // End of file A.swift
            """)
    }
    
    func testMergeNullabilityOfExternGlobals() {
        assertThat()
            .file(name: "A.h", """
            NS_ASSUME_NONNULL_BEGIN
            extern NSString *const kCPTableMenuViewReuseIdentifier;
            NS_ASSUME_NONNULL_END
            """)
            .file(name: "A.m", """
            NSString *const kCPTableMenuViewReuseIdentifier = @"cell";
            """)
            .translatesToSwift("""
            let kCPTableMenuViewReuseIdentifier: String = "cell"
            // End of file A.swift
            """)
    }
    
    func testMergeAndKeepNullabilityDefinitions() {
        assertThat()
            .file(name: "A.h", """
            @interface A
            @property CGFloat width;
            @end
            """)
            .file(name: "A.m", """
            @implementation A
            @end
            """)
            .file(name: "B.h", """
            @interface B
            @property (nullable) A* a;
            - (void)takesCGFloat:(CGFloat)f;
            @end
            """)
            .file(name: "B.m", """
            @implementation B
            - (void)method {
                [self takesCGFloat:a.width];
            }
            - (void)takesCGFloat:(CGFloat)f {
            }
            @end
            """)
            .translatesToSwift("""
            class A {
                var width: CGFloat = 0.0
            }
            // End of file A.swift
            class B {
                var a: A?
            
                func method() {
                    self.takesCGFloat(a?.width ?? 0.0)
                }
                func takesCGFloat(_ f: CGFloat) {
                }
            }
            // End of file B.swift
            """)
    }
    
    func testHandleMultifileTypesInheritingFromTypesDefinedInGlobalProviders() {
        assertThat()
            .file(name: "A.h", """
            @interface A: UIView
            @property (nullable) B* b;
            @end
            """)
            .file(name: "A.m", """
            @implementation A
            - (void)test {
                (self.window.bounds);
                (self.b.bounds);
            }
            @end
            """)
            .file(name: "B.h", """
            @interface B: UIView
            @end
            """)
            .translatesToSwift(
            """
            class A: UIView {
                var b: B?
            
                func test() {
                    // type: CGRect?
                    self.window?.bounds
                    // type: CGRect?
                    self.b?.bounds
                }
            }
            // End of file A.swift
            class B: UIView {
            }
            // End of file B.swift
            """,
            options: SwiftSyntaxOptions.default.with(\.outputExpressionTypes, true))
    }
    
    func testProtocolConformanceHandling() {
        let assert = assertThat()
            .file(name: "Protocol.h", """
            @protocol Protocol <NSObject>
            - (nullable NSString*)protocolRequirement;
            - (nonnull NSString*)otherProtocolRequirement;
            @end
            """)
            .file(name: "Class.h", """
            @interface Class
            @end
            """)
            .file(name: "Class.m", """
            @implementation Class
            @end
            """)
            .file(name: "Class+Protocol.h", """
            @interface Class (Protocol) <Protocol>
            - (nullable NSString*)protocolRequirement;
            @end
            """)
            .file(name: "Class+Protocol.m", """
            @implementation Class (Protocol)
            - (NSString*)protocolRequirement {
                return nil;
            }
            - (NSString*)otherProtocolRequirement {
                return @"";
            }
            @end
            """)
                
        assert
            .expectSwiftFile(name: "Class.swift", """
            class Class {
            }
            // End of file Class.swift
            """)
            .expectSwiftFile(name: "Class+Protocol.swift", """
            // MARK: - Protocol
            extension Class: Protocol {
                func protocolRequirement() -> String? {
                    return nil
                }
                func otherProtocolRequirement() -> String {
                    return ""
                }
            }
            // End of file Class+Protocol.swift
            """)
            .expectSwiftFile(name: "Protocol.swift", """
            protocol Protocol {
                func protocolRequirement() -> String?
                func otherProtocolRequirement() -> String
            }
            // End of file Protocol.swift
            """)
            .transpile()
            .assertExpectedSwiftFiles()
    }
    
    func testMergeStructsFromHeaderAndImplementation() {
        assertThat()
            .file(name: "A.h", """
            typedef struct Aimpl A;
            """)
            .file(name: "A.m", """
            struct Aimpl {
                int a;
            };
            """)
            .translatesToSwift("""
            typealias A = Aimpl
            
            struct Aimpl {
                var a: CInt
            
                init() {
                    a = 0
                }
                init(a: CInt) {
                    self.a = a
                }
            }
            // End of file A.swift
            """)
    }
    
    func testMergePropertyConformanceWithMethodInImplementation() {
        assertThat()
            .file(name: "A.h", """
            @protocol DateConvertible <NSObject>
            
            @property (nullable, readonly) NSDate *asDate;

            @end

            @interface NSString (QuickDateExtensions) <DateConvertible>
            
            @end
            """)
            .file(name: "A.m", """
            @implementation NSString (QuickDateExtensions)
            
            - (NSDate*)asDate
            {
                return [NSDate date];
            }
            
            @end
            """)
            .translatesToSwift("""
            protocol DateConvertible {
                var asDate: Date? { get }
            }

            // MARK: - QuickDateExtensions
            extension String: DateConvertible {
                var asDate: Date? {
                    return Date()
                }
            }
            // End of file A.swift
            """)
    }
    
    func testMergePropertyConformanceWithMethodInImplementationSynergy() {
        assertThat()
            .file(name: "A.h", """
            @protocol DateConvertible <NSObject>
            
            @property (nullable, readonly) NSDate *asDate;

            @end

            @interface NSString (QuickDateExtensions) <DateConvertible>
            
            // This should not be duplicated on the final emitted type!
            @property (nullable, readonly) NSDate *asDate;
            
            @end
            """)
            .file(name: "A.m", """
            @implementation NSString (QuickDateExtensions)
            
            - (NSDate*)asDate
            {
                return [NSDate date];
            }
            
            @end
            """)
            .translatesToSwift("""
            protocol DateConvertible {
                var asDate: Date? { get }
            }

            // MARK: - QuickDateExtensions
            extension String: DateConvertible {
                // This should not be duplicated on the final emitted type!
                var asDate: Date? {
                    return Date()
                }
            }
            // End of file A.swift
            """)
    }
    
    func testIgnoresNonPrimaryFileInputs() {
        assertThat()
            .file(name: "A.h", """
            @interface A
            @end
            """, isPrimary: true)
            .file(name: "B.h", """
            @interface B
            @end
            """, isPrimary: false)
            .translatesToSwift("""
            class A {
            }
            // End of file A.swift
            """)
    }
    
    func testNonPrimaryFilesContributeToPrimaryFileAnalysis() {
        // Test that non-primary files are actually contributing to analysis on
        // primary files by checking that 'B' is detected as a class and is not
        // turning into an UnsafeMutablePointer<B>! type
        assertThat()
            .file(name: "A.h", """
            @interface A
            @property B *b;
            @end
            """, isPrimary: true)
            .file(name: "B.h", """
            @interface B
            @end
            """, isPrimary: false)
            .translatesToSwift("""
            class A {
                var b: B!
            }
            // End of file A.swift
            """)
    }
    
    func testNonPrimaryFilesMerge() {
        // Tests that non-primary files are still susceptible to merging into
        // primary files
        assertThat()
            .file(name: "objc.h",
            """
            @interface MyClass
            @property (nonnull) NSString *property;
            - (nonnull id)myMethod:(nonnull NSString*)parameter;
            @end
            """, isPrimary: false)
            .file(name: "objc.m",
            """
            @implementation MyClass
            - (id)myMethod:(NSString*)parameter {
            }
            @end
            """)
            .translatesToSwift(
            """
            class MyClass {
                var property: String
            
                func myMethod(_ parameter: String) -> AnyObject {
                }
            }
            // End of file objc.swift
            """)
    }
    
    func testNSArrayExtensionDetection() {
        assertThat()
            .file(name: "NSArray+Ext.h",
            """
            NS_ASSUME_NONNULL_BEGIN
            @interface NSArray (Filtering)
            - (NSArray*)map:(id(^)(ObjectType obj))mapper __attribute__((warn_unused_result));
            - (NSArray<ObjectType>*)filter:(BOOL(^)(ObjectType obj))filter __attribute__((warn_unused_result));
            @end
            NS_ASSUME_NONNULL_END
            """)
            .file(name: "NSArray+Ext.m",
            """
            @implementation NSArray (Filtering)
            - (NSArray*)map:(id(^)(ObjectType obj))mapper {
                return self;
            }
            - (NSArray<ObjectType>*)filter:(BOOL(^)(ObjectType obj))filter {
                return self;
            }
            @end
            """)
            .file(name: "NSCollections+TypeSafe.h",
            """
            NS_ASSUME_NONNULL_BEGIN

            @protocol TypeSafeNavigable <NSObject>

            - (nullable __kindof NSArray*)arrayAt:(NSArray*)keyPath;
            - (nullable __kindof NSDictionary*)dictionaryAt:(NSArray*)keyPath;
            - (__kindof NSDictionary*)tryDictionaryAt:(NSArray*)keyPath;

            - (__kindof NSArray*)tryArrayAt:(NSArray*)keyPath;

            - (nullable __kindof NSDictionary*)tryDictionaryAt:(NSArray*)keyPath error:(NSError**)error;
            - (nullable __kindof NSArray*)tryArrayAt:(NSArray*)keyPath error:(NSError**)error;

            @end

            @interface NSDictionary (TypeSafe) <TypeSafeNavigable>
            @end

            @interface NSArray (TypeSafe) <TypeSafeNavigable>
            @end

            NS_ASSUME_NONNULL_END
            """)
            .file(name: "Resource.h",
            """
            @interface Resource
            @property (nullable) id ID;
            @property (nullable) id BP;
            @property (nullable) id firstName;
            @property (nullable) id lastName;
            @property (nullable) id middleName;
            @property (nullable) id mothersMaidenName;
            - (instancetype)init;
            @end
            """)
            .file(name: "Resource.m",
            """
            @implementation Resource
            @end
            """)
            .file(name: "A.h",
            """
            @interface A
            - (nullable id)doWork;
            @end
            """)
            .file(name: "A.m",
            """
            @implementation A
            - (id)doWork {
                NSDictionary *response = @{};
                NSArray *resources = [response tryArrayAt:@[@"data", @"user", @"getByProfile"] error:errorPtr];
                if(resources == nil)
                    return nil;
                
                // - Filter by bases
                // Start by transforming the bases array into an NSSet which is more efficient
                // for querying
                NSSet *baseIdsSet = [NSSet setWithArray:baseIds];
                
                NSArray *filtered =
                    [resources filter:^BOOL(NSDictionary *res) {
                        return [baseIdsSet containsObject:res[@"airbase"][@"id"]];
                    }];
                
                // Transform them into resource objects, now
                NSArray<CPResource*> *results =
                    [filtered map:^Resource*(NSDictionary *obj) {
                        Resource *resource = [[Resource alloc] init];
                        
                        resource.ID = obj[@"id"];
                        resource.BP = obj[@"bp"];
                        resource.firstName = AS(obj[@"firstName"], NSString);
                        resource.lastName = AS(obj[@"lastName"], NSString);
                        resource.middleName = AS(obj[@"middleName"], NSString);
                        resource.mothersMaidenName = AS(obj[@"mothersMaidenName"], NSString);
                        
                        return resource;
                    }];
                
                return results;
            }
            @end
            """)
            .expectSwiftFile(name: "A.swift",
            """
            class A {
                func doWork() -> AnyObject? {
                    // decl type: NSDictionary
                    // init type: NSDictionary
                    let response = [:]
                    // decl type: NSArray!
                    // init type: NSArray?
                    let resources = response.tryArrayAt(["data", "user", "getByProfile"], error: errorPtr)

                    if resources == nil {
                        return nil
                    }

                    // - Filter by bases
                    // Start by transforming the bases array into an NSSet which is more efficient
                    // for querying
                    // decl type: NSSet!
                    // init type: <<error type>>
                    let baseIdsSet: NSSet! = NSSet.setWithArray(baseIds)
                    // decl type: NSArray!
                    // init type: [ObjectType]?
                    let filtered = resources?.filter { (res: NSDictionary!) -> Bool in
                        return baseIdsSet.containsObject(res["airbase"]?["id"])
                    }
                    // decl type: [CPResource]
                    // init type: NSArray
                    let results = filtered.map { (obj: NSDictionary!) -> Resource! in
                        // Transform them into resource objects, now
                        // decl type: Resource
                        // init type: Resource
                        var resource = Resource()

                        // type: AnyObject?
                        resource.ID = obj["id"]
                        // type: AnyObject?
                        resource.BP = obj["bp"]
                        // type: AnyObject?
                        resource.firstName = AS(obj["firstName"], String)
                        // type: AnyObject?
                        resource.lastName = AS(obj["lastName"], String)
                        // type: AnyObject?
                        resource.middleName = AS(obj["middleName"], String)
                        // type: AnyObject?
                        resource.mothersMaidenName = AS(obj["mothersMaidenName"], String)

                        return resource
                    }

                    return results
                }
            }
            // End of file A.swift
            """)
            .transpile(options: SwiftSyntaxOptions(outputExpressionTypes: true,
                                                   printIntentionHistory: false,
                                                   emitObjcCompatibility: false))
            .assertExpectedSwiftFiles()
    }
}

extension SwiftRewriter_MultiFilesTests {
    private func assertThat() -> MultiFileTestBuilder {
        return MultiFileTestBuilder(test: self)
    }
}
