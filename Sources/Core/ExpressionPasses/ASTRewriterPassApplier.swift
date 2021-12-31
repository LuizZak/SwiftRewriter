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
        let queue = ConcurrentOperationQueue()
        queue.maxConcurrentOperationCount = numThreads
        
        let files = intentions.fileIntentions().filter(shouldApply(on:))
        
        // Calculate total expected work
        progress.total = files.count * passes.count
        
        for (fileIndex, file) in files.enumerated() {
            for (passIndex, passType) in passes.enumerated() {
                progress.current = fileIndex * passes.count + passIndex + 1

                progressDelegate?
                    .astWriterPassApplier(
                        self,
                        applyingPassType: passType,
                        toFile: file
                    )
                
                self.internalApply(
                    on: file,
                    intentions: intentions,
                    passType: passType,
                    operationQueue: queue
                )
            }
        }
        
        queue.runAndWaitConcurrent()
    }
    
    private func shouldApply(on file: FileGenerationIntention) -> Bool {
        return file.isPrimary
    }
    
    private func internalApply(
        on file: FileGenerationIntention,
        intentions: IntentionCollection,
        passType: ASTRewriterPass.Type,
        operationQueue: ConcurrentOperationQueue
    ) {
        
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
        
        operationQueue.runAndWaitConcurrent()
        
        self.afterFile?(file.targetPath, "\(passType)")
    }
    
    private func applyPassOnBody(
        _ item: FunctionBodyQueue<TypeResolvingQueueDelegate>.FunctionBodyQueueItem,
        passType: ASTRewriterPass.Type
    ) {
        guard let intention = item.intention else {
            return
        }
        
        // Resolve types before feeding into passes
        resolveTypes(in: item)
        
        let notifyChangedTree: () -> Void = {
            self.dirtyFunctions.markDirty(intention)
        }
        
        let expContext =
            ASTRewriterPassContext(
                typeSystem: typeSystem,
                typeResolver: item.context.typeResolver,
                notifyChangedTree: notifyChangedTree,
                source: item.intention,
                container: item.container
            )
        
        let pass = passType.init(context: expContext)

        switch item.container {
        case .function(let body):
            let result = pass.apply(on: body.body, context: expContext)
            
            if let compound = result.asCompound {
                body.body = compound
            } else {
                body.body = [result]
            }

        case .statement(_):
            // TODO: Handle top-level statements
            // let result = pass.apply(on: stmt, context: expContext)
            break
        
        case .expression(let exp):
            let result = pass.apply(on: exp, context: expContext)

            switch intention {
            case .globalVariable(_, let intention):
                intention.expression = result
            case .propertyInitializer(_, let intention):
                intention.expression = result
            default:
                break
            }
        }
    }

    private func resolveTypes(in item: FunctionBodyQueue<TypeResolvingQueueDelegate>.FunctionBodyQueueItem) {
        guard let intention = item.intention else {
            return
        }

        if dirtyFunctions.isDirty(intention) {
            switch item.container {
            case .function(let body):
                _ = item.context.typeResolver.resolveTypes(in: body.body)
            case .statement(let stmt):
                _ = item.context.typeResolver.resolveTypes(in: stmt)
            case .expression(let exp):
                _ = item.context.typeResolver.resolveType(exp)
            }
        }
    }
    
    private class DirtyFunctionBodyMap {
        @ConcurrentValue var dirty: Set<FunctionBodyCarryingIntention> = []
        
        func markDirty(_ body: FunctionBodyCarryingIntention) {
            dirty.insert(body)
        }
        
        func isDirty(_ body: FunctionBodyCarryingIntention) -> Bool {
            dirty.contains(body)
        }
    }
}

extension FunctionBodyCarryingIntention: Hashable {
    public static func == (lhs: FunctionBodyCarryingIntention, rhs: FunctionBodyCarryingIntention) -> Bool {
        switch (lhs, rhs) {
        case (.method(let l), .method(let r)):
            return l === r
        case (.initializer(let l), .initializer(let r)):
            return l === r
        case (.`deinit`(let l), .`deinit`(let r)):
            return l === r
        case (.global(let l), .global(let r)):
            return l === r
        case (.property(let l, _), .property(let r, _)):
            return l === r
        case (.`subscript`(let l, _), .`subscript`(let r, _)):
            return l === r
        case (.propertyInitializer(let l, _), .propertyInitializer(let r, _)):
            return l === r
        case (.globalVariable(let l, _), .globalVariable(let r, _)):
            return l === r
        default:
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
            case .method(let o):
                hasher.combine(ObjectIdentifier(o))
            case .initializer(let o):
                hasher.combine(ObjectIdentifier(o))
            case .`deinit`(let o):
                hasher.combine(ObjectIdentifier(o))
            case .global(let o):
                hasher.combine(ObjectIdentifier(o))
            case .property(let o, _):
                hasher.combine(ObjectIdentifier(o))
            case .`subscript`(let o, _):
                hasher.combine(ObjectIdentifier(o))
            case .propertyInitializer(let o, _):
                hasher.combine(ObjectIdentifier(o))
            case .globalVariable(let o, _):
                hasher.combine(ObjectIdentifier(o))
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
    func astWriterPassApplier(
        _ passApplier: ASTRewriterPassApplier,
        applyingPassType passType: ASTRewriterPass.Type,
        toFile file: FileGenerationIntention
    )
}
