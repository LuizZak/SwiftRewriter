// Preprocessor directives found in file:
// #import "ZXEncodeHints.h"
// #import "ZXDataMatrixASCIIEncoder.h"
// #import "ZXDataMatrixBase256Encoder.h"
// #import "ZXDataMatrixC40Encoder.h"
// #import "ZXDataMatrixEdifactEncoder.h"
// #import "ZXDataMatrixEncoderContext.h"
// #import "ZXDataMatrixHighLevelEncoder.h"
// #import "ZXDataMatrixSymbolInfo.h"
// #import "ZXDataMatrixTextEncoder.h"
// #import "ZXDataMatrixX12Encoder.h"
let PAD_CHAR: unichar = 129
var MACRO_05_HEADER: String! = nil
var MACRO_06_HEADER: String! = nil
var MACRO_TRAILER: String! = nil

/*
 * Copyright 2013 ZXing authors
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
 * DataMatrix ECC 200 data encoder following the algorithm described in ISO/IEC 16022:200(E) in
 * annex S.
 */
/*
 * Copyright 2013 ZXing authors
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
 * DataMatrix ECC 200 data encoder following the algorithm described in ISO/IEC 16022:200(E) in
 * annex S.
 */
@objc
class ZXDataMatrixHighLevelEncoder: NSObject {
    @objc
    static func initialize() {
        if self.self != ZXDataMatrixHighLevelEncoder.self {
            return
        }

        MACRO_05_HEADER = String(format: "[)>%C05%C", 0x1e as? unichar, 0x1d as? unichar)
        MACRO_06_HEADER = String(format: "[)>%C06%C", 0x1e as? unichar, 0x1d as? unichar)
        MACRO_TRAILER = String(format: "%C%C", 0x1e as? unichar, 0x4 as? unichar)
    }
    /**
 * mode latch to C40 encodation mode
 */
    /**
 * mode latch to C40 encodation mode
 */
    @objc
    static func latchToC40() -> unichar {
        return 230
    }
    /**
 * mode latch to Base 256 encodation mode
 */
    /**
 * mode latch to Base 256 encodation mode
 */
    @objc
    static func latchToBase256() -> unichar {
        return 231
    }
    /**
 * Upper Shift
 */
    /**
 * Upper Shift
 */
    @objc
    static func upperShift() -> unichar {
        return 235
    }
    /**
 * 05 Macro
 */
    /**
 * 05 Macro
 */
    @objc
    static func macro05() -> unichar {
        return 236
    }
    /**
 * 06 Macro
 */
    /**
 * 06 Macro
 */
    @objc
    static func macro06() -> unichar {
        return 237
    }
    /**
 * mode latch to ANSI X.12 encodation mode
 */
    /**
 * mode latch to ANSI X.12 encodation mode
 */
    @objc
    static func latchToAnsiX12() -> unichar {
        return 238
    }
    /**
 * mode latch to Text encodation mode
 */
    /**
 * mode latch to Text encodation mode
 */
    @objc
    static func latchToText() -> unichar {
        return 239
    }
    /**
 * mode latch to EDIFACT encodation mode
 */
    /**
 * mode latch to EDIFACT encodation mode
 */
    @objc
    static func latchToEdifact() -> unichar {
        return 240
    }
    /**
 * Unlatch from C40 encodation
 */
    /**
 * Unlatch from C40 encodation
 */
    @objc
    static func c40Unlatch() -> unichar {
        return 254
    }
    /**
 * Unlatch from X12 encodation
 */
    /**
 * Unlatch from X12 encodation
 */
    @objc
    static func x12Unlatch() -> unichar {
        return 254
    }
    @objc
    static func asciiEncodation() -> CInt {
        return 0
    }
    @objc
    static func c40Encodation() -> CInt {
        return 1
    }
    @objc
    static func textEncodation() -> CInt {
        return 2
    }
    @objc
    static func x12Encodation() -> CInt {
        return 3
    }
    @objc
    static func edifactEncodation() -> CInt {
        return 4
    }
    @objc
    static func base256Encodation() -> CInt {
        return 5
    }
    /*
+ (int8_t *)bytesForMessage:(NSString *)msg {
  return (int8_t *)[[msg dataUsingEncoding:(NSStringEncoding) 0x80000400] bytes]; //See 4.4.3 and annex B of ISO/IEC 15438:2001(E)
}
*/
    @objc
    static func randomize253State(_ ch: unichar, codewordPosition: CInt) -> unichar {
        let pseudoRandom = ((149 * codewordPosition) % 253) + 1
        let tempVariable = ch + pseudoRandom

        return (tempVariable <= 254) ? tempVariable as? unichar : (tempVariable - 254) as? unichar
    }
    /*
 * Converts the message to a byte array using the default encoding (cp437) as defined by the
 * specification
 *
 * @param msg the message
 * @return the byte array of the message
 */
    /*
+ (int8_t *)bytesForMessage:(NSString *)msg;
*/
    /**
 * Performs message encoding of a DataMatrix message using the algorithm described in annex P
 * of ISO/IEC 16022:2000(E).
 *
 * @param msg the message
 * @return the encoded message (the char values range from 0 to 255)
 */
    /*
 * Converts the message to a byte array using the default encoding (cp437) as defined by the
 * specification
 *
 * @param msg the message
 * @return the byte array of the message
 */
    /*
+ (int8_t *)bytesForMessage:(NSString *)msg;
*/
    /**
 * Performs message encoding of a DataMatrix message using the algorithm described in annex P
 * of ISO/IEC 16022:2000(E).
 *
 * @param msg the message
 * @return the encoded message (the char values range from 0 to 255)
 */
    @objc
    static func encodeHighLevel(_ msg: String!) -> String? {
        return self.encodeHighLevel(msg, shape: ZXDataMatrixSymbolShapeHint.ZXDataMatrixSymbolShapeHintForceNone, minSize: nil, maxSize: nil)
    }
    /**
 * Performs message encoding of a DataMatrix message using the algorithm described in annex P
 * of ISO/IEC 16022:2000(E).
 *
 * @param msg     the message
 * @param shape   requested shape. May be {@code SymbolShapeHint.FORCE_NONE},
 *                {@code SymbolShapeHint.FORCE_SQUARE} or {@code SymbolShapeHint.FORCE_RECTANGLE}.
 * @param minSize the minimum symbol size constraint or null for no constraint
 * @param maxSize the maximum symbol size constraint or null for no constraint
 * @return the encoded message (the char values range from 0 to 255)
 */
    /**
 * Performs message encoding of a DataMatrix message using the algorithm described in annex P
 * of ISO/IEC 16022:2000(E).
 *
 * @param msg     the message
 * @param shape   requested shape. May be {@code SymbolShapeHint.FORCE_NONE},
 *                {@code SymbolShapeHint.FORCE_SQUARE} or {@code SymbolShapeHint.FORCE_RECTANGLE}.
 * @param minSize the minimum symbol size constraint or null for no constraint
 * @param maxSize the maximum symbol size constraint or null for no constraint
 * @return the encoded message (the char values range from 0 to 255)
 */
    @objc
    static func encodeHighLevel(_ msg: String!, shape: ZXDataMatrixSymbolShapeHint, minSize: ZXDimension!, maxSize: ZXDimension!) -> String? {
        //the codewords 0..255 are encoded as Unicode characters
        let encoders = [ZXDataMatrixASCIIEncoder(), ZXDataMatrixC40Encoder(), ZXDataMatrixTextEncoder(), ZXDataMatrixX12Encoder(), ZXDataMatrixEdifactEncoder(), ZXDataMatrixBase256Encoder()]
        let context = ZXDataMatrixEncoderContext(message: msg)

        context.symbolShape = shape
        context.setSizeConstraints(minSize, maxSize: maxSize)

        if msg.hasPrefix(MACRO_05_HEADER) && msg.hasSuffix(MACRO_TRAILER) {
            context.writeCodeword(self.macro05())
            context.setSkipAtEnd(2)
            context.pos += CInt(MACRO_05_HEADER.length)
        } else if msg.hasPrefix(MACRO_06_HEADER) && msg.hasSuffix(MACRO_TRAILER) {
            context.writeCodeword(self.macro06())
            context.setSkipAtEnd(2)
            context.pos += CInt(MACRO_06_HEADER.length)
        }

        var encodingMode = self.asciiEncodation() //Default mode

        while context.hasMoreCharacters() {
            encoders[Int(encodingMode)].encode(context)

            if context.newEncoding >= 0 {
                encodingMode = context.newEncoding
                context.resetEncoderSignal()
            }
        }

        let len: UInt = context.codewords.length

        context.updateSymbolInfo()

        let capacity = context.symbolInfo.dataCapacity ?? 0

        if len < capacity {
            if encodingMode != self.asciiEncodation() && encodingMode != self.base256Encodation() && encodingMode != self.edifactEncodation() {
                if let value = 0xfe as? unichar {
                    context.writeCodeword(value)
                }
            }
        }

        //Padding
        let codewords = context.codewords

        if codewords?.length < capacity {
            codewords?.appendFormat("%C", PAD_CHAR)
        }

        while codewords?.length < capacity {
            codewords?.appendFormat("%C", self.randomize253State(PAD_CHAR, codewordPosition: CInt(codewords?.length) + 1))
        }

        return String.stringWithString(context.codewords)
    }
    @objc
    static func lookAheadTest(_ msg: String!, startpos: CInt, currentMode: CInt) -> CInt {
        if startpos >= msg.length {
            return currentMode
        }

        var charCounts: (CFloat, CFloat, CFloat, CFloat, CFloat, CFloat)

        //step J
        if currentMode == self.asciiEncodation() {
            charCounts[0] = 0
            charCounts[1] = 1
            charCounts[2] = 1
            charCounts[3] = 1
            charCounts[4] = 1
            charCounts[5] = 1.25
        } else {
            charCounts[0] = 1
            charCounts[1] = 2
            charCounts[2] = 2
            charCounts[3] = 2
            charCounts[4] = 2
            charCounts[5] = 2.25
            charCounts[currentMode] = 0
        }

        var charsProcessed: CInt = 0

        while true {
            //step K
            if (startpos + charsProcessed) == msg.length {
                var min: CInt = INT_MAX
                let mins: (int8_t, int8_t, int8_t, int8_t, int8_t, int8_t)
                let intCharCounts: (CInt, CInt, CInt, CInt, CInt, CInt)

                min = self.findMinimums(charCounts, intCharCounts: intCharCounts, min: min, mins: mins)

                let minCount = self.minimumCount(mins)

                if intCharCounts[self.asciiEncodation()] == min {
                    return self.asciiEncodation()
                }

                if minCount == 1 && mins[self.base256Encodation()] > 0 {
                    return self.base256Encodation()
                }

                if minCount == 1 && mins[self.edifactEncodation()] > 0 {
                    return self.edifactEncodation()
                }

                if minCount == 1 && mins[self.textEncodation()] > 0 {
                    return self.textEncodation()
                }

                if minCount == 1 && mins[self.x12Encodation()] > 0 {
                    return self.x12Encodation()
                }

                return self.c40Encodation()
            }

            let c: unichar = msg.characterAtIndex(startpos + charsProcessed)

            charsProcessed += 1

            //step L
            if self.isDigit(c) {
                charCounts[self.asciiEncodation()] += 0.5
            } else if self.isExtendedASCII(c) {
                charCounts[self.asciiEncodation()] = CInt(ceil(charCounts[self.asciiEncodation()]))
                charCounts[self.asciiEncodation()] += 2
            } else {
                charCounts[self.asciiEncodation()] = CInt(ceil(charCounts[self.asciiEncodation()]))
                charCounts[self.asciiEncodation()] += 1
            }

            //step M
            if self.isNativeC40(c) {
                charCounts[self.c40Encodation()] += 2.0 / 3.0
            } else if self.isExtendedASCII(c) {
                charCounts[self.c40Encodation()] += 8.0 / 3.0
            } else {
                charCounts[self.c40Encodation()] += 4.0 / 3.0
            }

            //step N
            if self.isNativeText(c) {
                charCounts[self.textEncodation()] += 2.0 / 3.0
            } else if self.isExtendedASCII(c) {
                charCounts[self.textEncodation()] += 8.0 / 3.0
            } else {
                charCounts[self.textEncodation()] += 4.0 / 3.0
            }

            //step O
            if self.isNativeX12(c) {
                charCounts[self.x12Encodation()] += 2.0 / 3.0
            } else if self.isExtendedASCII(c) {
                charCounts[self.x12Encodation()] += 13.0 / 3.0
            } else {
                charCounts[self.x12Encodation()] += 10.0 / 3.0
            }

            //step P
            if self.isNativeEDIFACT(c) {
                charCounts[self.edifactEncodation()] += 3.0 / 4.0
            } else if self.isExtendedASCII(c) {
                charCounts[self.edifactEncodation()] += 17.0 / 4.0
            } else {
                charCounts[self.edifactEncodation()] += 13.0 / 4.0
            }

            // step Q
            if self.isSpecialB256(c) {
                charCounts[self.base256Encodation()] += 4
            } else {
                charCounts[self.base256Encodation()] += 1
            }

            //step R
            if charsProcessed >= 4 {
                let intCharCounts: (CInt, CInt, CInt, CInt, CInt, CInt)
                let mins: (int8_t, int8_t, int8_t, int8_t, int8_t, int8_t)

                self.findMinimums(charCounts, intCharCounts: intCharCounts, min: INT_MAX, mins: mins)

                let minCount = self.minimumCount(mins)

                if intCharCounts[self.asciiEncodation()] < intCharCounts[self.base256Encodation()] && intCharCounts[self.asciiEncodation()] < intCharCounts[self.c40Encodation()] && intCharCounts[self.asciiEncodation()] < intCharCounts[self.textEncodation()] && intCharCounts[self.asciiEncodation()] < intCharCounts[self.x12Encodation()] && intCharCounts[self.asciiEncodation()] < intCharCounts[self.edifactEncodation()] {
                    return self.asciiEncodation()
                }

                if intCharCounts[self.base256Encodation()] < intCharCounts[self.asciiEncodation()] || (mins[self.c40Encodation()] + mins[self.textEncodation()] + mins[self.x12Encodation()] + mins[self.edifactEncodation()]) == 0 {
                    return self.base256Encodation()
                }

                if minCount == 1 && mins[self.edifactEncodation()] > 0 {
                    return self.edifactEncodation()
                }

                if minCount == 1 && mins[self.textEncodation()] > 0 {
                    return self.textEncodation()
                }

                if minCount == 1 && mins[self.x12Encodation()] > 0 {
                    return self.x12Encodation()
                }

                if intCharCounts[self.c40Encodation()] + 1 < intCharCounts[self.asciiEncodation()] && intCharCounts[self.c40Encodation()] + 1 < intCharCounts[self.base256Encodation()] && intCharCounts[self.c40Encodation()] + 1 < intCharCounts[self.edifactEncodation()] && intCharCounts[self.c40Encodation()] + 1 < intCharCounts[self.textEncodation()] {
                    if intCharCounts[self.c40Encodation()] < intCharCounts[self.x12Encodation()] {
                        return self.c40Encodation()
                    }

                    if intCharCounts[self.c40Encodation()] == intCharCounts[self.x12Encodation()] {
                        var p = startpos + charsProcessed + 1

                        while p < msg.length {
                            let tc: CChar = msg.characterAtIndex(p)

                            if self.isX12TermSep(tc) {
                                return self.x12Encodation()
                            }

                            if !self.isNativeX12(tc) {
                                break
                            }

                            p += 1
                        }

                        return self.c40Encodation()
                    }
                }
            }
        }
    }
    @objc
    static func findMinimums(_ charCounts: UnsafeMutablePointer<CFloat>!, intCharCounts: UnsafeMutablePointer<CInt>!, min: CInt, mins: UnsafeMutablePointer<int8_t>!) -> CInt {
        memset(mins, 0, 6)

        var i: CInt = 0

        while i < 6 {
            defer {
                i += 1
            }

            intCharCounts[i] = CInt(ceil(charCounts[i]))

            let current: CInt = intCharCounts[i]

            if min > current {
                min = current
                memset(mins, 0, 6)
            }

            if min == current {
                mins[i] += 1
            }
        }

        return min
    }
    @objc
    static func minimumCount(_ mins: UnsafeMutablePointer<int8_t>!) -> CInt {
        var minCount: CInt = 0
        var i: CInt = 0

        while i < 6 {
            defer {
                i += 1
            }

            minCount += mins[i]
        }

        return minCount
    }
    @objc
    static func isDigit(_ ch: unichar) -> Bool {
        return ch >= "0" && ch <= "9"
    }
    @objc
    static func isExtendedASCII(_ ch: unichar) -> Bool {
        return ch >= 128 && ch <= 255
    }
    @objc
    static func isNativeC40(_ ch: unichar) -> Bool {
        return (ch == " ") || (ch >= "0" && ch <= "9") || (ch >= "A" && ch <= "Z")
    }
    @objc
    static func isNativeText(_ ch: unichar) -> Bool {
        return (ch == " ") || (ch >= "0" && ch <= "9") || (ch >= "a" && ch <= "z")
    }
    @objc
    static func isNativeX12(_ ch: unichar) -> Bool {
        return self.isX12TermSep(ch) || (ch == " ") || (ch >= "0" && ch <= "9") || (ch >= "A" && ch <= "Z")
    }
    @objc
    static func isX12TermSep(_ ch: unichar) -> Bool {
        return (ch == "\\r") || (ch == "*") || (ch == ">")
    }
    @objc
    static func isNativeEDIFACT(_ ch: unichar) -> Bool {
        return ch >= " " && ch <= "^"
    }
    @objc
    static func isSpecialB256(_ ch: unichar) -> Bool {
        return false //TODO NOT IMPLEMENTED YET!!!
    }
    /**
 * Determines the number of consecutive characters that are encodable using numeric compaction.
 *
 * @param msg      the message
 * @param startpos the start position within the message
 * @return the requested character count
 */
    /**
 * Determines the number of consecutive characters that are encodable using numeric compaction.
 *
 * @param msg      the message
 * @param startpos the start position within the message
 * @return the requested character count
 */
    @objc
    static func determineConsecutiveDigitCount(_ msg: String!, startpos: CInt) -> CInt {
        var count: CInt = 0
        let len: UInt = msg.length
        var idx = startpos

        if idx < len {
            var ch: unichar = msg.characterAtIndex(idx)

            while self.isDigit(ch) && idx < len {
                count += 1
                idx += 1

                if idx < len {
                    ch = msg.characterAtIndex(idx)
                }
            }
        }

        return count
    }
    @objc
    static func illegalCharacter(_ c: unichar) {
        var hex: String! = String(format: "%x", c)

        hex = "0000".substringWithRange(NSMakeRange(0, hex.length)).stringByAppendingString(hex)
        NSException.raise(NSInvalidArgumentException, format: "Illegal character: %C (0x%@)", c, hex)
    }
}