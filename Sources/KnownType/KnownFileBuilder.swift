import SwiftAST

public final class KnownFileBuilder {
    public typealias TypeBuildCallback = (KnownTypeBuilder) -> KnownTypeBuilder
    
    private var file: BuildingKnownFile
    public var useSwiftSignatureMatching: Bool = false
    
    public var fileName: String {
        return file.fileName
    }
    
    public init(fileName: String) {
        self.file = BuildingKnownFile(fileName: fileName, types: [], globals: [], knownImportDirectives: [])
    }
    
    // TODO: Not public until we solve the TODO within this init down bellow
    /*public*/ init(from existingFile: KnownFile) {
        let file =
            BuildingKnownFile(fileName: existingFile.fileName,
                              types: [],
                              globals: [],
                              knownImportDirectives: existingFile.knownImportDirectives)
        
        self.file = file
        
        // TODO: Copy over globals from new file
    }
    
    private init(file: BuildingKnownFile) {
        self.file = file
    }
    
    func clone() -> KnownFileBuilder {
        return KnownFileBuilder(file: file)
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
    
    func type(name: String, kind: KnownTypeKind, _ builder: TypeBuildCallback = { $0 }) -> KnownFileBuilder {
        var typeBuilder = KnownTypeBuilder(typeName: name, kind: kind)
        typeBuilder = builder(typeBuilder)
        
        let new = clone()
        new.file.types.append(typeBuilder.type)
        return new
    }
    
    public func build() -> KnownFile {
        let newFile
            = DummyFile(fileName: file.fileName,
                        knownTypes: [],
                        knownGlobals: [],
                        knownImportDirectives: file.knownImportDirectives)
        
        newFile.knownTypes = assigningKeyPath(file.types, value: newFile, keyPath: \.knownFile)
        newFile.knownGlobals = assigningKeyPath(file.globals, value: newFile, keyPath: \.knownFile)
        
        return newFile
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
    var types: [BuildingKnownType]
    var globals: [BuildingKnownGlobalFunction]
    var knownImportDirectives: [String]
}

extension BuildingKnownFile: KnownFile {
    var knownTypes: [KnownType] {
        types
    }
    var knownGlobals: [KnownGlobal] {
        return globals
    }
}

struct BuildingKnownGlobalFunction: Codable {
    var semantics: Set<Semantic>
    var knownFile: KnownFile?
    
    enum CodingKeys: String, CodingKey {
        case semantics
    }
}

extension BuildingKnownGlobalFunction: KnownGlobal {
}

private class DummyFile: KnownFile {
    var fileName: String
    var knownTypes: [KnownType]
    var knownGlobals: [KnownGlobal]
    var knownImportDirectives: [String]
    
    init(fileName: String,
         knownTypes: [KnownType],
         knownGlobals: [KnownGlobal],
         knownImportDirectives: [String]) {
        
        self.fileName = fileName
        self.knownTypes = knownTypes
        self.knownGlobals = knownGlobals
        self.knownImportDirectives = knownImportDirectives
    }
}
