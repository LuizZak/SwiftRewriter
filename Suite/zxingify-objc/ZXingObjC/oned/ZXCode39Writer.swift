// Preprocessor directives found in file:
// #import "ZXOneDimensionalCodeWriter.h"
// #import "ZXBitMatrix.h"
// #import "ZXBoolArray.h"
// #import "ZXCode39Reader.h"
// #import "ZXCode39Writer.h"
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
 * This object renders a CODE39 code as a ZXBitMatrix.
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
 * This object renders a CODE39 code as a ZXBitMatrix.
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
class ZXCode39Writer: ZXOneDimensionalCodeWriter {
    @objc
    override func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if format != ZXBarcodeFormat.kBarcodeFormatCode39 {
            NSException.raise(NSInvalidArgumentException, format: "Can only encode CODE_39.")
        }

        return super.encode(contents, format: format, width: width, height: height, hints: hints, error: error)
    }
    @objc
    func encode(_ contents: String!) -> ZXBoolArray {
        var length: CInt = CInt(contents.length())

        if length > 80 {
            NSException.raise(NSInvalidArgumentException, format: "Requested contents should be less than 80 digits long, but got %d", length)
        }

        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            let indexInString: UInt = ZX_CODE39_ALPHABET_STRING.rangeOfString(contents.substringWithRange(NSMakeRange(i, 1))).location

            if indexInString == NSNotFound {
                contents = self.tryToConvertToExtendedMode(contents)
                length = CInt(contents.length())

                if length > 80 {
                    NSException.raise(NSInvalidArgumentException, format: "Requested contents should be less than 80 digits long, but got %d (extended full ASCII mode)", length)
                }
            }
        }

        let widths = ZXIntArray(length: 9)
        let codeWidth = 24 + 1 + (13 * length)
        let result = ZXBoolArray(length: CUnsignedInt(codeWidth))

        self.toIntArray(ZX_CODE39_ASTERISK_ENCODING, toReturn: widths)

        var pos = self.appendPattern(result, pos: 0, pattern: widths.array, patternLen: CInt(widths.length), startColor: true)
        let narrowWhite: ZXIntArray! = ZXIntArray(ints: 1, 1)

        pos += self.appendPattern(result, pos: pos, pattern: narrowWhite.array, patternLen: CInt(narrowWhite.length), startColor: false)

        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            let indexInString: UInt = ZX_CODE39_ALPHABET_STRING.rangeOfString(contents.substringWithRange(NSMakeRange(i, 1))).location

            self.toIntArray(ZX_CODE39_CHARACTER_ENCODINGS[indexInString], toReturn: widths)
            pos += self.appendPattern(result, pos: pos, pattern: widths.array, patternLen: CInt(widths.length), startColor: true)
            pos += self.appendPattern(result, pos: pos, pattern: narrowWhite.array, patternLen: CInt(narrowWhite.length), startColor: false)
        }

        self.toIntArray(ZX_CODE39_ASTERISK_ENCODING, toReturn: widths)
        self.appendPattern(result, pos: pos, pattern: widths.array, patternLen: CInt(widths.length), startColor: true)

        return result
    }
    @objc
    func toIntArray(_ a: CInt, toReturn: ZXIntArray!) {
        var i: CInt = 0

        while i < 9 {
            defer {
                i += 1
            }

            let temp = a & (1 << (8 - i))

            toReturn.array[i] = (temp == 0) ? 1 : 2
        }
    }
    @objc
    func tryToConvertToExtendedMode(_ contents: String!) -> String? {
        let length: CInt = CInt(contents.length())
        let extendedContent = NSMutableString()
        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            let character: unichar = contents.characterAtIndex(i)

            switch character {
            case 0x0:
                extendedContent.append("%U")
            case ' ', '-', '.':
                extendedContent.appendFormat("%C", character)
            case '@':
                extendedContent.append("%V")
            case '`':
                extendedContent.append("%W")
            default:
                if character > 0 && character < 27 {
                    extendedContent.appendFormat("%C", '$' as? unichar)
                    extendedContent.appendFormat("%C", ('A' + (character - 1)) as? unichar)
                } else if character > 26 && character < ' ' {
                    extendedContent.appendFormat("%C", '%' as? unichar)
                    extendedContent.appendFormat("%C", ('A' + (character - 27)) as? unichar)
                } else if (character > ' ' && character < '-') || character == '/' || character == ':' {
                    extendedContent.appendFormat("%C", '/' as? unichar)
                    extendedContent.appendFormat("%C", ('A' + (character - 33)) as? unichar)
                } else if character > '/' && character < ':' {
                    extendedContent.appendFormat("%C", ('0' + (character - 48)) as? unichar)
                } else if character > ':' && character < '@' {
                    extendedContent.appendFormat("%C", '%' as? unichar)
                    extendedContent.appendFormat("%C", ('F' + (character - 59)) as? unichar)
                } else if character > '@' && character < '[' {
                    extendedContent.appendFormat("%C", ('A' + (character - 65)) as? unichar)
                } else if character > 'Z' && character < '`' {
                    extendedContent.appendFormat("%C", '%' as? unichar)
                    extendedContent.appendFormat("%C", ('K' + (character - 91)) as? unichar)
                } else if character > '`' && character < '{' {
                    extendedContent.appendFormat("%C", '+' as? unichar)
                    extendedContent.appendFormat("%C", ('A' + (character - 97)) as? unichar)
                } else if character > 'z' && character < 128 {
                    extendedContent.appendFormat("%C", '%' as? unichar)
                    extendedContent.appendFormat("%C", ('P' + (character - 123)) as? unichar)
                } else {
                    NSException.raise(NSInvalidArgumentException, format: "Requested content contains a non-encodable character: \'%@\'", contents.substringWithRange(NSMakeRange(i, 1)))
                }
            }
        }

        return extendedContent
    }
}