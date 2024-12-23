// Preprocessor directives found in file:
// #import "ZXOneDimensionalCodeWriter.h"
// #import "ZXBoolArray.h"
// #import "ZXCode128Reader.h"
// #import "ZXCode128Writer.h"
// Results of minimal lookahead for Code C
@objc
enum ZXCType: CInt {
    case ZXCTypeUncodable = 0
    case ZXCTypeOneDigit
    case ZXCTypeTwoDigits
    case ZXCTypeFNC1
}

let ZX_CODE128_ESCAPE_FNC_1: unichar = L
let ZX_CODE128_ESCAPE_FNC_2: unichar = L
let ZX_CODE128_ESCAPE_FNC_3: unichar = L
let ZX_CODE128_ESCAPE_FNC_4: unichar = L

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
 * This object renders a CODE128 code as a ZXBitMatrix.
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
 * This object renders a CODE128 code as a ZXBitMatrix.
 */
@objc
class ZXCode128Writer: ZXOneDimensionalCodeWriter {
    @objc
    override func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if format != ZXBarcodeFormat.kBarcodeFormatCode128 {
            NSException.raise(NSInvalidArgumentException, format: "Can only encode CODE_128")
        }

        return super.encode(contents, format: format, width: width, height: height, hints: hints, error: error)
    }
    @objc
    func encode(_ contents: String!) -> ZXBoolArray {
        let length: CInt = CInt(contents.length())

        // Check length
        if length < 1 || length > 80 {
            NSException.raise(NSInvalidArgumentException, format: "Contents length should be between 1 and 80 characters, but got %d", length)
        }

        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            let c: unichar = contents.characterAtIndex(i)

            switch c {
            case ZX_CODE128_ESCAPE_FNC_1, ZX_CODE128_ESCAPE_FNC_2, ZX_CODE128_ESCAPE_FNC_3, ZX_CODE128_ESCAPE_FNC_4:
                break
            default:
                if c > 127 {
                    // support for FNC4 isn't implemented, no full Latin-1 character set available at the moment
                    NSException.raise(NSInvalidArgumentException, format: "Bad character in input: %C", c)
                }
            }
        }

        let patterns = NSMutableArray() // temporary storage for patterns
        var checkSum: CInt = 0
        var checkWeight: CInt = 1
        var codeSet: CInt = 0 // selected code (CODE_CODE_B or CODE_CODE_C)
        var position: CInt = 0 // position in contents

        while position < length {
            //Select code to use
            let newCodeSet = self.chooseCodeFrom(contents, position: position, oldCode: codeSet)
            //Get the pattern index
            var patternIndex: CInt

            if newCodeSet == codeSet {
                // Encode the current character
                // First handle escapes
                switch contents.characterAtIndex(position) {
                case ZX_CODE128_ESCAPE_FNC_1:
                    patternIndex = ZX_CODE128_CODE_FNC_1
                case ZX_CODE128_ESCAPE_FNC_2:
                    patternIndex = ZX_CODE128_CODE_FNC_2
                case ZX_CODE128_ESCAPE_FNC_3:
                    patternIndex = ZX_CODE128_CODE_FNC_3
                case ZX_CODE128_ESCAPE_FNC_4:
                    if codeSet == ZX_CODE128_CODE_CODE_A {
                        patternIndex = ZX_CODE128_CODE_FNC_4_A
                    } else {
                        patternIndex = ZX_CODE128_CODE_FNC_4_B
                    }
                default:
                    // Then handle normal characters otherwise
                    if codeSet == ZX_CODE128_CODE_CODE_A {
                        patternIndex = contents.characterAtIndex(position) - " "

                        if patternIndex < 0 {
                            // everything below a space character comes behind the underscore in the code patterns table
                            patternIndex += "`"
                        }
                    } else if codeSet == ZX_CODE128_CODE_CODE_B {
                        patternIndex = contents.characterAtIndex(position) - " "
                    } else {
                        // CODE_CODE_C
                        patternIndex = contents.substringWithRange(NSMakeRange(position, 2)).intValue()
                        position += 1 // Also incremented below
                    }
                }

                position += 1
            } else {
                // Should we change the current code?
                // Do we have a code set?
                if codeSet == 0 {
                    // No, we don't have a code set
                    if newCodeSet == ZX_CODE128_CODE_CODE_A {
                        patternIndex = ZX_CODE128_CODE_START_A
                    } else if newCodeSet == ZX_CODE128_CODE_CODE_B {
                        patternIndex = ZX_CODE128_CODE_START_B
                    } else {
                        // CODE_CODE_C
                        patternIndex = ZX_CODE128_CODE_START_C
                    }
                } else {
                    // Yes, we have a code set
                    patternIndex = newCodeSet
                }

                codeSet = newCodeSet
            }

            // Get the pattern
            var pattern = NSMutableArray()
            var i: CInt = 0

            while i < MemoryLayout.size(ofValue: ZX_CODE128_CODE_PATTERNS[patternIndex]) / MemoryLayout<CInt>.size {
                defer {
                    i += 1
                }

                pattern.add(ZX_CODE128_CODE_PATTERNS[patternIndex][i])
            }

            patterns.add(pattern)
            // Compute checksum
            checkSum += patternIndex * checkWeight

            if position != 0 {
                checkWeight += 1
            }
        }

        // Compute and append checksum
        checkSum %= 103

        var pattern = NSMutableArray()
        var i: CInt = 0

        while i < MemoryLayout.size(ofValue: ZX_CODE128_CODE_PATTERNS[checkSum]) / MemoryLayout<CInt>.size {
            defer {
                i += 1
            }

            pattern.add(ZX_CODE128_CODE_PATTERNS[checkSum][i])
        }

        patterns.add(pattern)
        // Append stop code
        pattern = NSMutableArray()

        var i: CInt = 0

        while i < MemoryLayout.size(ofValue: ZX_CODE128_CODE_PATTERNS[ZX_CODE128_CODE_STOP]) / MemoryLayout<CInt>.size {
            defer {
                i += 1
            }

            pattern.add(ZX_CODE128_CODE_PATTERNS[ZX_CODE128_CODE_STOP][i])
        }

        patterns.add(pattern)

        // Compute code width
        var codeWidth: CInt = 0

        /*
        
        */

        /*
        for
        */

         as? pattern

        var i: CInt = 0

        while i < pattern.count {
            defer {
                i += 1
            }

            codeWidth += pattern[Int(i)].intValue()
        }

        // Compute result
        let result = ZXBoolArray(length: CUnsignedInt(codeWidth))
        var pos: CInt = 0

        for patternArray in patterns {
            let patternLen: CInt = CInt(patternArray.count())
            var pattern: UnsafeMutablePointer<CInt>!
            var i: CInt = 0

            while i < patternLen {
                defer {
                    i += 1
                }

                pattern[i] = patternArray[i].intValue()
            }

            pos += self.appendPattern(result, pos: pos, pattern: pattern, patternLen: patternLen, startColor: true)
        }

        return result
    }
    @objc
    func findCTypeIn(_ value: String!, start: CInt) -> ZXCType {
        let last: CInt = CInt(value.length())

        if start >= last {
            return ZXCType.ZXCTypeUncodable
        }

        var c: unichar = value.characterAtIndex(start)

        if c == ZX_CODE128_ESCAPE_FNC_1 {
            return ZXCType.ZXCTypeFNC1
        }

        if c < "0" || c > "9" {
            return ZXCType.ZXCTypeUncodable
        }

        if start + 1 >= last {
            return ZXCType.ZXCTypeOneDigit
        }

        c = value.characterAtIndex(start + 1)

        if c < "0" || c > "9" {
            return ZXCType.ZXCTypeOneDigit
        }

        return ZXCType.ZXCTypeTwoDigits
    }
    @objc
    func chooseCodeFrom(_ contents: String!, position: CInt, oldCode: CInt) -> CInt {
        var lookahead = self.findCTypeIn(contents, start: position)

        if lookahead == ZXCType.ZXCTypeOneDigit {
            if oldCode == ZX_CODE128_CODE_CODE_A {
                return ZX_CODE128_CODE_CODE_A
            }

            return ZX_CODE128_CODE_CODE_B
        }

        if lookahead == ZXCType.ZXCTypeUncodable {
            if position < contents.length {
                let c: unichar = contents.characterAtIndex(position)

                if c < " " || (oldCode == ZX_CODE128_CODE_CODE_A && (c < "`" || (c >= ZX_CODE128_ESCAPE_FNC_1 && c <= ZX_CODE128_ESCAPE_FNC_4))) {
                    // can continue in code A, encodes ASCII 0 to 95 or FNC1 to FNC4
                    return ZX_CODE128_CODE_CODE_A
                }
            }

            return ZX_CODE128_CODE_CODE_B // no choice
        }

        if oldCode == ZX_CODE128_CODE_CODE_A && lookahead == ZXCType.ZXCTypeFNC1 {
            return ZX_CODE128_CODE_CODE_A
        }

        if oldCode == ZX_CODE128_CODE_CODE_C {
            // can continue in code C
            return ZX_CODE128_CODE_CODE_C
        }

        if oldCode == ZX_CODE128_CODE_CODE_B {
            if lookahead == ZXCType.ZXCTypeFNC1 {
                return ZX_CODE128_CODE_CODE_B // can continue in code B
            }

            // Seen two consecutive digits, see what follows
            lookahead = self.findCTypeIn(contents, start: position + 2)

            if lookahead == ZXCType.ZXCTypeUncodable || lookahead == ZXCType.ZXCTypeOneDigit {
                return ZX_CODE128_CODE_CODE_B // not worth switching now
            }

            if lookahead == ZXCType.ZXCTypeFNC1 {
                // two digits, then FNC_1...
                lookahead = self.findCTypeIn(contents, start: position + 3)

                if lookahead == ZXCType.ZXCTypeTwoDigits {
                    // then two more digits, switch
                    return ZX_CODE128_CODE_CODE_C
                } else {
                    return ZX_CODE128_CODE_CODE_B // otherwise not worth switching
                }
            }

            // At this point, there are at least 4 consecutive digits.
            // Look ahead to choose whether to switch now or on the next round.
            var index = position + 4

            while (lookahead = self.findCTypeIn(contents, start: index)) == ZXCType.ZXCTypeTwoDigits {
                index += 2
            }

            if lookahead == ZXCType.ZXCTypeOneDigit {
                // odd number of digits, switch later
                return ZX_CODE128_CODE_CODE_B
            }

            return ZX_CODE128_CODE_CODE_C // even number of digits, switch now
        }

        // Here oldCode == 0, which means we are choosing the initial code
        if lookahead == ZXCType.ZXCTypeFNC1 {
            // ignore FNC_1
            lookahead = self.findCTypeIn(contents, start: position + 1)
        }

        if lookahead == ZXCType.ZXCTypeTwoDigits {
            // at least two digits, start in code C
            return ZX_CODE128_CODE_CODE_C
        }

        return ZX_CODE128_CODE_CODE_B
    }
}