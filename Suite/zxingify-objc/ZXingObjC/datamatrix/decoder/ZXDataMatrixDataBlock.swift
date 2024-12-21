// Preprocessor directives found in file:
// #import "ZXByteArray.h"
// #import "ZXDataMatrixDataBlock.h"
// #import "ZXDataMatrixVersion.h"
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
 * Encapsulates a block of data within a Data Matrix Code. Data Matrix Codes may split their data into
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
class ZXDataMatrixDataBlock: NSObject {
    private var _numDataCodewords: CInt = 0
    private var _codewords: ZXByteArray!
    @objc var numDataCodewords: CInt {
        return self._numDataCodewords
    }
    @objc var codewords: ZXByteArray! {
        return self._codewords
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
 * When Data Matrix Codes use multiple data blocks, they actually interleave the bytes of each of them.
 * That is, the first byte of data block 1 to n is written, then the second bytes, and so on. This
 * method will separate the data into original blocks.
 *
 * @param rawCodewords bytes as read directly from the Data Matrix Code
 * @param version version of the Data Matrix Code
 * @return DataBlocks containing original bytes, "de-interleaved" from representation in the
 *         Data Matrix Code
 */
    @objc
    static func dataBlocks(_ rawCodewords: ZXByteArray!, version: ZXDataMatrixVersion!) -> NSArray {
        // Figure out the number and size of data blocks used by this version
        let ecBlocks = version.ecBlocks
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
                let numBlockCodewords = (ecBlocks?.ecCodewords ?? 0) + numDataCodewords

                result.add(ZXDataMatrixDataBlock(numDataCodewords: numDataCodewords, codewords: ZXByteArray(length: CUnsignedInt(numBlockCodewords))))
            }
        }

        // All blocks have the same amount of data, except that the last n
        // (where n may be 0) have 1 less byte. Figure out where these start.
        // TODO(bbrown): There is only one case where there is a difference for Data Matrix for size 144
        let longerBlocksTotalCodewords: CInt = CInt(CInt((result[0] as? ZXDataMatrixDataBlock)?.codewords.length ?? 0))
        //int shorterBlocksTotalCodewords = longerBlocksTotalCodewords - 1;
        let longerBlocksNumDataCodewords = (longerBlocksTotalCodewords - (ecBlocks?.ecCodewords ?? 0)) ?? 0
        let shorterBlocksNumDataCodewords = longerBlocksNumDataCodewords - 1
        // The last elements of result may be 1 element shorter for 144 matrix
        // first fill out as many elements as all of them have minus 1
        var rawCodewordsOffset: CInt = 0
        var i: CInt = 0

        while i < shorterBlocksNumDataCodewords {
            defer {
                i += 1
            }

            for block in result {
                block.codewords.array[i] = rawCodewords.array[rawCodewordsOffset += 1]
            }
        }

        // Fill out the last data block in the longer ones
        let specialVersion = version.versionNumber == 24
        let numLongerBlocks: CInt = specialVersion ? 8 : CInt(result.count)
        var j: CInt = 0

        while j < numLongerBlocks {
            defer {
                j += 1
            }

            (result[Int(j)] as? ZXDataMatrixDataBlock)?.codewords.array[longerBlocksNumDataCodewords - 1] = rawCodewords.array[rawCodewordsOffset += 1]
        }

        let max: UInt = UInt(UInt((result[0] as? ZXDataMatrixDataBlock)?.codewords.length ?? 0))
        var i = longerBlocksNumDataCodewords

        while i < max {
            defer {
                i += 1
            }

            var j: CInt = 0

            while j < result.count {
                defer {
                    j += 1
                }

                let jOffset: CInt = specialVersion ? Int(j + 8) % result.count : j
                let iOffset = (specialVersion && jOffset > 7) ? i - 1 : i

                (result[Int(jOffset)] as? ZXDataMatrixDataBlock)?.codewords.array[iOffset] = rawCodewords.array[rawCodewordsOffset += 1]
            }
        }

        if rawCodewordsOffset != rawCodewords.length {
            NSException.raise(NSInvalidArgumentException, format: "Codewords size mismatch")
        }

        return result
    }
}