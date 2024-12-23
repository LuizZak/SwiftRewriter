// Preprocessor directives found in file:
// #import "ZXBitSource.h"
// #import "ZXByteArray.h"
// #import "ZXCharacterSetECI.h"
// #import "ZXDecoderResult.h"
// #import "ZXErrors.h"
// #import "ZXQRCodeDecodedBitStreamParser.h"
// #import "ZXQRCodeErrorCorrectionLevel.h"
// #import "ZXQRCodeMode.h"
// #import "ZXQRCodeVersion.h"
// #import "ZXStringUtils.h"
var ZX_ALPHANUMERIC_CHARS: (unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar)
let ZX_GB2312_SUBSET: CInt = 1

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
 * QR Codes can encode text as bits in one of several modes, and can use multiple modes
 * in one QR Code. This class decodes the bits back into text.
 *
 * See ISO 18004:2006, 6.4.3 - 6.4.7
 */
@objc
class ZXQRCodeDecodedBitStreamParser: NSObject {
    @objc
    static func decode(_ bytes: ZXByteArray!, version: ZXQRCodeVersion!, ecLevel: ZXQRCodeErrorCorrectionLevel!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        let bits = ZXBitSource(bytes: bytes)
        let result = NSMutableString(capacity: 50)
        let byteSegments: NSMutableArray! = NSMutableArray.arrayWithCapacity(1)
        var symbolSequence: CInt = 1
        var parityData: CInt = 1
        var currentCharacterSetECI: ZXCharacterSetECI! = nil
        var mode: ZXQRCodeMode!
        var fc1InEffect = false

        repeat {
            // While still another segment to read...
            if bits.available() < 4 {
                // OK, assume we're done. Really, a TERMINATOR mode should have been recorded here
                mode = ZXQRCodeMode.terminatorMode()
            } else {
                mode = ZXQRCodeMode.forBits(bits.readBits(4)) // mode is encoded by 4 bits

                if !mode {
                    if error != nil {
                        error.pointee = ZXFormatErrorInstance()
                    }

                    return nil
                }
            }

            if !mode.isEqual(ZXQRCodeMode.terminatorMode()) {
                if mode.isEqual(ZXQRCodeMode.fnc1FirstPositionMode()) || mode.isEqual(ZXQRCodeMode.fnc1SecondPositionMode()) {
                    // We do little with FNC1 except alter the parsed result a bit according to the spec
                    fc1InEffect = true
                } else if mode.isEqual(ZXQRCodeMode.structuredAppendMode()) {
                    if bits.available < 16 {
                        if error != nil {
                            error.pointee = ZXFormatErrorInstance()
                        }

                        return nil
                    }

                    // sequence number and parity is added later to the result metadata
                    // Read next 8 bits (symbol sequence #) and 8 bits (parity data), then continue
                    symbolSequence = bits.readBits(8)
                    parityData = bits.readBits(8)
                } else if mode.isEqual(ZXQRCodeMode.eciMode()) {
                    // Count doesn't apply to ECI
                    let value = self.parseECIValue(bits)

                    currentCharacterSetECI = ZXCharacterSetECI.characterSetECIByValue(value)

                    if currentCharacterSetECI == nil {
                        if error != nil {
                            error.pointee = ZXFormatErrorInstance()
                        }

                        return nil
                    }
                } else if mode.isEqual(ZXQRCodeMode.hanziMode()) {
                    //chinese mode contains a sub set indicator right after mode indicator
                    let subset = bits.readBits(4)
                    let countHanzi = bits.readBits(mode.characterCountBits(version))

                    if subset == ZX_GB2312_SUBSET {
                        if !self.decodeHanziSegment(bits, result: result, count: countHanzi) {
                            if error != nil {
                                error.pointee = ZXFormatErrorInstance()
                            }

                            return nil
                        }
                    }
                } else {
                    // "Normal" QR code modes:
                    // How many characters will follow, encoded in this mode?
                    let count = bits.readBits(mode.characterCountBits(version))

                    if mode.isEqual(ZXQRCodeMode.numericMode()) {
                        if !self.decodeNumericSegment(bits, result: result, count: count) {
                            if error != nil {
                                error.pointee = ZXFormatErrorInstance()
                            }

                            return nil
                        }
                    } else if mode.isEqual(ZXQRCodeMode.alphanumericMode()) {
                        if !self.decodeAlphanumericSegment(bits, result: result, count: count, fc1InEffect: fc1InEffect) {
                            if error != nil {
                                error.pointee = ZXFormatErrorInstance()
                            }

                            return nil
                        }
                    } else if mode.isEqual(ZXQRCodeMode.byteMode()) {
                        if !self.decodeByteSegment(bits, result: result, count: count, currentCharacterSetECI: currentCharacterSetECI, byteSegments: byteSegments, hints: hints) {
                            if error != nil {
                                error.pointee = ZXFormatErrorInstance()
                            }

                            return nil
                        }
                    } else if mode.isEqual(ZXQRCodeMode.kanjiMode()) {
                        if !self.decodeKanjiSegment(bits, result: result, count: count) {
                            if error != nil {
                                error.pointee = ZXFormatErrorInstance()
                            }

                            return nil
                        }
                    } else {
                        if error != nil {
                            error.pointee = ZXFormatErrorInstance()
                        }

                        return nil
                    }
                }
            }
        } while !mode.isEqual(ZXQRCodeMode.terminatorMode())

        return ZXDecoderResult(rawBytes: bytes, text: result.description, byteSegments: (byteSegments.count == 0) ? nil : byteSegments, ecLevel: (ecLevel == nil) ? nil : ecLevel.description, saSequence: symbolSequence, saParity: parityData)
    }
    /**
 * See specification GBT 18284-2000
 */
    @objc
    static func decodeHanziSegment(_ bits: ZXBitSource!, result: NSMutableString!, count: CInt) -> Bool {
        if count * 13 > bits.available {
            return false
        }

        let buffer: NSMutableData! = NSMutableData.dataWithCapacity(2 * count)

        while count > 0 {
            let twoBytes = bits.readBits(13)
            var assembledTwoBytes = ((twoBytes / 0x60) << 8) | (twoBytes % 0x60)

            if assembledTwoBytes < 0xa00 {
                // In the 0xA1A1 to 0xAAFE range
                assembledTwoBytes += 0xa1a1
            } else {
                // In the 0xB0A1 to 0xFAFE range
                assembledTwoBytes += 0xa6a1
            }

            var bytes: (int8_t, int8_t)

            bytes[0] = ((assembledTwoBytes >> 8) & 0xff) as? int8_t
            bytes[1] = (assembledTwoBytes & 0xff) as? int8_t

            buffer.appendBytes(bytes, length: 2)

            count -= 1
        }

        let string: String! = String(data: buffer, encoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000))

        if string {
            result.append(string)
        }

        return true
    }
    @objc
    static func decodeKanjiSegment(_ bits: ZXBitSource!, result: NSMutableString!, count: CInt) -> Bool {
        if count * 13 > bits.available {
            return false
        }

        let buffer: NSMutableData! = NSMutableData.dataWithCapacity(2 * count)

        while count > 0 {
            let twoBytes = bits.readBits(13)
            var assembledTwoBytes = ((twoBytes / 0xc0) << 8) | (twoBytes % 0xc0)

            if assembledTwoBytes < 0x1f00 {
                assembledTwoBytes += 0x8140
            } else {
                assembledTwoBytes += 0xc140
            }

            var bytes: (int8_t, int8_t)

            bytes[0] = (assembledTwoBytes >> 8) as? int8_t
            bytes[1] = assembledTwoBytes as? int8_t

            buffer.appendBytes(bytes, length: 2)

            count -= 1
        }

        let string: String! = String(data: buffer, encoding: NSShiftJISStringEncoding)

        if string {
            result.append(string)
        }

        return true
    }
    @objc
    static func decodeByteSegment(_ bits: ZXBitSource!, result: NSMutableString!, count: CInt, currentCharacterSetECI: ZXCharacterSetECI!, byteSegments: NSMutableArray!, hints: ZXDecodeHints!) -> Bool {
        if 8 * count > bits.available {
            return false
        }

        let readBytes = ZXByteArray(length: CUnsignedInt(count))
        var i: CInt = 0

        while i < count {
            defer {
                i += 1
            }

            readBytes.array[i] = bits.readBits(8) as? int8_t
        }

        var encoding: NSStringEncoding

        if currentCharacterSetECI == nil {
            encoding = ZXStringUtils.guessEncoding(readBytes, hints: hints)
        } else {
            encoding = currentCharacterSetECI.encoding
        }

        let string: String! = String(bytes: readBytes.array, length: readBytes.length, encoding: encoding)

        if string {
            result.append(string)
        }

        byteSegments.add(readBytes)

        return true
    }
    @objc
    static func toAlphaNumericChar(_ value: CInt) -> unichar {
        if value >= 45 {
            return 1
        }

        return ZX_ALPHANUMERIC_CHARS[value]
    }
    @objc
    static func decodeAlphanumericSegment(_ bits: ZXBitSource!, result: NSMutableString!, count: CInt, fc1InEffect: Bool) -> Bool {
        let start: CInt = CInt(result.length)

        while count > 1 {
            if bits.available() < 11 {
                return false
            }

            let nextTwoCharsBits = bits.readBits(11)
            let next1 = self.toAlphaNumericChar(nextTwoCharsBits / 45)
            let next2 = self.toAlphaNumericChar(nextTwoCharsBits % 45)

            result.appendFormat("%C%C", next1, next2)
            count -= 2
        }

        if count == 1 {
            if bits.available() < 6 {
                return false
            }

            let next1 = self.toAlphaNumericChar(bits.readBits(6))

            result.appendFormat("%C", next1)
        }

        if fc1InEffect {
            var i = start

            while i < result.length() {
                defer {
                    i += 1
                }

                if result.characterAtIndex(i) == '%' {
                    if i < result.length() - 1 && result.characterAtIndex(i + 1) == '%' {
                        result.deleteCharacters(in: NSMakeRange(i + 1, 1))
                    } else {
                        result.insert(String(format: "%C", 0x1d as? unichar), at: Int(i))
                    }
                }
            }
        }

        return true
    }
    @objc
    static func decodeNumericSegment(_ bits: ZXBitSource!, result: NSMutableString!, count: CInt) -> Bool {
        // Read three digits at a time
        while count >= 3 {
            // Each 10 bits encodes three digits
            if bits.available < 10 {
                return false
            }

            let threeDigitsBits = bits.readBits(10)

            if threeDigitsBits >= 1000 {
                return false
            }

            let next1 = self.toAlphaNumericChar(threeDigitsBits / 100)
            let next2 = self.toAlphaNumericChar((threeDigitsBits / 10) % 10)
            let next3 = self.toAlphaNumericChar(threeDigitsBits % 10)

            result.appendFormat("%C%C%C", next1, next2, next3)
            count -= 3
        }

        if count == 2 {
            // Two digits left over to read, encoded in 7 bits
            if bits.available < 7 {
                return false
            }

            let twoDigitsBits = bits.readBits(7)

            if twoDigitsBits >= 100 {
                return false
            }

            let next1 = self.toAlphaNumericChar(twoDigitsBits / 10)
            let next2 = self.toAlphaNumericChar(twoDigitsBits % 10)

            result.appendFormat("%C%C", next1, next2)
        } else if count == 1 {
            // One digit left over to read
            if bits.available < 4 {
                return false
            }

            let digitBits = bits.readBits(4)

            if digitBits >= 10 {
                return false
            }

            let next1 = self.toAlphaNumericChar(digitBits)

            result.appendFormat("%C", next1)
        }

        return true
    }
    @objc
    static func parseECIValue(_ bits: ZXBitSource!) -> CInt {
        let firstByte = bits.readBits(8)

        if (firstByte & 0x80) == 0 {
            return firstByte & 0x7f
        }

        if (firstByte & 0xc0) == 0x80 {
            let secondByte = bits.readBits(8)

            return ((firstByte & 0x3f) << 8) | secondByte
        }

        if (firstByte & 0xe0) == 0xc0 {
            let secondThirdBytes = bits.readBits(16)

            return ((firstByte & 0x1f) << 16) | secondThirdBytes
        }

        return 1
    }
}