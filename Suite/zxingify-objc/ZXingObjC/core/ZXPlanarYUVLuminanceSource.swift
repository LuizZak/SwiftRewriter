// Preprocessor directives found in file:
// #import "ZXLuminanceSource.h"
// #import "ZXByteArray.h"
// #import "ZXPlanarYUVLuminanceSource.h"
let THUMBNAIL_SCALE_FACTOR: CInt = 2

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
 * This object extends LuminanceSource around an array of YUV data returned from the camera driver,
 * with the option to crop to a rectangle within the full data. This can be used to exclude
 * superfluous pixels around the perimeter and speed up decoding.
 *
 * It works for any pixel format where the Y channel is planar and appears first, including
 * YCbCr_420_SP and YCbCr_422_SP.
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
 * This object extends LuminanceSource around an array of YUV data returned from the camera driver,
 * with the option to crop to a rectangle within the full data. This can be used to exclude
 * superfluous pixels around the perimeter and speed up decoding.
 *
 * It works for any pixel format where the Y channel is planar and appears first, including
 * YCbCr_420_SP and YCbCr_422_SP.
 */
@objc
class ZXPlanarYUVLuminanceSource: ZXLuminanceSource {
    private var _yuvData: ZXByteArray!
    private var _dataWidth: CInt = 0
    private var _dataHeight: CInt = 0
    private var _left: CInt = 0
    private var _top: CInt = 0
    /**
 * @return width of image from renderThumbnail
 */
    @objc var thumbnailWidth: CInt {
        return self.width / THUMBNAIL_SCALE_FACTOR
    }
    /**
 * @return height of image from renderThumbnail
 */
    @objc var thumbnailHeight: CInt {
        return self.height / THUMBNAIL_SCALE_FACTOR
    }

    @objc
    init(yuvData: UnsafeMutablePointer<int8_t>!, yuvDataLen: CInt, dataWidth: CInt, dataHeight: CInt, left: CInt, top: CInt, width: CInt, height: CInt, reverseHorizontal: Bool) {
        if self = super.init(width: width, height: height) {
            if left + width > dataWidth || top + height > dataHeight {
                NSException.raise(NSInvalidArgumentException, format: "Crop rectangle does not fit within image data.")
            }

            _yuvData = ZXByteArray(length: CUnsignedInt(yuvDataLen))

            memcpy(_yuvData.array, yuvData, Int(yuvDataLen) * MemoryLayout.size(ofValue: int8_t))

            _dataWidth = dataWidth

            _dataHeight = dataHeight

            _left = left

            _top = top

            if reverseHorizontal {
                self.reverseHorizontal(width, height: height)
            }
        }

        return self
    }

    @objc
    func rowAtY(_ y: CInt, row: ZXByteArray!) -> ZXByteArray? {
        if y < 0 || y >= self.height {
            NSException.raise(NSInvalidArgumentException, format: "Requested row is outside the image: %d", y)
        }

        let width = self.width

        if !row || row.length < width {
            row = ZXByteArray(length: CUnsignedInt(width))
        }

        let offset = (y + self.top) * self.dataWidth + self.left

        memcpy(row.array, self.yuvData.array + offset, Int(self.width) * MemoryLayout.size(ofValue: int8_t))

        return row
    }
    @objc
    func matrix() -> ZXByteArray {
        let width = self.width
        let height = self.height

        // If the caller asks for the entire underlying image, save the copy and give them the
        // original data. The docs specifically warn that result.length must be ignored.
        if width == self.dataWidth && height == self.dataHeight {
            return self.yuvData
        }

        let area = self.width * self.height
        let matrix = ZXByteArray(length: CUnsignedInt(area))
        var inputOffset = self.top * self.dataWidth + self.left

        // If the width matches the full width of the underlying data, perform a single copy.
        if self.width == self.dataWidth {
            memcpy(matrix.array, self.yuvData.array + inputOffset, Int(area - inputOffset) * MemoryLayout.size(ofValue: int8_t))

            return matrix
        }

        // Otherwise copy one cropped row at a time.
        let yuvData = self.yuvData
        var y: CInt = 0

        while y < self.height {
            defer {
                y += 1
            }

            let outputOffset = y * self.width

            memcpy(matrix.array + outputOffset, yuvData?.array + inputOffset, Int(self.width) * MemoryLayout.size(ofValue: int8_t))
            inputOffset += self.dataWidth
        }

        return matrix
    }
    @objc
    func cropSupported() -> Bool {
        return true
    }
    @objc
    func crop(_ left: CInt, top: CInt, width: CInt, height: CInt) -> ZXLuminanceSource? {
        return type(of: self).alloc().init(yuvData: self.yuvData.array, yuvDataLen: self.yuvData.length ?? 0, dataWidth: self.dataWidth, dataHeight: self.dataHeight, left: self.left + left, top: self.top + top, width: width, height: height, reverseHorizontal: false)
    }
    @objc
    func renderThumbnail() -> UnsafeMutablePointer<CInt> {
        let thumbWidth = self.width / THUMBNAIL_SCALE_FACTOR
        let thumbHeight = self.height / THUMBNAIL_SCALE_FACTOR
        var pixels: UnsafeMutablePointer<CInt>! = malloc(Int(thumbWidth * thumbHeight) * MemoryLayout<CInt>.size) as? UnsafeMutablePointer<CInt>
        var inputOffset = self.top * self.dataWidth + self.left
        var y: CInt = 0

        while y < self.height {
            defer {
                y += 1
            }

            let outputOffset = y * self.width
            var x: CInt = 0

            while x < self.width {
                defer {
                    x += 1
                }

                let grey: CInt = self.yuvData.array[inputOffset + x * THUMBNAIL_SCALE_FACTOR] & 0xff

                pixels[outputOffset + x] = 0xff000000 | (grey * 0x10101)
            }

            inputOffset += self.dataWidth * THUMBNAIL_SCALE_FACTOR
        }

        return pixels
    }
    @objc
    func reverseHorizontal(_ width: CInt, height: CInt) {
        var y: CInt = 0, rowStart = self.top * self.dataWidth + self.left

        while y < height {
            defer {
                y += 1
                rowStart += self.dataWidth
            }

            let middle = rowStart + width / 2
            var x1 = rowStart, x2 = rowStart + width - 1

            while x1 < middle {
                defer {
                    x1 += 1
                    x2 -= 1
                }

                let temp: int8_t = self.yuvData.array[x1]

                self.yuvData.array[x1] = self.yuvData.array[x2]
                self.yuvData.array[x2] = temp
            }
        }
    }
}

// MARK: -
@objc
extension ZXPlanarYUVLuminanceSource {
    @objc var yuvData: ZXByteArray! {
        return self._yuvData
    }
    @objc var dataWidth: CInt {
        return self._dataWidth
    }
    @objc var dataHeight: CInt {
        return self._dataHeight
    }
    @objc var left: CInt {
        return self._left
    }
    @objc var top: CInt {
        return self._top
    }
}