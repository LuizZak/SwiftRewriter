import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXDataMatrixErrorCorrection.h"
// #import "ZXDataMatrixSymbolInfo.h"
var ZX_FACTOR_SETS: UnsafePointer<CInt>!
var ZX_FACTORS: (CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt)
let ZX_MODULO_VALUE: CInt = 0x12d
var ZX_LOG: (CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt)
var ZX_ALOG: (CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt)

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
 * Error Correction Code for ECC200.
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
 * Error Correction Code for ECC200.
 */
@objc
class ZXDataMatrixErrorCorrection: NSObject {
    @objc
    static func initialize() {
        if self.self != ZXDataMatrixErrorCorrection.self {
            return
        }

        //Create log and antilog table
        var p: CInt = 1
        var i: CInt = 0

        while i < 255 {
            defer {
                i += 1
            }

            ZX_ALOG[i] = p
            ZX_LOG[p] = i
            p *= 2

            if p >= 256 {
                p ^= ZX_MODULO_VALUE
            }
        }
    }
    /**
 * Creates the ECC200 error correction for an encoded message.
 *
 * @param codewords  the codewords
 * @param symbolInfo information about the symbol to be encoded
 * @return the codewords with interleaved error correction.
 */
    /**
 * Creates the ECC200 error correction for an encoded message.
 *
 * @param codewords  the codewords
 * @param symbolInfo information about the symbol to be encoded
 * @return the codewords with interleaved error correction.
 */
    @objc
    static func encodeECC200(_ codewords: String!, symbolInfo: ZXDataMatrixSymbolInfo!) -> String? {
        if codewords.length != symbolInfo.dataCapacity {
            NSException.raise(NSInvalidArgumentException, format: "The number of codewords does not match the selected symbol")
        }

        let capacity: UInt = UInt(symbolInfo.dataCapacity + symbolInfo.errorCodewords)
        let sb = NSMutableString(capacity: Int(capacity))

        sb.append(codewords)

        let blockCount: CInt = symbolInfo.interleavedBlockCount

        if blockCount == 1 {
            let ecc = self.createECCBlock(codewords, numECWords: symbolInfo.errorCodewords)

            if let ecc = ecc {
                sb.append(ecc)
            }
        } else {
            if sb.length > capacity {
                sb.deleteCharacters(in: NSMakeRange(capacity, sb.length - capacity))
            }

            while sb.length < capacity {
                sb.appendFormat("%C", 0 as? unichar)
            }

            var dataSizes: UnsafeMutablePointer<CInt>!
            var errorSizes: UnsafeMutablePointer<CInt>!
            var startPos: UnsafeMutablePointer<CInt>!
            var i: CInt = 0

            while i < blockCount {
                defer {
                    i += 1
                }

                dataSizes[i] = symbolInfo.dataLengthForInterleavedBlock(i + 1)
                errorSizes[i] = symbolInfo.errorLengthForInterleavedBlock(i + 1)
                startPos[i] = 0

                if i > 0 {
                    startPos[i] = startPos[i - 1] + dataSizes[i]
                }
            }

            var block: CInt = 0

            while block < blockCount {
                defer {
                    block += 1
                }

                let temp = NSMutableString(capacity: dataSizes[block])
                var d = block

                while d < symbolInfo.dataCapacity {
                    defer {
                        d += blockCount
                    }

                    temp.appendFormat("%C", codewords.characterAtIndex(d))
                }

                let ecc = self.createECCBlock(temp, numECWords: errorSizes[block])
                var pos: CInt = 0
                var e = block

                while e < errorSizes[block] * blockCount {
                    defer {
                        e += blockCount
                    }

                    sb.replaceCharacters(in: NSMakeRange(symbolInfo.dataCapacity + e, 1), with: ecc?.substringWithRange(NSMakeRange(pos += 1, 1)))
                }
            }
        }

        return String.stringWithString(sb)
    }
    @objc
    static func createECCBlock(_ codewords: String!, numECWords: CInt) -> String? {
        return self.createECCBlock(codewords, start: 0, len: CInt(codewords.length), numECWords: numECWords)
    }
    @objc
    static func createECCBlock(_ codewords: String!, start: CInt, len: CInt, numECWords: CInt) -> String? {
        var table: CInt = 1
        var i: CInt = 0

        while i < MemoryLayout.size(ofValue: ZX_FACTOR_SETS) / MemoryLayout<CInt>.size {
            defer {
                i += 1
            }

            if ZX_FACTOR_SETS[i] == numECWords {
                table = i

                break
            }
        }

        if table < 0 {
            NSException.raise(NSInvalidArgumentException, format: "Illegal number of error correction codewords specified: %d", numECWords)
        }

        let poly: UnsafeMutablePointer<CInt>! = ZX_FACTORS[table] as? UnsafeMutablePointer<CInt>
        var ecc: UnsafeMutablePointer<unichar>!

        memset(ecc, 0, Int(numECWords) * MemoryLayout.size(ofValue: unichar))

        var i = start

        while i < start + len {
            defer {
                i += 1
            }

            let m: CInt = ecc[numECWords - 1] ^ codewords.characterAtIndex(i)
            var k = numECWords - 1

            while k > 0 {
                defer {
                    k -= 1
                }

                if m != 0 && poly[k] != 0 {
                    ecc[k] = (ecc[k - 1] ^ ZX_ALOG[(ZX_LOG[m] + ZX_LOG[poly[k]]) % 255]) as? unichar
                } else {
                    ecc[k] = ecc[k - 1]
                }
            }

            if m != 0 && poly[0] != 0 {
                ecc[0] = ZX_ALOG[(ZX_LOG[m] + ZX_LOG[poly[0]]) % 255] as? unichar
            } else {
                ecc[0] = 0
            }
        }

        var eccReversed: UnsafeMutablePointer<unichar>!
        var i: CInt = 0

        while i < numECWords {
            defer {
                i += 1
            }

            eccReversed[i] = ecc[numECWords - i - 1]
        }

        return String.stringWithCharacters(eccReversed, length: numECWords)
    }
}