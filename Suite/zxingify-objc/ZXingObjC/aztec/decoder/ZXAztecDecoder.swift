// Preprocessor directives found in file:
// #import "ZXByteArray.h"
// #import "ZXAztecDecoder.h"
// #import "ZXAztecDetectorResult.h"
// #import "ZXBitMatrix.h"
// #import "ZXBoolArray.h"
// #import "ZXDecoderResult.h"
// #import "ZXErrors.h"
// #import "ZXGenericGF.h"
// #import "ZXIntArray.h"
// #import "ZXReedSolomonDecoder.h"
// #import "ZXByteArray.h"
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
enum ZXAztecTable: CInt {
    case ZXAztecTableUpper = 0
    case ZXAztecTableLower
    case ZXAztecTableMixed
    case ZXAztecTableDigit
    case ZXAztecTablePunct
    case ZXAztecTableBinary
}

var ZX_AZTEC_UPPER_TABLE: UnsafeMutablePointer<String?>!
var ZX_AZTEC_LOWER_TABLE: UnsafeMutablePointer<String?>!
var ZX_AZTEC_MIXED_TABLE: UnsafeMutablePointer<String?>!
var ZX_AZTEC_PUNCT_TABLE: UnsafeMutablePointer<String?>!
var ZX_AZTEC_DIGIT_TABLE: UnsafeMutablePointer<String?>!

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
 * The main class which implements Aztec Code decoding -- as opposed to locating and extracting
 * the Aztec Code from an image.
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
 * The main class which implements Aztec Code decoding -- as opposed to locating and extracting
 * the Aztec Code from an image.
 */
@objc
class ZXAztecDecoder: NSObject {
    @objc var ddata: ZXAztecDetectorResult!

    @objc
    func decode(_ detectorResult: ZXAztecDetectorResult!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult {
        self.ddata = detectorResult

        let matrix = detectorResult.bits
        let rawbits = self.extractBits(matrix)

        if !rawbits {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            return nil
        }

        let correctedBits = self.correctBits(rawbits, error: error)

        if !correctedBits {
            return nil
        }

        let rawBytes = ZXAztecDecoder.convertBoolArrayToByteArray(correctedBits)
        let result: String! = type(of: self).encodedData(correctedBits)
        let rawBytesSize: UInt = UInt(rawBytes.length)
        let rawBytesReturned = ZXByteArray(length: CUnsignedInt(rawBytesSize))
        var i: CInt = 0

        while i < rawBytesSize {
            defer {
                i += 1
            }

            rawBytesReturned.array[i] = rawBytes.array[i] as? int8_t
        }

        let decoderResult = ZXDecoderResult(rawBytes: rawBytesReturned, text: result, byteSegments: nil, ecLevel: nil)

        decoderResult.numBits = CInt(correctedBits.length)

        return decoderResult
    }
    // This method is used for testing the high-level encoder
    // This method is used for testing the high-level encoder
    @objc
    static func highLevelDecode(_ correctedBits: ZXBoolArray!) -> String? {
        return self.encodedData(correctedBits)
    }
    @objc
    static func encodedData(_ correctedBits: ZXBoolArray!) -> String? {
        let endIndex: CInt = CInt(correctedBits.length)
        var latchTable = ZXAztecTable.ZXAztecTableUpper
        var shiftTable = ZXAztecTable.ZXAztecTableUpper
        let result = NSMutableString(capacity: 20)
        var index: CInt = 0

        while index < endIndex {
            if shiftTable == ZXAztecTable.ZXAztecTableBinary {
                if endIndex - index < 5 {
                    break
                }

                var length = self.readCode(correctedBits, startIndex: index, length: 5)

                index += 5

                if length == 0 {
                    if endIndex - index < 11 {
                        break
                    }

                    length = self.readCode(correctedBits, startIndex: index, length: 11) + 31
                    index += 11
                }

                var charCount: CInt = 0

                while charCount < length {
                    defer {
                        charCount += 1
                    }

                    if endIndex - index < 8 {
                        index = endIndex

                        break
                    }

                    let code = self.readCode(correctedBits, startIndex: index, length: 8)

                    result.appendFormat("%C", code as? unichar)
                    index += 8
                }

                shiftTable = latchTable
            } else {
                let size: CInt = (shiftTable == ZXAztecTable.ZXAztecTableDigit) ? 4 : 5

                if endIndex - index < size {
                    break
                }

                let code = self.readCode(correctedBits, startIndex: index, length: size)

                index += size

                let str = self.character(shiftTable, code: code)

                if str.hasPrefix("CTRL_") {
                    latchTable = shiftTable
                    shiftTable = self.table(str.characterAtIndex(5))

                    if str.characterAtIndex(6) == "L" {
                        latchTable = shiftTable
                    }
                } else {
                    result.append(str)
                    shiftTable = latchTable
                }
            }
        }

        return String.stringWithString(result)
    }
    @objc
    static func table(_ t: unichar) -> ZXAztecTable {
        switch t {
        case "L":
            return ZXAztecTable.ZXAztecTableLower
        case "P":
            return ZXAztecTable.ZXAztecTablePunct
        case "M":
            return ZXAztecTable.ZXAztecTableMixed
        case "D":
            return ZXAztecTable.ZXAztecTableDigit
        case "B":
            return ZXAztecTable.ZXAztecTableBinary
        default:
            return ZXAztecTable.ZXAztecTableUpper
        }
    }
    @objc
    static func character(_ table: ZXAztecTable, code: CInt) -> String {
        switch table {
        case ZXAztecTable.ZXAztecTableUpper:
            return ZX_AZTEC_UPPER_TABLE[code]
        case ZXAztecTable.ZXAztecTableLower:
            return ZX_AZTEC_LOWER_TABLE[code]
        case ZXAztecTable.ZXAztecTableMixed:
            return ZX_AZTEC_MIXED_TABLE[code]
        case ZXAztecTable.ZXAztecTablePunct:
            return ZX_AZTEC_PUNCT_TABLE[code]
        case ZXAztecTable.ZXAztecTableDigit:
            return ZX_AZTEC_DIGIT_TABLE[code]
        default:
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalStateException"reason:@"Bad table"userInfo:nil];
            */
        }
    }
    @objc
    func correctBits(_ rawbits: ZXBoolArray!, error: UnsafeMutablePointer<Error?>!) -> ZXBoolArray {
        var gf: ZXGenericGF!
        var codewordSize: CInt

        if (self.ddata.nbLayers ?? 0) <= 2 {
            codewordSize = 6
            gf = ZXGenericGF.AztecData6()
        } else if (self.ddata.nbLayers ?? 0) <= 8 {
            codewordSize = 8
            gf = ZXGenericGF.AztecData8()
        } else if (self.ddata.nbLayers ?? 0) <= 22 {
            codewordSize = 10
            gf = ZXGenericGF.AztecData10()
        } else {
            codewordSize = 12
            gf = ZXGenericGF.AztecData12()
        }

        let numDataCodewords = self.ddata.nbDatablocks ?? 0
        let numCodewords: CInt = CInt(rawbits.length) / codewordSize

        if numCodewords < numDataCodewords {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            return 0
        }

        var offset: CInt = CInt(rawbits.length) % codewordSize
        let numECCodewords = numCodewords - numDataCodewords
        let dataWords = ZXIntArray(length: CUnsignedInt(numCodewords))
        var i: CInt = 0

        while i < numCodewords {
            defer {
                i += 1
                offset += codewordSize
            }

            dataWords.array[i] = type(of: self).readCode(rawbits, startIndex: offset, length: codewordSize)
        }

        let rsDecoder = ZXReedSolomonDecoder(field: gf)
        var decodeError: Error! = nil

        if !rsDecoder.decode(dataWords, twoS: numECCodewords, error: &decodeError) {
            if decodeError?.code == ZXReedSolomonError {
                if error != nil {
                    error.pointee = ZXFormatErrorInstance()
                }
            } else if error != nil {
                error.pointee = decodeError
            }

            return 0
        }

        let mask = (1 << codewordSize) - 1
        var stuffedBits: CInt = 0
        var i: CInt = 0

        while i < numDataCodewords {
            defer {
                i += 1
            }

            let dataWord: int32_t = dataWords.array[i]

            if dataWord == 0 || dataWord == mask {
                if error != nil {
                    error.pointee = ZXFormatErrorInstance()
                }

                return 0
            } else if dataWord == 1 || dataWord == mask - 1 {
                stuffedBits += 1
            }
        }

        let correctedBits = ZXBoolArray(length: CUnsignedInt(numDataCodewords * codewordSize - stuffedBits))
        var index: CInt = 0
        var i: CInt = 0

        while i < numDataCodewords {
            defer {
                i += 1
            }

            let dataWord: CInt = dataWords.array[i]

            if dataWord == 1 || dataWord == mask - 1 {
                memset(correctedBits.array + Int(index) * MemoryLayout.size(ofValue: BOOL), dataWord > 1, codewordSize - 1)
                index += codewordSize - 1
            } else {
                var bit = codewordSize - 1

                while bit >= 0 {
                    defer {
                        bit -= 1
                    }

                    correctedBits.array[index += 1] = (dataWord & (1 << bit)) != 0
                }
            }
        }

        return correctedBits
    }
    @objc
    func extractBits(_ matrix: ZXBitMatrix!) -> ZXBoolArray {
        let compact: Bool = self.ddata.isCompact
        let layers = self.ddata.nbLayers ?? 0
        let baseMatrixSize = compact ? 11 + layers * 4 : 14 + layers * 4
        let alignmentMap = ZXIntArray(length: CUnsignedInt(baseMatrixSize))
        let rawbits = ZXBoolArray(length: CUnsignedInt(self.totalBitsInLayer(layers, compact: compact)))

        if compact {
            var i: CInt = 0

            while i < alignmentMap.length {
                defer {
                    i += 1
                }

                alignmentMap.array[i] = i
            }
        } else {
            let matrixSize = baseMatrixSize + 1 + 2 * ((baseMatrixSize / 2 - 1) / 15)
            let origCenter = baseMatrixSize / 2
            let center = matrixSize / 2
            var i: CInt = 0

            while i < origCenter {
                defer {
                    i += 1
                }

                let newOffset = i + i / 15

                alignmentMap.array[origCenter - i - 1] = (center - newOffset - 1) as? int32_t
                alignmentMap.array[origCenter + i] = (center + newOffset + 1) as? int32_t
            }
        }

        var i: CInt = 0, rowOffset: CInt = 0

        while i < layers {
            defer {
                i += 1
            }

            let rowSize = compact ? (layers - i) * 4 + 9 : (layers - i) * 4 + 12
            let low = i * 2
            let high = baseMatrixSize - 1 - low
            var j: CInt = 0

            while j < rowSize {
                defer {
                    j += 1
                }

                let columnOffset = j * 2
                var k: CInt = 0

                while k < 2 {
                    defer {
                        k += 1
                    }

                    rawbits.array[rowOffset + columnOffset + k] = matrix.getX(alignmentMap.array[low + k], y: alignmentMap.array[low + j])
                    rawbits.array[rowOffset + 2 * rowSize + columnOffset + k] = matrix.getX(alignmentMap.array[low + j], y: alignmentMap.array[high - k])
                    rawbits.array[rowOffset + 4 * rowSize + columnOffset + k] = matrix.getX(alignmentMap.array[high - k], y: alignmentMap.array[high - j])
                    rawbits.array[rowOffset + 6 * rowSize + columnOffset + k] = matrix.getX(alignmentMap.array[high - j], y: alignmentMap.array[low + k])
                }
            }

            rowOffset += rowSize * 8
        }

        return rawbits
    }
    @objc
    static func readCode(_ rawbits: ZXBoolArray!, startIndex: CInt, length: CInt) -> CInt {
        var res: CInt = 0
        var i = startIndex

        while i < startIndex + length {
            defer {
                i += 1
            }

            res <<= 1

            if rawbits.array[i] {
                res |= 0x1
            }
        }

        return res
    }
    @objc
    static func readByte(_ rawbits: ZXBoolArray!, startIndex: CInt) -> int8_t {
        let n: CInt = CInt(rawbits.length) - startIndex

        if n >= 8 {
            return self.readCode(rawbits, startIndex: startIndex, length: 8) as? int8_t
        }

        return (self.readCode(rawbits, startIndex: startIndex, length: n) << (8 - n)) as? int8_t
    }
    @objc
    static func convertBoolArrayToByteArray(_ boolArr: ZXBoolArray!) -> ZXByteArray {
        let byteArrLength: CInt = CInt((boolArr.length + 7) / 8)
        let byteArr = ZXByteArray(length: CUnsignedInt(byteArrLength))
        var i: CInt = 0

        while i < byteArrLength {
            defer {
                i += 1
            }

            let code = self.readByte(boolArr, startIndex: 8 * i)

            byteArr.array[i] = code
        }

        return byteArr
    }
    @objc
    func totalBitsInLayer(_ layers: CInt, compact: Bool) -> CInt {
        return ((compact ? 88 : 112) + 16 * layers) * layers
    }
}