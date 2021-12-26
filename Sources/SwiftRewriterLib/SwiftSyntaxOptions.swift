import Foundation
import SwiftFormatConfiguration
import SwiftSyntaxSupport

public struct SwiftSyntaxOptions {
    /// Default settings instance
    public static let `default` = Self(
        outputExpressionTypes: false,
        printIntentionHistory: false,
        emitObjcCompatibility: false,
        alwaysEmitVariableTypes: false,
        format: .noFormatting
    )

    /// If `true`, when outputting expression statements, print the resulting
    /// type of the expression before the expression statement as a comment
    /// for inspection.
    public var outputExpressionTypes: Bool
    
    /// If `true`, when outputting final intentions, print any history
    /// information tracked on its `IntentionHistory` property before the
    /// intention's declaration as a comment for inspection.
    public var printIntentionHistory: Bool
    
    /// If `true`, `@objc` attributes and `: NSObject` are emitted for
    /// declarations during output.
    ///
    /// This may increase compatibility with previous Objective-C code when
    /// compiled and executed.
    public var emitObjcCompatibility: Bool

    /// If `true`, the output writers always emit the type of variable initializer
    /// expressions.
    public var alwaysEmitVariableTypes: Bool

    /// Specifies the type of formatting to perform on the output files.
    public var format: FormatOption
    
    public init(
        outputExpressionTypes: Bool,
        printIntentionHistory: Bool,
        emitObjcCompatibility: Bool,
        alwaysEmitVariableTypes: Bool,
        format: FormatOption
    ) {
        self.outputExpressionTypes = outputExpressionTypes
        self.printIntentionHistory = printIntentionHistory
        self.emitObjcCompatibility = emitObjcCompatibility
        self.alwaysEmitVariableTypes = alwaysEmitVariableTypes
        self.format = format
    }

    public func toSwiftSyntaxProducerSettings() -> SwiftSyntaxProducer.Settings {
        .init(
            outputExpressionTypes: self.outputExpressionTypes,
            printIntentionHistory: self.printIntentionHistory,
            emitObjcCompatibility: self.emitObjcCompatibility
        )
    }
        
    /// To ease modifications of single parameters from default settings
    /// without having to create a temporary variable first
    public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }

    /// Specifies the type of formatting to perform on the output files.
    public enum FormatOption {
        /// No formatting is performed.
        case noFormatting

        /// Performs SwiftFormat formatting, optionally using a provided configuration
        /// for the process.
        case swiftFormat(configuration: Configuration?)
    }
}
