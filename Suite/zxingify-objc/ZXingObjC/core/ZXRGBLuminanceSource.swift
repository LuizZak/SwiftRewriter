// Preprocessor directives found in file:
// #import "ZXLuminanceSource.h"
// #import "ZXByteArray.h"
// #import "ZXRGBLuminanceSource.h"
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
 * This class is used to help decode images from files which arrive as RGB data from
 * an ARGB pixel array. It does not support rotation.
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
 * This class is used to help decode images from files which arrive as RGB data from
 * an ARGB pixel array. It does not support rotation.
 */
@objc
class ZXRGBLuminanceSource: ZXLuminanceSource {
    private var _luminances: ZXByteArray!
    private var _dataWidth: CInt = 0
    private var _dataHeight: CInt = 0
    private var _left: CInt = 0
    private var _top: CInt = 0

    @objc
    init(width: CInt, height: CInt, pixels: UnsafeMutablePointer<CInt>!, pixelsLen: CInt) {
        if self = super.init(width: width, height: height) {
            _dataWidth = width

            _dataHeight = height

            _left = 0

            _top = 0

            // In order to measure pure decoding speed, we convert the entire image to a greyscale array
            // up front, which is the same as the Y channel of the YUVLuminanceSource in the real app.
            let size = width * height

            _luminances = ZXByteArray(length: CUnsignedInt(size))

            var offset: CInt = 0

            while offset < size {
                defer {
                    offset += 1
                }

                let pixel: CInt = pixels[offset]
                let r = (pixel >> 16) & 0xff // red
                let g2 = (pixel >> 7) & 0x1fe // 2 * green
                let b = pixel & 0xff // blue

                // Calculate green-favouring average cheaply
                _luminances.array[offset] = ((r + g2 + b) / 4) as? int8_t
            }
        }

        return self
    }
    @objc
    init(pixels: UnsafeMutablePointer<int8_t>!, width: CInt, height: CInt) {
        if self = super.init(width: width, height: height) {
            _dataWidth = width

            _dataHeight = height

            _left = 0

            _top = 0

            _luminances = ZXByteArray(array: pixels, length: CUnsignedInt(width * height))
        }

        return self
    }
    @objc
    init(pixels: ZXByteArray!, dataWidth: CInt, dataHeight: CInt, left: CInt, top: CInt, width: CInt, height: CInt) {
        if self = super.init(width: width, height: height) {
            if left + self.width > dataWidth || top + self.height > dataHeight {
                NSException.raise(NSInvalidArgumentException, format: "Crop rectangle does not fit within image data.")
            }

            _luminances = pixels

            _dataWidth = dataWidth

            _dataHeight = dataHeight

            _left = left

            _top = top
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

        memcpy(row.array, self.luminances.array + offset, Int(self.width) * MemoryLayout.size(ofValue: int8_t))

        return row
    }
    @objc
    func matrix() -> ZXByteArray {
        let width = self.width
        let height = self.height

        // If the caller asks for the entire underlying image, save the copy and give them the
        // original data. The docs specifically warn that result.length must be ignored.
        if width == self.dataWidth && height == self.dataHeight {
            return self.luminances
        }

        let area = self.width * self.height
        let matrix = ZXByteArray(length: CUnsignedInt(area))
        var inputOffset = self.top * self.dataWidth + self.left

        // If the width matches the full width of the underlying data, perform a single copy.
        if self.width == self.dataWidth {
            memcpy(matrix.array, self.luminances.array + inputOffset, Int(area) * MemoryLayout.size(ofValue: int8_t))

            return matrix
        }

        var y: CInt = 0

        while y < self.height {
            defer {
                y += 1
            }

            let outputOffset = y * self.width

            memcpy(matrix.array + outputOffset, self.luminances.array + inputOffset, Int(self.width) * MemoryLayout.size(ofValue: int8_t))
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
        return type(of: self).alloc().init(pixels: self.luminances, dataWidth: self.dataWidth, dataHeight: self.dataHeight, left: self.left + left, top: self.top + top, width: width, height: height)
    }
}

// MARK: -
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
extension ZXRGBLuminanceSource {
    @objc var luminances: ZXByteArray! {
        return self._luminances
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