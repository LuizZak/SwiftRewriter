// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXAddressBookParsedResult.h"
// #import "ZXResult.h"
// #import "ZXVCardResultParser.h"
var ZX_BEGIN_VCARD: NSRegularExpression! = nil
var ZX_VCARD_LIKE_DATE: NSRegularExpression! = nil
var ZX_CR_LF_SPACE_TAB: NSRegularExpression! = nil
var ZX_NEWLINE_ESCAPE: NSRegularExpression! = nil
var ZX_VCARD_ESCAPES: NSRegularExpression! = nil
var ZX_EQUALS: String! = "="
var ZX_SEMICOLON: String! = ";"
var ZX_UNESCAPED_SEMICOLONS: NSRegularExpression! = nil
var ZX_COMMA: NSCharacterSet! = nil
var ZX_SEMICOLON_OR_COMMA: NSCharacterSet! = nil

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
 * Parses contact information formatted according to the VCard (2.1) format. This is not a complete
 * implementation but should parse information as commonly encoded in 2D barcodes.
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
 * Parses contact information formatted according to the VCard (2.1) format. This is not a complete
 * implementation but should parse information as commonly encoded in 2D barcodes.
 */
@objc
class ZXVCardResultParser: ZXResultParser {
    @objc
    static func initialize() {
        if self.self != ZXVCardResultParser.self {
            return
        }

        ZX_BEGIN_VCARD = NSRegularExpression(pattern: "BEGIN:VCARD", options: NSRegularExpressionCaseInsensitive, error: nil)

        ZX_VCARD_LIKE_DATE = NSRegularExpression(pattern: "\\\\d{4}-?\\\\d{2}-?\\\\d{2}", options: 0, error: nil)

        ZX_CR_LF_SPACE_TAB = NSRegularExpression(pattern: "\\r\\n[ \\t]", options: 0, error: nil)

        ZX_NEWLINE_ESCAPE = NSRegularExpression(pattern: "\\\\\\\\[nN]", options: 0, error: nil)

        ZX_VCARD_ESCAPES = NSRegularExpression(pattern: "\\\\\\\\([,;\\\\\\\\])", options: 0, error: nil)

        ZX_UNESCAPED_SEMICOLONS = NSRegularExpression(pattern: "(?<!\\\\\\\\);+", options: 0, error: nil)

        ZX_COMMA = NSCharacterSet.characterSetWithCharactersInString(",")

        ZX_SEMICOLON_OR_COMMA = NSCharacterSet.characterSetWithCharactersInString(";,")
    }
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        // Although we should insist on the raw text ending with "END:VCARD", there's no reason
        // to throw out everything else we parsed just because this was omitted. In fact, Eclair
        // is doing just that, and we can't parse its contacts without this leniency.
        let rawText = ZXResultParser.massagedText(result)

        if ZX_BEGIN_VCARD.numberOfMatchesInString(rawText, options: 0, range: NSMakeRange(0, rawText?.length)) == 0 {
            return nil
        }

        var names: NSMutableArray! = type(of: self).matchVCardPrefixedField("FN", rawText: rawText, trim: true, parseFieldDivider: false)

        if names == nil {
            // If no display names found, look for regular name fields and format them
            names = type(of: self).matchVCardPrefixedField("N", rawText: rawText, trim: true, parseFieldDivider: false)
            self.formatNames(names)
        }

        let nicknameString: NSArray! = type(of: self).matchSingleVCardPrefixedField("NICKNAME", rawText: rawText, trim: true, parseFieldDivider: false)
        let nicknames: NSArray! = (nicknameString == nil) ? nil : nicknameString[0].componentsSeparatedByCharactersInSet(ZX_COMMA)
        let phoneNumbers: NSArray! = type(of: self).matchVCardPrefixedField("TEL", rawText: rawText, trim: true, parseFieldDivider: false)
        let emails: NSArray! = type(of: self).matchVCardPrefixedField("EMAIL", rawText: rawText, trim: true, parseFieldDivider: false)
        let note: NSArray! = type(of: self).matchSingleVCardPrefixedField("NOTE", rawText: rawText, trim: false, parseFieldDivider: false)
        let addresses: NSMutableArray! = type(of: self).matchVCardPrefixedField("ADR", rawText: rawText, trim: true, parseFieldDivider: true)
        let org: NSArray! = type(of: self).matchSingleVCardPrefixedField("ORG", rawText: rawText, trim: true, parseFieldDivider: true)
        var birthday: NSArray! = type(of: self).matchSingleVCardPrefixedField("BDAY", rawText: rawText, trim: true, parseFieldDivider: false)

        if birthday != nil && !self.isLikeVCardDate(birthday[0]) {
            birthday = nil
        }

        let title: NSArray! = type(of: self).matchSingleVCardPrefixedField("TITLE", rawText: rawText, trim: true, parseFieldDivider: false)
        let urls: NSArray! = type(of: self).matchVCardPrefixedField("URL", rawText: rawText, trim: true, parseFieldDivider: false)
        let instantMessenger: NSArray! = type(of: self).matchSingleVCardPrefixedField("IMPP", rawText: rawText, trim: true, parseFieldDivider: false)
        let geoString: NSArray! = type(of: self).matchSingleVCardPrefixedField("GEO", rawText: rawText, trim: true, parseFieldDivider: false)
        var geo: NSArray! = (geoString == nil) ? nil : geoString[0].componentsSeparatedByCharactersInSet(ZX_SEMICOLON_OR_COMMA)

        if geo != nil && geo.count != 2 {
            geo = nil
        }

        return ZXAddressBookParsedResult.addressBookParsedResultWithNames(self.toPrimaryValues(names), nicknames: nicknames, pronunciation: nil, phoneNumbers: self.toPrimaryValues(phoneNumbers), phoneTypes: self.toTypes(phoneNumbers), emails: self.toPrimaryValues(emails), emailTypes: self.toTypes(emails), instantMessenger: self.toPrimaryValue(instantMessenger), note: self.toPrimaryValue(note), addresses: self.toPrimaryValues(addresses), addressTypes: self.toTypes(addresses), org: self.toPrimaryValue(org), birthday: self.toPrimaryValue(birthday), title: self.toPrimaryValue(title), urls: self.toPrimaryValues(urls), geo: geo)
    }
    @objc
    static func matchVCardPrefixedField(_ prefix: String!, rawText: String!, trim: Bool, parseFieldDivider: Bool) -> NSMutableArray? {
        var matches: NSMutableArray! = nil
        var i: UInt = 0
        let max: UInt = rawText.length()

        while i < max {
            // At start or after newling, match prefix, followed by optional metadata
            // (led by ;) ultimately ending in colon
            let regex: NSRegularExpression! = NSRegularExpression.regularExpressionWithPattern(String(format: "(?:^|\\n)%@(?:;([^:]*))?:", prefix), options: NSRegularExpressionCaseInsensitive, error: nil)

            if i > 0 {
                i -= 1 // Find from i-1 not i since looking at the preceding character
            }

            let regexMatches: NSArray! = regex.matchesInString(rawText, options: 0, range: NSMakeRange(i, rawText.length - i))

            if regexMatches.count == 0 {
                break
            }

            let matchRange: NSRange = regexMatches[0].range()

            i = matchRange.location + matchRange.length

            var metadataString: String! = nil

            if regexMatches[0].rangeAtIndex(1).location != NSNotFound {
                metadataString = rawText.substringWithRange(regexMatches[0].rangeAtIndex(1))
            }

            var metadata: NSMutableArray! = nil
            var quotedPrintable = false
            var quotedPrintableCharset: String! = nil

            if metadataString != nil {
                for metadatum in metadataString?.componentsSeparatedByString(ZX_SEMICOLON) {
                    if metadata == nil {
                        metadata = NSMutableArray()
                    }

                    metadata?.add(metadatum)

                    let equals: UInt = metadatum.rangeOfString(ZX_EQUALS).location

                    if equals != NSNotFound {
                        let key: String! = metadatum.substringToIndex(equals)
                        let value: String! = metadatum.substringFromIndex(equals + 1)

                        if "ENCODING".caseInsensitiveCompare(key) == ComparisonResult.orderedSame && "QUOTED-PRINTABLE".caseInsensitiveCompare(value) == ComparisonResult.orderedSame {
                            quotedPrintable = true
                        } else if "CHARSET".caseInsensitiveCompare(key) == ComparisonResult.orderedSame {
                            quotedPrintableCharset = value
                        }
                    }
                }
            }

            let matchStart = i // Found the start of a match here

            while UInt(i = rawText.rangeOfString("\\n", options: NSLiteralSearch, range: NSMakeRange(i, rawText.length() - i)).location) != NSNotFound {
                // Really, end in \r\n
                if i < rawText.length() - 1 && (rawText.characterAtIndex(i + 1) == " " || rawText.characterAtIndex(i + 1) == "\\t") {
                    // But if followed by tab or space,
                    // this is only a continuation
                    i += 2 // Skip \n and continutation whitespace
                } else if quotedPrintable && ((i >= 1 && rawText.characterAtIndex(i - 1) == "=") || (i >= 2 && rawText.characterAtIndex(i - 2) == "=")) {
                    // If preceded by = in quoted printable
                    // this is a continuation
                    i += 1 // Skip \n
                } else {
                    break
                }
            }

            if i == NSNotFound {
                // No terminating end character? uh, done. Set i such that loop terminates and break
                i = max
            } else if i > matchStart {
                // found a match
                if matches == nil {
                    matches = NSMutableArray.arrayWithCapacity(1)
                }

                if i >= 1 && rawText.characterAtIndex(i - 1) == "\\r" {
                    i -= 1 // Back up over \r, which really should be there
                }

                var element: String! = rawText.substringWithRange(NSMakeRange(matchStart, i - matchStart))

                if trim {
                    element = element.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                }

                if quotedPrintable {
                    element = self.decodeQuotedPrintable(element, charset: quotedPrintableCharset)

                    if parseFieldDivider {
                        element = ZX_UNESCAPED_SEMICOLONS.stringByReplacingMatchesInString(element, options: 0, range: NSMakeRange(0, element.length), withTemplate: "\\n").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    }
                } else {
                    if parseFieldDivider {
                        element = ZX_UNESCAPED_SEMICOLONS.stringByReplacingMatchesInString(element, options: 0, range: NSMakeRange(0, element.length), withTemplate: "\\n").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    }

                    element = ZX_CR_LF_SPACE_TAB.stringByReplacingMatchesInString(element, options: 0, range: NSMakeRange(0, element.length), withTemplate: "")
                    element = ZX_NEWLINE_ESCAPE.stringByReplacingMatchesInString(element, options: 0, range: NSMakeRange(0, element.length), withTemplate: "\\n")
                    element = ZX_VCARD_ESCAPES.stringByReplacingMatchesInString(element, options: 0, range: NSMakeRange(0, element.length), withTemplate: "$1")
                }

                if metadata == nil {
                    let match: NSMutableArray! = NSMutableArray.arrayWithObject(element)

                    match.add(element)
                    matches?.add(match)
                } else {
                    metadata?.insertObject(element, atIndex: 0)

                    if let metadata = metadata {
                        matches?.add(metadata)
                    }
                }

                i += 1
            } else {
                i += 1
            }
        }

        return matches
    }
    @objc
    static func decodeQuotedPrintable(_ value: String!, charset: String!) -> String? {
        let length: UInt = value.length()
        let result = NSMutableString(capacity: Int(length))
        let fragmentBuffer: NSMutableData! = NSMutableData.data()
        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            let c: unichar = value.characterAtIndex(i)

            switch c {
            case "\\r", "\\n":
                break
            case "=":
                if i < length - 2 {
                    let nextChar: unichar = value.characterAtIndex(i + 1)

                    if nextChar != "\\r" && nextChar != "\\n" {
                        let nextNextChar: unichar = value.characterAtIndex(i + 2)
                        let firstDigit = self.parseHexDigit(nextChar)
                        let secondDigit = self.parseHexDigit(nextNextChar)

                        if firstDigit >= 0 && secondDigit >= 0 {
                            var encodedByte = (firstDigit << 4) + secondDigit

                            fragmentBuffer.appendBytes(&encodedByte, length: 1)
                        } // else ignore it, assume it was incorrectly encoded

                        i += 2
                    }
                }
            default:
                self.maybeAppendFragment(fragmentBuffer, charset: charset, result: result)
                result.appendFormat("%C", c)
            }
        }

        self.maybeAppendFragment(fragmentBuffer, charset: charset, result: result)

        return result
    }
    @objc
    static func maybeAppendFragment(_ fragmentBuffer: NSMutableData!, charset: String!, result: NSMutableString!) {
        if fragmentBuffer.length() > 0 {
            var fragment: String!

            if charset == nil || CFStringConvertIANACharSetNameToEncoding(charset as? CFStringRef) == kCFStringEncodingInvalidId {
                fragment = String(data: fragmentBuffer, encoding: NSUTF8StringEncoding)
            } else {
                fragment = String(data: fragmentBuffer, encoding: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(charset as? CFStringRef)))

                if !fragment {
                    fragment = String(data: fragmentBuffer, encoding: NSUTF8StringEncoding)
                }
            }

            fragmentBuffer.setLength(0)
            result.append(fragment)
        }
    }
    @objc
    static func matchSingleVCardPrefixedField(_ prefix: String!, rawText: String!, trim: Bool, parseFieldDivider: Bool) -> NSArray? {
        let values = self.matchVCardPrefixedField(prefix, rawText: rawText, trim: trim, parseFieldDivider: parseFieldDivider)

        return (values == nil) ? nil : values?[0]
    }
    @objc
    func toPrimaryValue(_ list: NSArray!) -> String? {
        return (list == nil || list.count == 0) ? nil : list[0]
    }
    @objc
    func toPrimaryValues(_ lists: NSArray!) -> NSArray {
        if lists == nil || lists.count == 0 {
            return nil
        }

        let result: NSMutableArray! = NSMutableArray.arrayWithCapacity(lists.count)

        for list in lists {
            let value: String! = list[0]

            if value != nil && value.length > 0 {
                result.add(value)
            }
        }

        return result
    }
    @objc
    func toTypes(_ lists: NSArray!) -> NSArray {
        if lists == nil || lists.count == 0 {
            return nil
        }

        let result: NSMutableArray! = NSMutableArray.arrayWithCapacity(lists.count)

        for list in lists {
            var type: String! = nil
            var i: CInt = 1

            while i < list.count {
                defer {
                    i += 1
                }

                let metadatum: String! = list[i]
                let equals: UInt = metadatum.rangeOfString("=", options: NSCaseInsensitiveSearch).location

                if equals == NSNotFound {
                    // take the whole thing as a usable label
                    type = metadatum

                    break
                }

                if "TYPE" == metadatum.substringToIndex(equals).uppercaseString() {
                    type = metadatum.substringFromIndex(equals + 1)

                    break
                }
            }

            if type != nil {
                if let type = type {
                    result.add(type)
                }
            } else {
                result.add(NSNull.null())
            }
        }

        return result
    }
    @objc
    func isLikeVCardDate(_ value: String!) -> Bool {
        return value == nil || ZX_VCARD_LIKE_DATE.numberOfMatchesInString(value, options: 0, range: NSMakeRange(0, value.length)) > 0
    }
    /**
 * Formats name fields of the form "Public;John;Q.;Reverend;III" into a form like
 * "Reverend John Q. Public III".
 *
 * @param names name values to format, in place
 */
    @objc
    func formatNames(_ names: NSMutableArray!) {
        if names != nil {
            for list in names {
                let name: String! = list[0]
                let allComponents: NSArray! = name.componentsSeparatedByString(";")
                let components = NSMutableArray()

                for component in allComponents {
                    if component.length() > 0 {
                        components.add(component)
                    }
                }

                let newName = NSMutableString(capacity: 100)

                self.maybeAppendComponent(components, i: 3, newName: newName)
                self.maybeAppendComponent(components, i: 1, newName: newName)
                self.maybeAppendComponent(components, i: 2, newName: newName)
                self.maybeAppendComponent(components, i: 0, newName: newName)
                self.maybeAppendComponent(components, i: 4, newName: newName)

                list[0] = newName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            }
        }
    }
    @objc
    func maybeAppendComponent(_ components: NSArray!, i: CInt, newName: NSMutableString!) {
        if components.count > i && components[Int(i)] && (components[Int(i)] as? String)?.length() > 0 {
            if newName.length() > 0 {
                newName.append(" ")
            }

            newName.append(components[Int(i)])
        }
    }
}