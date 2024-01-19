import SwiftSyntax

extension TokenSyntax {
    @available(*, deprecated, renamed: "leftParenToken()")
    static var leftParen: TokenSyntax { .leftParenToken() }

    @available(*, deprecated, renamed: "rightParenToken()")
    static var rightParen: TokenSyntax { .rightParenToken() }

    @available(*, deprecated, renamed: "colonToken()")
    static var colon: TokenSyntax { .colonToken() }

    @available(*, deprecated, renamed: "commaToken()")
    static var comma: TokenSyntax { .commaToken() }
    
    @available(*, deprecated, renamed: "atSignToken()")
    static var atSign: TokenSyntax { .atSignToken() }

    @available(*, deprecated, renamed: "colonToken()")
    static var arrow: TokenSyntax { .arrowToken() }

    @available(*, deprecated, renamed: "leftBraceToken()")
    static var leftBrace: TokenSyntax { .leftBraceToken() }

    @available(*, deprecated, renamed: "rightBraceToken()")
    static var rightBrace: TokenSyntax { .rightBraceToken() }

    @available(*, deprecated, renamed: "leftSquareToken()")
    static var leftSquare: TokenSyntax { .leftSquareToken() }

    @available(*, deprecated, renamed: "rightSquareToken()")
    static var rightSquare: TokenSyntax { .rightSquareToken() }

    @available(*, deprecated, renamed: "leftAngleToken()")
    static var leftAngle: TokenSyntax { .leftAngleToken() }

    @available(*, deprecated, renamed: "rightAngleToken()")
    static var rightAngle: TokenSyntax { .rightAngleToken() }

    @available(*, deprecated, renamed: "wildcardToken()")
    static var wildcard: TokenSyntax { .wildcardToken() }

    @available(*, deprecated, renamed: "periodToken()")
    static var period: TokenSyntax { .periodToken() }

    @available(*, deprecated, renamed: "exclamationMarkToken()")
    static var exclamationMark: TokenSyntax { .exclamationMarkToken() }

    @available(*, deprecated, renamed: "ellipsisToken()")
    static var ellipsis: TokenSyntax { .ellipsisToken() }
}

extension MemberDeclBlockSyntax {
    @available(*, deprecated, renamed: "init(leadingTrivia:_:leftBrace:_:members:_:rightBrace:_:trailingTrivia:)")
    init() {
        self.init(members: [])
    }
}

extension TokenSyntax {
    @available(*, deprecated, renamed: "keyword()")
    static var __consuming: TokenSyntax { .keyword(.__consuming) }
    @available(*, deprecated, renamed: "keyword()")
    static var __owned: TokenSyntax { .keyword(.__owned) }
    @available(*, deprecated, renamed: "keyword()")
    static var __setter_access: TokenSyntax { .keyword(.__setter_access) }
    @available(*, deprecated, renamed: "keyword()")
    static var __shared: TokenSyntax { .keyword(.__shared) }
    @available(*, deprecated, renamed: "keyword()")
    static var _alignment: TokenSyntax { .keyword(._alignment) }
    @available(*, deprecated, renamed: "keyword()")
    static var _backDeploy: TokenSyntax { .keyword(._backDeploy) }
    @available(*, deprecated, renamed: "keyword()")
    static var _borrow: TokenSyntax { .keyword(._borrow) }
    @available(*, deprecated, renamed: "keyword()")
    static var _cdecl: TokenSyntax { .keyword(._cdecl) }
    @available(*, deprecated, renamed: "keyword()")
    static var _Class: TokenSyntax { .keyword(._Class) }
    @available(*, deprecated, renamed: "keyword()")
    static var _compilerInitialized: TokenSyntax { .keyword(._compilerInitialized) }
    @available(*, deprecated, renamed: "keyword()")
    static var _const: TokenSyntax { .keyword(._const) }
    @available(*, deprecated, renamed: "keyword()")
    static var _documentation: TokenSyntax { .keyword(._documentation) }
    @available(*, deprecated, renamed: "keyword()")
    static var _dynamicReplacement: TokenSyntax { .keyword(._dynamicReplacement) }
    @available(*, deprecated, renamed: "keyword()")
    static var _effects: TokenSyntax { .keyword(._effects) }
    @available(*, deprecated, renamed: "keyword()")
    static var _expose: TokenSyntax { .keyword(._expose) }
    @available(*, deprecated, renamed: "keyword()")
    static var _forward: TokenSyntax { .keyword(._forward) }
    @available(*, deprecated, renamed: "keyword()")
    static var _implements: TokenSyntax { .keyword(._implements) }
    @available(*, deprecated, renamed: "keyword()")
    static var _linear: TokenSyntax { .keyword(._linear) }
    @available(*, deprecated, renamed: "keyword()")
    static var _local: TokenSyntax { .keyword(._local) }
    @available(*, deprecated, renamed: "keyword()")
    static var _modify: TokenSyntax { .keyword(._modify) }
    @available(*, deprecated, renamed: "keyword()")
    static var _move: TokenSyntax { .keyword(._move) }
    @available(*, deprecated, renamed: "keyword()")
    static var _NativeClass: TokenSyntax { .keyword(._NativeClass) }
    @available(*, deprecated, renamed: "keyword()")
    static var _NativeRefCountedObject: TokenSyntax { .keyword(._NativeRefCountedObject) }
    @available(*, deprecated, renamed: "keyword()")
    static var _noMetadata: TokenSyntax { .keyword(._noMetadata) }
    @available(*, deprecated, renamed: "keyword()")
    static var _nonSendable: TokenSyntax { .keyword(._nonSendable) }
    @available(*, deprecated, renamed: "keyword()")
    static var _objcImplementation: TokenSyntax { .keyword(._objcImplementation) }
    @available(*, deprecated, renamed: "keyword()")
    static var _objcRuntimeName: TokenSyntax { .keyword(._objcRuntimeName) }
    @available(*, deprecated, renamed: "keyword()")
    static var _opaqueReturnTypeOf: TokenSyntax { .keyword(._opaqueReturnTypeOf) }
    @available(*, deprecated, renamed: "keyword()")
    static var _optimize: TokenSyntax { .keyword(._optimize) }
    @available(*, deprecated, renamed: "keyword()")
    static var _originallyDefinedIn: TokenSyntax { .keyword(._originallyDefinedIn) }
    @available(*, deprecated, renamed: "keyword()")
    static var _PackageDescription: TokenSyntax { .keyword(._PackageDescription) }
    @available(*, deprecated, renamed: "keyword()")
    static var _private: TokenSyntax { .keyword(._private) }
    @available(*, deprecated, renamed: "keyword()")
    static var _projectedValueProperty: TokenSyntax { .keyword(._projectedValueProperty) }
    @available(*, deprecated, renamed: "keyword()")
    static var _read: TokenSyntax { .keyword(._read) }
    @available(*, deprecated, renamed: "keyword()")
    static var _RefCountedObject: TokenSyntax { .keyword(._RefCountedObject) }
    @available(*, deprecated, renamed: "keyword()")
    static var _semantics: TokenSyntax { .keyword(._semantics) }
    @available(*, deprecated, renamed: "keyword()")
    static var _specialize: TokenSyntax { .keyword(._specialize) }
    @available(*, deprecated, renamed: "keyword()")
    static var _spi: TokenSyntax { .keyword(._spi) }
    @available(*, deprecated, renamed: "keyword()")
    static var _spi_available: TokenSyntax { .keyword(._spi_available) }
    @available(*, deprecated, renamed: "keyword()")
    static var _swift_native_objc_runtime_base: TokenSyntax { .keyword(._swift_native_objc_runtime_base) }
    @available(*, deprecated, renamed: "keyword()")
    static var _Trivial: TokenSyntax { .keyword(._Trivial) }
    @available(*, deprecated, renamed: "keyword()")
    static var _TrivialAtMost: TokenSyntax { .keyword(._TrivialAtMost) }
    @available(*, deprecated, renamed: "keyword()")
    static var _typeEraser: TokenSyntax { .keyword(._typeEraser) }
    @available(*, deprecated, renamed: "keyword()")
    static var _unavailableFromAsync: TokenSyntax { .keyword(._unavailableFromAsync) }
    @available(*, deprecated, renamed: "keyword()")
    static var _underlyingVersion: TokenSyntax { .keyword(._underlyingVersion) }
    @available(*, deprecated, renamed: "keyword()")
    static var _UnknownLayout: TokenSyntax { .keyword(._UnknownLayout) }
    @available(*, deprecated, renamed: "keyword()")
    static var _version: TokenSyntax { .keyword(._version) }
    @available(*, deprecated, renamed: "keyword()")
    static var accesses: TokenSyntax { .keyword(.accesses) }
    @available(*, deprecated, renamed: "keyword()")
    static var actor: TokenSyntax { .keyword(.actor) }
    @available(*, deprecated, renamed: "keyword()")
    static var addressWithNativeOwner: TokenSyntax { .keyword(.addressWithNativeOwner) }
    @available(*, deprecated, renamed: "keyword()")
    static var addressWithOwner: TokenSyntax { .keyword(.addressWithOwner) }
    @available(*, deprecated, renamed: "keyword()")
    static var any: TokenSyntax { .keyword(.any) }
    @available(*, deprecated, renamed: "keyword()")
    static var `Any`: TokenSyntax { .keyword(.`Any`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `as`: TokenSyntax { .keyword(.`as`) }
    @available(*, deprecated, renamed: "keyword()")
    static var assignment: TokenSyntax { .keyword(.assignment) }
    @available(*, deprecated, renamed: "keyword()")
    static var `associatedtype`: TokenSyntax { .keyword(.`associatedtype`) }
    @available(*, deprecated, renamed: "keyword()")
    static var associativity: TokenSyntax { .keyword(.associativity) }
    @available(*, deprecated, renamed: "keyword()")
    static var async: TokenSyntax { .keyword(.async) }
    @available(*, deprecated, renamed: "keyword()")
    static var attached: TokenSyntax { .keyword(.attached) }
    @available(*, deprecated, renamed: "keyword()")
    static var autoclosure: TokenSyntax { .keyword(.autoclosure) }
    @available(*, deprecated, renamed: "keyword()")
    static var availability: TokenSyntax { .keyword(.availability) }
    @available(*, deprecated, renamed: "keyword()")
    static var available: TokenSyntax { .keyword(.available) }
    @available(*, deprecated, renamed: "keyword()")
    static var await: TokenSyntax { .keyword(.await) }
    @available(*, deprecated, renamed: "keyword()")
    static var backDeployed: TokenSyntax { .keyword(.backDeployed) }
    @available(*, deprecated, renamed: "keyword()")
    static var before: TokenSyntax { .keyword(.before) }
    @available(*, deprecated, renamed: "keyword()")
    static var block: TokenSyntax { .keyword(.block) }
    @available(*, deprecated, renamed: "keyword()")
    static var borrowing: TokenSyntax { .keyword(.borrowing) }
    @available(*, deprecated, renamed: "keyword()")
    static var `break`: TokenSyntax { .keyword(.`break`) }
    @available(*, deprecated, renamed: "keyword()")
    static var canImport: TokenSyntax { .keyword(.canImport) }
    @available(*, deprecated, renamed: "keyword()")
    static var `case`: TokenSyntax { .keyword(.`case`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `catch`: TokenSyntax { .keyword(.`catch`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `class`: TokenSyntax { .keyword(.`class`) }
    @available(*, deprecated, renamed: "keyword()")
    static var compiler: TokenSyntax { .keyword(.compiler) }
    @available(*, deprecated, renamed: "keyword()")
    static var consume: TokenSyntax { .keyword(.consume) }
    @available(*, deprecated, renamed: "keyword()")
    static var copy: TokenSyntax { .keyword(.copy) }
    @available(*, deprecated, renamed: "keyword()")
    static var consuming: TokenSyntax { .keyword(.consuming) }
    @available(*, deprecated, renamed: "keyword()")
    static var `continue`: TokenSyntax { .keyword(.`continue`) }
    @available(*, deprecated, renamed: "keyword()")
    static var convenience: TokenSyntax { .keyword(.convenience) }
    @available(*, deprecated, renamed: "keyword()")
    static var convention: TokenSyntax { .keyword(.convention) }
    @available(*, deprecated, renamed: "keyword()")
    static var cType: TokenSyntax { .keyword(.cType) }
    @available(*, deprecated, renamed: "keyword()")
    static var `default`: TokenSyntax { .keyword(.`default`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `defer`: TokenSyntax { .keyword(.`defer`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `deinit`: TokenSyntax { .keyword(.`deinit`) }
    @available(*, deprecated, renamed: "keyword()")
    static var deprecated: TokenSyntax { .keyword(.deprecated) }
    @available(*, deprecated, renamed: "keyword()")
    static var derivative: TokenSyntax { .keyword(.derivative) }
    @available(*, deprecated, renamed: "keyword()")
    static var didSet: TokenSyntax { .keyword(.didSet) }
    @available(*, deprecated, renamed: "keyword()")
    static var differentiable: TokenSyntax { .keyword(.differentiable) }
    @available(*, deprecated, renamed: "keyword()")
    static var distributed: TokenSyntax { .keyword(.distributed) }
    @available(*, deprecated, renamed: "keyword()")
    static var `do`: TokenSyntax { .keyword(.`do`) }
    @available(*, deprecated, renamed: "keyword()")
    static var dynamic: TokenSyntax { .keyword(.dynamic) }
    @available(*, deprecated, renamed: "keyword()")
    static var each: TokenSyntax { .keyword(.each) }
    @available(*, deprecated, renamed: "keyword()")
    static var `else`: TokenSyntax { .keyword(.`else`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `enum`: TokenSyntax { .keyword(.`enum`) }
    @available(*, deprecated, renamed: "keyword()")
    static var escaping: TokenSyntax { .keyword(.escaping) }
    @available(*, deprecated, renamed: "keyword()")
    static var exclusivity: TokenSyntax { .keyword(.exclusivity) }
    @available(*, deprecated, renamed: "keyword()")
    static var exported: TokenSyntax { .keyword(.exported) }
    @available(*, deprecated, renamed: "keyword()")
    static var `extension`: TokenSyntax { .keyword(.`extension`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `fallthrough`: TokenSyntax { .keyword(.`fallthrough`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `false`: TokenSyntax { .keyword(.`false`) }
    @available(*, deprecated, renamed: "keyword()")
    static var file: TokenSyntax { .keyword(.file) }
    @available(*, deprecated, renamed: "keyword()")
    static var `fileprivate`: TokenSyntax { .keyword(.`fileprivate`) }
    @available(*, deprecated, renamed: "keyword()")
    static var final: TokenSyntax { .keyword(.final) }
    @available(*, deprecated, renamed: "keyword()")
    static var `for`: TokenSyntax { .keyword(.`for`) }
    @available(*, deprecated, renamed: "keyword()")
    static var discard: TokenSyntax { .keyword(.discard) }
    @available(*, deprecated, renamed: "keyword()")
    static var forward: TokenSyntax { .keyword(.forward) }
    @available(*, deprecated, renamed: "keyword()")
    static var `func`: TokenSyntax { .keyword(.`func`) }
    @available(*, deprecated, renamed: "keyword()")
    static var get: TokenSyntax { .keyword(.get) }
    @available(*, deprecated, renamed: "keyword()")
    static var `guard`: TokenSyntax { .keyword(.`guard`) }
    @available(*, deprecated, renamed: "keyword()")
    static var higherThan: TokenSyntax { .keyword(.higherThan) }
    @available(*, deprecated, renamed: "keyword()")
    static var `if`: TokenSyntax { .keyword(.`if`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `import`: TokenSyntax { .keyword(.`import`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `in`: TokenSyntax { .keyword(.`in`) }
    @available(*, deprecated, renamed: "keyword()")
    static var indirect: TokenSyntax { .keyword(.indirect) }
    @available(*, deprecated, renamed: "keyword()")
    static var infix: TokenSyntax { .keyword(.infix) }
    @available(*, deprecated, renamed: "keyword()")
    static var `init`: TokenSyntax { .keyword(.`init`) }
    @available(*, deprecated, renamed: "keyword()")
    static var initializes: TokenSyntax { .keyword(.initializes) }
    @available(*, deprecated, renamed: "keyword()")
    static var inline: TokenSyntax { .keyword(.inline) }
    @available(*, deprecated, renamed: "keyword()")
    static var `inout`: TokenSyntax { .keyword(.`inout`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `internal`: TokenSyntax { .keyword(.`internal`) }
    @available(*, deprecated, renamed: "keyword()")
    static var introduced: TokenSyntax { .keyword(.introduced) }
    @available(*, deprecated, renamed: "keyword()")
    static var `is`: TokenSyntax { .keyword(.`is`) }
    @available(*, deprecated, renamed: "keyword()")
    static var isolated: TokenSyntax { .keyword(.isolated) }
    @available(*, deprecated, renamed: "keyword()")
    static var kind: TokenSyntax { .keyword(.kind) }
    @available(*, deprecated, renamed: "keyword()")
    static var lazy: TokenSyntax { .keyword(.lazy) }
    @available(*, deprecated, renamed: "keyword()")
    static var left: TokenSyntax { .keyword(.left) }
    @available(*, deprecated, renamed: "keyword()")
    static var `let`: TokenSyntax { .keyword(.`let`) }
    @available(*, deprecated, renamed: "keyword()")
    static var line: TokenSyntax { .keyword(.line) }
    @available(*, deprecated, renamed: "keyword()")
    static var linear: TokenSyntax { .keyword(.linear) }
    @available(*, deprecated, renamed: "keyword()")
    static var lowerThan: TokenSyntax { .keyword(.lowerThan) }
    @available(*, deprecated, renamed: "keyword()")
    static var macro: TokenSyntax { .keyword(.macro) }
    @available(*, deprecated, renamed: "keyword()")
    static var message: TokenSyntax { .keyword(.message) }
    @available(*, deprecated, renamed: "keyword()")
    static var metadata: TokenSyntax { .keyword(.metadata) }
    @available(*, deprecated, renamed: "keyword()")
    static var module: TokenSyntax { .keyword(.module) }
    @available(*, deprecated, renamed: "keyword()")
    static var mutableAddressWithNativeOwner: TokenSyntax { .keyword(.mutableAddressWithNativeOwner) }
    @available(*, deprecated, renamed: "keyword()")
    static var mutableAddressWithOwner: TokenSyntax { .keyword(.mutableAddressWithOwner) }
    @available(*, deprecated, renamed: "keyword()")
    static var mutating: TokenSyntax { .keyword(.mutating) }
    @available(*, deprecated, renamed: "keyword()")
    static var `nil`: TokenSyntax { .keyword(.`nil`) }
    @available(*, deprecated, renamed: "keyword()")
    static var noasync: TokenSyntax { .keyword(.noasync) }
    @available(*, deprecated, renamed: "keyword()")
    static var noDerivative: TokenSyntax { .keyword(.noDerivative) }
    @available(*, deprecated, renamed: "keyword()")
    static var noescape: TokenSyntax { .keyword(.noescape) }
    @available(*, deprecated, renamed: "keyword()")
    static var none: TokenSyntax { .keyword(.none) }
    @available(*, deprecated, renamed: "keyword()")
    static var nonisolated: TokenSyntax { .keyword(.nonisolated) }
    @available(*, deprecated, renamed: "keyword()")
    static var nonmutating: TokenSyntax { .keyword(.nonmutating) }
    @available(*, deprecated, renamed: "keyword()")
    static var objc: TokenSyntax { .keyword(.objc) }
    @available(*, deprecated, renamed: "keyword()")
    static var obsoleted: TokenSyntax { .keyword(.obsoleted) }
    @available(*, deprecated, renamed: "keyword()")
    static var of: TokenSyntax { .keyword(.of) }
    @available(*, deprecated, renamed: "keyword()")
    static var open: TokenSyntax { .keyword(.open) }
    @available(*, deprecated, renamed: "keyword()")
    static var `operator`: TokenSyntax { .keyword(.`operator`) }
    @available(*, deprecated, renamed: "keyword()")
    static var optional: TokenSyntax { .keyword(.optional) }
    @available(*, deprecated, renamed: "keyword()")
    static var override: TokenSyntax { .keyword(.override) }
    @available(*, deprecated, renamed: "keyword()")
    static var package: TokenSyntax { .keyword(.package) }
    @available(*, deprecated, renamed: "keyword()")
    static var postfix: TokenSyntax { .keyword(.postfix) }
    @available(*, deprecated, renamed: "keyword()")
    static var `precedencegroup`: TokenSyntax { .keyword(.`precedencegroup`) }
    @available(*, deprecated, renamed: "keyword()")
    static var prefix: TokenSyntax { .keyword(.prefix) }
    @available(*, deprecated, renamed: "keyword()")
    static var `private`: TokenSyntax { .keyword(.`private`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `Protocol`: TokenSyntax { .keyword(.`Protocol`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `protocol`: TokenSyntax { .keyword(.`protocol`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `public`: TokenSyntax { .keyword(.`public`) }
    @available(*, deprecated, renamed: "keyword()")
    static var reasync: TokenSyntax { .keyword(.reasync) }
    @available(*, deprecated, renamed: "keyword()")
    static var renamed: TokenSyntax { .keyword(.renamed) }
    @available(*, deprecated, renamed: "keyword()")
    static var `repeat`: TokenSyntax { .keyword(.`repeat`) }
    @available(*, deprecated, renamed: "keyword()")
    static var required: TokenSyntax { .keyword(.required) }
    @available(*, deprecated, renamed: "keyword()")
    static var `rethrows`: TokenSyntax { .keyword(.`rethrows`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `return`: TokenSyntax { .keyword(.`return`) }
    @available(*, deprecated, renamed: "keyword()")
    static var reverse: TokenSyntax { .keyword(.reverse) }
    @available(*, deprecated, renamed: "keyword()")
    static var right: TokenSyntax { .keyword(.right) }
    @available(*, deprecated, renamed: "keyword()")
    static var safe: TokenSyntax { .keyword(.safe) }
    @available(*, deprecated, renamed: "keyword()")
    static var `self`: TokenSyntax { .keyword(.`self`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `Self`: TokenSyntax { .keyword(.`Self`) }
    @available(*, deprecated, renamed: "keyword()")
    static var Sendable: TokenSyntax { .keyword(.Sendable) }
    @available(*, deprecated, renamed: "keyword()")
    static var set: TokenSyntax { .keyword(.set) }
    @available(*, deprecated, renamed: "keyword()")
    static var some: TokenSyntax { .keyword(.some) }
    @available(*, deprecated, renamed: "keyword()")
    static var sourceFile: TokenSyntax { .keyword(.sourceFile) }
    @available(*, deprecated, renamed: "keyword()")
    static var spi: TokenSyntax { .keyword(.spi) }
    @available(*, deprecated, renamed: "keyword()")
    static var spiModule: TokenSyntax { .keyword(.spiModule) }
    @available(*, deprecated, renamed: "keyword()")
    static var `static`: TokenSyntax { .keyword(.`static`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `struct`: TokenSyntax { .keyword(.`struct`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `subscript`: TokenSyntax { .keyword(.`subscript`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `super`: TokenSyntax { .keyword(.`super`) }
    @available(*, deprecated, renamed: "keyword()")
    static var swift: TokenSyntax { .keyword(.swift) }
    @available(*, deprecated, renamed: "keyword()")
    static var `switch`: TokenSyntax { .keyword(.`switch`) }
    @available(*, deprecated, renamed: "keyword()")
    static var target: TokenSyntax { .keyword(.target) }
    @available(*, deprecated, renamed: "keyword()")
    static var `throw`: TokenSyntax { .keyword(.`throw`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `throws`: TokenSyntax { .keyword(.`throws`) }
    @available(*, deprecated, renamed: "keyword()")
    static var transpose: TokenSyntax { .keyword(.transpose) }
    @available(*, deprecated, renamed: "keyword()")
    static var `true`: TokenSyntax { .keyword(.`true`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `try`: TokenSyntax { .keyword(.`try`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `Type`: TokenSyntax { .keyword(.`Type`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `typealias`: TokenSyntax { .keyword(.`typealias`) }
    @available(*, deprecated, renamed: "keyword()")
    static var unavailable: TokenSyntax { .keyword(.unavailable) }
    @available(*, deprecated, renamed: "keyword()")
    static var unchecked: TokenSyntax { .keyword(.unchecked) }
    @available(*, deprecated, renamed: "keyword()")
    static var unowned: TokenSyntax { .keyword(.unowned) }
    @available(*, deprecated, renamed: "keyword()")
    static var unsafe: TokenSyntax { .keyword(.unsafe) }
    @available(*, deprecated, renamed: "keyword()")
    static var unsafeAddress: TokenSyntax { .keyword(.unsafeAddress) }
    @available(*, deprecated, renamed: "keyword()")
    static var unsafeMutableAddress: TokenSyntax { .keyword(.unsafeMutableAddress) }
    @available(*, deprecated, renamed: "keyword()")
    static var `var`: TokenSyntax { .keyword(.`var`) }
    @available(*, deprecated, renamed: "keyword()")
    static var visibility: TokenSyntax { .keyword(.visibility) }
    @available(*, deprecated, renamed: "keyword()")
    static var weak: TokenSyntax { .keyword(.weak) }
    @available(*, deprecated, renamed: "keyword()")
    static var `where`: TokenSyntax { .keyword(.`where`) }
    @available(*, deprecated, renamed: "keyword()")
    static var `while`: TokenSyntax { .keyword(.`while`) }
    @available(*, deprecated, renamed: "keyword()")
    static var willSet: TokenSyntax { .keyword(.willSet) }
    @available(*, deprecated, renamed: "keyword()")
    static var witness_method: TokenSyntax { .keyword(.witness_method) }
    @available(*, deprecated, renamed: "keyword()")
    static var wrt: TokenSyntax { .keyword(.wrt) }
    @available(*, deprecated, renamed: "keyword()")
    static var yield: TokenSyntax { .keyword(.yield) }
}
