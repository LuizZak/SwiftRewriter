//
//  ObjcParser+TokenizerTests.swift
//  ObjcParserTests
//
//  Created by Luiz Silva on 22/01/2018.
//

import XCTest
import GrammarModels
@testable import ObjcParser

class ObjcParser_TokenizerTests: XCTestCase {
    func testTokenizeLiterals() {
        expect("123", toTokenizeAs: .decimalLiteral)
        expect("123.4", toTokenizeAs: .floatLiteral)
        expect("0123", toTokenizeAs: .octalLiteral)
        expect("\"abc\"", toTokenizeAs: .stringLiteral)
        expect("@\"abc\"", toTokenizeAs: .stringLiteral)
        expect("L\"abc\"", toTokenizeAs: .stringLiteral)
    }
    
    func testTokenizeIdentifiers() {
        expect("AnIdentifier", toTokenizeAs: .identifier)
        expect("_AnIdentifier_", toTokenizeAs: .identifier)
    }
    
    func testTokenizeKeywords() {
        expect("@interface", toTokenizeAs: .keyword)
        expect("@implementation", toTokenizeAs: .keyword)
        expect("@protocol", toTokenizeAs: .keyword)
        expect("@end", toTokenizeAs: .keyword)
        expect("if", toTokenizeAs: .keyword)
        expect("else", toTokenizeAs: .keyword)
        expect("while", toTokenizeAs: .keyword)
        expect("switch", toTokenizeAs: .keyword)
        expect("continue", toTokenizeAs: .keyword)
        expect("break", toTokenizeAs: .keyword)
        expect("return", toTokenizeAs: .keyword)
        expect("typedef", toTokenizeAs: .keyword)
        expect("struct", toTokenizeAs: .keyword)
    }
    
    private func expect(_ string: String, toTokenizeAs expectedType: TokenType, _ expectedString: String? = nil, file: String = #file, line: Int = #line) {
        let expString = expectedString ?? string
        
        let token =
            Token(type: expectedType, string: expString,
                  location: fullRange(expString))
        
        tokenizeTest(string, token, file: file, line: line)
    }
    
    private func tokenizeTest(_ string: String, _ expected: Token, file: String = #file, line: Int = #line) {
        let parser = ObjcParser(string: string)
        
        if parser.token() != expected {
            recordFailure(withDescription: "Expected token: \(expected) received token: \(parser.token())",
                          inFile: file, atLine: line, expected: false)
        }
    }
    
    private func fullRange(_ str: String) -> SourceLocation {
        return .range(str.startIndex..<str.endIndex)
    }
}
