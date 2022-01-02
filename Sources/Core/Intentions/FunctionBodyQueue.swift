import Foundation
import Utils
import SwiftAST

// TODO: Rename to `StatementContainerQueue` to reflect the fact that function
// TODO: bodies are no longer the only top-level statement containers.

public protocol FunctionBodyQueueDelegate: AnyObject {
    associatedtype Context
    
    func makeContext(forFunction function: GlobalFunctionGenerationIntention) -> Context
    
    func makeContext(forInit ctor: InitGenerationIntention) -> Context
    
    func makeContext(forDeinit deinitIntent: DeinitGenerationIntention) -> Context
    
    func makeContext(forMethod method: MethodGenerationIntention) -> Context
    
    func makeContext(
        forPropertyGetter property: PropertyGenerationIntention,
        getter: FunctionBodyIntention
    ) -> Context
    
    func makeContext(
        forPropertySetter property: PropertyGenerationIntention,
        setter: PropertyGenerationIntention.Setter
    ) -> Context
    
    func makeContext(
        forProperty property: PropertyGenerationIntention,
        initializer: PropertyInitialValueGenerationIntention
    ) -> Context
    
    func makeContext(
        forSubscriptGetter subscriptIntent: SubscriptGenerationIntention,
        getter: FunctionBodyIntention
    ) -> Context
    
    func makeContext(
        forSubscriptSetter subscriptIntent: SubscriptGenerationIntention,
        setter: SubscriptGenerationIntention.Setter
    ) -> Context
    
    func makeContext(
        forGlobalVariable variable: GlobalVariableGenerationIntention,
        initializer: GlobalVariableInitialValueIntention
    ) -> Context
}

/// Allows collecting function bodies across intention collections from functions,
/// methods and properties.
public class FunctionBodyQueue<Delegate: FunctionBodyQueueDelegate> {
    let mutex = Mutex()
    
    public typealias Context = Delegate.Context
    
    public static func fromFile(
        _ intentionCollection: IntentionCollection,
        file: FileGenerationIntention,
        delegate: Delegate
    ) -> FunctionBodyQueue {
        
        let queue = FunctionBodyQueue(intentionCollection, delegate: delegate)
        queue.collectFromFile(file)
        
        return queue
    }
    
    public static func fromIntentionCollection(
        _ intentionCollection: IntentionCollection,
        delegate: Delegate,
        numThreads: Int
    ) -> FunctionBodyQueue {
        
        let queue = FunctionBodyQueue(intentionCollection, delegate: delegate)
        queue.collect(from: intentionCollection, numThreads: numThreads)
        
        return queue
    }
    
    public static func fromDeinit(
        _ intentionCollection: IntentionCollection,
        deinitIntent: DeinitGenerationIntention,
        delegate: Delegate
    ) -> FunctionBodyQueue {
        
        let queue = FunctionBodyQueue(intentionCollection, delegate: delegate)
        queue.collectDeinit(deinitIntent)
        
        return queue
    }
    
    public static func fromMethod(
        _ intentionCollection: IntentionCollection,
        method: MethodGenerationIntention,
        delegate: Delegate
    ) -> FunctionBodyQueue {
        
        let queue = FunctionBodyQueue(intentionCollection, delegate: delegate)
        queue.collectMethod(method)
        
        return queue
    }
    
    public static func fromProperty(
        _ intentionCollection: IntentionCollection,
        property: PropertyGenerationIntention,
        delegate: Delegate
    ) -> FunctionBodyQueue {
        
        let queue = FunctionBodyQueue(intentionCollection, delegate: delegate)
        queue.collectProperty(property)
        
        return queue
    }

    public static func fromGlobalVariable(
        _ intentionCollection: IntentionCollection,
        variable: GlobalVariableGenerationIntention,
        delegate: Delegate
    ) -> FunctionBodyQueue {

        let queue = FunctionBodyQueue(intentionCollection, delegate: delegate)
        queue.collectFromGlobalVariable(variable)
        
        return queue
    }
    
    private var intentionCollection: IntentionCollection
    private weak var delegate: Delegate?
    
    public var items: [FunctionBodyQueueItem] = []
    
    private init(_ intentionCollection: IntentionCollection, delegate: Delegate) {
        
        self.intentionCollection = intentionCollection
        self.delegate = delegate
    }
    
    private func collect(from intentions: IntentionCollection, numThreads: Int) {
        let queue = ConcurrentOperationQueue()
        queue.maxConcurrentOperationCount = numThreads
        
        for file in intentions.fileIntentions() {
            queue.addOperation {
                self.collectFromFile(file)
            }
        }
        
        queue.runAndWaitConcurrent()
    }
    
    private func collectFromFile(_ file: FileGenerationIntention) {
        for function in file.globalFunctionIntentions {
            collectFromFunction(function)
        }

        for glob in file.globalVariableIntentions {
            collectFromGlobalVariable(glob)
        }
        
        for type in file.typeIntentions {
            collectFromType(type)
        }
        
        for cls in file.classIntentions {
            collectFromClass(cls)
        }
        
        for cls in file.extensionIntentions {
            collectFromClass(cls)
        }
    }

    private func collectFromGlobalVariable(_ intention: GlobalVariableGenerationIntention) {
        guard let delegate = delegate else {
            return
        }
        guard let initialValue = intention.initialValueIntention else {
            return
        }

        let context = delegate.makeContext(
            forGlobalVariable: intention,
            initializer: initialValue
        )

        collectExpression(
            initialValue.expression,
            .globalVariable(intention, initialValue),
            context: context
        )
    }
    
    private func collectFromType(_ typeIntent: TypeGenerationIntention) {
        for prop in typeIntent.properties {
            collectProperty(prop)
        }
        
        for ctor in typeIntent.constructors {
            collectInit(ctor)
        }
        
        for method in typeIntent.methods {
            collectMethod(method)
        }
    }
    
    private func collectFromClass(_ cls: BaseClassIntention) {
        for sub in cls.subscripts {
            collectSubscript(sub)
        }
        
        if let deinitIntent = cls.deinitIntention {
            collectDeinit(deinitIntent)
        }
    }
    
    private func collectFromFunction(_ function: GlobalFunctionGenerationIntention) {
        guard let body = function.functionBody, let delegate = delegate else {
            return
        }
        
        let context = delegate.makeContext(forFunction: function)
        collectFunctionBody(body, .global(function), context: context)
    }
    
    private func collectFunction(_ f: FunctionIntention,
                                 _ intention: FunctionBodyCarryingIntention,
                                 context: Context) {
        
        if let method = f.functionBody {
            collectFunctionBody(method, intention, context: context)
        }
    }
    
    private func collectInit(_ ctor: InitGenerationIntention) {
        guard let delegate = delegate else {
            return
        }
        
        let context = delegate.makeContext(forInit: ctor)
        collectFunction(ctor, .initializer(ctor), context: context)
    }
    
    private func collectDeinit(_ deinitIntent: DeinitGenerationIntention) {
        guard let delegate = delegate else {
            return
        }
        
        let context = delegate.makeContext(forDeinit: deinitIntent)
        collectFunction(deinitIntent, .deinit(deinitIntent), context: context)
    }
    
    private func collectMethod(_ method: MethodGenerationIntention) {
        guard let delegate = delegate else {
            return
        }
        
        let context = delegate.makeContext(forMethod: method)
        collectFunction(method, .method(method), context: context)
    }
    
    private func collectProperty(_ property: PropertyGenerationIntention) {
        guard let delegate = delegate else {
            return
        }
        
        switch property.mode {
        case .computed(let getter):
            let context =
                delegate.makeContext(forPropertyGetter: property, getter: getter)
            
            collectFunctionBody(getter, .propertyGetter(property, getter), context: context)
            
        case let .property(getter, setter):
            let getterContext =
                delegate.makeContext(forPropertyGetter: property, getter: getter)
            let setterContext =
                delegate.makeContext(forPropertySetter: property, setter: setter)
            
            collectFunctionBody(getter, .propertyGetter(property, getter), context: getterContext)
            collectFunctionBody(setter.body, .propertySetter(property, setter), context: setterContext)
            
        case .asField:
            guard let initializer = property.initialValueIntention else {
                break
            }

            let context = delegate.makeContext(
                forProperty: property,
                initializer: initializer
            )
            
            collectExpression(
                initializer.expression,
                .propertyInitializer(property, initializer),
                context: context
            )
        }
    }
    
    private func collectSubscript(_ subscriptIntent: SubscriptGenerationIntention) {
        guard let delegate = delegate else {
            return
        }
        
        switch subscriptIntent.mode {
        case .getter(let getter):
            let context =
                delegate.makeContext(forSubscriptGetter: subscriptIntent, getter: getter)
            
            collectFunctionBody(getter, .subscriptGetter(subscriptIntent, getter), context: context)
            
        case let .getterAndSetter(getter, setter):
            let getterContext =
                delegate.makeContext(forSubscriptGetter: subscriptIntent, getter: getter)
            let setterContext =
                delegate.makeContext(forSubscriptSetter: subscriptIntent, setter: setter)
            
            collectFunctionBody(getter, .subscriptGetter(subscriptIntent, getter), context: getterContext)
            collectFunctionBody(setter.body, .subscriptSetter(subscriptIntent, setter), context: setterContext)
        }
    }
    
    private func collectFunctionBody(
        _ functionBody: FunctionBodyIntention,
        _ intention: FunctionBodyCarryingIntention,
        context: Context
    ) {
        
        mutex.locking {
            items.append(
                FunctionBodyQueueItem(
                    container: .function(functionBody),
                    intention: intention,
                    context: context
                )
            )
        }
    }
    
    private func collectStatement(
        _ statement: Statement,
        _ intention: FunctionBodyCarryingIntention,
        context: Context
    ) {
        
        mutex.locking {
            items.append(
                FunctionBodyQueueItem(
                    container: .statement(statement),
                    intention: intention,
                    context: context
                )
            )
        }
    }
    
    private func collectExpression(
        _ expression: Expression,
        _ intention: FunctionBodyCarryingIntention,
        context: Context
    ) {
        
        mutex.locking {
            items.append(
                FunctionBodyQueueItem(
                    container: .expression(expression),
                    intention: intention,
                    context: context
                )
            )
        }
    }
    
    public struct FunctionBodyQueueItem {
        public var container: StatementContainer
        public var intention: FunctionBodyCarryingIntention?
        public var context: Context
        
        public init(
            container: StatementContainer,
            intention: FunctionBodyCarryingIntention?,
            context: Context
        ) {
            
            self.container = container
            self.intention = intention
            self.context = context
        }
    }
}

/// An empty function body queue implementation which always return an empty
/// context object.
public class EmptyFunctionBodyQueueDelegate: FunctionBodyQueueDelegate {
    public typealias Context = Void
    
    public init() {
        
    }
    
    public func makeContext(forFunction function: GlobalFunctionGenerationIntention) -> Void {
        
    }

    public func makeContext(forMethod method: MethodGenerationIntention) -> Void {
        
    }

    public func makeContext(forInit ctor: InitGenerationIntention) -> Void {
        
    }
    
    public func makeContext(forDeinit deinitIntent: DeinitGenerationIntention) -> Void {
        
    }

    public func makeContext(
        forPropertyGetter property: PropertyGenerationIntention,
        getter: FunctionBodyIntention
    ) -> Void {
        
    }

    public func makeContext(
        forPropertySetter property: PropertyGenerationIntention,
        setter: PropertyGenerationIntention.Setter
    ) -> Void {
        
    }

    public func makeContext(
        forProperty property: PropertyGenerationIntention,
        initializer: PropertyInitialValueGenerationIntention
    ) -> Void {
    
    }

    public func makeContext(
        forSubscriptGetter subscriptIntent: SubscriptGenerationIntention,
        getter: FunctionBodyIntention
    ) -> Void {
        
    }
    
    public func makeContext(
        forSubscriptSetter subscriptIntent: SubscriptGenerationIntention,
        setter: SubscriptGenerationIntention.Setter
    ) -> Void {
        
    }

    public func makeContext(
        forGlobalVariable variable: GlobalVariableGenerationIntention,
        initializer: GlobalVariableInitialValueIntention
    ) -> Void {
    
    }
}
