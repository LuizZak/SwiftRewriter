import Foundation
import SwiftAST
import Intentions
import Utils
import TypeSystem

/// Handy class used to apply a series of `ASTRewriterPass` instances to
/// all function bodies found in one go.
public final class ASTRewriterPassApplier {
    private var dirtyFunctions = DirtyFunctionBodyMap()
    
    /// A closure that is invoked after all AST rewriter passes finish being
    /// applied to methods in a file.
    ///
    /// May be called concurrently, so locking/unlocking should be performed
    /// within this closure to access shared resources.
    public var afterFile: ((String, _ passName: String) -> Void)?
    
    var intentionGlobals: IntentionCollectionGlobals!
    
    public var passes: [ASTRewriterPass.Type]
    public var typeSystem: TypeSystem
    public var numThreads: Int
    public var globals: DefinitionsSource
    
    public init(passes: [ASTRewriterPass.Type],
                typeSystem: TypeSystem,
                globals: DefinitionsSource,
                numThreds: Int = 8) {
        
        self.passes = passes
        self.typeSystem = typeSystem
        self.numThreads = numThreds
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
            ASTRewriterPassContext(typeSystem: typeSystem,
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
        queue.maxConcurrentOperationCount = numThreads
        
        for file in intentions.fileIntentions() where shouldApply(on: file) {
            for passType in self.passes {
                self.internalApply(on: file,
                                   intentions: intentions,
                                   passType: passType,
                                   operationQueue: queue)
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
    }
    
    private func shouldApply(on file: FileGenerationIntention) -> Bool {
        return file.isPrimary
    }
    
    private func internalApply(on file: FileGenerationIntention,
                               intentions: IntentionCollection,
                               passType: ASTRewriterPass.Type,
                               operationQueue: OperationQueue) {
        
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
            operationQueue.addOperation {
                #if canImport(ObjectiveC)
                autoreleasepool {
                    self.applyPassOnBody(item, passType: passType)
                }
                #else
                self.applyPassOnBody(item, passType: passType)
                #endif
            }
        }
        
        operationQueue.waitUntilAllOperationsAreFinished()
        
        self.afterFile?(file.targetPath, "\(passType)")
    }
    
    private class DirtyFunctionBodyMap {
        @ConcurrentValue var dirty: Set<FunctionBodyIntention> = []
        
        func markDirty(_ body: FunctionBodyIntention) {
            _dirty.wrappedValue.insert(body)
        }
        
        func isDirty(_ body: FunctionBodyIntention) -> Bool {
            dirty.contains(body)
        }
    }
}

extension FunctionBodyIntention: Hashable {
    public static func == (lhs: FunctionBodyIntention, rhs: FunctionBodyIntention) -> Bool {
        lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
