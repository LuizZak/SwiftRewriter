//
//  ConsoleColor+Terminal.swift
//  LogParser
//
//  Created by Luiz Fernando Silva on 19/01/17.
//  Copyright © 2017 Luiz Fernando Silva. All rights reserved.
//

import Cocoa

// This code is based off Vapor's Console library
//
// http://github.com/vapor/console
//

extension String {
    /**
     Wraps a string in the color indicated
     by the UInt8 terminal color code.
     */
    public func terminalColorize(_ color: ConsoleColor) -> String {
        
        #if !DEBUG
            return color.terminalForeground.ansi + self + UInt8(0).ansi
        #else
            return self
        #endif
    }
    
    /**
     Strips this entire string of terminal color commands
     */
    public func stripTerminalColors() -> String {
        #if !DEBUG
            guard let regex = try? NSRegularExpression(pattern: "\\e\\[(\\d+;)*(\\d+)?[ABCDHJKfmsu]", options: []) else {
                return self
            }
            
            let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            //let removed = results.reduce(0) { $0 + $1.range.length }
            
            // Remove ranges in descending order
            
            var output = self
            
            for res in results.sorted(by: { $0.range.location > $1.range.location }) {
                let startIndex = output.index(output.startIndex, offsetBy: res.range.location)
                let endIndex = output.index(output.startIndex, offsetBy: res.range.location + res.range.length)
                
                output.removeSubrange(startIndex..<endIndex)
            }
            
            return output
        #else
            return self
        #endif
    }
}

extension String {
    /**
     Converts a String to a full ANSI command.
     */
    public var ansi: String {
        return "\u{001B}[" + self
    }
}

/**
 Underlying colors for console styles.
 */
public enum ConsoleColor {
    case black
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
}

extension ConsoleColor {
    /**
     Returns the foreground terminal color
     code for the ConsoleColor.
     */
    public var terminalForeground: UInt8 {
        switch self {
        case .black:
            return 30
        case .red:
            return 31
        case .green:
            return 32
        case .yellow:
            return 33
        case .blue:
            return 34
        case .magenta:
            return 35
        case .cyan:
            return 36
        case .white:
            return 37
        }
    }
    
    /**
     Returns the background terminal color
     code for the ConsoleColor.
     */
    public var terminalBackground: UInt8 {
        switch self {
        case .black:
            return 40
        case .red:
            return 41
        case .green:
            return 42
        case .yellow:
            return 43
        case .blue:
            return 44
        case .magenta:
            return 45
        case .cyan:
            return 46
        case .white:
            return 47
        }
    }
}

extension UInt8 {
    /**
     Converts a UInt8 to an ANSI code.
     */
    public var ansi: String {
        return (self.description + "m").ansi
    }
}
