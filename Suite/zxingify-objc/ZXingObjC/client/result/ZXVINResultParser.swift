// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXVINParsedResult.h"
// #import "ZXVINResultParser.h"
var ZX_IOQ: NSRegularExpression! = nil
var ZX_AZ09: NSRegularExpression! = nil

/*
 * Copyright 2014 ZXing authors
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
 * Detects a result that is likely a vehicle identification number.
 */
/*
 * Copyright 2014 ZXing authors
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
 * Detects a result that is likely a vehicle identification number.
 */
@objc
class ZXVINResultParser: ZXResultParser {
    @objc
    static func initialize() {
        if self.self != ZXVINResultParser.self {
            return
        }

        ZX_IOQ = NSRegularExpression(pattern: "[IOQ]", options: 0, error: nil)
        ZX_AZ09 = NSRegularExpression(pattern: "[A-Z0-9]{17}", options: 0, error: nil)
    }
    @objc
    func parse(_ result: ZXResult!) -> ZXVINParsedResult? {
        if result.barcodeFormat != ZXBarcodeFormat.kBarcodeFormatCode39 {
            return nil
        }

        var rawText = result.text

        rawText = ZX_IOQ.stringByReplacingMatchesInString(rawText, options: 0, range: NSMakeRange(0, rawText?.length), withTemplate: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        if ZX_AZ09.numberOfMatchesInString(rawText, options: 0, range: NSMakeRange(0, rawText?.length)) == 0 {
            return nil
        }

        if !self.checkChecksum(rawText) {
            return nil
        }

        let modelYear = self.modelYear(rawText?.characterAtIndex(9))

        if modelYear == 1 {
            return nil
        }

        let wmi: String! = rawText?.substringToIndex(3)

        return ZXVINParsedResult(vIN: rawText, worldManufacturerID: wmi, vehicleDescriptorSection: rawText?.substringWithRange(NSMakeRange(3, 6)), vehicleIdentifierSection: rawText?.substringWithRange(NSMakeRange(9, 8)), countryCode: self.countryCode(wmi), vehicleAttributes: rawText?.substringWithRange(NSMakeRange(3, 5)), modelYear: modelYear, plantCode: rawText?.characterAtIndex(10), sequentialNumber: rawText?.substringFromIndex(11))
    }
    @objc
    func checkChecksum(_ vin: String!) -> Bool {
        var sum: CInt = 0
        var i: CInt = 0

        while i < vin.length() {
            defer {
                i += 1
            }

            let vinPositionWeight = self.vinPositionWeight(i + 1)

            if vinPositionWeight == 1 {
                return false
            }

            let vinCharValue = self.vinCharValue(vin.characterAtIndex(i))

            if vinCharValue == 1 {
                return false
            }

            sum += vinPositionWeight * vinCharValue
        }

        let checkChar: unichar = vin.characterAtIndex(8)

        if checkChar == "\\0" {
            return false
        }

        let expectedCheckChar = self.checkChar(sum % 11)

        return checkChar == expectedCheckChar
    }
    @objc
    func vinCharValue(_ c: unichar) -> CInt {
        if c >= "A" && c <= "I" {
            return (c - "A") + 1
        }

        if c >= "J" && c <= "R" {
            return (c - "J") + 1
        }

        if c >= "S" && c <= "Z" {
            return (c - "S") + 2
        }

        if c >= "0" && c <= "9" {
            return c - "0"
        }

        return 1
    }
    @objc
    func vinPositionWeight(_ position: CInt) -> CInt {
        if position >= 1 && position <= 7 {
            return 9 - position
        }

        if position == 8 {
            return 10
        }

        if position == 9 {
            return 0
        }

        if position >= 10 && position <= 17 {
            return 19 - position
        }

        return 1
    }
    @objc
    func checkChar(_ remainder: CInt) -> unichar {
        if remainder < 10 {
            return ("0" + remainder) as? unichar
        }

        if remainder == 10 {
            return "X"
        }

        return "\\0"
    }
    @objc
    func modelYear(_ c: unichar) -> CInt {
        if c >= "E" && c <= "H" {
            return (c - "E") + 1984
        }

        if c >= "J" && c <= "N" {
            return (c - "J") + 1988
        }

        if c == "P" {
            return 1993
        }

        if c >= "R" && c <= "T" {
            return (c - "R") + 1994
        }

        if c >= "V" && c <= "Y" {
            return (c - "V") + 1997
        }

        if c >= "1" && c <= "9" {
            return (c - "1") + 2001
        }

        if c >= "A" && c <= "D" {
            return (c - "A") + 2010
        }

        return 1
    }
    @objc
    func countryCode(_ wmi: String!) -> String? {
        let c1: unichar = wmi.characterAtIndex(0)
        let c2: unichar = wmi.characterAtIndex(1)

        switch c1 {
        case "1", "4", "5":
            return "US"
        case "2":
            return "CA"
        case "3":
            if c2 >= "A" && c2 <= "W" {
                return "MX"
            }
        case "9":
            if (c2 >= "A" && c2 <= "E") || (c2 >= "3" && c2 <= "9") {
                return "BR"
            }
        case "J":
            if c2 >= "A" && c2 <= "T" {
                return "JP"
            }
        case "K":
            if c2 >= "L" && c2 <= "R" {
                return "KO"
            }
        case "L":
            return "CN"
        case "M":
            if c2 >= "A" && c2 <= "E" {
                return "IN"
            }
        case "S":
            if c2 >= "A" && c2 <= "M" {
                return "UK"
            }

            if c2 >= "N" && c2 <= "T" {
                return "DE"
            }
        case "V":
            if c2 >= "F" && c2 <= "R" {
                return "FR"
            }

            if c2 >= "S" && c2 <= "W" {
                return "ES"
            }
        case "W":
            return "DE"
        case "X":
            if c2 == "0" || (c2 >= "3" && c2 <= "9") {
                return "RU"
            }
        case "Z":
            if c2 >= "A" && c2 <= "R" {
                return "IT"
            }
        default:
            break
        }

        return nil
    }
}