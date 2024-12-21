// Preprocessor directives found in file:
// #import "ZXOneDimensionalCodeWriter.h"
// #import "ZXBitMatrix.h"
// #import "ZXBoolArray.h"
// #import "ZXCode93Reader.h"
// #import "ZXCode93Writer.h"
// #import "ZXIntArray.h"
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
 * This object renders a CODE93 code as a ZXBitMatrix.
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
@objc
class ZXCode93Writer: ZXOneDimensionalCodeWriter {
    @objc
    override func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if format != ZXBarcodeFormat.kBarcodeFormatCode93 {
            NSException.raise(NSInvalidArgumentException, format: "Can only encode CODE_93.")
        }

        return super.encode(contents, format: format, width: width, height: height, hints: hints, error: error)
    }
    /**
 * @param contents barcode contents to encode. It should not be encoded for extended characters.
 * @return a {@code boolean[]} of horizontal pixels (false = white, true = black)
 */
    @objc
    func encode(_ contents: String!) -> ZXBoolArray {
        contents = self.convertToExtended(contents)

        let length: CInt = CInt(contents.length())

        if length > 80 {
            NSException.raise(NSInvalidArgumentException, format: "Requested contents should be less than 80 digits long after converting to extended encoding, but got %d", length)
        }

        //lenght of code + 2 start/stop characters + 2 checksums, each of 9 bits, plus a termination bar
        let codeWidth = (length + 2 + 2) * 9 + 1
        let result = ZXBoolArray(length: CUnsignedInt(codeWidth))
        //start character (*)
        var pos = self.appendPattern(result, pos: 0, a: ZX_CODE93_ASTERISK_ENCODING)
        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            let indexInString: UInt = ZX_CODE93_ALPHABET_STRING.rangeOfString(contents.substringWithRange(NSMakeRange(i, 1))).location

            if indexInString == NSNotFound {
                NSException.raise(NSInvalidArgumentException, format: "Bad contents: %@", contents)
            }

            pos += self.appendPattern(result, pos: pos, a: ZX_CODE93_CHARACTER_ENCODINGS[indexInString])
        }

        //add two checksums
        let check1 = self.computeChecksumIndexFrom(contents, withMaxWeight: 20)

        pos += self.appendPattern(result, pos: pos, a: ZX_CODE93_CHARACTER_ENCODINGS[check1])
        //append the contents to reflect the first checksum added
        contents = contents.stringByAppendingString(ZX_CODE93_ALPHABET_STRING.substringWithRange(NSMakeRange(check1, 1)))

        let check2 = self.computeChecksumIndexFrom(contents, withMaxWeight: 15)

        pos += self.appendPattern(result, pos: pos, a: ZX_CODE93_CHARACTER_ENCODINGS[check2])
        //end character (*)
        pos += self.appendPattern(result, pos: pos, a: ZX_CODE93_ASTERISK_ENCODING)
        //termination bar (single black bar)
        result.array[pos] = true

        return result
    }
    @objc
    func convertToExtended(_ contents: String!) -> String? {
        let length: CInt = CInt(contents.length())
        let extendedContent = NSMutableString(capacity: Int(length * 2))
        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            let character: unichar = contents.characterAtIndex(i)

            // ($)=a, (%)=b, (/)=c, (+)=d. see Code93Reader.ALPHABET_STRING
            if character == 0 {
                // NUL: (%)U
                extendedContent.append("bU")
            } else if character <= 26 {
                // SOH - SUB: ($)A - ($)Z
                extendedContent.appendFormat("%c", 'a')
                extendedContent.appendFormat("%c", 'A' + character - 1)
            } else if character <= 31 {
                // ESC - US: (%)A - (%)E
                extendedContent.appendFormat("%c", 'b')
                extendedContent.appendFormat("%c", 'A' + character - 27)
            } else if character == ' ' || character == '$' || character == '%' || character == '+' {
                // space $ % +
                extendedContent.appendFormat("%c", character)
            } else if character <= ',' {
                // ! " # & ' ( ) * ,: (/)A - (/)L
                extendedContent.appendFormat("%c", 'c')
                extendedContent.appendFormat("%c", 'A' + character - '!')
            } else if character <= '9' {
                extendedContent.appendFormat("%c", character)
            } else if character == ':' {
                // :: (/)Z
                extendedContent.append("cZ")
            } else if character <= '?' {
                // ; - ?: (%)F - (%)J
                extendedContent.appendFormat("%c", 'b')
                extendedContent.appendFormat("%c", 'F' + character - ';')
            } else if character == '@' {
                // @: (%)V
                extendedContent.append("bV")
            } else if character <= 'Z' {
                // A - Z
                extendedContent.appendFormat("%c", character)
            } else if character <= '_' {
                // [ - _: (%)K - (%)O
                extendedContent.appendFormat("%c", 'b')
                extendedContent.appendFormat("%c", 'K' + character - '[')
            } else if character == '`' {
                // `: (%)W
                extendedContent.append("bW")
            } else if character <= 'z' {
                // a - z: (*)A - (*)Z
                extendedContent.appendFormat("%c", 'd')
                extendedContent.appendFormat("%c", 'A' + character - 'a')
            } else if character <= 127 {
                // { - DEL: (%)P - (%)T
                extendedContent.appendFormat("%c", 'b')
                extendedContent.appendFormat("%c", 'P' + character - '{')
            } else {
                NSException.raise(NSInvalidArgumentException, format: "Requested content contains a non-encodable character: \'%c\'", character)
            }
        }

        return extendedContent
    }
    @objc
    func appendPattern(_ target: ZXBoolArray!, pos: CInt, pattern: UnsafePointer<CInt>!, patternLen: CInt) -> CInt {
        var i: CInt = 0

        while i < patternLen {
            defer {
                i += 1
            }

            target.array[pos += 1] = pattern[i] != 0
        }

        return 9
    }
    @objc
    func appendPattern(_ target: ZXBoolArray!, pos: CInt, a: CInt) -> CInt {
        var i: CInt = 0

        while i < 9 {
            defer {
                i += 1
            }

            let temp = a & (1 << (8 - i))

            target.array[pos + i] = temp != 0
        }

        return 9
    }
    @objc
    func computeChecksumIndexFrom(_ contents: String!, withMaxWeight maxWeight: CInt) -> CInt {
        var weight: CInt = 1
        var total: CInt = 0
        let length: CInt = CInt(contents.length())
        var i = length - 1

        while i >= 0 {
            defer {
                i -= 1
            }

            let indexInString: UInt = ZX_CODE93_ALPHABET_STRING.rangeOfString(contents.substringWithRange(NSMakeRange(i, 1))).location

            if indexInString == NSNotFound {
                NSException.raise(NSInvalidArgumentException, format: "Bad contents: %@", contents)
            }

            total += CInt(indexInString) * weight

            if weight += 1 > maxWeight {
                weight = 1
            }
        }

        return total % 47
    }
}