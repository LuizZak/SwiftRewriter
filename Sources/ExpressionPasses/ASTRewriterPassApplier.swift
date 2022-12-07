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
    
    /// A progress delegate which will be notified of ongoing progress made while
    /// AST passes are applied
    public weak var progressDelegate: ASTRewriterPassApplierProgressDelegate?
    
    /// Progress information for the passes being applied
    private(set) public var progress: (current: Int, total: Int) = (0, 0)
    
    public init(passes: [ASTRewriterPass.Type],
                typeSystem: TypeSystem,
                globals: DefinitionsSource,
                numThreads: Int = 8) {
        
        self.passes = passes
        self.typeSystem = typeSystem
        self.numThreads = numThreads
        self.globals = globals
    }
    
    public func apply(on intentions: IntentionCollection) {
        intentionGlobals = IntentionCollectionGlobals(intentions: intentions)
        
        internalApply(on: intentions)
    }
    
    private func internalApply(on intentions: IntentionCollection) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = numThreads
        
        let files = intentions.fileIntentions().filter(shouldApply(on:))
        
        // Calculate total expected work
        progress.total = files.count * passes.count
        
        for (fileIndex, file) in files.enumerated() {
            for (passIndex, passType) in passes.enumerated() {
                progress.current = fileIndex * passes.count + passIndex + 1
                progressDelegate?.astWriterPassApplier(self,
                                                       applyingPassType: passType,
                                                       toFile: file)
                
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
    
    private class DirtyFunctionBodyMap {
        @ConcurrentValue var dirty: Set<FunctionBodyIntention> = []
        
        func markDirty(_ body: FunctionBodyIntention) {
            dirty.insert(body)
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

public protocol ASTRewriterPassApplierProgressDelegate: AnyObject {
    func astWriterPassApplier(_ passApplier: ASTRewriterPassApplier,
                              applyingPassType passType: ASTRewriterPass.Type,
                              toFile file: FileGenerationIntention)
}
