import SwiftAST

public final class SwiftASTReaderContext {
    private var localsStack: [[Local]] = [[]]
    private var typeSystem: TypeSystem?
    private var typeContext: KnownType?
    
    public init(typeSystem: TypeSystem?, typeContext: KnownType?) {
        self.typeSystem = typeSystem
        self.typeContext = typeContext
    }
    
    func define(localNamed name: String, storage: ValueStorage) {
        guard !localsStack.isEmpty else {
            fatalError("No definition contexts available to define local variable in")
        }
        
        let local = Local(name: name, storage: storage)
        
        localsStack[localsStack.count - 1].append(local)
    }
    
    func localNamed(_ name: String) -> Local? {
        for stackLevel in localsStack.reversed() {
            if let local = stackLevel.first(where: { $0.name == name }) {
                return local
            }
        }
        
        return nil
    }
    
    func typePropertyOrFieldNamed(_ name: String) -> KnownMember? {
        guard let typeContext = typeContext else {
            return nil
        }
        
        if let field = typeSystem?.field(named: name, static: false, in: typeContext) {
            return field
        }
        
        return typeSystem?.property(named: name,
                                    static: false,
                                    includeOptional: false,
                                    in: typeContext)
    }
    
    func pushDefinitionContext() {
        localsStack.append([])
    }
    
    func popDefinitionContext() {
        localsStack.removeLast()
    }
    
    struct Local {
        var name: String
        var storage: ValueStorage
    }
    
}
