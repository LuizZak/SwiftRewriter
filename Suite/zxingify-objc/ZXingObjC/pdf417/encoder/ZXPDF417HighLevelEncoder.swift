// Preprocessor directives found in file:
// #import "ZXEncodeHints.h"
// #import "ZXByteArray.h"
// #import "ZXCharacterSetECI.h"
// #import "ZXErrors.h"
// #import "ZXPDF417HighLevelEncoder.h"
let ZX_PDF417_TEXT_COMPACTION: CInt = 0
let ZX_PDF417_BYTE_COMPACTION: CInt = 1
let ZX_PDF417_NUMERIC_COMPACTION: CInt = 2
let ZX_PDF417_SUBMODE_ALPHA: CInt = 0
let ZX_PDF417_SUBMODE_LOWER: CInt = 1
let ZX_PDF417_SUBMODE_MIXED: CInt = 2
let ZX_PDF417_SUBMODE_PUNCTUATION: CInt = 3
let ZX_PDF417_LATCH_TO_TEXT: CInt = 900
let ZX_PDF417_LATCH_TO_BYTE_PADDED: CInt = 901
let ZX_PDF417_LATCH_TO_NUMERIC: CInt = 902
let ZX_PDF417_SHIFT_TO_BYTE: CInt = 913
let ZX_PDF417_LATCH_TO_BYTE: CInt = 924
let ZX_PDF417_HIGH_LEVEL_ECI_USER_DEFINED: CInt = 925
let ZX_PDF417_HIGH_LEVEL_ECI_GENERAL_PURPOSE: CInt = 926
let ZX_PDF417_HIGH_LEVEL_ECI_CHARSET: CInt = 927
var ZX_PDF417_TEXT_MIXED_RAW: UnsafePointer<int8_t>!
var ZX_PDF417_TEXT_PUNCTUATION_RAW: UnsafePointer<int8_t>!
let ZX_PDF417_MIXED_TABLE_LEN: CInt = 128
var ZX_PDF417_MIXED_TABLE: UnsafeMutablePointer<unichar>!
let ZX_PDF417_PUNCTUATION_LEN: CInt = 128
var ZX_PDF417_PUNCTUATION: UnsafeMutablePointer<unichar>!
let ZX_PDF417_DEFAULT_ENCODING: NSStringEncoding = NSISOLatin1StringEncoding

/**
 * PDF417 high-level encoder following the algorithm described in ISO/IEC 15438:2001(E) in
 * annex P.
 */
@objc
class ZXPDF417HighLevelEncoder: NSObject {
    @objc
    static func initialize() {
        if self.self != ZXPDF417HighLevelEncoder.self {
            return
        }

        var i: CInt = 0

        while i < ZX_PDF417_MIXED_TABLE_LEN {
            defer {
                i += 1
            }

            ZX_PDF417_MIXED_TABLE[i] = 0xff
        }

        var i: int8_t = 0

        while i < MemoryLayout.size(ofValue: ZX_PDF417_TEXT_MIXED_RAW) / MemoryLayout.size(ofValue: int8_t) {
            defer {
                i += 1
            }

            let b: int8_t = ZX_PDF417_TEXT_MIXED_RAW[i]

            if b > 0 {
                ZX_PDF417_MIXED_TABLE[b] = i
            }
        }

        var i: CInt = 0

        while i < ZX_PDF417_PUNCTUATION_LEN {
            defer {
                i += 1
            }

            ZX_PDF417_PUNCTUATION[i] = 0xff
        }

        var i: int8_t = 0

        while i < MemoryLayout.size(ofValue: ZX_PDF417_TEXT_PUNCTUATION_RAW) / MemoryLayout.size(ofValue: int8_t) {
            defer {
                i += 1
            }

            let b: int8_t = ZX_PDF417_TEXT_PUNCTUATION_RAW[i]

            if b > 0 {
                ZX_PDF417_PUNCTUATION[b] = i
            }
        }
    }
    /**
 * Performs high-level encoding of a PDF417 message using the algorithm described in annex P
 * of ISO/IEC 15438:2001(E). If byte compaction has been selected, then only byte compaction
 * is used.
 *
 * @param msg the message
 * @return the encoded message (the char values range from 0 to 928)
 */
    @objc
    static func encodeHighLevel(_ msg: String!, compaction: ZXPDF417Compaction, encoding: NSStringEncoding, error: UnsafeMutablePointer<Error?>!) -> String? {
        //the codewords 0..928 are encoded as Unicode characters
        let sb = NSMutableString(capacity: msg.length)

        if encoding == 0 {
            encoding = ZX_PDF417_DEFAULT_ENCODING
        } else if ZX_PDF417_DEFAULT_ENCODING != encoding {
            let eci = ZXCharacterSetECI.characterSetECIByEncoding(encoding)

            if !self.encodingECI(eci?.value ?? 0, sb: sb, error: error) {
                return nil
            }
        }

        let len: UInt = msg.length
        var p: CInt = 0
        var textSubMode = ZX_PDF417_SUBMODE_ALPHA

        // User selected encoding mode
        if compaction == ZXPDF417Compaction.ZXPDF417CompactionText {
            self.encodeText(msg, startpos: p, count: CInt(len), buffer: sb, initialSubmode: textSubMode)
        } else if compaction == ZXPDF417Compaction.ZXPDF417CompactionByte {
            let bytes = self.bytesForMessage(msg, encoding: encoding)

            self.encodeBinary(bytes, startpos: p, count: CInt(msg.length), startmode: ZX_PDF417_BYTE_COMPACTION, buffer: sb)
        } else if compaction == ZXPDF417Compaction.ZXPDF417CompactionNumeric {
            sb.appendFormat("%C", ZX_PDF417_LATCH_TO_NUMERIC as? unichar)
            self.encodeNumeric(msg, startpos: p, count: CInt(len), buffer: sb)
        } else {
            var encodingMode = ZX_PDF417_TEXT_COMPACTION //Default mode, see 4.4.2.1

            while p < len {
                let n = self.determineConsecutiveDigitCount(msg, startpos: p)

                if n >= 13 {
                    sb.appendFormat("%C", ZX_PDF417_LATCH_TO_NUMERIC as? unichar)

                    encodingMode = ZX_PDF417_NUMERIC_COMPACTION

                    textSubMode = ZX_PDF417_SUBMODE_ALPHA //Reset after latch

                    self.encodeNumeric(msg, startpos: p, count: n, buffer: sb)

                    p += n
                } else {
                    let t = self.determineConsecutiveTextCount(msg, startpos: p)

                    if t >= 5 || n == len {
                        if encodingMode != ZX_PDF417_TEXT_COMPACTION {
                            sb.appendFormat("%C", ZX_PDF417_LATCH_TO_TEXT as? unichar)
                            encodingMode = ZX_PDF417_TEXT_COMPACTION
                            textSubMode = ZX_PDF417_SUBMODE_ALPHA //start with submode alpha after latch
                        }

                        textSubMode = self.encodeText(msg, startpos: p, count: t, buffer: sb, initialSubmode: textSubMode)
                        p += t
                    } else {
                        var b = self.determineConsecutiveBinaryCount(msg, startpos: p, encoding: encoding, error: error)

                        if b == 1 {
                            return nil
                        } else if b == 0 {
                            b = 1
                        }

                        let submsg: String! = msg.substringWithRange(NSMakeRange(p, b))
                        let bytes = self.bytesForMessage(submsg, encoding: encoding)

                        if bytes.length == 1 && encodingMode == ZX_PDF417_TEXT_COMPACTION {
                            //Switch for one byte (instead of latch)
                            self.encodeBinary(bytes, startpos: 0, count: 1, startmode: ZX_PDF417_TEXT_COMPACTION, buffer: sb)
                        } else {
                            //Mode latch performed by encodeBinary
                            self.encodeBinary(bytes, startpos: 0, count: CInt(bytes.length), startmode: encodingMode, buffer: sb)
                            encodingMode = ZX_PDF417_BYTE_COMPACTION
                            textSubMode = ZX_PDF417_SUBMODE_ALPHA //Reset after latch
                        }

                        p += b
                    }
                }
            }
        }

        return sb
    }
    /**
 * Encode parts of the message using Text Compaction as described in ISO/IEC 15438:2001(E),
 * chapter 4.4.2.
 *
 * @param msg            the message
 * @param startpos       the start position within the message
 * @param count          the number of characters to encode
 * @param sb             receives the encoded codewords
 * @param initialSubmode should normally be SUBMODE_ALPHA
 * @return the text submode in which this method ends
 */
    @objc
    static func encodeText(_ msg: String!, startpos: CInt, count: CInt, buffer sb: NSMutableString!, initialSubmode: CInt) -> CInt {
        let tmp = NSMutableString(capacity: Int(count))
        var submode = initialSubmode
        var idx: CInt = 0

        while true {
            let ch: unichar = msg.characterAtIndex(startpos + idx)

            switch submode {
            case ZX_PDF417_SUBMODE_ALPHA:
                if self.isAlphaUpper(ch) {
                    if ch == ' ' {
                        tmp.appendFormat("%C", 26 as? unichar) //space
                    } else {
                        tmp.appendFormat("%C", (ch - 65) as? unichar)
                    }
                } else if self.isAlphaLower(ch) {
                    submode = ZX_PDF417_SUBMODE_LOWER
                    tmp.appendFormat("%C", 27 as? unichar) //ll

                    continue
                } else if self.isMixed(ch) {
                    submode = ZX_PDF417_SUBMODE_MIXED
                    tmp.appendFormat("%C", 28 as? unichar) //ml

                    continue
                } else {
                    tmp.appendFormat("%C", 29 as? unichar) //ps
                    tmp.appendFormat("%C", ZX_PDF417_PUNCTUATION[ch])

                    break
                }
            case ZX_PDF417_SUBMODE_LOWER:
                if self.isAlphaLower(ch) {
                    if ch == ' ' {
                        tmp.appendFormat("%C", 26 as? unichar) //space
                    } else {
                        tmp.appendFormat("%C", (ch - 97) as? unichar)
                    }
                } else if self.isAlphaUpper(ch) {
                    tmp.appendFormat("%C", 27 as? unichar) //as
                    tmp.appendFormat("%C", (ch - 65) as? unichar)

                    //space cannot happen here, it is also in "Lower"
                    break
                } else if self.isMixed(ch) {
                    submode = ZX_PDF417_SUBMODE_MIXED
                    tmp.appendFormat("%C", 28 as? unichar) //ml

                    continue
                } else {
                    tmp.appendFormat("%C", 29 as? unichar) //ps
                    tmp.appendFormat("%C", ZX_PDF417_PUNCTUATION[ch])

                    break
                }
            case ZX_PDF417_SUBMODE_MIXED:
                if self.isMixed(ch) {
                    tmp.appendFormat("%C", ZX_PDF417_MIXED_TABLE[ch]) //as
                } else if self.isAlphaUpper(ch) {
                    submode = ZX_PDF417_SUBMODE_ALPHA
                    tmp.appendFormat("%C", 28 as? unichar) //al

                    continue
                } else if self.isAlphaLower(ch) {
                    submode = ZX_PDF417_SUBMODE_LOWER
                    tmp.appendFormat("%C", 27 as? unichar) //ll

                    continue
                } else {
                    if startpos + idx + 1 < count {
                        let next: CChar = msg.characterAtIndex(startpos + idx + 1)

                        if self.isPunctuation(next) {
                            submode = ZX_PDF417_SUBMODE_PUNCTUATION
                            tmp.appendFormat("%C", 25 as? unichar) //pl

                            continue
                        }
                    }

                    tmp.appendFormat("%C", 29 as? unichar) //ps
                    tmp.appendFormat("%C", ZX_PDF417_PUNCTUATION[ch])
                }
            default:
                //ZX_PDF417_SUBMODE_PUNCTUATION
                if self.isPunctuation(ch) {
                    tmp.appendFormat("%C", ZX_PDF417_PUNCTUATION[ch])
                } else {
                    submode = ZX_PDF417_SUBMODE_ALPHA
                    tmp.appendFormat("%C", 29 as? unichar) //al

                    continue
                }
            }

            idx += 1

            if idx >= count {
                break
            }
        }

        var h: unichar = 0
        let len: UInt = tmp.length
        var i: CInt = 0

        while i < len {
            defer {
                i += 1
            }

            let odd = (i % 2) != 0

            if odd {
                h = ((h * 30) + tmp.characterAtIndex(i)) as? unichar
                sb.appendFormat("%C", h)
            } else {
                h = tmp.characterAtIndex(i)
            }
        }

        if (len % 2) != 0 {
            sb.appendFormat("%C", ((h * 30) + 29) as? unichar) //ps
        }

        return submode
    }
    /**
 * Encode parts of the message using Byte Compaction as described in ISO/IEC 15438:2001(E),
 * chapter 4.4.3. The Unicode characters will be converted to binary using the cp437
 * codepage.
 *
 * @param bytes     the message converted to a byte array
 * @param startpos  the start position within the message
 * @param count     the number of bytes to encode
 * @param startmode the mode from which this method starts
 * @param sb        receives the encoded codewords
 */
    @objc
    static func encodeBinary(_ bytes: ZXByteArray!, startpos: CInt, count: CInt, startmode: CInt, buffer sb: NSMutableString!) {
        if count == 1 && startmode == ZX_PDF417_TEXT_COMPACTION {
            sb.appendFormat("%C", ZX_PDF417_SHIFT_TO_BYTE as? unichar)
        } else {
            let sixpack = (count % 6) == 0

            if sixpack {
                sb.appendFormat("%C", ZX_PDF417_LATCH_TO_BYTE as? unichar)
            } else {
                sb.appendFormat("%C", ZX_PDF417_LATCH_TO_BYTE_PADDED as? unichar)
            }
        }

        var idx = startpos

        // Encode sixpacks
        if count >= 6 {
            let charsLen: CInt = 5
            var chars: UnsafeMutablePointer<unichar>!

            memset(chars, 0, Int(charsLen) * MemoryLayout.size(ofValue: unichar))

            while (startpos + count - idx) >= 6 {
                var t: CLongLong = 0
                var i: CInt = 0

                while i < 6 {
                    defer {
                        i += 1
                    }

                    t <<= 8
                    t += bytes.array[idx + i] & 0xff
                }

                var i: CInt = 0

                while i < 5 {
                    defer {
                        i += 1
                    }

                    chars[i] = (t % 900) as? unichar
                    t /= 900
                }

                var i = charsLen - 1

                while i >= 0 {
                    defer {
                        i -= 1
                    }

                    sb.appendFormat("%C", chars[i])
                }

                idx += 6
            }
        }

        var i = idx

        while i < startpos + count {
            defer {
                i += 1
            }

            let ch: CInt = bytes.array[i] & 0xff

            sb.appendFormat("%C", ch as? unichar)
        }
    }
    @objc
    static func encodeNumeric(_ msg: String!, startpos: CInt, count: CInt, buffer sb: NSMutableString!) {
        var idx: CInt = 0
        let tmp = NSMutableString(capacity: Int(count / 3 + 1))
        let num900: NSDecimalNumber! = NSDecimalNumber.decimalNumberWithDecimal(NSNumber.numberWithInt(900).decimalValue())
        let num0: NSDecimalNumber! = NSDecimalNumber.decimalNumberWithDecimal(NSNumber.numberWithInt(0).decimalValue())

        while idx < count {
            tmp.setString("")

            let len = min(44, count - idx)
            let part: String! = "1".stringByAppendingString(msg.substringWithRange(NSMakeRange(startpos + idx, len)))
            var bigint: NSDecimalNumber! = NSDecimalNumber.decimalNumberWithString(part)

            repeat {
                let roundingMode: NSRoundingMode = ((bigint.floatValue < 0) ^ (num900.floatValue < 0)) ? NSRoundUp : NSRoundDown
                let quotient: NSDecimalNumber! = bigint.decimalNumberByDividingBy(num900, withBehavior: NSDecimalNumberHandler.decimalNumberHandlerWithRoundingMode(roundingMode, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
                let subtractAmount: NSDecimalNumber! = quotient.decimalNumberByMultiplyingBy(num900)
                let remainder: NSDecimalNumber! = bigint.decimalNumberBySubtracting(subtractAmount)

                tmp.appendFormat("%C", remainder.longValue() as? unichar)
                bigint = quotient
            } while !bigint.isEqualToNumber(num0)

            var i: CInt = CInt(tmp.length) - 1

            while i >= 0 {
                defer {
                    i -= 1
                }

                sb.appendFormat("%C", tmp.characterAtIndex(i))
            }

            idx += len
        }
    }
    @objc
    static func isDigit(_ ch: unichar) -> Bool {
        return ch >= '0' && ch <= '9'
    }
    @objc
    static func isAlphaUpper(_ ch: unichar) -> Bool {
        return ch == ' ' || (ch >= 'A' && ch <= 'Z')
    }
    @objc
    static func isAlphaLower(_ ch: unichar) -> Bool {
        return ch == ' ' || (ch >= 'a' && ch <= 'z')
    }
    @objc
    static func isMixed(_ ch: unichar) -> Bool {
        return ZX_PDF417_MIXED_TABLE[ch] != 0xff
    }
    @objc
    static func isPunctuation(_ ch: unichar) -> Bool {
        return ZX_PDF417_PUNCTUATION[ch] != 0xff
    }
    @objc
    static func isText(_ ch: unichar) -> Bool {
        return ch == '\t' || ch == '\n' || ch == '\r' || (ch >= 32 && ch <= 126)
    }
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
            var ch: CChar = msg.characterAtIndex(idx)

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
    /**
 * Determines the number of consecutive characters that are encodable using text compaction.
 *
 * @param msg      the message
 * @param startpos the start position within the message
 * @return the requested character count
 */
    @objc
    static func determineConsecutiveTextCount(_ msg: String!, startpos: CInt) -> CInt {
        let len: UInt = msg.length
        var idx = startpos

        while idx < len {
            var ch: CChar = msg.characterAtIndex(idx)
            var numericCount: CInt = 0

            while numericCount < 13 && self.isDigit(ch) && idx < len {
                numericCount += 1
                idx += 1

                if idx < len {
                    ch = msg.characterAtIndex(idx)
                }
            }

            if numericCount >= 13 {
                return idx - startpos - numericCount
            }

            if numericCount > 0 {
                //Heuristic: All text-encodable chars or digits are binary encodable
                continue
            }

            ch = msg.characterAtIndex(idx)

            //Check if character is encodable
            if !self.isText(ch) {
                break
            }

            idx += 1
        }

        return idx - startpos
    }
    /**
 * Determines the number of consecutive characters that are encodable using binary compaction.
 *
 * @param msg      the message
 * @param startpos the start position within the message
 * @param encoding the charset used to convert the message to a byte array
 * @return the requested character count
 */
    @objc
    static func determineConsecutiveBinaryCount(_ msg: String!, startpos: CInt, encoding: NSStringEncoding, error: UnsafeMutablePointer<Error?>!) -> CInt {
        let len: UInt = msg.length
        var idx = startpos

        while idx < len {
            var ch: CChar = msg.characterAtIndex(idx)
            var numericCount: CInt = 0

            while numericCount < 13 && self.isDigit(ch) {
                numericCount += 1

                //textCount++;
                let i = idx + numericCount

                if i >= len {
                    break
                }

                ch = msg.characterAtIndex(i)
            }

            if numericCount >= 13 {
                return idx - startpos
            }

            ch = msg.characterAtIndex(idx)

            let chString: String! = String(format: "%c", ch)

            if !chString.canBeConvertedToEncoding(encoding) {
                let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: String(format: "Non-encodable character detected: %c (Unicode: %C)", ch, ch as? unichar)]

                if error {
                    *error = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
                }

                return 1
            }

            idx += 1
        }

        return idx - startpos
    }
    @objc
    static func encodingECI(_ eci: CInt, sb: NSMutableString!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        if eci >= 0 && eci < 900 {
            sb.appendFormat("%C", ZX_PDF417_HIGH_LEVEL_ECI_CHARSET as? unichar)
            sb.appendFormat("%C", eci as? unichar)
        } else if eci < 810900 {
            sb.appendFormat("%C", ZX_PDF417_HIGH_LEVEL_ECI_GENERAL_PURPOSE as? unichar)
            sb.appendFormat("%C", (eci / 900 - 1) as? unichar)
            sb.appendFormat("%C", (eci % 900) as? unichar)
        } else if eci < 811800 {
            sb.appendFormat("%C", ZX_PDF417_HIGH_LEVEL_ECI_USER_DEFINED as? unichar)
            sb.appendFormat("%C", (810900 - eci) as? unichar)
        } else {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: String(format: "ECI number not in valid range from 0..811799, but was %d", eci)]

            if error {
                *error = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return false
        }

        return true
    }
    @objc
    static func bytesForMessage(_ msg: String!, encoding: NSStringEncoding) -> ZXByteArray {
        let data: NSData! = msg.dataUsingEncoding(encoding)
        let bytes: UnsafeMutablePointer<int8_t>! = data.bytes() as? UnsafeMutablePointer<int8_t>
        let byteArray = ZXByteArray(length: CUnsignedInt(data.length()))

        memcpy(byteArray.array, bytes, data.length() * MemoryLayout.size(ofValue: int8_t))

        return byteArray
    }
}