import XCTest
import Intentions

public extension Asserter where Object == IntentionCollection {
    /// Opens an asserter context for the list of files in the underlying
    /// `IntentionCollection` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForFiles<Result>(
        _ closure: (Asserter<[FileGenerationIntention]>) -> Result?
    ) -> Self? {
        
        let files = object.fileIntentions()

        return asserter(for: files) { files in
            files.inClosure(closure)
        }.map(self)
    }

    /// Opens an asserter context for a file with a given target path in the
    /// underlying `IntentionCollection` object being tested.
    ///
    /// Name checking is performed against the full
    /// `FileGenerationIntention.targetPath` of each file.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forTargetPathFile targetPath: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<FileGenerationIntention>) -> Result?
    ) -> Self? {
        
        asserterForFiles { files in
            files.asserterForFirstElement(
                message: #"Could not find file with target path "\#(targetPath)""#,
                file: file,
                line: line
            ) {
                $0.targetPath == targetPath
            }?.inClosure(closure)
        }
    }
    
    /// Asserts that the underlying `IntentionCollection` object being tested
    /// has a specified count of files.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        fileCount: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserterForFiles {
            $0.assertCount(fileCount, file: file, line: line)
        }
    }

    // MARK: Full file list search helpers
    
    /// Opens an asserter context for a type with a given name in the underlying
    /// `IntentionCollection` object being tested, looking at each file until
    /// a type with a specified name is found.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forTypeNamed typeName: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<TypeGenerationIntention>) -> Result?
    ) -> Self? {
        
        let types = object.typeIntentions()

        return asserter(for: types) { types in
            types.asserterForFirstElement(
                message: #"Could not find class with name "\#(typeName)""#,
                file: file,
                line: line
            ) {
                $0.typeName == typeName
            }?.inClosure(closure)
        }.map(self)
    }

    /// Opens an asserter context for a class with a given name in the underlying
    /// `IntentionCollection` object being tested, looking at each file until
    /// a class with a specified name is found.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forClassNamed typeName: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ClassGenerationIntention>) -> Result?
    ) -> Self? {

        let classes = object.classIntentions()

        return asserter(for: classes) { types in
            types.asserterForFirstElement(
                message: #"Could not find class with name "\#(typeName)""#,
                file: file,
                line: line
            ) {
                $0.typeName == typeName
            }?.inClosure(closure)
        }.map(self)
    }

    /// Opens an asserter context for a class extension with a given type name
    /// in the underlying `IntentionCollection` object being tested, looking at
    /// each file until a class extension with a specified name is found.
    /// Optionally a category name can be specified to return only extensions
    /// with a matching `categoryName` property.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forClassExtensionNamed typeName: String,
        categoryName: String? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ClassExtensionGenerationIntention>) -> Result?
    ) -> Self? {

        let extensions = object.extensionIntentions()

        return asserter(for: extensions) { types in
            types.asserterForFirstElement(
                message: #"Could not find class extension with name "\#(typeName)" and category name "\#(categoryName ?? "<any>")""#,
                file: file,
                line: line
            ) {
                $0.typeName == typeName && (categoryName == nil || $0.categoryName == categoryName)
            }?.inClosure(closure)
        }.map(self)
    }

    /// Opens an asserter context for a global function with a given name in the
    /// underlying `IntentionCollection` object being tested, looking at each
    /// file until a global function with a specified name is found.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forGlobalFunctionNamed name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<GlobalFunctionGenerationIntention>) -> Result?
    ) -> Self? {

        let globalFunctions = object.globalFunctions()

        return asserter(for: globalFunctions) { functions in
            functions.asserterForFirstElement(
                message: #"Could not find class with name "\#(name)""#,
                file: file,
                line: line
            ) {
                $0.name == name
            }?.inClosure(closure)
        }.map(self)
    }
}
