import XCTest
import SwiftRewriterLib

class SwiftRewriter_ThreadingTests: XCTestCase {
    private var state = State()
    
    override func setUp() {
        super.setUp()
        
        state = State()
    }
    
    /// Tests multi-threading with a large number of input files
    func testMultithreading() {
        var builder = MultiFileTestBuilder(test: self)
        
        for _ in 0..<25 {
            builder = produceNextClassFiles(classCount: 15, in: builder)
        }
        
        builder.compile()
    }
}

private extension SwiftRewriter_ThreadingTests {
    func produceNextClassFiles(classCount: Int, in builder: MultiFileTestBuilder) -> MultiFileTestBuilder {
        var header = ""
        var implementation = ""
        
        for _ in 0..<classCount {
            let className = "Class\(state.nextClassId())"
            
            header += """
            @interface \(className) : NSObject
            @property (weak) \(className)* next;
            @property Bool a;
            @property Bool b;
            @property CGFloat c;
            - (void)myMethod;
            @end
            
            """
            
            implementation += """
            @implementation \(className)
            - (void)myMethod {
                for(int i = 0; i < (int)[self myOtherMethod]; i += 1) {
                    self.a;
                    self.b;
                }
            }
            - (CGFloat)myOtherMethod {
                return (10 + next.c) / 2;
            }
            @end
            
            """
        }
        
        let fileName = "File\(state.nextFileId())"
        
        return builder
            .file(name: fileName + ".h", header)
            .file(name: fileName + ".m", implementation)
    }
    
    struct State {
        var fileCounter: Int = 0
        var classCounter: Int = 0
        
        mutating func nextFileId() -> Int {
            defer {
                fileCounter += 1
            }
            
            return fileCounter
        }
        
        mutating func nextClassId() -> Int {
            defer {
                classCounter += 1
            }
            
            return classCounter
        }
    }
}
