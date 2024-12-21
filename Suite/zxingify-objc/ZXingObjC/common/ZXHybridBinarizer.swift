// Preprocessor directives found in file:
// #import "ZXGlobalHistogramBinarizer.h"
// #import "ZXByteArray.h"
// #import "ZXHybridBinarizer.h"
// #import "ZXIntArray.h"
// #import "ZXErrors.h"
let ZX_BLOCK_SIZE_POWER: CInt = 3
let ZX_BLOCK_SIZE: CInt = 1 << ZX_BLOCK_SIZE_POWER
let ZX_BLOCK_SIZE_MASK: CInt = ZX_BLOCK_SIZE - 1
let ZX_MINIMUM_DIMENSION: CInt = ZX_BLOCK_SIZE * 5
let ZX_MIN_DYNAMIC_RANGE: CInt = 24

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
 * This class implements a local thresholding algorithm, which while slower than the
 * ZXGlobalHistogramBinarizer, is fairly efficient for what it does. It is designed for
 * high frequency images of barcodes with black data on white backgrounds. For this application,
 * it does a much better job than a global blackpoint with severe shadows and gradients.
 * However it tends to produce artifacts on lower frequency images and is therefore not
 * a good general purpose binarizer for uses outside ZXing.
 *
 * This class extends ZXGlobalHistogramBinarizer, using the older histogram approach for 1D readers,
 * and the newer local approach for 2D readers. 1D decoding using a per-row histogram is already
 * inherently local, and only fails for horizontal gradients. We can revisit that problem later,
 * but for now it was not a win to use local blocks for 1D.
 *
 * This Binarizer is the default for the unit tests and the recommended class for library users.
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
 * This class implements a local thresholding algorithm, which while slower than the
 * ZXGlobalHistogramBinarizer, is fairly efficient for what it does. It is designed for
 * high frequency images of barcodes with black data on white backgrounds. For this application,
 * it does a much better job than a global blackpoint with severe shadows and gradients.
 * However it tends to produce artifacts on lower frequency images and is therefore not
 * a good general purpose binarizer for uses outside ZXing.
 *
 * This class extends ZXGlobalHistogramBinarizer, using the older histogram approach for 1D readers,
 * and the newer local approach for 2D readers. 1D decoding using a per-row histogram is already
 * inherently local, and only fails for horizontal gradients. We can revisit that problem later,
 * but for now it was not a win to use local blocks for 1D.
 *
 * This Binarizer is the default for the unit tests and the recommended class for library users.
 */
@objc
class ZXHybridBinarizer: ZXGlobalHistogramBinarizer {
    @objc var matrix: ZXBitMatrix!

    /**
 * Calculates the final BitMatrix once for all requests. This could be called once from the
 * constructor instead, but there are some advantages to doing it lazily, such as making
 * profiling easier, and not doing heavy lifting when callers don't expect it.
 */
    @objc
    override func blackMatrixWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if self.matrix != nil {
            return self.matrix
        }

        let source = self.luminanceSource
        let width = source?.width ?? 0
        let height = source?.height ?? 0

        if width <= 0 || height <= 0 {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Source is empty or misbehaving."]

            if error {
                *error = Error(domain: ZXErrorDomain, code: ZXNotFoundError, userInfo: userInfo)
            }

            return nil
        }

        if width >= ZX_MINIMUM_DIMENSION && height >= ZX_MINIMUM_DIMENSION {
            let luminances: ZXByteArray! = source?.matrix
            var subWidth = width >> ZX_BLOCK_SIZE_POWER

            if (width & ZX_BLOCK_SIZE_MASK) != 0 {
                subWidth += 1
            }

            var subHeight = height >> ZX_BLOCK_SIZE_POWER

            if (height & ZX_BLOCK_SIZE_MASK) != 0 {
                subHeight += 1
            }

            let blackPoints = self.calculateBlackPoints(luminances.array, subWidth: subWidth, subHeight: subHeight, width: width, height: height)
            let newMatrix = ZXBitMatrix(width: width, height: height)

            self.calculateThresholdForBlock(luminances.array, subWidth: subWidth, subHeight: subHeight, width: width, height: height, blackPoints: blackPoints, matrix: newMatrix)
            self.matrix = newMatrix

            var i: CInt = 0

            while i < subHeight {
                defer {
                    i += 1
                }

                free(blackPoints[i])
            }

            free(blackPoints)
        } else {
            // If the image is too small, fall back to the global histogram approach.
            self.matrix = super.blackMatrixWithError(error)
        }

        return self.matrix
    }
    @objc
    func createBinarizer(_ source: ZXLuminanceSource!) -> ZXBinarizer? {
        return ZXHybridBinarizer(source: source)
    }
    /**
 * For each block in the image, calculate the average black point using a 5x5 grid
 * of the blocks around it. Also handles the corner cases (fractional blocks are computed based
 * on the last pixels in the row/column which are also used in the previous block).
 */
    @objc
    func calculateThresholdForBlock(_ luminances: UnsafeMutablePointer<int8_t>!, subWidth: CInt, subHeight: CInt, width: CInt, height: CInt, blackPoints: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>!, matrix: ZXBitMatrix!) {
        let maxYOffset = height - ZX_BLOCK_SIZE
        let maxXOffset = width - ZX_BLOCK_SIZE
        var y: CInt = 0

        while y < subHeight {
            defer {
                y += 1
            }

            var yoffset = y << ZX_BLOCK_SIZE_POWER

            if yoffset > maxYOffset {
                yoffset = maxYOffset
            }

            let top = self.cap(y, min: 2, max: subHeight - 3)
            var x: CInt = 0

            while x < subWidth {
                defer {
                    x += 1
                }

                var xoffset = x << ZX_BLOCK_SIZE_POWER

                if xoffset > maxXOffset {
                    xoffset = maxXOffset
                }

                let left = self.cap(x, min: 2, max: subWidth - 3)
                var sum: CInt = 0
                var z: CInt = 2

                while z <= 2 {
                    defer {
                        z += 1
                    }

                    let blackRow: UnsafeMutablePointer<CInt>! = blackPoints[top + z]

                    sum += blackRow[left - 2] + blackRow[left - 1] + blackRow[left] + blackRow[left + 1] + blackRow[left + 2]
                }

                let average = sum / 25

                self.thresholdBlock(luminances, xoffset: xoffset, yoffset: yoffset, threshold: average, stride: width, matrix: matrix)
            }
        }
    }
    @objc
    func cap(_ value: CInt, min: CInt, max: CInt) -> CInt {
        return (value < min) ? min : (value > max) ? max : value
    }
    /**
 * Applies a single threshold to a block of pixels.
 */
    @objc
    func thresholdBlock(_ luminances: UnsafeMutablePointer<int8_t>!, xoffset: CInt, yoffset: CInt, threshold: CInt, stride: CInt, matrix: ZXBitMatrix!) {
        var y: CInt = 0, offset = yoffset * stride + xoffset

        while y < ZX_BLOCK_SIZE {
            defer {
                y += 1
                offset += stride
            }

            var x: CInt = 0

            while x < ZX_BLOCK_SIZE {
                defer {
                    x += 1
                }

                // Comparison needs to be <= so that black == 0 pixels are black even if the threshold is 0
                if (luminances[offset + x] & 0xff) <= threshold {
                    matrix.setX(xoffset + x, y: yoffset + y)
                }
            }
        }
    }
    /**
 * Calculates a single black point for each block of pixels and saves it away.
 * See the following thread for a discussion of this algorithm:
 *  http://groups.google.com/group/zxing/browse_thread/thread/d06efa2c35a7ddc0
 */
    @objc
    func calculateBlackPoints(_ luminances: UnsafeMutablePointer<int8_t>!, subWidth: CInt, subHeight: CInt, width: CInt, height: CInt) -> UnsafeMutablePointer<UnsafeMutablePointer<CInt>?> {
        var blackPoints: UnsafeMutablePointer<UnsafeMutablePointer<CInt>?>! = malloc(Int(subHeight) * MemoryLayout<CInt>.size) as? UnsafeMutablePointer<UnsafeMutablePointer<CInt>>
        let maxYOffset = height - ZX_BLOCK_SIZE
        let maxXOffset = width - ZX_BLOCK_SIZE
        var y: CInt = 0

        while y < subHeight {
            defer {
                y += 1
            }

            blackPoints[y] = malloc(Int(subWidth) * MemoryLayout<CInt>.size) as? UnsafeMutablePointer<CInt>

            var yoffset = y << ZX_BLOCK_SIZE_POWER

            if yoffset > maxYOffset {
                yoffset = maxYOffset
            }

            var x: CInt = 0

            while x < subWidth {
                defer {
                    x += 1
                }

                var xoffset = x << ZX_BLOCK_SIZE_POWER

                if xoffset > maxXOffset {
                    xoffset = maxXOffset
                }

                var sum: CInt = 0
                var min: CInt = 0xff
                var max: CInt = 0
                var yy: CInt = 0, offset = yoffset * width + xoffset

                while yy < ZX_BLOCK_SIZE {
                    defer {
                        yy += 1
                        offset += width
                    }

                    var xx: CInt = 0

                    while xx < ZX_BLOCK_SIZE {
                        defer {
                            xx += 1
                        }

                        let pixel: CInt = luminances[offset + xx] & 0xff

                        sum += pixel

                        // still looking for good contrast
                        if pixel < min {
                            min = pixel
                        }

                        if pixel > max {
                            max = pixel
                        }
                    }

                    // short-circuit min/max tests once dynamic range is met
                    if max - min > ZX_MIN_DYNAMIC_RANGE {
                        yy += 1
                        offset += width

                        while yy < ZX_BLOCK_SIZE {
                            defer {
                                yy += 1
                                offset += width
                            }

                            var xx: CInt = 0

                            while xx < ZX_BLOCK_SIZE {
                                defer {
                                    xx += 1
                                }

                                sum += luminances[offset + xx] & 0xff
                            }
                        }
                    }
                }

                // The default estimate is the average of the values in the block.
                var average = sum >> (ZX_BLOCK_SIZE_POWER * 2)

                if max - min <= ZX_MIN_DYNAMIC_RANGE {
                    // If variation within the block is low, assume this is a block with only light or only
                    // dark pixels. In that case we do not want to use the average, as it would divide this
                    // low contrast area into black and white pixels, essentially creating data out of noise.
                    //
                    // The default assumption is that the block is light/background. Since no estimate for
                    // the level of dark pixels exists locally, use half the min for the block.
                    average = min / 2

                    if y > 0 && x > 0 {
                        // Correct the "white background" assumption for blocks that have neighbors by comparing
                        // the pixels in this block to the previously calculated black points. This is based on
                        // the fact that dark barcode symbology is always surrounded by some amount of light
                        // background for which reasonable black point estimates were made. The bp estimated at
                        // the boundaries is used for the interior.
                        // The (min < bp) is arbitrary but works better than other heuristics that were tried.
                        let averageNeighborBlackPoint: CInt = (blackPoints[y - 1][x] + (2 * blackPoints[y][x - 1]) + blackPoints[y - 1][x - 1]) / 4

                        if min < averageNeighborBlackPoint {
                            average = averageNeighborBlackPoint
                        }
                    }
                }

                blackPoints[y][x] = average
            }
        }

        return blackPoints
    }
}