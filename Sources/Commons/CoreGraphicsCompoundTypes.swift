import SwiftAST

public enum CoreGraphicsCompoundTypes {
    public static let cgPoint = CGPointCompoundType.self
    public static let cgSize = CGSizeCompoundType.self
    public static let cgRect = CGRectCompoundType.self
}

public enum CGPointCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "CGPoint")
    
    public static func create() -> CompoundedMappingType {
        singleton
    }
    
    private static func typeString() -> String {
        let typeString = """
            struct CGPoint {
                static var zero: CGPoint { get }
                var x: CGFloat
                var y: CGFloat
                
                init()
                
                @_swiftrewriter(initFromFunction: "CGPointMake(_:_:)")
                init(x: CGFloat, y: CGFloat)
            }
            """
        
        return typeString
    }
}

public enum CGSizeCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "CGSize")
    
    public static func create() -> CompoundedMappingType {
        singleton
    }
    
    private static func typeString() -> String {
        let typeString = """
            struct CGSize {
                static var zero: CGSize { get }
                var width: CGFloat
                var height: CGFloat
                
                init()
                
                @_swiftrewriter(initFromFunction: "CGSizeMake(_:_:)")
                init(width: CGFloat, height: CGFloat)
            }
            """
        
        return typeString
    }
}

public enum CGRectCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "CGRect")
    
    public static func create() -> CompoundedMappingType {
        singleton
    }
    
    private static func typeString() -> String {
        let typeString = """
            struct CGRect {
                static let null: CGRect
                static let infinite: CGRect
                static var zero: CGRect { get }
                
                var origin: CGPoint
                var size: CGSize
                
                @_swiftrewriter(mapFrom: "CGRectGetMinX(self:)")
                var minX: CGFloat { get }
                
                @_swiftrewriter(mapFrom: "CGRectGetMidX(self:)")
                var midX: CGFloat { get }
                
                @_swiftrewriter(mapFrom: "CGRectGetMaxX(self:)")
                var maxX: CGFloat { get }
                
                @_swiftrewriter(mapFrom: "CGRectGetMinY(self:)")
                var minY: CGFloat { get }
                
                @_swiftrewriter(mapFrom: "CGRectGetMidY(self:)")
                var midY: CGFloat { get }
                
                @_swiftrewriter(mapFrom: "CGRectGetMaxY(self:)")
                var maxY: CGFloat { get }
                
                @_swiftrewriter(mapFrom: "CGRectGetWidth(self:)")
                var width: CGFloat { get }
                
                @_swiftrewriter(mapFrom: "CGRectGetHeight(self:)")
                var height: CGFloat { get }
                var standardized: CGRect { get }
                
                @_swiftrewriter(mapFrom: "CGRectIsEmpty(self:)")
                var isEmpty: Bool { get }
                
                @_swiftrewriter(mapFrom: "CGRectIsNull(self:)")
                var isNull: Bool { get }
                
                @_swiftrewriter(mapFrom: "CGRectIsInfinite(self:)")
                var isInfinite: Bool { get }
                
                @_swiftrewriter(mapFrom: "CGRectIntegral(self:)")
                var integral: CGRect { get }
                
                init()
                
                @_swiftrewriter(initFromFunction: "CGRectMake(_:_:_:_:)")
                init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
                
                @_swiftrewriter(mapFrom: "CGRectInset(self:_:_:)")
                func insetBy(dx: CGFloat, dy: CGFloat) -> CGRect
                
                @_swiftrewriter(mapFrom: "CGRectOffset(self:_:_:)")
                func offsetBy(dx: CGFloat, dy: CGFloat) -> CGRect
                
                @_swiftrewriter(mapFrom: "CGRectIntersection(self:_:)")
                func intersection(_ r2: CGRect) -> CGRect
                
                @_swiftrewriter(mapFrom: "CGRectContainsRect(self:_:)")
                func contains(_ rect2: CGRect) -> Bool
                
                @_swiftrewriter(mapFrom: "CGRectContainsPoint(self:_:)")
                func contains(_ point: CGPoint) -> Bool
                
                @_swiftrewriter(mapFrom: "CGRectIntersectsRect(self:_:)")
                func intersects(_ rect2: CGRect) -> Bool
                
                @_swiftrewriter(mapFrom: "CGRectEqualToRect(self:_:)")
                func equalTo(_ rect2: CGRect) -> Bool
            }
            """
        
        return typeString
    }
}
