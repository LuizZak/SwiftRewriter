import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXAddressBookAUResultParser.h"
// #import "ZXAddressBookDoCoMoResultParser.h"
// #import "ZXAddressBookParsedResult.h"
// #import "ZXBizcardResultParser.h"
// #import "ZXBookmarkDoCoMoResultParser.h"
// #import "ZXCalendarParsedResult.h"
// #import "ZXEmailAddressParsedResult.h"
// #import "ZXEmailAddressResultParser.h"
// #import "ZXEmailDoCoMoResultParser.h"
// #import "ZXExpandedProductParsedResult.h"
// #import "ZXExpandedProductResultParser.h"
// #import "ZXGeoParsedResult.h"
// #import "ZXGeoResultParser.h"
// #import "ZXISBNParsedResult.h"
// #import "ZXISBNResultParser.h"
// #import "ZXParsedResult.h"
// #import "ZXProductParsedResult.h"
// #import "ZXProductResultParser.h"
// #import "ZXResult.h"
// #import "ZXResultParser.h"
// #import "ZXSMSMMSResultParser.h"
// #import "ZXSMSParsedResult.h"
// #import "ZXSMSTOMMSTOResultParser.h"
// #import "ZXSMTPResultParser.h"
// #import "ZXTelParsedResult.h"
// #import "ZXTelResultParser.h"
// #import "ZXTextParsedResult.h"
// #import "ZXURIParsedResult.h"
// #import "ZXURIResultParser.h"
// #import "ZXURLTOResultParser.h"
// #import "ZXVCardResultParser.h"
// #import "ZXVEventResultParser.h"
// #import "ZXVINResultParser.h"
// #import "ZXWifiParsedResult.h"
// #import "ZXWifiResultParser.h"
var ZX_PARSERS: NSArray! = nil
var ZX_DIGITS: NSRegularExpression! = nil
var ZX_AMPERSAND: String! = "&"
var ZX_EQUALS: String! = "="
var ZX_BYTE_ORDER_MARK: unichar = L

/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Abstract class representing the result of decoding a barcode, as more than
 * a String -- as some type of structured data. This might be a subclass which represents
 * a URL, or an e-mail address. parseResult() will turn a raw
 * decoded string into the most appropriate type of structured representation.
 *
 * Thanks to Jeff Griffin for proposing rewrite of these classes that relies less
 * on exception-based mechanisms during parsing.
 */
/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Abstract class representing the result of decoding a barcode, as more than
 * a String -- as some type of structured data. This might be a subclass which represents
 * a URL, or an e-mail address. parseResult() will turn a raw
 * decoded string into the most appropriate type of structured representation.
 *
 * Thanks to Jeff Griffin for proposing rewrite of these classes that relies less
 * on exception-based mechanisms during parsing.
 */
@objc
class ZXResultParser: NSObject {
    @objc
    static func initialize() {
        if self.self != ZXResultParser.self {
            return
        }

        ZX_PARSERS = [ZXBookmarkDoCoMoResultParser(), ZXAddressBookDoCoMoResultParser(), ZXEmailDoCoMoResultParser(), ZXAddressBookAUResultParser(), ZXVCardResultParser(), ZXBizcardResultParser(), ZXVEventResultParser(), ZXEmailAddressResultParser(), ZXSMTPResultParser(), ZXTelResultParser(), ZXSMSMMSResultParser(), ZXSMSTOMMSTOResultParser(), ZXGeoResultParser(), ZXWifiResultParser(), ZXURLTOResultParser(), ZXURIResultParser(), ZXISBNResultParser(), ZXProductResultParser(), ZXExpandedProductResultParser(), ZXVINResultParser()]
        ZX_DIGITS = NSRegularExpression(pattern: "^\\\\d+$", options: 0, error: nil)
    }
    /**
 * Attempts to parse the raw ZXResult's contents as a particular type
 * of information (email, URL, etc.) and return a ZXParsedResult encapsulating
 * the result of parsing.
 *
 * @param result the raw ZXResult to parse
 * @return ZXParsedResult encapsulating the parsing result
 */
    /**
 * Attempts to parse the raw ZXResult's contents as a particular type
 * of information (email, URL, etc.) and return a ZXParsedResult encapsulating
 * the result of parsing.
 *
 * @param result the raw ZXResult to parse
 * @return ZXParsedResult encapsulating the parsing result
 */
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
    @objc
    static func massagedText(_ result: ZXResult!) -> String? {
        var text = result.text

        if text?.length > 0 && text?.characterAtIndex(0) == ZX_BYTE_ORDER_MARK {
            text = text?.substringFromIndex(1)
        }

        return text
    }
    @objc
    static func parseResult(_ theResult: ZXResult!) -> ZXParsedResult? {
        for parser in ZX_PARSERS {
            let result: ZXParsedResult! = parser.parse(theResult)

            if result != nil {
                return result
            }
        }

        return ZXTextParsedResult.textParsedResultWithText(theResult.text(), language: nil)
    }
    @objc
    func maybeAppend(_ value: String!, result: NSMutableString!) {
        if value != nil {
            result.appendFormat("\\n%@", value)
        }
    }
    @objc
    func maybeAppendArray(_ value: NSArray!, result: NSMutableString!) {
        if value != nil {
            for s in value {
                result.appendFormat("\\n%@", s)
            }
        }
    }
    @objc
    func maybeWrap(_ value: String!) -> NSArray? {
        return (value == nil) ? nil : [value]
    }
    @objc
    static func unescapeBackslash(_ escaped: String!) -> String? {
        let backslash: UInt = escaped.rangeOfString("\\\\").location

        if backslash == NSNotFound {
            return escaped
        }

        let max: UInt = escaped.length()
        let unescaped = NSMutableString(capacity: Int(max - 1))

        unescaped.append(escaped.substringToIndex(backslash))

        var nextIsEscaped = false
        var i: CInt = CInt(backslash)

        while i < max {
            defer {
                i += 1
            }

            let c: unichar = escaped.characterAtIndex(i)

            if nextIsEscaped || c != '\\' {
                unescaped.appendFormat("%C", c)
                nextIsEscaped = false
            } else {
                nextIsEscaped = true
            }
        }

        return unescaped
    }
    @objc
    static func parseHexDigit(_ c: unichar) -> CInt {
        if c >= '0' && c <= '9' {
            return c - '0'
        }

        if c >= 'a' && c <= 'f' {
            return 10 + (c - 'a')
        }

        if c >= 'A' && c <= 'F' {
            return 10 + (c - 'A')
        }

        return 1
    }
    @objc
    static func isStringOfDigits(_ value: String!, length: CUnsignedInt) -> Bool {
        return value != nil && length > 0 && length == value.length && ZX_DIGITS.numberOfMatchesInString(value, options: 0, range: NSMakeRange(0, value.length)) > 0
    }
    @objc
    func urlDecode(_ escaped: String!) -> String? {
        if escaped == nil {
            return nil
        }

        let first = self.findFirstEscape(escaped)

        if first == 1 {
            return escaped
        }

        let max: UInt = escaped.length()
        let unescaped = NSMutableString(capacity: Int(max - 2))

        unescaped.append(escaped.substringToIndex(first))

        var i = first

        while i < max {
            defer {
                i += 1
            }

            let c: unichar = escaped.characterAtIndex(i)

            switch c {
            case '+':
                unescaped.append(" ")
            case '%':
                if i >= max - 2 {
                    unescaped.append("%")
                } else {
                    let firstDigitValue: CInt = type(of: self).parseHexDigit(escaped.characterAtIndex(i += 1))
                    let secondDigitValue: CInt = type(of: self).parseHexDigit(escaped.characterAtIndex(i += 1))

                    if firstDigitValue < 0 || secondDigitValue < 0 {
                        unescaped.appendFormat("%%%C%C", escaped.characterAtIndex(i - 1), escaped.characterAtIndex(i))
                    }

                    unescaped.appendFormat("%C", ((firstDigitValue << 4) + secondDigitValue) as? unichar)
                }
            default:
                unescaped.appendFormat("%C", c)
            }
        }

        return unescaped
    }
    @objc
    func findFirstEscape(_ escaped: String!) -> CInt {
        let max: UInt = escaped.length()
        var i: CInt = 0

        while i < max {
            defer {
                i += 1
            }

            let c: unichar = escaped.characterAtIndex(i)

            if c == '+' || c == '%' {
                return i
            }
        }

        return 1
    }
    @objc
    static func isSubstringOfDigits(_ value: String!, offset: CInt, length: CInt) -> Bool {
        if value == nil || length <= 0 {
            return false
        }

        let max = offset + length

        return value.length >= max && ZX_DIGITS.numberOfMatchesInString(value, options: 0, range: NSMakeRange(offset, max - offset)) > 0
    }
    @objc
    func parseNameValuePairs(_ uri: String!) -> NSMutableDictionary {
        let paramStart: UInt = uri.rangeOfString("?").location

        if paramStart == NSNotFound {
            return nil
        }

        let result: NSMutableDictionary! = NSMutableDictionary.dictionaryWithCapacity(3)

        for keyValue in uri.substringFromIndex(paramStart + 1).componentsSeparatedByString(ZX_AMPERSAND) {
            self.appendKeyValue(keyValue, result: result)
        }

        return result
    }
    @objc
    func appendKeyValue(_ keyValue: String!, result: NSMutableDictionary!) {
        let equalsRange: NSRange = keyValue.rangeOfString(ZX_EQUALS)

        if equalsRange.location != NSNotFound {
            let key: String! = keyValue.substringToIndex(equalsRange.location)
            var value: String! = keyValue.substringFromIndex(equalsRange.location + 1)

            value = self.urlDecode(value)
            result[key] = value
        }
    }
    @objc
    static func urlDecode(_ encoded: String!) -> String {
        var result: String! = encoded.stringByReplacingOccurrencesOfString("+", withString: " ")

        result = result.stringByRemovingPercentEncoding()

        return result
    }
    @objc
    static func matchPrefixedField(_ prefix: String!, rawText: String!, endChar: unichar, trim: Bool) -> NSArray? {
        var matches: NSMutableArray! = nil
        var i: UInt = 0
        let max: UInt = rawText.length()

        while i < max {
            i = rawText.rangeOfString(prefix, options: NSLiteralSearch, range: NSMakeRange(i, rawText.length() - i - 1)).location

            if i == NSNotFound {
                break
            }

            i += prefix.length() // Skip past this prefix we found to start

            let start = i // Found the start of a match here
            var more = true

            while more {
                i = rawText.rangeOfString(String(format: "%C", endChar), options: NSLiteralSearch, range: NSMakeRange(i, rawText.length() - i)).location

                if i == NSNotFound {
                    // No terminating end character? uh, done. Set i such that loop terminates and break
                    i = rawText.length()
                    more = false
                } else if self.countPrecedingBackslashes(rawText, pos: Int(i)) % 2 != 0 {
                    // semicolon was escaped (odd count of preceding backslashes) so continue
                    i += 1
                } else {
                    // found a match
                    if matches == nil {
                        matches = NSMutableArray.arrayWithCapacity(3) // lazy init
                    }

                    var element = self.unescapeBackslash(rawText.substringWithRange(NSMakeRange(start, i - start)))

                    if trim {
                        element = element?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    }

                    if element?.length > 0 {
                        if let element = element {
                            matches?.add(element)
                        }
                    }

                    i += 1
                    more = false
                }
            }
        }

        if matches == nil || matches?.count == 0 {
            return nil
        }

        return matches
    }
    @objc
    static func countPrecedingBackslashes(_ s: String!, pos: Int) -> CInt {
        var count: CInt = 0
        var i = pos - 1

        while i >= 0 {
            defer {
                i -= 1
            }

            if s.characterAtIndex(i) == '\\' {
                count += 1
            } else {
                break
            }
        }

        return count
    }
    @objc
    static func matchSinglePrefixedField(_ prefix: String!, rawText: String!, endChar: unichar, trim: Bool) -> String? {
        let matches = self.matchPrefixedField(prefix, rawText: rawText, endChar: endChar, trim: trim)

        return (matches == nil) ? nil : matches?[0]
    }
}