import Foundation
import SwiftAST

public struct KnownFileBuilder {
    public typealias TypeBuildCallback = (KnownTypeBuilder) -> KnownTypeBuilder
    
    private var file: BuildingKnownFile
    public var useSwiftSignatureMatching: Bool = false
    
    public var fileName: String {
        return file.fileName
    }
    
    public init(fileName: String) {
        self.file = BuildingKnownFile(fileName: fileName,
                                      buildingTypes: [],
                                      buildingGlobalFunctions: [],
                                      buildingGlobalVariables: [],
                                      importDirectives: [])
    }
    
    public init(from existingFile: KnownFile) {
        var file =
            BuildingKnownFile(fileName: existingFile.fileName,
                              buildingTypes: [],
                              buildingGlobalFunctions: [],
                              buildingGlobalVariables: [],
                              importDirectives: existingFile.importDirectives)
        
        for type in existingFile.types {
            let typeBuilder = KnownTypeBuilder(from: type)
            
            file.buildingTypes.append(typeBuilder.type)
        }
        
        self.file = file
        
        for global in existingFile.globals {
            if let f = global as? KnownGlobalFunction {
                self = self.globalFunction(signature: f.signature, semantics: f.semantics)
            }
            if let v = global as? KnownGlobalVariable {
                self = self.globalVar(name: v.name, storage: v.storage, semantics: v.semantics)
            }
        }
    }
    
    private init(file: BuildingKnownFile) {
        self.file = file
    }
    
    func clone() -> KnownFileBuilder {
        return KnownFileBuilder(file: file)
    }
    
    public func importDirective(_ moduleName: String) -> KnownFileBuilder {
        var new = clone()
        new.file.importDirectives.append(moduleName)
        return new
    }
    
    public func `class`(name: String, _ builder: TypeBuildCallback = { $0 }) -> KnownFileBuilder {
        return type(name: name, kind: .class, builder)
    }
    
    public func `struct`(name: String, _ builder: TypeBuildCallback = { $0 }) -> KnownFileBuilder {
        return type(name: name, kind: .struct, builder)
    }
    
    public func `enum`(name: String, _ builder: TypeBuildCallback = { $0 }) -> KnownFileBuilder {
        return type(name: name, kind: .enum, builder)
    }
    
    public func `protocol`(name: String, _ builder: TypeBuildCallback = { $0 }) -> KnownFileBuilder {
        return type(name: name, kind: .protocol, builder)
    }
    
    public func globalFunction(signature: FunctionSignature,
                               semantics: Set<Semantic> = []) -> KnownFileBuilder {
        
        let newFunc = BuildingKnownGlobalFunction(signature: signature,
                                                  semantics: semantics,
                                                  knownFile: nil)
        
        var new = clone()
        new.file.buildingGlobalFunctions.append(newFunc)
        return new
    }
    
    public func globalVar(name: String,
                          type: SwiftType,
                          semantics: Set<Semantic> = []) -> KnownFileBuilder {
        
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        return globalVar(name: name, storage: storage, semantics: semantics)
    }
    
    public func globalVar(name: String,
                          storage: ValueStorage,
                          semantics: Set<Semantic> = []) -> KnownFileBuilder {
        
        let newVar = BuildingKnownGlobalVariable(name: name,
                                                 storage: storage,
                                                 knownFile: nil,
                                                 semantics: semantics)
        
        var new = clone()
        new.file.buildingGlobalVariables.append(newVar)
        return new
    }
    
    func type(name: String, kind: KnownTypeKind, _ builder: TypeBuildCallback = { $0 }) -> KnownFileBuilder {
        var typeBuilder = KnownTypeBuilder(typeName: name, kind: kind)
        typeBuilder = builder(typeBuilder)
        
        var new = clone()
        new.file.buildingTypes.append(typeBuilder.type)
        return new
    }
    
    /// Returns the constructed KnownFile instance from this builder.
    public func build() -> KnownFile {
        let newFile
            = DummyFile(fileName: file.fileName,
                        types: [],
                        globals: [],
                        importDirectives: file.importDirectives)
        
        let globalFuncs = assigningKeyPath(file.buildingGlobalFunctions, value: newFile, keyPath: \.knownFile)
        let globalVars = assigningKeyPath(file.buildingGlobalVariables, value: newFile, keyPath: \.knownFile)
        
        newFile.types = assigningKeyPath(file.buildingTypes, value: newFile, keyPath: \.knownFile)
        newFile.globals = globalFuncs + globalVars
        
        return newFile
    }
    
    /// Encodes the file represented by this known file builder
    ///
    /// - Returns: A data representation of the file being built which can be later
    /// deserialized back into a buildable file with `KnownFileBuilder.decode(from:)`.
    /// - Throws: Any error thrown during the decoding process.
    public func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(file)
    }
    
    /// Decodes the file to be built by this file builder from a given serialized
    /// data which resulted from a call to `KnownFileBuilder.encode()`.
    ///
    /// - Parameter data: A data object produced by a call to `KnownFileBuilder.encode()`.
    /// - Throws: Any error thrown during the decoding process.
    public mutating func decode(from data: Data) throws {
        let decoder = JSONDecoder()
        file = try decoder.decode(BuildingKnownFile.self, from: data)
    }
    
    private func assigningKeyPath<T>(_ array: [T],
                                     value: KnownFile,
                                     keyPath: WritableKeyPath<T, KnownFile?>) -> [T] {
        return array.map {
            var new = $0
            new[keyPath: keyPath] = value
            return new
        }
    }
}

struct BuildingKnownFile: Codable {
    var fileName: String
    var buildingTypes: [BuildingKnownType]
    var buildingGlobalFunctions: [BuildingKnownGlobalFunction]
    var buildingGlobalVariables: [BuildingKnownGlobalVariable]
    var importDirectives: [String]
}

extension BuildingKnownFile: KnownFile {
    var types: [KnownType] {
        buildingTypes
    }
    
    var globals: [KnownGlobal] {
        buildingGlobalFunctions + buildingGlobalVariables
    }
}

struct BuildingKnownGlobalFunction: Codable {
    var signature: FunctionSignature
    var semantics: Set<Semantic>
    var knownFile: KnownFile?
    
    var identifier: FunctionIdentifier {
        return signature.asIdentifier
    }
    
    enum CodingKeys: String, CodingKey {
        case semantics
        case signature
    }
}

extension BuildingKnownGlobalFunction: KnownGlobalFunction {
    
}

struct BuildingKnownGlobalVariable: Codable {
    var name: String
    var storage: ValueStorage
    var knownFile: KnownFile?
    var semantics: Set<Semantic>
    
    enum CodingKeys: String, CodingKey {
        case name
        case storage
        case semantics
    }
}

extension BuildingKnownGlobalVariable: KnownGlobalVariable {
    
}

private class DummyFile: KnownFile {
    var fileName: String
    var types: [KnownType]
    var globals: [KnownGlobal]
    var importDirectives: [String]
    
    init(fileName: String,
         types: [KnownType],
         globals: [KnownGlobal],
         importDirectives: [String]) {
        
        self.fileName = fileName
        self.types = types
        self.globals = globals
        self.importDirectives = importDirectives
    }
}
