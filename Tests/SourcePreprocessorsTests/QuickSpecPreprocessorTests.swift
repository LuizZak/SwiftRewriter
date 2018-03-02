import XCTest
import SourcePreprocessors
import SwiftRewriterLib
import Utils

class QuickSpecPreprocessorTests: XCTestCase {
    func testPreprocessorEmptyInput() {
        let sut = QuickSpecPreprocessor()
        
        let result = sut.preprocess(source: "", context: EmptyContext())
        
        XCTAssertEqual(result, "")
    }
    
    /// Tests preprocessing a file that doesn't require preprocessing
    func testPreprocessorPlainFile() {
        let input = """
            #import <Foundation/Foundation.h>
            #import <Expecta/Expecta.h>
            #import "SourceCode.h"
            #import <OCMock/OCMock.h>

            #import "MyType.h"

            @interface MyType (Private)

            - (void)myPrivate;
            - (void)setMyPrivateVar:(NSInteger)value;

            @end
            
            @interface MyTypeSpec : QuickSpec
            @end
            @implementation MyTypeSpec
            - (void)spec {

                describe(@"MyType", ^{
                    
                    describe(@"when it's initiated", ^{
                        MyType *inst = [[MyType alloc] initWithValue:@"value"];
                        
                        [inst config];
                        
                        it(@"must behave a certain way", ^{

                            expect(inst.layer.shadowRadius).equal(2.0f);
                            expect(inst.layer.shadowOpacity).equal(0.2f);
                            expect(inst.layer.shadowOffset).equal(CGSizeMake(0, 1));
                            expect(inst.layer.backgroundColor).equal([[UIColor clearColor] CGColor]);
                            expect(inst.backgroundColor).equal([UIColor clearColor]);
                        });

                    });
                });

            }
            @end
            """
        
        let sut = QuickSpecPreprocessor()
        
        let result = sut.preprocess(source: input, context: EmptyContext())
        
        XCTAssertEqual(result, input)
    }
    
    /// Tests converting a QuickSpec-containing file
    func testQuickSpecFile() {
        let sut = QuickSpecPreprocessor()
        
        let result = sut.preprocess(source: """
            #import <Foundation/Foundation.h>
            #import <Expecta/Expecta.h>
            #import "SourceCode.h"
            #import <OCMock/OCMock.h>

            #import "MyType.h"

            @interface MyType (Private)

            - (void)myPrivate;
            - (void)setMyPrivateVar:(NSInteger)value;

            @end

            QuickSpecBegin(MyTypeSpec)

                describe(@"MyType", ^{
                    
                    describe(@"when it's initiated", ^{
                        MyType *inst = [[MyType alloc] initWithValue:@"value"];
                        
                        [inst config];
                        
                        it(@"must behave a certain way", ^{

                            expect(inst.layer.shadowRadius).equal(2.0f);
                            expect(inst.layer.shadowOpacity).equal(0.2f);
                            expect(inst.layer.shadowOffset).equal(CGSizeMake(0, 1));
                            expect(inst.layer.backgroundColor).equal([[UIColor clearColor] CGColor]);
                            expect(inst.backgroundColor).equal([UIColor clearColor]);
                        });

                    });
                });

            QuickSpecEnd
            """, context: EmptyContext())
        
        let expected = """
            #import <Foundation/Foundation.h>
            #import <Expecta/Expecta.h>
            #import "SourceCode.h"
            #import <OCMock/OCMock.h>

            #import "MyType.h"

            @interface MyType (Private)

            - (void)myPrivate;
            - (void)setMyPrivateVar:(NSInteger)value;

            @end
            
            @interface MyTypeSpec : QuickSpec
            @end
            @implementation MyTypeSpec
            - (void)spec {

                describe(@"MyType", ^{
                    
                    describe(@"when it's initiated", ^{
                        MyType *inst = [[MyType alloc] initWithValue:@"value"];
                        
                        [inst config];
                        
                        it(@"must behave a certain way", ^{

                            expect(inst.layer.shadowRadius).equal(2.0f);
                            expect(inst.layer.shadowOpacity).equal(0.2f);
                            expect(inst.layer.shadowOffset).equal(CGSizeMake(0, 1));
                            expect(inst.layer.backgroundColor).equal([[UIColor clearColor] CGColor]);
                            expect(inst.backgroundColor).equal([UIColor clearColor]);
                        });

                    });
                });

            }
            @end
            """
        
        XCTAssertEqual(result, expected, "\n\nDiff:\n\n\(result.makeDifferenceMarkString(against: expected))")
    }
    
    func testInvalidCases() {
        let sut = QuickSpecPreprocessor()
        
        XCTAssertEqual(
            sut.preprocess(source: """
            //QuickSpecBegin(InComment)
            /* QuickSpecEnd */
            """, context: EmptyContext()), """
            //QuickSpecBegin(InComment)
            /* QuickSpecEnd */
            """)
    }
    
    func testIsWhitespaceTolerant() {
        let sut = QuickSpecPreprocessor()
        
        XCTAssertEqual(
            sut.preprocess(
            source:
            """
            QuickSpecBegin ( Abc)
            QuickSpecEnd
            """,
            context: EmptyContext()),
            """
            @interface Abc : QuickSpec
            @end
            @implementation Abc
            - (void)spec {
            }
            @end
            """)
        
        XCTAssertEqual(
            sut.preprocess(
            source:
            """
            QuickSpecBegin (Abc )
            QuickSpecEnd
            """,
            context: EmptyContext()),
            """
            @interface Abc : QuickSpec
            @end
            @implementation Abc
            - (void)spec {
            }
            @end
            """)
        
        XCTAssertEqual(
            sut.preprocess(
            source:
            """
            QuickSpecBegin  (  Abc  )
            QuickSpecEnd
            """,
            context: EmptyContext()),
            """
            @interface Abc : QuickSpec
            @end
            @implementation Abc
            - (void)spec {
            }
            @end
            """)
    }
    
    private class EmptyContext: PreprocessingContext {
        var filePath: String = ""
    }
}
