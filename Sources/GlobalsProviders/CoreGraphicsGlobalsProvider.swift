import SwiftAST
import SwiftRewriterLib
import Commons

public class CoreGraphicsGlobalsProvider: GlobalsProvider {
    private static var provider = InnerCoreGraphicsGlobalsProvider()
    
    public init() {
        
    }
    
    public func knownTypeProvider() -> KnownTypeProvider {
        return CollectionKnownTypeProvider(knownTypes: CoreGraphicsGlobalsProvider.provider.types)
    }
    
    public func typealiasProvider() -> TypealiasProvider {
        return CollectionTypealiasProvider(aliases: CoreGraphicsGlobalsProvider.provider.typealiases)
    }
    
    public func definitionsSource() -> DefinitionsSource {
        return CoreGraphicsGlobalsProvider.provider.definitions
    }
}

private class InnerCoreGraphicsGlobalsProvider: BaseGlobalsProvider {
    
    var definitions: ArrayDefinitionsSource = ArrayDefinitionsSource(definitions: [])
    
    public override init() {
        
    }
    
    override func createTypes() {
        createCGPoint()
        createCGSize()
        createCGRect()
    }
    
    override func createDefinitions() {
        super.createDefinitions()
        
        definitions = ArrayDefinitionsSource(definitions: globals)
    }
    
    func createCGPoint() {
        makeType(named: "CGPoint", kind: .struct) { type -> (KnownType) in
            var type = type
            
            type.useSwiftSignatureMatching = true
            
            let typeString = """
                struct CGPoint {
                    static var zero: CGPoint { get }
                    var x: CGFloat
                    var y: CGFloat
                    
                    init()
                    init(x: CGFloat, y: CGFloat)
                }
                """
            
            try! SwiftClassInterfaceParser
                .parseDeclaration(from: typeString, into: &type)
            
            return type.build()
        }
    }
    
    func createCGSize() {
        makeType(named: "CGSize", kind: .struct) { type -> (KnownType) in
            var type = type
            
            type.useSwiftSignatureMatching = true
            
            let typeString = """
                struct CGSize {
                    static var zero: CGSize { get }
                    var width: CGFloat
                    var height: CGFloat
                    
                    init()
                    init(width: CGFloat, height: CGFloat)
                }
                """
            
            try! SwiftClassInterfaceParser
                .parseDeclaration(from: typeString, into: &type)
            
            return type.build()
        }
    }
    
    func createCGRect() {
        makeType(named: "CGRect") { type in
            var type = type
            
            type.useSwiftSignatureMatching = true
            
            let typeString = """
                struct CGRect {
                    static let null: CGRect
                    static let infinite: CGRect
                    static var zero: CGRect { get }
                    var origin: CGPoint
                    var size: CGSize
                    var minX: CGFloat { get }
                    var midX: CGFloat { get }
                    var maxX: CGFloat { get }
                    var minY: CGFloat { get }
                    var midY: CGFloat { get }
                    var maxY: CGFloat { get }
                    @_swiftrewriter(mapFrom: CGRectGetWidth(self:))
                    var width: CGFloat { get }
                    var height: CGFloat { get }
                    var standardized: CGRect { get }
                    var isEmpty: Bool { get }
                    var isNull: Bool { get }
                    var isInfinite: Bool { get }
                    var integral: CGRect { get }
                    
                    init()
                    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
                    func insetBy(dx: CGFloat, dy: CGFloat) -> CGRect
                    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGRect
                }
                """
            
            try! SwiftClassInterfaceParser
                .parseDeclaration(from: typeString, into: &type)
            
            return type.build()
        }
    }
}
