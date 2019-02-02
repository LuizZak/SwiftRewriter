import Foundation
import SwiftAST
import Intentions
import Utils
import TypeSystem

/// Handy class used to apply a series of `ASTRewriterPass` instances to
/// all function bodies found in one go.
public final class ASTRewriterPassApplier {
    private var dirtyFunctions = DirtyFunctionBodyMap()
    
    var afterFile: ((String, _ passName: String) -> Void)?
    
    var intentionGlobals: IntentionCollectionGlobals!
    
    public var passes: [ASTRewriterPass.Type]
    public var typeSystem: TypeSystem
    public var numThreds: Int
    public var globals: DefinitionsSource
    
    public init(passes: [ASTRewriterPass.Type],
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
                                 passType: ASTRewriterPass.Type) {
        
        let functionBody = item.body
        
        // Resolve types before feeding into passes
        if dirtyFunctions.isDirty(functionBody) {
            _=item.context.typeResolver.resolveTypes(in: functionBody.body)
        }
        
        let notifyChangedTree: () -> Void = {
            self.dirtyFunctions.markDirty(functionBody)
        }
        
        let expContext =
            ASTRewriterPassContext(typeSystem: self.typeSystem,
                                   typeResolver: item.context.typeResolver,
                                   notifyChangedTree: notifyChangedTree,
                                   source: item.intention,
                                   functionBodyIntention: item.body)
        
        let pass = passType.init(context: expContext)
        let result = pass.apply(on: item.body.body, context: expContext)
        
        if let compound = result.asCompound {
            item.body.body = compound
        } else {
            item.body.body = [result]
        }
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
    
    private func internalApply(on file: FileGenerationIntention,
                               intentions: IntentionCollection,
                               passType: ASTRewriterPass.Type) {
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = numThreds
        
        let delegate =
            TypeResolvingQueueDelegate(
                intentions: intentions,
                globals: globals,
                typeSystem: typeSystem,
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
        
        func isDirty(_ body: FunctionBodyIntention) -> Bool {
            return synchronized(self) {
                return dirty.contains(where: { $0 === body })
            }
        }
    }
}
