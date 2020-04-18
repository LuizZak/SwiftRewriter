#if !canImport(ObjectiveC)
import XCTest

extension DefaultIntentionPassesTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DefaultIntentionPassesTests = [
        ("testDefaultIntentionPasses", testDefaultIntentionPasses),
    ]
}

extension DetectNonnullReturnsIntentionPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DetectNonnullReturnsIntentionPassTests = [
        ("testApplyOnMethod", testApplyOnMethod),
        ("testDontApplyOnMethodWithErrorReturnType", testDontApplyOnMethodWithErrorReturnType),
        ("testDontApplyOnMethodWithExplicitOptionalReturnType", testDontApplyOnMethodWithExplicitOptionalReturnType),
        ("testDontApplyOnOverrides", testDontApplyOnOverrides),
    ]
}

extension FileTypeMergingIntentionPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FileTypeMergingIntentionPassTests = [
        ("testDoesNotRemovesExtensionsWithCategoryName", testDoesNotRemovesExtensionsWithCategoryName),
        ("testDoesNotRemovesExtensionsWithInheritances", testDoesNotRemovesExtensionsWithInheritances),
        ("testDoesNotRemovesExtensionsWithMembers", testDoesNotRemovesExtensionsWithMembers),
        ("testDoesntMergeStaticAndNonStaticSelectors", testDoesntMergeStaticAndNonStaticSelectors),
        ("testDontDuplicateGlobalFunctionsDeclarationsWhenMovingFromHeaderToImplementation", testDontDuplicateGlobalFunctionsDeclarationsWhenMovingFromHeaderToImplementation),
        ("testDontDuplicateGlobalVariableDeclarationsWhenMovingFromHeaderToImplementation", testDontDuplicateGlobalVariableDeclarationsWhenMovingFromHeaderToImplementation),
        ("testDontMergeSimilarButNotActuallyMatchingGlobalFunctions", testDontMergeSimilarButNotActuallyMatchingGlobalFunctions),
        ("testHistoryTracking", testHistoryTracking),
        ("testKeepsAliasInMergedBlockSignatures", testKeepsAliasInMergedBlockSignatures),
        ("testKeepsInterfaceFilesWithNoMatchingImplementationFileAlone", testKeepsInterfaceFilesWithNoMatchingImplementationFileAlone),
        ("testMergeBlockParameterNullability", testMergeBlockParameterNullability),
        ("testMergeDirectivesIntoImplementationFile", testMergeDirectivesIntoImplementationFile),
        ("testMergeFiles", testMergeFiles),
        ("testMergeFromSameFile", testMergeFromSameFile),
        ("testMergeFunctionDefinitionsToDeclarations", testMergeFunctionDefinitionsToDeclarations),
        ("testMergeKeepsEmptyFilesWithPreprocessorDirectives", testMergeKeepsEmptyFilesWithPreprocessorDirectives),
        ("testMergeStructTypeDefinitions", testMergeStructTypeDefinitions),
        ("testMergingTypesSortsMethodsFromImplementationAboveMethodsFromInterface", testMergingTypesSortsMethodsFromImplementationAboveMethodsFromInterface),
        ("testMovesClassesFromHeaderToImplementationWithMismatchesFileNames", testMovesClassesFromHeaderToImplementationWithMismatchesFileNames),
        ("testMovesEnumsToImplementationWhenAvailable", testMovesEnumsToImplementationWhenAvailable),
        ("testMovesGlobalFunctionsToImplementationWhenAvailable", testMovesGlobalFunctionsToImplementationWhenAvailable),
        ("testMovesGlobalVariablesToImplementationWhenAvailable", testMovesGlobalVariablesToImplementationWhenAvailable),
        ("testMovesProtocolsToImplementationWhenAvailable", testMovesProtocolsToImplementationWhenAvailable),
        ("testMovesStructsToImplementationWhenAvailable", testMovesStructsToImplementationWhenAvailable),
        ("testMovesTypealiasesToImplementationWhenAvailable", testMovesTypealiasesToImplementationWhenAvailable),
        ("testProperMergeOfStaticSelectors", testProperMergeOfStaticSelectors),
        ("testRemovesEmptyExtensions", testRemovesEmptyExtensions),
    ]
}

extension ImportDirectiveIntentionPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ImportDirectiveIntentionPassTests = [
        ("testImportDirectiveIntentionPass", testImportDirectiveIntentionPass),
    ]
}

extension InitAnalysisIntentionPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__InitAnalysisIntentionPassTests = [
        ("testEmptyInit", testEmptyInit),
        ("testFlagsInitAsConvenienceInit", testFlagsInitAsConvenienceInit),
        ("testIgnoreWithinIfWithNilCheckSelf", testIgnoreWithinIfWithNilCheckSelf),
        ("testIgnoreWithinIfWithNilCheckSelfEqualsSelfInit", testIgnoreWithinIfWithNilCheckSelfEqualsSelfInit),
        ("testIgnoreWithinIfWithNilCheckSelfEqualsSuperInit", testIgnoreWithinIfWithNilCheckSelfEqualsSuperInit),
        ("testInitThatHasBlockThatReturnsNil", testInitThatHasBlockThatReturnsNil),
        ("testInitThatReturnsNil", testInitThatReturnsNil),
    ]
}

extension PromoteProtocolPropertyConformanceIntentionPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PromoteProtocolPropertyConformanceIntentionPassTests = [
        ("testDontDuplicatePropertyImplementations", testDontDuplicatePropertyImplementations),
        ("testDontDuplicatePropertyImplementations_2", testDontDuplicatePropertyImplementations_2),
        ("testLookThroughNullabilityInSignatureOfMethodAndProperty", testLookThroughNullabilityInSignatureOfMethodAndProperty),
        ("testPromoteMethodIntoGetterComputedProperty", testPromoteMethodIntoGetterComputedProperty),
    ]
}

extension PropertyMergeIntentionPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PropertyMergeIntentionPassTests = [
        ("testCreateBackingFieldIfUsageIsFoundTakingIntoAccountSynthesizationDeclarations", testCreateBackingFieldIfUsageIsFoundTakingIntoAccountSynthesizationDeclarations),
        ("testDoesntConfusesLocalVariableWithSynthesizedBackingField", testDoesntConfusesLocalVariableWithSynthesizedBackingField),
        ("testDontCreateBackingFieldIfExplicitSynthesizeDeclarationNamesAnotherBackingField", testDontCreateBackingFieldIfExplicitSynthesizeDeclarationNamesAnotherBackingField),
        ("testDontCreateBackingFieldIfExplicitSynthesizeDeclarationNamesAnotherBackingField_AcrossCategories", testDontCreateBackingFieldIfExplicitSynthesizeDeclarationNamesAnotherBackingField_AcrossCategories),
        ("testDontCreateBackingFieldIfExplicitSynthesizeDeclarationPointsInstanceVariableWithSameNameAsProperty", testDontCreateBackingFieldIfExplicitSynthesizeDeclarationPointsInstanceVariableWithSameNameAsProperty),
        ("testDontMergeGetterAndSetterWithDifferentTypes", testDontMergeGetterAndSetterWithDifferentTypes),
        ("testDontMergeInstancePropertyWithClassGetterSetterLikesAndViceVersa", testDontMergeInstancePropertyWithClassGetterSetterLikesAndViceVersa),
        ("testDontOverwriteImplementationsWhileVisitingCategoriesOfType", testDontOverwriteImplementationsWhileVisitingCategoriesOfType),
        ("testErasesAccessLevelWhenDealingWithSettableSynthesizedProperty", testErasesAccessLevelWhenDealingWithSettableSynthesizedProperty),
        ("testHistoryTrackingMergingGetterSetterMethods", testHistoryTrackingMergingGetterSetterMethods),
        ("testMergeGetterAndSetter", testMergeGetterAndSetter),
        ("testMergeGetterAndSetterWithTypeAliases", testMergeGetterAndSetterWithTypeAliases),
        ("testMergeInCategories", testMergeInCategories),
        ("testMergePropertiesWithDifferentNullabilitySignatures", testMergePropertiesWithDifferentNullabilitySignatures),
        ("testMergePropertyFromExtension", testMergePropertyFromExtension),
        ("testMergePropertyWithSetterInCategory", testMergePropertyWithSetterInCategory),
        ("testMergeReadonlyRespectsCustomizedGetterWithNonRelatedSetter", testMergeReadonlyRespectsCustomizedGetterWithNonRelatedSetter),
        ("testMergeReadonlyWithGetter", testMergeReadonlyWithGetter),
        ("testMergeSetterOverrideProducesBackingField", testMergeSetterOverrideProducesBackingField),
        ("testMergesPropertyAndAccessorMethodsBetweenExtensionsAcrossFiles", testMergesPropertyAndAccessorMethodsBetweenExtensionsAcrossFiles),
        ("testMergesPropertyAndAccessorMethodsBetweenExtensionsWithinFile", testMergesPropertyAndAccessorMethodsBetweenExtensionsWithinFile),
        ("testPropertyMergingRespectsExistingPropertySynthesization", testPropertyMergingRespectsExistingPropertySynthesization),
        ("testSynthesizeBackingFieldInCategoryExtensions", testSynthesizeBackingFieldInCategoryExtensions),
        ("testSynthesizeBackingFieldOnIndirectReferences", testSynthesizeBackingFieldOnIndirectReferences),
        ("testSynthesizeBackingFieldWhenUsageOfBackingFieldIsDetected", testSynthesizeBackingFieldWhenUsageOfBackingFieldIsDetected),
        ("testSynthesizesReadOnlyBackingFieldIfPropertyIsReadOnly", testSynthesizesReadOnlyBackingFieldIfPropertyIsReadOnly),
    ]
}

extension ProtocolNullabilityPropagationToConformersIntentionPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ProtocolNullabilityPropagationToConformersIntentionPassTests = [
        ("testPropagatesNullability", testPropagatesNullability),
        ("testPropagatesNullabilityLookingThroughProtocolConformancesInExtensions", testPropagatesNullabilityLookingThroughProtocolConformancesInExtensions),
        ("testProperlyOrganizePropagationToTypeExtensions", testProperlyOrganizePropagationToTypeExtensions),
    ]
}

extension StoredPropertyToNominalTypesIntentionPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StoredPropertyToNominalTypesIntentionPassTests = [
        ("testDontMovePropertyWithFullGetterAndSetterDefinitions", testDontMovePropertyWithFullGetterAndSetterDefinitions),
        ("testDontMoveReadonlyPropertyWithGetterDefinition", testDontMoveReadonlyPropertyWithGetterDefinition),
        ("testMovePropertyFromExtensionToMainDeclaration", testMovePropertyFromExtensionToMainDeclaration),
    ]
}

extension SubscriptDeclarationPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SubscriptDeclarationPassTests = [
        ("testConvertSubscriptGetter", testConvertSubscriptGetter),
        ("testConvertSubscriptGetterAndSetter", testConvertSubscriptGetterAndSetter),
        ("testConvertSubscriptGetterAndSetterHistoryTracking", testConvertSubscriptGetterAndSetterHistoryTracking),
        ("testConvertSubscriptGetterHistoryTracking", testConvertSubscriptGetterHistoryTracking),
        ("testDontConvertGetterWithVoidReturnType", testDontConvertGetterWithVoidReturnType),
        ("testDontConvertSubscriptWithSetterOnly", testDontConvertSubscriptWithSetterOnly),
        ("testDontMergeGetterWithSetterWithDifferentIndexParameters", testDontMergeGetterWithSetterWithDifferentIndexParameters),
        ("testDontMergeGetterWithSetterWithDifferentObjectParameter", testDontMergeGetterWithSetterWithDifferentObjectParameter),
        ("testDontMergeGetterWithSetterWithNonVoidReturnType", testDontMergeGetterWithSetterWithNonVoidReturnType),
    ]
}

extension SwiftifyMethodSignaturesIntentionPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SwiftifyMethodSignaturesIntentionPassTests = [
        ("testConvertInit", testConvertInit),
        ("testConvertInitWithInt", testConvertInitWithInt),
        ("testConvertInitWithNonMatchingSelectorName", testConvertInitWithNonMatchingSelectorName),
        ("testConvertNullableReturnInitsIntoFailableInits", testConvertNullableReturnInitsIntoFailableInits),
        ("testConvertVeryShortTypeName", testConvertVeryShortTypeName),
        ("testConvertWith", testConvertWith),
        ("testConvertWithAtSuffix", testConvertWithAtSuffix),
        ("testConvertWithin", testConvertWithin),
        ("testConvertWithinWithParameter", testConvertWithinWithParameter),
        ("testConvertWithOnlyConvertsIfSelectorSuffixMatchesTypeNameAsWell", testConvertWithOnlyConvertsIfSelectorSuffixMatchesTypeNameAsWell),
        ("testDontConvertNonInitMethods", testDontConvertNonInitMethods),
    ]
}

extension UIKitCorrectorIntentionPassTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__UIKitCorrectorIntentionPassTests = [
        ("testDrawRect", testDrawRect),
        ("testUITableViewDataSource", testUITableViewDataSource),
        ("testUITableViewDelegate", testUITableViewDelegate),
        ("testUpdatesNullabilityOfDetectedOverrides", testUpdatesNullabilityOfDetectedOverrides),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DefaultIntentionPassesTests.__allTests__DefaultIntentionPassesTests),
        testCase(DetectNonnullReturnsIntentionPassTests.__allTests__DetectNonnullReturnsIntentionPassTests),
        testCase(FileTypeMergingIntentionPassTests.__allTests__FileTypeMergingIntentionPassTests),
        testCase(ImportDirectiveIntentionPassTests.__allTests__ImportDirectiveIntentionPassTests),
        testCase(InitAnalysisIntentionPassTests.__allTests__InitAnalysisIntentionPassTests),
        testCase(PromoteProtocolPropertyConformanceIntentionPassTests.__allTests__PromoteProtocolPropertyConformanceIntentionPassTests),
        testCase(PropertyMergeIntentionPassTests.__allTests__PropertyMergeIntentionPassTests),
        testCase(ProtocolNullabilityPropagationToConformersIntentionPassTests.__allTests__ProtocolNullabilityPropagationToConformersIntentionPassTests),
        testCase(StoredPropertyToNominalTypesIntentionPassTests.__allTests__StoredPropertyToNominalTypesIntentionPassTests),
        testCase(SubscriptDeclarationPassTests.__allTests__SubscriptDeclarationPassTests),
        testCase(SwiftifyMethodSignaturesIntentionPassTests.__allTests__SwiftifyMethodSignaturesIntentionPassTests),
        testCase(UIKitCorrectorIntentionPassTests.__allTests__UIKitCorrectorIntentionPassTests),
    ]
}
#endif
