import SwiftAST

public final class KnownFileBuilder {
    private var file: BuildingKnownFile
    public var useSwiftSignatureMatching: Bool = false
    
    public var fileName: String {
        return file.fileName
    }
    
    public init(fileName: String) {
        self.file = BuildingKnownFile(fileName: fileName, types: [])
    }
    
    public init(from existingFile: KnownFile) {
        let file = BuildingKnownFile(fileName: existingFile.fileName, types: [])
        
        self.file = file
    }
    
    private init(file: BuildingKnownFile) {
        self.file = file
    }
    
    func clone() -> KnownFileBuilder {
        return KnownFileBuilder(file: file)
    }
    
    public func `class`(name: String, _ builder: (KnownTypeBuilder) -> Void = { _ in }) -> KnownFileBuilder {
        return type(name: name, kind: .class, builder)
    }
    
    public func `struct`(name: String, _ builder: (KnownTypeBuilder) -> Void = { _ in }) -> KnownFileBuilder {
        return type(name: name, kind: .struct, builder)
    }
    
    public func `enum`(name: String, _ builder: (KnownTypeBuilder) -> Void = { _ in }) -> KnownFileBuilder {
        return type(name: name, kind: .enum, builder)
    }
    
    public func `protocol`(name: String, _ builder: (KnownTypeBuilder) -> Void = { _ in }) -> KnownFileBuilder {
        return type(name: name, kind: .protocol, builder)
    }
    
    func type(name: String, kind: KnownTypeKind, _ builder: (KnownTypeBuilder) -> Void) -> KnownFileBuilder {
        let typeBuilder = KnownTypeBuilder(typeName: name, kind: kind)
        builder(typeBuilder)
        
        let new = clone()
        new.file.types.append(typeBuilder.type)
        return new
    }
    
    public func build() -> KnownFile {
        let newFile = DummyFile(fileName: file.fileName, knownTypes: [])
        
        let newTypes: [BuildingKnownType] = file.types.map {
            var new = $0
            new.knownFile = newFile
            return new
        }
        
        newFile.knownTypes = newTypes
        
        return newFile
    }
}

struct BuildingKnownFile: Codable {
    var fileName: String
    var types: [BuildingKnownType]
}

extension BuildingKnownFile: KnownFile {
    var knownTypes: [KnownType] {
        types
    }
}

private class DummyFile: KnownFile {
    var fileName: String
    var knownTypes: [KnownType]
    
    init(fileName: String, knownTypes: [KnownType]) {
        self.fileName = fileName
        self.knownTypes = knownTypes
    }
}
