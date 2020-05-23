import XCTest
import SwiftAST
import KnownType
import Commons
import TypeSystem
import MiniLexer

class SwiftRewriterAttributeParserTests: XCTestCase {
    func testParseSwiftAttribute() throws {
        let attribute = try parseAttribute("""
            @_swiftrewriter(mapFrom: "dateByAddingUnit(_ component: Calendar.Component, value: Int, toDate date: Date, options: NSCalendarOptions) -> Date?")
            """)
        
        XCTAssertEqual(attribute.content.asString, """
            mapFrom: "dateByAddingUnit(_ component: Calendar.Component, value: Int, toDate date: Date, options: NSCalendarOptions) -> Date?"
            """)
    }
    
    func testParseSwiftAttributeRoundtrip() throws {
        _=try parseAttribute("""
            @_swiftrewriter(mapFrom: "date() -> Date")
            """)
    }
}

extension SwiftRewriterAttributeParserTests {
    func parseAttribute(_ string: String,
                        file: String = #file,
                        line: Int = #line) throws -> SwiftRewriterAttribute {
        
        do {
            let type =
                try SwiftRewriterAttributeParser
                    .parseSwiftRewriterAttribute(from: Lexer(input: string))
            
            return type
        } catch {
            
            let description: String
            if let error = error as? LexerError {
                description = error.description(withOffsetsIn: string)
            } else {
                description = "\(error)"
            }
            
            recordFailure(withDescription: "Error while parsing attribute: \(description)",
                          inFile: file,
                          atLine: line,
                          expected: true)
            
            throw error
        }
    }
}
