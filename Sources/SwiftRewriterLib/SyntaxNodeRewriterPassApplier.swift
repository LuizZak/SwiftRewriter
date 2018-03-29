import Foundation
import SwiftAST

/// Handy class used to apply a series of `SyntaxNodeRewriterPass` instances to
/// all function bodies found in one go.
public final class SyntaxNodeRewriterPassApplier {
    var afterFile: ((String) -> Void)?
    
    public var passes: [SyntaxNodeRewriterPass.Type]
    public var typeSystem: TypeSystem
    public var numThreds: Int
    public var globals: DefinitionsSource
    
    public init(passes: [SyntaxNodeRewriterPass.Type],
                typeSystem: TypeSystem,
                globals: DefinitionsSource,
                numThreds: Int = 8) {
        
        self.passes = passes
        self.typeSystem = typeSystem
        self.numThreds = numThreds
        self.globals = globals
    }
    
    public func apply(on intentions: IntentionCollection) {
        internalApply(on: intentions)
    }
    
    func internalApply(on intentions: IntentionCollection) {
        let delegate =
            TypeResolvingQueueDelegate(intentions: intentions, globals: globals,
                                       typeSystem: typeSystem)
        
        let bodyQueue =
            FunctionBodyQueue
                .fromIntentionCollection(intentions,
                                         delegate: delegate)
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = numThreds
        
        for item in bodyQueue.items {
            queue.addOperation {
                autoreleasepool {
                    // Resolve types before feeding into passes
                    _=item.context.typeResolver.resolveTypes(in: item.body.body)
                    
                    var didChangeTree = false
                    let notifyChangedTree: () -> Void = {
                        didChangeTree = true
                    }
                    
                    let expContext =
                        SyntaxNodeRewriterPassContext(typeSystem: self.typeSystem,
                                                      typeResolver: item.context.typeResolver,
                                                      notifyChangedTree: notifyChangedTree)
                    
                    self.passes.forEach { pass in
                        let pass = pass.init()
                        
                        didChangeTree = false
                        
                        _=pass.apply(on: item.body.body, context: expContext)
                        
                        if didChangeTree {
                            // After each apply to the body, we must re-type check the result
                            // before handing it off to the next pass.
                            _=item.context.typeResolver.resolveTypes(in: item.body.body)
                        }
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
    }
}
