import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXPDF417CodewordDecoder.h"
// #import "ZXPDF417Common.h"
var ZX_PDF417_RATIOS_TABLE: UnsafeMutablePointer<CFloat>!

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
@objc
class ZXPDF417CodewordDecoder: NSObject {
    @objc
    static func initialize() {
        if self.self != ZXPDF417CodewordDecoder.self {
            return
        }

        var i: CInt = 0

        while i < ZX_PDF417_SYMBOL_TABLE_LEN {
            defer {
                i += 1
            }

            var currentSymbol: CInt = ZX_PDF417_SYMBOL_TABLE[i]
            var currentBit = currentSymbol & 0x1
            var j: CInt = 0

            while j < ZX_PDF417_BARS_IN_MODULE {
                defer {
                    j += 1
                }

                var size: CFloat = 0.0

                while (currentSymbol & 0x1) == currentBit {
                    size += 1.0
                    currentSymbol >>= 1
                }

                currentBit = currentSymbol & 0x1
                ZX_PDF417_RATIOS_TABLE[i][ZX_PDF417_BARS_IN_MODULE - j - 1] = size / ZX_PDF417_MODULES_IN_CODEWORD
            }
        }
    }
    @objc
    static func decodedValue(_ moduleBitCount: NSArray!) -> CInt {
        let decodedValue = self.decodedCodewordValue(self.sampleBitCounts(moduleBitCount))

        if decodedValue != 1 {
            return decodedValue
        }

        return self.closestDecodedValue(moduleBitCount)
    }
    @objc
    static func sampleBitCounts(_ moduleBitCount: NSArray!) -> NSArray {
        let bitCountSum: CFloat = CFloat(ZXPDF417Common.bitCountSum(moduleBitCount))
        let result: NSMutableArray! = NSMutableArray.arrayWithCapacity(ZX_PDF417_BARS_IN_MODULE)
        var i: CInt = 0

        while i < ZX_PDF417_BARS_IN_MODULE {
            defer {
                i += 1
            }

            result.add(0)
        }

        var bitCountIndex: CInt = 0
        var sumPreviousBits: CInt = 0
        var i: CInt = 0

        while i < ZX_PDF417_MODULES_IN_CODEWORD {
            defer {
                i += 1
            }

            let sampleIndex: CFloat = bitCountSum / CFloat(2 * ZX_PDF417_MODULES_IN_CODEWORD) + (CFloat(i) * bitCountSum) / ZX_PDF417_MODULES_IN_CODEWORD

            if sumPreviousBits + moduleBitCount[Int(bitCountIndex)].intValue() <= sampleIndex {
                sumPreviousBits += moduleBitCount[Int(bitCountIndex)].intValue()
                bitCountIndex += 1
            }

            result[Int(bitCountIndex)] = result[Int(bitCountIndex)].intValue() + 1
        }

        return result
    }
    @objc
    static func decodedCodewordValue(_ moduleBitCount: NSArray!) -> CInt {
        let decodedValue = self.bitValue(moduleBitCount)

        return (ZXPDF417Common.codeword(decodedValue) == 1) ? 1 : decodedValue
    }
    @objc
    static func bitValue(_ moduleBitCount: NSArray!) -> CInt {
        var result: CLong = 0
        var i: CInt = 0

        while i < moduleBitCount.count {
            defer {
                i += 1
            }

            var bit: CInt = 0

            while bit < moduleBitCount[Int(i)].intValue() {
                defer {
                    bit += 1
                }

                result = (result << 1) | ((i % 2 == 0) ? 1 : 0)
            }
        }

        return CInt(result)
    }
    @objc
    static func closestDecodedValue(_ moduleBitCount: NSArray!) -> CInt {
        let bitCountSum = ZXPDF417Common.bitCountSum(moduleBitCount)
        var bitCountRatios: UnsafeMutablePointer<CFloat>!

        if bitCountSum > 1 {
            var i: CInt = 0

            while i < ZX_PDF417_BARS_IN_MODULE {
                defer {
                    i += 1
                }

                bitCountRatios[i] = moduleBitCount[Int(i)].intValue() / CFloat(bitCountSum)
            }
        }

        var bestMatchError: CFloat = MAXFLOAT
        var bestMatch: CInt = 1
        var j: CInt = 0

        while j < ZX_PDF417_SYMBOL_TABLE_LEN {
            defer {
                j += 1
            }

            var error: CFloat = 0.0
            let ratioTableRow: UnsafeMutablePointer<CFloat>! = ZX_PDF417_RATIOS_TABLE[j]
            var k: CInt = 0

            while k < ZX_PDF417_BARS_IN_MODULE {
                defer {
                    k += 1
                }

                let diff: CFloat = ratioTableRow[k] - bitCountRatios[k]

                error += diff * diff

                if error >= bestMatchError {
                    break
                }
            }

            if error < bestMatchError {
                bestMatchError = error
                bestMatch = ZX_PDF417_SYMBOL_TABLE[j]
            }
        }

        return bestMatch
    }
}