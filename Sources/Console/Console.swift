//
//  Console.swift
//  LogParser
//
//  Created by Luiz Fernando Silva on 20/01/17.
//  Copyright © 2017 Luiz Fernando Silva. All rights reserved.
//

import Foundation
import Cocoa
import MiniLexer
import TypeLexing

/// A publicly-facing protocol for console clients
public protocol ConsoleClient {
    /// Displays an items table on the console.
    func displayTable(withValues values: [[String]], separator: String)
    
    /// Reads a line from the console, re-prompting the user until they enter
    /// a non-empty line.
    ///
    /// - Parameter prompt: Prompt to display to the user
    /// - Returns: Result of the prompt
    func readSureLineWith(prompt: String) -> String
    
    /// Reads a line from the console, performing some validation steps with the
    /// user's input.
    ///
    /// - Parameters:
    ///   - prompt: Textual prompt to present to the user
    ///   - allowEmpty: Whether the method allows empty inputs - empty inputs
    /// finish the console input and return `nil`.
    ///   - validate: A validation method applied to every input attempt by the user.
    /// If the method returns false, the user is re-prompted until a valid input
    /// is provided.
    /// - Returns: First input that was correctly validated, or if `allowEmpty` is
    /// `true`, an empty input line, if the user specified no input.
    func readLineWith(prompt: String, allowEmpty: Bool, validate: (String) -> Bool) -> String?
    
    /// Reads a line from the console, showing a given prompt to the user.
    func readLineWith(prompt: String) -> String?
    
    /// Prints an empty line feed into the console
    func printLine()
    
    /// Prints a line into the console's output with a linefeed terminator
    func printLine(_ line: String)
    
    /// Prints a line into the console's output, with a given terminator
    func printLine(_ line: String, terminator: String)
    
    /// Called to record the given exit code for the console's program
    func recordExitCode(_ code: Int)
}

/// Helper console-interation interface
open class Console: ConsoleClient {
    private final var outputSink: OutputSink
    
    /// Target output stream to print messages to
    public final var output: TextOutputStream
    
    /// Initializes this console class with the default standard output stream
    public convenience init() {
        self.init(output: StandardOutputTextStream())
    }
    
    /// Initializes this console class with a custom output stream
    public init(output: TextOutputStream) {
        self.output = output
        outputSink = OutputSink(forward: { _ in })
        
        outputSink = OutputSink { [weak self] str in
            self?.output.write(str)
        }
    }
    
    /// Displays a table-layouted list of values on the console.
    ///
    /// The value matrix is interpreted as an array of lines, with an inner array
    /// of elements within.
    ///
    /// The table is automatically adjusted so the columns are spaced evenly
    /// across items of multiple lengths.
    open func displayTable(withValues values: [[String]], separator: String) {
        // Measure maximum length of values on each column
        var columnWidths: [Int] = []
        
        for line in values {
            for (i, cell) in line.enumerated() {
                // Make sure we have the minimum ammount of storage for storing this column
                while(columnWidths.count <= i) {
                    columnWidths.append(0)
                }
                
                columnWidths[i] = max(columnWidths[i], Console.measureString(cell))
            }
        }
        
        // Print columns now
        for line in values {
            for (i, row) in line.enumerated() {
                if(i < line.count - 1) {
                    let rowLength = Console.measureString(row)
                    let spaces = String(repeating: " ", count: columnWidths[i] - rowLength)
                    
                    printLine("\(row)\(separator)\(spaces)", terminator: "")
                } else {
                    printLine(row, terminator: "")
                }
            }
            printLine()
        }
    }
    
    open func readSureLineWith(prompt: String) -> String {
        repeat {
            guard let input = readLineWith(prompt: prompt) else {
                printLine("Invalid input")
                continue
            }
            
            return input
        } while true
    }
    
    open func readLineWith(prompt: String, allowEmpty: Bool = true, validate: (String) -> Bool = { _ in true }) -> String? {
        repeat {
            let input = readSureLineWith(prompt: prompt)
            
            if input.isEmpty {
                return allowEmpty ? "" : nil
            }
            
            if !validate(input) {
                continue
            }
            
            return input
        } while true
    }
    
    open func readIntWith(prompt: String, allowEmpty: Bool = true, validate: (Int) -> Bool = { _ in true }) -> Int? {
        repeat {
            let input = readSureLineWith(prompt: prompt)
            
            if input.isEmpty {
                return nil
            }
            guard let int = Int(input) else {
                printLine("Please insert a valid digits-only number")
                continue
            }
            
            if !validate(int) {
                continue
            }
            
            return int
        } while true
    }
    
    open func readLineWith(prompt: String) -> String? {
        printLine(prompt, terminator: " ")
        return readLine()
    }
    
    open func printLine() {
        print(to: &outputSink)
    }
    
    open func printLine(_ line: String) {
        print(line, to: &outputSink)
    }
    
    open func printLine(_ line: String, terminator: String) {
        print(line, terminator: terminator, to: &outputSink)
    }
    
    open func recordExitCode(_ code: Int) {
        errno = Int32(code)
    }
    
    /// Measures the number of visible characters for a given string input
    static func measureString(_ string: String) -> Int {
        do {
            // Regex to ignore ASCII coloring from string
            let regex = try NSRegularExpression(pattern: "\\e\\[(\\d+;)*(\\d+)?[ABCDHJKfmsu]", options: [])
            
            let range = NSRange(location: 0, length: (string as NSString).length)
            
            let results = regex.matches(in: string, options: [], range: range)
            let removed = results.reduce(0) { $0 + $1.range.length }
            
            return string.count - removed
        } catch {
            return string.count
        }
    }
    
    /// Helper closure for clarifying behavior of commands and actions that
    /// result in an interaction with the upper menu
    public enum CommandMenuResult {
        /// Loops the menu again
        case loop
        
        /// Quits the active menu back
        case quit
    }
    
    public enum ConsoleParseError: Error {
        case invalidInput
    }
    
    private final class OutputSink: TextOutputStream {
        var forward: (String) -> ()
        
        init(forward: @escaping (String) -> ()) {
            self.forward = forward
        }
        
        func write(_ string: String) {
            forward(string)
        }
    }
}

/// Standard output text stream
public class StandardOutputTextStream: TextOutputStream {
    public func write(_ string: String) {
        print(string, separator: "", terminator: "")
    }
}

