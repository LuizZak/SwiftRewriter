// Preprocessor directives found in file:
// #import "ZXBitSource.h"
// #import "ZXByteArray.h"
// #import "ZXDataMatrixDecodedBitStreamParser.h"
// #import "ZXDecoderResult.h"
// #import "ZXErrors.h"
var C40_BASIC_SET_CHARS: (unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar)
var C40_SHIFT2_SET_CHARS: (unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar)
var TEXT_BASIC_SET_CHARS: (unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar)
var TEXT_SHIFT2_SET_CHARS: (unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar)
var TEXT_SHIFT3_SET_CHARS: (unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar)

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
 * Data Matrix Codes can encode text as bits in one of several modes, and can use multiple modes
 * in one Data Matrix Code. This class decodes the bits back into text.
 *
 * See ISO 16022:2006, 5.2.1 - 5.2.9.2
 */
@objc
class ZXDataMatrixDecodedBitStreamParser: NSObject {
    @objc
    static func initialize() {
        if self.self != ZXDataMatrixDecodedBitStreamParser.self {
            return
        }

        memcpy(TEXT_SHIFT2_SET_CHARS, C40_SHIFT2_SET_CHARS, MemoryLayout.size(ofValue: C40_SHIFT2_SET_CHARS))
    }
    @objc
    static func decode(_ bytes: ZXByteArray!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        let bits = ZXBitSource(bytes: bytes)
        let result = NSMutableString(capacity: 100)
        let resultTrailer = NSMutableString()
        let byteSegments: NSMutableArray! = NSMutableArray.arrayWithCapacity(1)
        var mode: CInt = ASCII_ENCODE

        repeat {
            if mode == ASCII_ENCODE {
                mode = self.decodeAsciiSegment(bits, result: result, resultTrailer: resultTrailer)

                if mode == 1 {
                    if error != nil {
                        error.pointee = ZXFormatErrorInstance()
                    }

                    return nil
                }
            } else {
                switch mode {
                case C40_ENCODE:
                    if !self.decodeC40Segment(bits, result: result) {
                        if error != nil {
                            error.pointee = ZXFormatErrorInstance()
                        }

                        return nil
                    }
                case TEXT_ENCODE:
                    if !self.decodeTextSegment(bits, result: result) {
                        if error != nil {
                            error.pointee = ZXFormatErrorInstance()
                        }

                        return nil
                    }
                case ANSIX12_ENCODE:
                    if !self.decodeAnsiX12Segment(bits, result: result) {
                        if error != nil {
                            error.pointee = ZXFormatErrorInstance()
                        }

                        return nil
                    }
                case EDIFACT_ENCODE:
                    self.decodeEdifactSegment(bits, result: result)
                case BASE256_ENCODE:
                    if !self.decodeBase256Segment(bits, result: result, byteSegments: byteSegments) {
                        if error != nil {
                            error.pointee = ZXFormatErrorInstance()
                        }

                        return nil
                    }
                default:
                    if error != nil {
                        error.pointee = ZXFormatErrorInstance()
                    }

                    return nil
                }

                mode = ASCII_ENCODE
            }
        } while mode != PAD_ENCODE && bits.available > 0

        if resultTrailer.length() > 0 {
            result.append(resultTrailer)
        }

        return ZXDecoderResult(rawBytes: bytes, text: result, byteSegments: (byteSegments.count == 0) ? nil : byteSegments, ecLevel: nil)
    }
    @objc
    static func decodeAsciiSegment(_ bits: ZXBitSource!, result: NSMutableString!, resultTrailer: NSMutableString!) -> CInt {
        var upperShift = false

        repeat {
            var oneByte = bits.readBits(8)

            if oneByte == 0 {
                return 1
            } else if oneByte <= 128 {
                if upperShift {
                    oneByte += 128
                }

                result.appendFormat("%C", (oneByte - 1) as? unichar)

                return ASCII_ENCODE
            } else if oneByte == 129 {
                return PAD_ENCODE
            } else if oneByte <= 229 {
                let value = oneByte - 130

                if value < 10 {
                    result.append("0")
                }

                result.appendFormat("%d", value)
            } else if oneByte == 230 {
                return C40_ENCODE
            } else if oneByte == 231 {
                return BASE256_ENCODE
            } else if oneByte == 232 {
                result.appendFormat("%C", 29 as? unichar)
            } else if oneByte == 233 || oneByte == 234 {
            } else if oneByte == 235 {
                upperShift = true
            } else if oneByte == 236 {
                result.appendFormat("[)>%C05%C", 0x1e as? unichar, 0x1d as? unichar)
                resultTrailer.insert(String(format: "%C%C", 0x1e as? unichar, 0x4 as? unichar), at: 0)
            } else if oneByte == 237 {
                result.appendFormat("[)>%C06%C", 0x1e as? unichar, 0x1d as? unichar)
                resultTrailer.insert(String(format: "%C%C", 0x1e as? unichar, 0x4 as? unichar), at: 0)
            } else if oneByte == 238 {
                return ANSIX12_ENCODE
            } else if oneByte == 239 {
                return TEXT_ENCODE
            } else if oneByte == 240 {
                return EDIFACT_ENCODE
            } else if oneByte == 241 {
            } else if oneByte >= 242 {
                if oneByte != 254 || bits.available != 0 {
                    return 1
                }
            }
        } while bits.available > 0

        return ASCII_ENCODE
    }
    @objc
    static func decodeC40Segment(_ bits: ZXBitSource!, result: NSMutableString!) -> Bool {
        var upperShift = false
        let cValues: (CInt, CInt, CInt)
        var shift: CInt = 0

        repeat {
            if bits.available() == 8 {
                return true
            }

            let firstByte = bits.readBits(8)

            if firstByte == 254 {
                return true
            }

            self.parseTwoBytes(firstByte, secondByte: bits.readBits(8), result: cValues)

            var i: CInt = 0

            while i < 3 {
                defer {
                    i += 1
                }

                let cValue: CInt = cValues[i]

                switch shift {
                case 0:
                    if cValue < 3 {
                        shift = cValue + 1
                    } else if cValue < MemoryLayout.size(ofValue: C40_BASIC_SET_CHARS) / MemoryLayout.size(ofValue: unichar) {
                        let c40char: unichar = C40_BASIC_SET_CHARS[cValue]

                        if upperShift {
                            result.appendFormat("%C", (c40char + 128) as? unichar)
                            upperShift = false
                        } else {
                            result.appendFormat("%C", c40char)
                        }
                    } else {
                        return false
                    }
                case 1:
                    if upperShift {
                        result.appendFormat("%C", (cValue + 128) as? unichar)
                        upperShift = false
                    } else {
                        result.appendFormat("%C", cValue as? unichar)
                    }

                    shift = 0
                case 2:
                    if cValue < 27 {
                        let c40char: unichar = C40_SHIFT2_SET_CHARS[cValue]

                        if upperShift {
                            result.appendFormat("%C", (c40char + 128) as? unichar)
                            upperShift = false
                        } else {
                            result.appendFormat("%C", c40char)
                        }
                    } else if cValue == 27 {
                        result.appendFormat("%C", 29 as? unichar)
                    } else if cValue == 30 {
                        upperShift = true
                    } else {
                        return false
                    }

                    shift = 0
                case 3:
                    if upperShift {
                        result.appendFormat("%C", (cValue + 224) as? unichar)
                        upperShift = false
                    } else {
                        result.appendFormat("%C", (cValue + 96) as? unichar)
                    }

                    shift = 0
                default:
                    return false
                }
            }
        } while bits.available > 0

        return true
    }
    @objc
    static func decodeTextSegment(_ bits: ZXBitSource!, result: NSMutableString!) -> Bool {
        var upperShift = false
        let cValues: (CInt, CInt, CInt)
        var shift: CInt = 0

        repeat {
            if bits.available == 8 {
                return true
            }

            let firstByte = bits.readBits(8)

            if firstByte == 254 {
                return true
            }

            self.parseTwoBytes(firstByte, secondByte: bits.readBits(8), result: cValues)

            var i: CInt = 0

            while i < 3 {
                defer {
                    i += 1
                }

                let cValue: CInt = cValues[i]

                switch shift {
                case 0:
                    if cValue < 3 {
                        shift = cValue + 1
                    } else if cValue < MemoryLayout.size(ofValue: TEXT_BASIC_SET_CHARS) / MemoryLayout.size(ofValue: unichar) {
                        let textChar: unichar = TEXT_BASIC_SET_CHARS[cValue]

                        if upperShift {
                            result.appendFormat("%C", (textChar + 128) as? unichar)
                            upperShift = false
                        } else {
                            result.appendFormat("%C", textChar)
                        }
                    } else {
                        return false
                    }
                case 1:
                    if upperShift {
                        result.appendFormat("%C", (cValue + 128) as? unichar)
                        upperShift = false
                    } else {
                        result.appendFormat("%C", cValue as? unichar)
                    }

                    shift = 0
                case 2:
                    if cValue < 27 {
                        let textChar: unichar = TEXT_SHIFT2_SET_CHARS[cValue]

                        if upperShift {
                            result.appendFormat("%C", (textChar + 128) as? unichar)
                            upperShift = false
                        } else {
                            result.appendFormat("%C", textChar)
                        }
                    } else if cValue == 27 {
                        result.appendFormat("%C", 29 as? unichar)
                    } else if cValue == 30 {
                        upperShift = true
                    } else {
                        return false
                    }

                    shift = 0
                case 3:
                    if cValue < MemoryLayout.size(ofValue: TEXT_SHIFT3_SET_CHARS) / MemoryLayout.size(ofValue: unichar) {
                        let textChar: unichar = TEXT_SHIFT3_SET_CHARS[cValue]

                        if upperShift {
                            result.appendFormat("%C", (textChar + 128) as? unichar)
                            upperShift = false
                        } else {
                            result.appendFormat("%C", textChar)
                        }

                        shift = 0
                    } else {
                        return false
                    }
                default:
                    return false
                }
            }
        } while bits.available > 0

        return true
    }
    @objc
    static func decodeAnsiX12Segment(_ bits: ZXBitSource!, result: NSMutableString!) -> Bool {
        let cValues: (CInt, CInt, CInt)

        repeat {
            if bits.available == 8 {
                return true
            }

            let firstByte = bits.readBits(8)

            if firstByte == 254 {
                return true
            }

            self.parseTwoBytes(firstByte, secondByte: bits.readBits(8), result: cValues)

            var i: CInt = 0

            while i < 3 {
                defer {
                    i += 1
                }

                let cValue: CInt = cValues[i]

                if cValue == 0 {
                    result.append("\\r")
                } else if cValue == 1 {
                    result.append("*")
                } else if cValue == 2 {
                    result.append(">")
                } else if cValue == 3 {
                    result.append(" ")
                } else if cValue < 14 {
                    result.appendFormat("%C", (cValue + 44) as? unichar)
                } else if cValue < 40 {
                    result.appendFormat("%C", (cValue + 51) as? unichar)
                } else {
                    return false
                }
            }
        } while bits.available > 0

        return true
    }
    @objc
    static func parseTwoBytes(_ firstByte: CInt, secondByte: CInt, result: UnsafeMutablePointer<CInt>!) {
        var fullBitValue = (firstByte << 8) + secondByte - 1
        var temp = fullBitValue / 1600

        result[0] = temp

        fullBitValue -= temp * 1600

        temp = fullBitValue / 40

        result[1] = temp
        result[2] = fullBitValue - temp * 40
    }
    @objc
    static func decodeEdifactSegment(_ bits: ZXBitSource!, result: NSMutableString!) {
        repeat {
            if bits.available <= 16 {
                return
            }

            var i: CInt = 0

            while i < 4 {
                defer {
                    i += 1
                }

                var edifactValue = bits.readBits(6)

                if edifactValue == 0x1f {
                    let bitsLeft = 8 - bits.bitOffset

                    if bitsLeft != 8 {
                        bits.readBits(bitsLeft)
                    }

                    return
                }

                if (edifactValue & 0x20) == 0 {
                    edifactValue |= 0x40
                }

                result.appendFormat("%c", CChar(edifactValue))
            }
        } while bits.available > 0
    }
    @objc
    static func decodeBase256Segment(_ bits: ZXBitSource!, result: NSMutableString!, byteSegments: NSMutableArray!) -> Bool {
        var codewordPosition = 1 + bits.byteOffset
        let d1 = self.unrandomize255State(bits.readBits(8), base256CodewordPosition: codewordPosition += 1)
        var count: CInt

        if d1 == 0 {
            count = bits.available() / 8
        } else if d1 < 250 {
            count = d1
        } else {
            count = 250 * (d1 - 249) + self.unrandomize255State(bits.readBits(8), base256CodewordPosition: codewordPosition += 1)
        }

        if count < 0 {
            return false
        }

        let bytes = ZXByteArray(length: CUnsignedInt(count))
        var i: CInt = 0

        while i < count {
            defer {
                i += 1
            }

            if bits.available() < 8 {
                return false
            }

            bytes.array[i] = self.unrandomize255State(bits.readBits(8), base256CodewordPosition: codewordPosition += 1) as? int8_t
        }

        byteSegments.add(bytes)
        result.append(String(bytes: bytes.array, length: bytes.length, encoding: NSISOLatin1StringEncoding))

        return true
    }
    @objc
    static func unrandomize255State(_ randomizedBase256Codeword: CInt, base256CodewordPosition: CInt) -> CInt {
        let pseudoRandomNumber = ((149 * base256CodewordPosition) % 255) + 1
        let tempVariable = randomizedBase256Codeword - pseudoRandomNumber

        return (tempVariable >= 0) ? tempVariable : tempVariable + 256
    }
}