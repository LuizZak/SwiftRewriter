import Foundation
import SwiftAST
import Utils

/// Handy class used to apply a series of `SyntaxNodeRewriterPass` instances to
/// all function bodies found in one go.
public final class SyntaxNodeRewriterPassApplier {
    private var dirtyFunctions = DirtyFunctionBodyMap()
    
    var afterFile: ((String, _ passName: String) -> Void)?
    
    var intentionGlobals: IntentionCollectionGlobals!
    
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
        intentionGlobals = IntentionCollectionGlobals(intentions: intentions)
        
        internalApply(on: intentions)
    }
    
    private func applyPassOnBody(_ item: FunctionBodyQueue<TypeResolvingQueueDelegate>.FunctionBodyQueueItem,
                                 passType: SyntaxNodeRewriterPass.Type) {
        let functionBody = item.body
        
        // Resolve types before feeding into passes
        if dirtyFunctions.isDirty(functionBody) {
            _=item.context.typeResolver.resolveTypes(in: functionBody.body)
        }
        
        let notifyChangedTree: () -> Void = {
            self.dirtyFunctions.markDirty(functionBody)
        }
        
        let expContext =
            SyntaxNodeRewriterPassContext(typeSystem: self.typeSystem,
                                          typeResolver: item.context.typeResolver,
                                          notifyChangedTree: notifyChangedTree)
        
        let pass = passType.init()
        _=pass.apply(on: item.body.body, context: expContext)
    }
    
    private func internalApply(on intentions: IntentionCollection) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = numThreds
        
        
        for file in intentions.fileIntentions() {
            queue.addOperation {
                for passType in self.passes {
                    self.internalApply(on: file, intentions: intentions,
                                       passType: passType)
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
    }
    
    private func internalApply(on file: FileGenerationIntention, intentions: IntentionCollection,
                               passType: SyntaxNodeRewriterPass.Type) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = numThreds
        
        let delegate =
            TypeResolvingQueueDelegate(
                intentions: intentions, globals: globals, typeSystem: typeSystem,
                intentionGlobals: intentionGlobals)
        
        let bodyQueue =
            FunctionBodyQueue
                .fromFile(intentions, file: file, delegate: delegate)
        
        for item in bodyQueue.items {
            queue.addOperation {
                autoreleasepool {
                    self.applyPassOnBody(item, passType: passType)
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        self.afterFile?(file.targetPath, "\(passType)")
    }
    
    private class DirtyFunctionBodyMap {
        var dirty: [FunctionBodyIntention] = []
        
        func markDirty(_ body: FunctionBodyIntention) {
            synchronized(self) {
                if dirty.contains(where: { $0 === body }) {
                    return
                }
                
                dirty.append(body)
            }
        }
        
        func clearDirty(_ body: FunctionBodyIntention) {
            synchronized(self) {
                guard let index = dirty.index(where: { $0 === body }) else {
                    return
                }
                
                dirty.remove(at: index)
            }
        }
        
        func isDirty(_ body: FunctionBodyIntention) -> Bool {
            return synchronized(self) {
                return dirty.contains(where: { $0 === body })
            }
        }
    }
}
