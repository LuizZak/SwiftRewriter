import XCTest

import AnalysisTests
import CommonsTests
import ExpressionPassesTests
import GlobalsProvidersTests
import GrammarModelsTests
import IntentionPassesTests
import IntentionsTests
import KnownTypeTests
import ObjcParserTests
import SourcePreprocessorsTests
import SwiftASTTests
import SwiftRewriterLibTests
import SwiftSyntaxRewriterPassesTests
import SwiftSyntaxSupportTests
import TestCommonsTests
import TypeSystemTests
import UtilsTests
import WriterTargetOutputTests

var tests = [XCTestCaseEntry]()
tests += AnalysisTests.__allTests()
tests += CommonsTests.__allTests()
tests += ExpressionPassesTests.__allTests()
tests += GlobalsProvidersTests.__allTests()
tests += GrammarModelsTests.__allTests()
tests += IntentionPassesTests.__allTests()
tests += IntentionsTests.__allTests()
tests += KnownTypeTests.__allTests()
tests += ObjcParserTests.__allTests()
tests += SourcePreprocessorsTests.__allTests()
tests += SwiftASTTests.__allTests()
tests += SwiftRewriterLibTests.__allTests()
tests += SwiftSyntaxRewriterPassesTests.__allTests()
tests += SwiftSyntaxSupportTests.__allTests()
tests += TestCommonsTests.__allTests()
tests += TypeSystemTests.__allTests()
tests += UtilsTests.__allTests()
tests += WriterTargetOutputTests.__allTests()

XCTMain(tests)
