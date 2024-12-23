// Preprocessor directives found in file:
// #import "ZXPDF417ResultMetadata.h"
// #import "ZXPDF417DecodedBitStreamParser.h"
// #import "ZXCharacterSetECI.h"
// #import "ZXDecoderResult.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXDecimal.h"
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
enum ZXPDF417Mode: CInt {
    case ZXPDF417ModeAlpha = 0
    case ZXPDF417ModeLower
    case ZXPDF417ModeMixed
    case ZXPDF417ModePunct
    case ZXPDF417ModeAlphaShift
    case ZXPDF417ModePunctShift
}

let ZX_PDF417_TEXT_COMPACTION_MODE_LATCH: CInt = 900
let ZX_PDF417_BYTE_COMPACTION_MODE_LATCH: CInt = 901
let ZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH: CInt = 902
let ZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6: CInt = 924
let ZX_PDF417_ECI_USER_DEFINED: CInt = 925
let ZX_PDF417_ECI_GENERAL_PURPOSE: CInt = 926
let ZX_PDF417_ECI_CHARSET: CInt = 927
let ZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK: CInt = 928
let ZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD: CInt = 923
let ZX_PDF417_MACRO_PDF417_TERMINATOR: CInt = 922
let ZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE: CInt = 913
let ZX_PDF417_MAX_NUMERIC_CODEWORDS: CInt = 15
let ZX_MACRO_PDF417_OPTIONAL_FIELD_FILE_NAME: CInt = 0
let ZX_MACRO_PDF417_OPTIONAL_FIELD_SEGMENT_COUNT: CInt = 1
let ZX_MACRO_PDF417_OPTIONAL_FIELD_TIME_STAMP: CInt = 2
let ZX_MACRO_PDF417_OPTIONAL_FIELD_SENDER: CInt = 3
let ZX_MACRO_PDF417_OPTIONAL_FIELD_ADDRESSEE: CInt = 4
let ZX_MACRO_PDF417_OPTIONAL_FIELD_FILE_SIZE: CInt = 5
let ZX_MACRO_PDF417_OPTIONAL_FIELD_CHECKSUM: CInt = 6
let ZX_PDF417_PL: CInt = 25
let ZX_PDF417_LL: CInt = 27
let ZX_PDF417_AS: CInt = 27
let ZX_PDF417_ML: CInt = 28
let ZX_PDF417_AL: CInt = 28
let ZX_PDF417_PS: CInt = 29
let ZX_PDF417_PAL: CInt = 29
var ZX_PDF417_PUNCT_CHARS: UnsafePointer<unichar>!
var ZX_PDF417_MIXED_CHARS: UnsafePointer<unichar>!
let ZX_PDF417_NUMBER_OF_SEQUENCE_CODEWORDS: CInt = 2
let ZX_PDF417_DECODING_DEFAULT_ENCODING: NSStringEncoding = NSISOLatin1StringEncoding
var ZX_PDF417_EXP900: NSArray! = nil

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
 * This class contains the methods for decoding the PDF417 codewords.
 */
@objc
class ZXPDF417DecodedBitStreamParser: NSObject {
    @objc
    static func initialize() {
        if self.self != ZXPDF417DecodedBitStreamParser.self {
            return
        }

        let exponents: NSMutableArray! = NSMutableArray.arrayWithCapacity(16)

        exponents.add(NSDecimalNumber.one())

        let nineHundred: NSDecimalNumber! = NSDecimalNumber.decimalNumberWithString("900")

        exponents.add(nineHundred)

        var i: CInt = 2

        while i < 16 {
            defer {
                i += 1
            }

            exponents.add(exponents[Int(i - 1)].decimalNumberByMultiplyingBy(nineHundred))
        }

        ZX_PDF417_EXP900 = NSArray(array: exponents)
    }
    @objc
    static func decode(_ codewords: ZXIntArray!, ecLevel: String!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult {
        let result = NSMutableString(capacity: Int(codewords.length * 2))
        var encoding = ZX_PDF417_DECODING_DEFAULT_ENCODING
        var codeIndex: CInt = 1
        var code: CInt = codewords.array[codeIndex += 1]
        let resultMetadata = ZXPDF417ResultMetadata()

        while codeIndex < codewords.array[0] {
            switch code {
            case ZX_PDF417_TEXT_COMPACTION_MODE_LATCH:
                codeIndex = self.textCompaction(codewords, codeIndex: codeIndex, result: result)
            case ZX_PDF417_BYTE_COMPACTION_MODE_LATCH, ZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6:
                codeIndex = self.byteCompaction(code, codewords: codewords, encoding: encoding, codeIndex: codeIndex, result: result)
            case ZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE:
                result.appendFormat("%C", codewords.array[codeIndex += 1] as? unichar)
            case ZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH:
                codeIndex = self.numericCompaction(codewords, codeIndex: codeIndex, result: result)

                if codeIndex < 0 {
                    if error != nil {
                        error.pointee = ZXFormatErrorInstance()
                    }

                    return nil
                }
            case ZX_PDF417_ECI_CHARSET:
                let charsetECI = ZXCharacterSetECI.characterSetECIByValue(codewords.array[codeIndex += 1])

                encoding = charsetECI?.encoding
            case ZX_PDF417_ECI_GENERAL_PURPOSE:
                codeIndex += 2
            case ZX_PDF417_ECI_USER_DEFINED:
                codeIndex += 1
            case ZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK:
                codeIndex = self.decodeMacroBlock(codewords, codeIndex: codeIndex, resultMetadata: resultMetadata)

                if codeIndex < 0 {
                    if error != nil {
                        error.pointee = ZXFormatErrorInstance()
                    }

                    return nil
                }
            case ZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD, ZX_PDF417_MACRO_PDF417_TERMINATOR:
                if error != nil {
                    error.pointee = ZXFormatErrorInstance()
                }

                return nil
            default:
                codeIndex -= 1
                codeIndex = self.textCompaction(codewords, codeIndex: codeIndex, result: result)
            }

            if codeIndex < codewords.length {
                code = codewords.array[codeIndex += 1]
            } else {
                if error != nil {
                    error.pointee = ZXFormatErrorInstance()
                }

                return nil
            }
        }

        if result.length() == 0 {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            return nil
        }

        let decoderResult = ZXDecoderResult(rawBytes: nil, text: result, byteSegments: nil, ecLevel: ecLevel)

        decoderResult.other = resultMetadata

        return decoderResult
    }
    @objc
    static func decodeMacroBlock(_ codewords: ZXIntArray!, codeIndex: CInt, resultMetadata: ZXPDF417ResultMetadata!) -> CInt {
        if codeIndex + ZX_PDF417_NUMBER_OF_SEQUENCE_CODEWORDS > codewords.array[0] {
            return 1
        }

        let segmentIndexArray = ZXIntArray(length: CUnsignedInt(ZX_PDF417_NUMBER_OF_SEQUENCE_CODEWORDS))
        var i: CInt = 0

        while i < ZX_PDF417_NUMBER_OF_SEQUENCE_CODEWORDS {
            defer {
                i += 1
                codeIndex += 1
            }

            segmentIndexArray.array[i] = codewords.array[codeIndex]
        }

        resultMetadata.segmentIndex = self.decodeBase900toBase10(segmentIndexArray, count: ZX_PDF417_NUMBER_OF_SEQUENCE_CODEWORDS).intValue()

        let fileId = NSMutableString()

        codeIndex = self.textCompaction(codewords, codeIndex: codeIndex, result: fileId)
        resultMetadata.fileId = String.stringWithString(fileId)

        var optionalFieldsStart: CInt = 1

        if codewords.array[codeIndex] == ZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD {
            optionalFieldsStart = codeIndex + 1
        }

        while codeIndex < codewords.array[0] {
            switch codewords.array[codeIndex] {
            case ZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD:
                codeIndex += 1

                switch codewords.array[codeIndex] {
                case ZX_MACRO_PDF417_OPTIONAL_FIELD_FILE_NAME:
                    let fileName = NSMutableString()

                    codeIndex = self.textCompaction(codewords, codeIndex: codeIndex + 1, result: fileName)
                    resultMetadata.fileName = fileName
                case ZX_MACRO_PDF417_OPTIONAL_FIELD_SENDER:
                    let sender = NSMutableString()

                    codeIndex = self.textCompaction(codewords, codeIndex: codeIndex + 1, result: sender)
                    resultMetadata.sender = sender
                case ZX_MACRO_PDF417_OPTIONAL_FIELD_ADDRESSEE:
                    let addressee = NSMutableString()

                    codeIndex = self.textCompaction(codewords, codeIndex: codeIndex + 1, result: addressee)
                    resultMetadata.addressee = addressee
                case ZX_MACRO_PDF417_OPTIONAL_FIELD_SEGMENT_COUNT:
                    let segmentCount = NSMutableString()

                    codeIndex = self.numericCompaction(codewords, codeIndex: codeIndex + 1, result: segmentCount)
                    resultMetadata.segmentCount = segmentCount.intValue()
                case ZX_MACRO_PDF417_OPTIONAL_FIELD_TIME_STAMP:
                    let timestamp = NSMutableString()

                    codeIndex = self.numericCompaction(codewords, codeIndex: codeIndex + 1, result: timestamp)
                    resultMetadata.timestamp = timestamp.longLongValue()
                case ZX_MACRO_PDF417_OPTIONAL_FIELD_CHECKSUM:
                    let checksum = NSMutableString()

                    codeIndex = self.numericCompaction(codewords, codeIndex: codeIndex + 1, result: checksum)
                    resultMetadata.checksum = checksum.intValue()
                case ZX_MACRO_PDF417_OPTIONAL_FIELD_FILE_SIZE:
                    let fileSize = NSMutableString()

                    codeIndex = self.numericCompaction(codewords, codeIndex: codeIndex + 1, result: fileSize)
                    resultMetadata.fileSize = fileSize.longLongValue()
                default:
                    NSException.raise(NSInvalidArgumentException, format: "MacroPDF417 invalid format")
                }
            case ZX_PDF417_MACRO_PDF417_TERMINATOR:
                codeIndex += 1
                resultMetadata.lastSegment = true
            default:
                NSException.raise(NSInvalidArgumentException, format: "MacroPDF417 invalid format")
            }

            if optionalFieldsStart != 1 {
                var optionalFieldsLength = codeIndex - optionalFieldsStart

                if resultMetadata.lastSegment {
                    optionalFieldsLength -= 1
                }

                let additionalOptionCodeWords = NSMutableArray()
                var i = optionalFieldsStart

                while i < (optionalFieldsStart + optionalFieldsLength) {
                    defer {
                        i += 1
                    }

                    let code: CInt = codewords.array[i]

                    additionalOptionCodeWords.add(code)
                }

                resultMetadata.optionalData = additionalOptionCodeWords
            }
        }

        return codeIndex
    }
    @objc
    static func textCompaction(_ codewords: ZXIntArray!, codeIndex: CInt, result: NSMutableString!) -> CInt {
        let textCompactionData = ZXIntArray(length: (codewords.array[0] - codeIndex) * 2)
        let byteCompactionData = ZXIntArray(length: (codewords.array[0] - codeIndex) * 2)
        var index: CInt = 0
        var end = false

        while (codeIndex < codewords.array[0]) && !end {
            var code: CInt = codewords.array[codeIndex += 1]

            if code < ZX_PDF417_TEXT_COMPACTION_MODE_LATCH {
                textCompactionData.array[index] = code / 30
                textCompactionData.array[index + 1] = code % 30
                index += 2
            } else {
                switch code {
                case ZX_PDF417_TEXT_COMPACTION_MODE_LATCH:
                    textCompactionData.array[index += 1] = ZX_PDF417_TEXT_COMPACTION_MODE_LATCH
                case ZX_PDF417_BYTE_COMPACTION_MODE_LATCH, ZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6, ZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH, ZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK, ZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD, ZX_PDF417_MACRO_PDF417_TERMINATOR:
                    codeIndex -= 1
                    end = true
                case ZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE:
                    textCompactionData.array[index] = ZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE

                    code = codewords.array[codeIndex += 1]

                    byteCompactionData.array[index] = code

                    index += 1
                default:
                    break
                }
            }
        }

        self.decodeTextCompaction(textCompactionData, byteCompactionData: byteCompactionData, length: CUnsignedInt(index), result: result)

        return codeIndex
    }
    @objc
    static func decodeTextCompaction(_ textCompactionData: ZXIntArray!, byteCompactionData: ZXIntArray!, length: CUnsignedInt, result: NSMutableString!) {
        var subMode = ZXPDF417Mode.ZXPDF417ModeAlpha
        var priorToShiftMode = ZXPDF417Mode.ZXPDF417ModeAlpha
        var i: CInt = 0

        while i < length {
            let subModeCh: CInt = textCompactionData.array[i]
            var ch: unichar = 0

            switch subMode {
            case ZXPDF417Mode.ZXPDF417ModeAlpha:
                if subModeCh < 26 {
                    ch = ('A' + subModeCh) as? unichar
                } else if subModeCh == 26 {
                    ch = ' '
                } else if subModeCh == ZX_PDF417_LL {
                    subMode = ZXPDF417Mode.ZXPDF417ModeLower
                } else if subModeCh == ZX_PDF417_ML {
                    subMode = ZXPDF417Mode.ZXPDF417ModeMixed
                } else if subModeCh == ZX_PDF417_PS {
                    priorToShiftMode = subMode
                    subMode = ZXPDF417Mode.ZXPDF417ModePunctShift
                } else if subModeCh == ZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE {
                    result.appendFormat("%C", byteCompactionData.array[i] as? unichar)
                } else if subModeCh == ZX_PDF417_TEXT_COMPACTION_MODE_LATCH {
                    subMode = ZXPDF417Mode.ZXPDF417ModeAlpha
                }
            case ZXPDF417Mode.ZXPDF417ModeLower:
                if subModeCh < 26 {
                    ch = ('a' + subModeCh) as? unichar
                } else if subModeCh == 26 {
                    ch = ' '
                } else if subModeCh == ZX_PDF417_AS {
                    priorToShiftMode = subMode
                    subMode = ZXPDF417Mode.ZXPDF417ModeAlphaShift
                } else if subModeCh == ZX_PDF417_ML {
                    subMode = ZXPDF417Mode.ZXPDF417ModeMixed
                } else if subModeCh == ZX_PDF417_PS {
                    priorToShiftMode = subMode
                    subMode = ZXPDF417Mode.ZXPDF417ModePunctShift
                } else if subModeCh == ZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE {
                    result.appendFormat("%C", byteCompactionData.array[i] as? unichar)
                } else if subModeCh == ZX_PDF417_TEXT_COMPACTION_MODE_LATCH {
                    subMode = ZXPDF417Mode.ZXPDF417ModeAlpha
                }
            case ZXPDF417Mode.ZXPDF417ModeMixed:
                if subModeCh < ZX_PDF417_PL {
                    ch = ZX_PDF417_MIXED_CHARS[subModeCh]
                } else if subModeCh == ZX_PDF417_PL {
                    subMode = ZXPDF417Mode.ZXPDF417ModePunct
                } else if subModeCh == 26 {
                    ch = ' '
                } else if subModeCh == ZX_PDF417_LL {
                    subMode = ZXPDF417Mode.ZXPDF417ModeLower
                } else if subModeCh == ZX_PDF417_AL {
                    subMode = ZXPDF417Mode.ZXPDF417ModeAlpha
                } else if subModeCh == ZX_PDF417_PS {
                    priorToShiftMode = subMode
                    subMode = ZXPDF417Mode.ZXPDF417ModePunctShift
                } else if subModeCh == ZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE {
                    result.appendFormat("%C", byteCompactionData.array[i] as? unichar)
                } else if subModeCh == ZX_PDF417_TEXT_COMPACTION_MODE_LATCH {
                    subMode = ZXPDF417Mode.ZXPDF417ModeAlpha
                }
            case ZXPDF417Mode.ZXPDF417ModePunct:
                if subModeCh < ZX_PDF417_PAL {
                    ch = ZX_PDF417_PUNCT_CHARS[subModeCh]
                } else if subModeCh == ZX_PDF417_PAL {
                    subMode = ZXPDF417Mode.ZXPDF417ModeAlpha
                } else if subModeCh == ZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE {
                    result.appendFormat("%C", byteCompactionData.array[i] as? unichar)
                } else if ZX_PDF417_TEXT_COMPACTION_MODE_LATCH != 0 {
                    subMode = ZXPDF417Mode.ZXPDF417ModeAlpha
                }
            case ZXPDF417Mode.ZXPDF417ModeAlphaShift:
                subMode = priorToShiftMode

                if subModeCh < 26 {
                    ch = ('A' + subModeCh) as? unichar
                } else if subModeCh == 26 {
                    ch = ' '
                } else if subModeCh == ZX_PDF417_TEXT_COMPACTION_MODE_LATCH {
                    subMode = ZXPDF417Mode.ZXPDF417ModeAlpha
                }
            case ZXPDF417Mode.ZXPDF417ModePunctShift:
                subMode = priorToShiftMode

                if subModeCh < ZX_PDF417_PAL {
                    ch = ZX_PDF417_PUNCT_CHARS[subModeCh]
                } else if subModeCh == ZX_PDF417_PAL {
                    subMode = ZXPDF417Mode.ZXPDF417ModeAlpha
                } else if subModeCh == ZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE {
                    result.appendFormat("%C", byteCompactionData.array[i] as? unichar)
                } else if subModeCh == ZX_PDF417_TEXT_COMPACTION_MODE_LATCH {
                    subMode = ZXPDF417Mode.ZXPDF417ModeAlpha
                }
            default:
                break
            }

            if ch != 0 {
                result.appendFormat("%C", ch)
            }

            i += 1
        }
    }
    @objc
    static func byteCompaction(_ mode: CInt, codewords: ZXIntArray!, encoding: NSStringEncoding, codeIndex: CInt, result: NSMutableString!) -> CInt {
        let decodedBytes: NSMutableData! = NSMutableData.data()

        if mode == ZX_PDF417_BYTE_COMPACTION_MODE_LATCH {
            var count: CInt = 0
            var value: CLongLong = 0
            let byteCompactedCodewords = ZXIntArray(length: 6)
            var end = false
            var nextCode: CInt = codewords.array[codeIndex += 1]

            while (codeIndex < codewords.array[0]) && !end {
                byteCompactedCodewords.array[count += 1] = nextCode
                value = 900 * value + CLongLong(nextCode)
                nextCode = codewords.array[codeIndex += 1]

                if nextCode == ZX_PDF417_TEXT_COMPACTION_MODE_LATCH || nextCode == ZX_PDF417_BYTE_COMPACTION_MODE_LATCH || nextCode == ZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH || nextCode == ZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6 || nextCode == ZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK || nextCode == ZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD || nextCode == ZX_PDF417_MACRO_PDF417_TERMINATOR {
                    codeIndex -= 1
                    end = true
                } else if (count % 5 == 0) && (count > 0) {
                    var j: CInt = 0

                    while j < 6 {
                        defer {
                            j += 1
                        }

                        var byte = (value >> (8 * (5 - j))) as? int8_t

                        decodedBytes.appendBytes(&byte, length: 1)
                    }

                    value = 0
                    count = 0
                }
            }

            if codeIndex == codewords.array[0] && nextCode < ZX_PDF417_TEXT_COMPACTION_MODE_LATCH {
                byteCompactedCodewords.array[count += 1] = nextCode
            }

            var i: CInt = 0

            while i < count {
                defer {
                    i += 1
                }

                var byte: int8_t = byteCompactedCodewords.array[i] as? int8_t

                decodedBytes.appendBytes(&byte, length: 1)
            }
        } else if mode == ZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6 {
            var count: CInt = 0
            var value: CLongLong = 0
            var end = false

            while codeIndex < codewords.array[0] && !end {
                let code: CInt = codewords.array[codeIndex += 1]

                if code < ZX_PDF417_TEXT_COMPACTION_MODE_LATCH {
                    count += 1
                    value = 900 * value + CLongLong(code)
                } else if code == ZX_PDF417_TEXT_COMPACTION_MODE_LATCH || code == ZX_PDF417_BYTE_COMPACTION_MODE_LATCH || code == ZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH || code == ZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6 || code == ZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK || code == ZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD || code == ZX_PDF417_MACRO_PDF417_TERMINATOR {
                    codeIndex -= 1
                    end = true
                }

                if (count % 5 == 0) && (count > 0) {
                    var j: CInt = 0

                    while j < 6 {
                        defer {
                            j += 1
                        }

                        var byte = (value >> (8 * (5 - j))) as? int8_t

                        decodedBytes.appendBytes(&byte, length: 1)
                    }

                    value = 0
                    count = 0
                }
            }
        }

        result.append(String(data: decodedBytes, encoding: encoding))

        return codeIndex
    }
    @objc
    static func numericCompaction(_ codewords: ZXIntArray!, codeIndex: CInt, result: NSMutableString!) -> CInt {
        var count: CInt = 0
        var end = false
        let numericCodewords = ZXIntArray(length: CUnsignedInt(ZX_PDF417_MAX_NUMERIC_CODEWORDS))

        while codeIndex < codewords.array[0] && !end {
            let code: CInt = codewords.array[codeIndex += 1]

            if codeIndex == codewords.array[0] {
                end = true
            }

            if code < ZX_PDF417_TEXT_COMPACTION_MODE_LATCH {
                numericCodewords.array[count] = code
                count += 1
            } else if code == ZX_PDF417_TEXT_COMPACTION_MODE_LATCH || code == ZX_PDF417_BYTE_COMPACTION_MODE_LATCH || code == ZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6 || code == ZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK || code == ZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD || code == ZX_PDF417_MACRO_PDF417_TERMINATOR {
                codeIndex -= 1
                end = true
            }

            if count % ZX_PDF417_MAX_NUMERIC_CODEWORDS == 0 || code == ZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH || end {
                if count > 0 {
                    let s = self.decodeBase900toBase10(numericCodewords, count: count)

                    if s == nil {
                        return 1
                    }

                    if let s = s {
                        result.append(s)
                    }

                    count = 0
                }
            }
        }

        return codeIndex
    }
    @objc
    static func decodeBase900toBase10(_ codewords: ZXIntArray!, count: CInt) -> String? {
        var result = ZXDecimal.decimalWithString("0")
        var i: CInt = 0

        while i < count {
            defer {
                i += 1
            }

            let toAdd = ZXDecimal.decimalWithDecimalNumber(ZX_PDF417_EXP900[Int(count - i - 1)])
            let multiplyWith = ZXDecimal.decimalWithString(codewords.array[i].stringValue())

            result = result.decimalByAdding(toAdd.decimalByMultiplyingBy(multiplyWith))
        }

        let resultString = result.value

        if !resultString?.hasPrefix("1") {
            return nil
        }

        return resultString?.substringFromIndex(1)
    }
}