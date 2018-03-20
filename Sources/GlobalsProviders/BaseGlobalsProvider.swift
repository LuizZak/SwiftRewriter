import SwiftAST
import SwiftRewriterLib

public class BaseGlobalsProvider: GlobalsProvider {
    var globals: [CodeDefinition] = []
    var types: [KnownType] = []
    
    init() {
        createDefinitions()
        createTypes()
    }
    
    public func registerDefinitions(on globals: GlobalDefinitions) {
        for global in self.globals {
            globals.recordDefinition(global)
        }
    }
    
    public func registerTypes(in typeSink: KnownTypeSink) {
        for type in types {
            typeSink.addType(type)
        }
    }
    
    func createDefinitions() {
        
    }
    
    func createTypes() {
        
    }
    
    func add(_ definition: CodeDefinition) {
        globals.append(definition)
    }
    
    func add(_ type: KnownType) {
        types.append(type)
    }
    
    func makeType(named name: String, supertype: KnownTypeReferenceConvertible? = nil,
                  kind: KnownTypeKind = .class,
                  initializer: (KnownTypeBuilder) -> (KnownType) = { $0.build() }) {
        
        let builder = KnownTypeBuilder(typeName: name, supertype: supertype, kind: kind)
        
        let type = initializer(builder)
        
        add(type)
    }
    
    func function(name: String, paramTypes: [SwiftType], returnType: SwiftType) -> CodeDefinition {
        let paramSignatures = paramTypes.enumerated().map { (arg) -> ParameterSignature in
            let (i, type) = arg
            return ParameterSignature(label: "_", name: "p\(i)", type: type)
        }
        
        let signature =
            FunctionSignature(name: name, parameters: paramSignatures,
                              returnType: returnType, isStatic: false)
        
        let definition = CodeDefinition(functionSignature: signature, intention: nil)
        
        return definition
    }
}
