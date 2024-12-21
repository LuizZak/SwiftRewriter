// Preprocessor directives found in file:
// #import "ZXByteArray.h"
// #import "ZXQRCodeDataBlock.h"
// #import "ZXQRCodeErrorCorrectionLevel.h"
// #import "ZXQRCodeVersion.h"
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
 * Encapsulates a block of data within a QR Code. QR Codes may split their data into
 * multiple blocks, each of which is a unit of data and error-correction codewords. Each
 * is represented by an instance of this class.
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
class ZXQRCodeDataBlock: NSObject {
    private var _codewords: ZXByteArray!
    private var _numDataCodewords: CInt = 0
    @objc var codewords: ZXByteArray! {
        return self._codewords
    }
    @objc var numDataCodewords: CInt {
        return self._numDataCodewords
    }

    @objc
    init(numDataCodewords: CInt, codewords: ZXByteArray!) {
        if self = super.init() {
            _numDataCodewords = numDataCodewords
            _codewords = codewords
        }

        return self
    }

    /**
 * When QR Codes use multiple data blocks, they are actually interleaved.
 * That is, the first byte of data block 1 to n is written, then the second bytes, and so on. This
 * method will separate the data into original blocks.
 *
 * @param rawCodewords bytes as read directly from the QR Code
 * @param version version of the QR Code
 * @param ecLevel error-correction level of the QR Code
 * @return DataBlocks containing original bytes, "de-interleaved" from representation in the
 *         QR Code
 */
    @objc
    static func dataBlocks(_ rawCodewords: ZXByteArray!, version: ZXQRCodeVersion!, ecLevel: ZXQRCodeErrorCorrectionLevel!) -> NSArray {
        if rawCodewords.length != version.totalCodewords {
            NSException.raise(NSInvalidArgumentException, format: "Invalid codewords count")
        }

        // Figure out the number and size of data blocks used by this version and
        // error correction level
        let ecBlocks = version.ecBlocksForLevel(ecLevel)
        // First count the total number of data blocks
        var totalBlocks: CInt = 0
        let ecBlockArray = ecBlocks?.ecBlocks

        for ecBlock in ecBlockArray {
            totalBlocks += ecBlock.count
        }

        // Now establish DataBlocks of the appropriate size and number of data codewords
        let result: NSMutableArray! = NSMutableArray.arrayWithCapacity(totalBlocks)

        for ecBlock in ecBlockArray {
            var i: CInt = 0

            while i < ecBlock.count {
                defer {
                    i += 1
                }

                let numDataCodewords: CInt = ecBlock.dataCodewords
                let numBlockCodewords = (ecBlocks?.ecCodewordsPerBlock ?? 0) + numDataCodewords

                result.add(ZXQRCodeDataBlock(numDataCodewords: numDataCodewords, codewords: ZXByteArray(length: CUnsignedInt(numBlockCodewords))))
            }
        }

        // All blocks have the same amount of data, except that the last n
        // (where n may be 0) have 1 more byte. Figure out where these start.
        let shorterBlocksTotalCodewords: CInt = CInt(CInt((result[0] as? ZXQRCodeDataBlock)?.codewords.length ?? 0))
        var longerBlocksStartAt: CInt = CInt(result.count) - 1

        while longerBlocksStartAt >= 0 {
            let numCodewords: CInt = (result[Int(longerBlocksStartAt)] as? ZXQRCodeDataBlock)?.codewords.length

            if numCodewords == shorterBlocksTotalCodewords {
                break
            }

            longerBlocksStartAt -= 1
        }

        longerBlocksStartAt += 1

        let shorterBlocksNumDataCodewords = (shorterBlocksTotalCodewords - (ecBlocks?.ecCodewordsPerBlock ?? 0)) ?? 0
        // The last elements of result may be 1 element longer;
        // first fill out as many elements as all of them have
        var rawCodewordsOffset: CInt = 0
        let numResultBlocks: CInt = CInt(result.count)
        var i: CInt = 0

        while i < shorterBlocksNumDataCodewords {
            defer {
                i += 1
            }

            var j: CInt = 0

            while j < numResultBlocks {
                defer {
                    j += 1
                }

                (result[Int(j)] as? ZXQRCodeDataBlock)?.codewords.array[i] = rawCodewords.array[rawCodewordsOffset += 1]
            }
        }

        var j = longerBlocksStartAt

        while j < numResultBlocks {
            defer {
                j += 1
            }

            (result[Int(j)] as? ZXQRCodeDataBlock)?.codewords.array[shorterBlocksNumDataCodewords] = rawCodewords.array[rawCodewordsOffset += 1]
        }

        // Now add in error correction blocks
        let max: CInt = CInt((result[0] as? ZXQRCodeDataBlock)?.codewords.length ?? 0)
        var i = shorterBlocksNumDataCodewords

        while i < max {
            defer {
                i += 1
            }

            var j: CInt = 0

            while j < numResultBlocks {
                defer {
                    j += 1
                }

                let iOffset = (j < longerBlocksStartAt) ? i : i + 1

                (result[Int(j)] as? ZXQRCodeDataBlock)?.codewords.array[iOffset] = rawCodewords.array[rawCodewordsOffset += 1]
            }
        }

        return result
    }
}