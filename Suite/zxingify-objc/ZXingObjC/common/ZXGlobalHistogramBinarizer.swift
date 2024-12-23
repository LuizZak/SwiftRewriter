// Preprocessor directives found in file:
// #import "ZXBinarizer.h"
// #import "ZXGlobalHistogramBinarizer.h"
// #import "ZXBitArray.h"
// #import "ZXBitMatrix.h"
// #import "ZXByteArray.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXLuminanceSource.h"
let ZX_LUMINANCE_BITS: CInt = 5
let ZX_LUMINANCE_SHIFT: CInt = 8 - ZX_LUMINANCE_BITS
let ZX_LUMINANCE_BUCKETS: CInt = 1 << ZX_LUMINANCE_BITS

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
 * This Binarizer implementation uses the old ZXing global histogram approach. It is suitable
 * for low-end mobile devices which don't have enough CPU or memory to use a local thresholding
 * algorithm. However, because it picks a global black point, it cannot handle difficult shadows
 * and gradients.
 *
 * Faster mobile devices and all desktop applications should probably use ZXHybridBinarizer instead.
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
 * This Binarizer implementation uses the old ZXing global histogram approach. It is suitable
 * for low-end mobile devices which don't have enough CPU or memory to use a local thresholding
 * algorithm. However, because it picks a global black point, it cannot handle difficult shadows
 * and gradients.
 *
 * Faster mobile devices and all desktop applications should probably use ZXHybridBinarizer instead.
 */
@objc
class ZXGlobalHistogramBinarizer: ZXBinarizer {
    private var _luminances: ZXByteArray!
    private var _buckets: ZXIntArray!

    @objc
    override init(source: ZXLuminanceSource!) {
        if self = super.init(source: source) {
            _luminances = ZXByteArray(length: 0)
            _buckets = ZXIntArray(length: CUnsignedInt(ZX_LUMINANCE_BUCKETS))
        }

        return self
    }

    // Applies simple sharpening to the row data to improve performance of the 1D Readers.
    // Applies simple sharpening to the row data to improve performance of the 1D Readers.
    @objc
    func blackRow(_ y: CInt, row: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> ZXBitArray? {
        let source = self.luminanceSource
        let width = source?.width ?? 0

        if row == nil || row.size < width {
            row = ZXBitArray(size: width)
        } else {
            row.clear()
        }

        self.initArrays(width)

        let localLuminances = source?.rowAtY(y, row: self.luminances)
        let localBuckets = self.buckets
        var x: CInt = 0

        while x < width {
            defer {
                x += 1
            }

            localBuckets?.array[(localLuminances?.array[x] & 0xff) >> ZX_LUMINANCE_SHIFT] += 1
        }

        let blackPoint = self.estimateBlackPoint(localBuckets)

        if blackPoint == 1 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        if width < 3 {
            var x: CInt = 0

            while x < width {
                defer {
                    x += 1
                }

                if (localLuminances.array[x] & 0xff) < blackPoint {
                    row.set(x)
                }
            }
        } else {
            var left: CInt = localLuminances.array[0] & 0xff
            var center: CInt = localLuminances.array[1] & 0xff
            var x: CInt = 1

            while x < width - 1 {
                defer {
                    x += 1
                }

                let right: CInt = localLuminances.array[x + 1] & 0xff

                // A simple -1 4 -1 box filter with a weight of 2.
                if ((center * 4) - left - right) / 2 < blackPoint {
                    row.set(x)
                }

                left = center
                center = right
            }
        }

        return row
    }
    @objc
    func blackMatrixWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        let source = self.luminanceSource
        let width = source?.width ?? 0
        let height = source?.height ?? 0
        let matrix = ZXBitMatrix(width: width, height: height)

        // Quickly calculates the histogram by sampling four rows from the image. This proved to be
        // more robust on the blackbox tests than sampling a diagonal as we used to do.
        self.initArrays(width)

        // We delay reading the entire image luminance until the black point estimation succeeds.
        // Although we end up reading four rows twice, it is consistent with our motto of
        // "fail quickly" which is necessary for continuous scanning.
        let localBuckets = self.buckets
        var y: CInt = 1

        while y < 5 {
            defer {
                y += 1
            }

            let row = height * y / 5
            let localLuminances = source?.rowAtY(row, row: self.luminances)
            let right = (width * 4) / 5
            var x = width / 5

            while x < right {
                defer {
                    x += 1
                }

                let pixel: CInt = localLuminances.array[x] & 0xff

                localBuckets?.array[pixel >> ZX_LUMINANCE_SHIFT] += 1
            }
        }

        let blackPoint = self.estimateBlackPoint(localBuckets)

        if blackPoint == 1 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let localLuminances: ZXByteArray! = source?.matrix
        var y: CInt = 0

        while y < height {
            defer {
                y += 1
            }

            let offset = y * width
            var x: CInt = 0

            while x < width {
                defer {
                    x += 1
                }

                let pixel: CInt = localLuminances.array[offset + x] & 0xff

                if pixel < blackPoint {
                    matrix.setX(x, y: y)
                }
            }
        }

        return matrix
    }
    // Does not sharpen the data, as this call is intended to only be used by 2D Readers.
    // Does not sharpen the data, as this call is intended to only be used by 2D Readers.
    @objc
    func createBinarizer(_ source: ZXLuminanceSource!) -> ZXBinarizer? {
        return ZXGlobalHistogramBinarizer(source: source)
    }
    @objc
    func initArrays(_ luminanceSize: CInt) {
        if (self.luminances.length ?? 0) < luminanceSize {
            self.luminances = ZXByteArray(length: CUnsignedInt(luminanceSize))
        }

        var x: CInt = 0

        while x < ZX_LUMINANCE_BUCKETS {
            defer {
                x += 1
            }

            self.buckets.array[x] = 0
        }
    }
    @objc
    func estimateBlackPoint(_ buckets: ZXIntArray!) -> CInt {
        // Find the tallest peak in the histogram.
        let numBuckets: CInt = CInt(buckets.length)
        var maxBucketCount: CInt = 0
        var firstPeak: CInt = 0
        var firstPeakSize: CInt = 0
        var x: CInt = 0

        while x < numBuckets {
            defer {
                x += 1
            }

            if buckets.array[x] > firstPeakSize {
                firstPeak = x
                firstPeakSize = buckets.array[x]
            }

            if buckets.array[x] > maxBucketCount {
                maxBucketCount = buckets.array[x]
            }
        }

        // Find the second-tallest peak which is somewhat far from the tallest peak.
        var secondPeak: CInt = 0
        var secondPeakScore: CInt = 0
        var x: CInt = 0

        while x < numBuckets {
            defer {
                x += 1
            }

            let distanceToBiggest = x - firstPeak
            // Encourage more distant second peaks by multiplying by square of distance.
            let score: CInt = buckets.array[x] * distanceToBiggest * distanceToBiggest

            if score > secondPeakScore {
                secondPeak = x
                secondPeakScore = score
            }
        }

        // Make sure firstPeak corresponds to the black peak.
        if firstPeak > secondPeak {
            let temp = firstPeak

            firstPeak = secondPeak
            secondPeak = temp
        }

        // If there is too little contrast in the image to pick a meaningful black point, throw rather
        // than waste time trying to decode the image, and risk false positives.
        if secondPeak - firstPeak <= numBuckets / 16 {
            return 1
        }

        // Find a valley between them that is low and closer to the white peak.
        var bestValley = secondPeak - 1
        var bestValleyScore: CInt = 1
        var x = secondPeak - 1

        while x > firstPeak {
            defer {
                x -= 1
            }

            let fromFirst = x - firstPeak
            let score: CInt = fromFirst * fromFirst * (secondPeak - x) * (maxBucketCount - buckets.array[x])

            if score > bestValleyScore {
                bestValley = x
                bestValleyScore = score
            }
        }

        return bestValley << ZX_LUMINANCE_SHIFT
    }
}

// MARK: -
@objc
extension ZXGlobalHistogramBinarizer {
    @objc var luminances: ZXByteArray! {
        get {
            return self._luminances
        }
        set {
            self._luminances = newValue
        }
    }
    @objc var buckets: ZXIntArray! {
        get {
            return self._buckets
        }
        set {
            self._buckets = newValue
        }
    }
}