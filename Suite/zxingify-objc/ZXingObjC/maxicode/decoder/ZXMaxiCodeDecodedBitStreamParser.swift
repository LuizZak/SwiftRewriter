// Preprocessor directives found in file:
// #import "ZXByteArray.h"
// #import "ZXDecoderResult.h"
// #import "ZXErrors.h"
// #import "ZXMaxiCodeDecodedBitStreamParser.h"
let SHIFTA: unichar = 0xfff0
let SHIFTB: unichar = 0xfff1
let SHIFTC: unichar = 0xfff2
let SHIFTD: unichar = 0xfff3
let SHIFTE: unichar = 0xfff4
let TWOSHIFTA: unichar = 0xfff5
let THREESHIFTA: unichar = 0xfff6
let LATCHA: unichar = 0xfff7
let LATCHB: unichar = 0xfff8
let LOCK: unichar = 0xfff9
let ECI: unichar = 0xfffa
let NS: unichar = 0xfffb
let PAD: unichar = 0xfffc
let FS: unichar = 0x1c
let GS: unichar = 0x1d
let RS: unichar = 0x1e
var SETS: (unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar, unichar)

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
 * MaxiCodes can encode text or structured information as bits in one of several modes,
 * with multiple character sets in one code. This class decodes the bits back into text.
 */
@objc
class ZXMaxiCodeDecodedBitStreamParser: NSObject {
    @objc
    static func decode(_ bytes: ZXByteArray!, mode: CInt) -> ZXDecoderResult? {
        let result = NSMutableString(capacity: 144)

        switch mode {
        case 2, 3:
            var postcode: String!

            if mode == 2 {
                let pc = self.postCode2(bytes)

                postcode = String(format: "%9d", pc)
            } else {
                postcode = self.postCode3(bytes)
            }

            let country: String! = String(format: "%3d", self.country(bytes))
            let service: String! = String(format: "%3d", self.serviceClass(bytes))

            result.append(self.message(bytes, start: 10, len: 84))

            if result.hasPrefix(String(format: "[)>%C01%C", RS, GS)) {
                result.insert(String(format: "%@%C%@%C%@%C", postcode, GS, country, GS, service, GS), at: 9)
            } else {
                result.insert(String(format: "%@%C%@%C%@%C", postcode, GS, country, GS, service, GS), at: 0)
            }
        case 4:
            result.append(self.message(bytes, start: 1, len: 93))
        case 5:
            result.append(self.message(bytes, start: 1, len: 77))
        default:
            break
        }

        return ZXDecoderResult(rawBytes: bytes, text: result, byteSegments: nil, ecLevel: String(format: "%d", mode))
    }
    @objc
    static func bit(_ bit: CInt, bytes: ZXByteArray!) -> CInt {
        bit -= 1

        return ((bytes.array[bit / 6] & (1 << (5 - (bit % 6)))) == 0) ? 0 : 1
    }
    @objc
    static func integer(_ bytes: ZXByteArray!, x: ZXByteArray!) -> CInt {
        var val: CInt = 0
        var i: CInt = 0

        while i < x.length {
            defer {
                i += 1
            }

            val += self.bit(x.array[i], bytes: bytes) << (x.length - i - 1)
        }

        return val
    }
    @objc
    static func country(_ bytes: ZXByteArray!) -> CInt {
        return self.integer(bytes, x: ZXByteArray(bytes: 53, 54, 43, 44, 45, 46, 47, 48, 37, 38, 1))
    }
    @objc
    static func serviceClass(_ bytes: ZXByteArray!) -> CInt {
        return self.integer(bytes, x: ZXByteArray(bytes: 55, 56, 57, 58, 59, 60, 49, 50, 51, 52, 1))
    }
    @objc
    static func postCode2Length(_ bytes: ZXByteArray!) -> CInt {
        return self.integer(bytes, x: ZXByteArray(bytes: 39, 40, 41, 42, 31, 32, 1))
    }
    @objc
    static func postCode2(_ bytes: ZXByteArray!) -> CInt {
        return self.integer(bytes, x: ZXByteArray(bytes: 33, 34, 35, 36, 25, 26, 27, 28, 29, 30, 19, 20, 21, 22, 23, 24, 13, 14, 15, 16, 17, 18, 7, 8, 9, 10, 11, 12, 1, 2, 1))
    }
    @objc
    static func postCode3(_ bytes: ZXByteArray!) -> String? {
        return String(format: "%C%C%C%C%C%C", SETS[0][self.integer(bytes, x: ZXByteArray(bytes: 39, 40, 41, 42, 31, 32, 1))], SETS[0][self.integer(bytes, x: ZXByteArray(bytes: 33, 34, 35, 36, 25, 26, 1))], SETS[0][self.integer(bytes, x: ZXByteArray(bytes: 27, 28, 29, 30, 19, 20, 1))], SETS[0][self.integer(bytes, x: ZXByteArray(bytes: 21, 22, 23, 24, 13, 14, 1))], SETS[0][self.integer(bytes, x: ZXByteArray(bytes: 15, 16, 17, 18, 7, 8, 1))], SETS[0][self.integer(bytes, x: ZXByteArray(bytes: 9, 10, 11, 12, 1, 2, 1))])
    }
    @objc
    static func message(_ bytes: ZXByteArray!, start: CInt, len: CInt) -> String? {
        let sb = NSMutableString()
        var shift: CInt = 1
        var set: CInt = 0
        var lastset: CInt = 0
        var i = start

        while i < start + len {
            defer {
                i += 1
            }

            let c: unichar = SETS[set][bytes.array[i]]

            switch c {
            case LATCHA:
                set = 0
                shift = 1
            case LATCHB:
                set = 1
                shift = 1
            case SHIFTA, SHIFTB, SHIFTC, SHIFTD, SHIFTE:
                lastset = set
                set = c - SHIFTA
                shift = 1
            case TWOSHIFTA:
                lastset = set
                set = 0
                shift = 2
            case THREESHIFTA:
                lastset = set
                set = 0
                shift = 3
            case NS:
                let nsval1: CInt = bytes.array[i += 1] << 24
                let nsval2: CInt = bytes.array[i += 1] << 18
                let nsval3: CInt = bytes.array[i += 1] << 12
                let nsval4: CInt = bytes.array[i += 1] << 6
                let nsval5: CInt = bytes.array[i += 1]
                let nsval = nsval1 + nsval2 + nsval3 + nsval4 + nsval5

                sb.appendFormat("%9d", nsval)
            case LOCK:
                shift = 1
            default:
                sb.appendFormat("%C", c)
            }

            if shift -= 1 == 0 {
                set = lastset
            }
        }

        while sb.length > 0 && sb.characterAtIndex(sb.length - 1) == PAD {
            sb.deleteCharacters(in: NSMakeRange(sb.length - 1, 1))
        }

        return sb
    }
}