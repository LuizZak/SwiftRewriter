import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXBinarizer.h"
// #import "ZXBinaryBitmap.h"
// #import "ZXBitArray.h"
// #import "ZXBitMatrix.h"
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
 * This class is the core bitmap class used by ZXing to represent 1 bit data. Reader objects
 * accept a BinaryBitmap and attempt to decode it.
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
 * This class is the core bitmap class used by ZXing to represent 1 bit data. Reader objects
 * accept a BinaryBitmap and attempt to decode it.
 */
@objc
class ZXBinaryBitmap: NSObject {
    private var _binarizer: ZXBinarizer!
    /**
 * @return The width of the bitmap.
 */
    @objc var width: CInt {
        return self.binarizer.width ?? 0
    }
    /**
 * @return The height of the bitmap.
 */
    @objc var height: CInt {
        return self.binarizer.height ?? 0
    }
    /**
 * @return Whether this bitmap can be cropped.
 */
    @objc var cropSupported: Bool {
        return self.binarizer.luminanceSource.cropSupported == true
    }
    /**
 * @return Whether this bitmap supports counter-clockwise rotation.
 */
    @objc var rotateSupported: Bool {
        return self.binarizer.luminanceSource.rotateSupported == true
    }
    @objc var matrix: ZXBitMatrix!

    @objc
    init(binarizer: ZXBinarizer!) {
        if self = super.init() {
            if binarizer == nil {
                NSException.raise(NSInvalidArgumentException, format: "Binarizer must be non-null.")
            }

            _binarizer = binarizer
        }

        return self
    }

    @objc
    static func binaryBitmapWithBinarizer(_ binarizer: ZXBinarizer!) -> AnyObject? {
        return self.init(binarizer: binarizer)
    }
    /**
 * Converts one row of luminance data to 1 bit data. May actually do the conversion, or return
 * cached data. Callers should assume this method is expensive and call it as seldom as possible.
 * This method is intended for decoding 1D barcodes and may choose to apply sharpening.
 *
 * @param y The row to fetch, which must be in [0, bitmap height)
 * @param row An optional preallocated array. If null or too small, it will be ignored.
 *            If used, the Binarizer will call BitArray.clear(). Always use the returned object.
 * @return The array of bits for this row (true means black) or nil if row can't be binarized.
 */
    /**
 * Converts one row of luminance data to 1 bit data. May actually do the conversion, or return
 * cached data. Callers should assume this method is expensive and call it as seldom as possible.
 * This method is intended for decoding 1D barcodes and may choose to apply sharpening.
 *
 * @param y The row to fetch, which must be in [0, bitmap height)
 * @param row An optional preallocated array. If null or too small, it will be ignored.
 *            If used, the Binarizer will call BitArray.clear(). Always use the returned object.
 * @return The array of bits for this row (true means black) or nil if row can't be binarized.
 */
    @objc
    func blackRow(_ y: CInt, row: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> ZXBitArray? {
        return self.binarizer.blackRow(y, row: row, error: error)
    }
    /**
 * Converts a 2D array of luminance data to 1 bit. As above, assume this method is expensive
 * and do not call it repeatedly. This method is intended for decoding 2D barcodes and may or
 * may not apply sharpening. Therefore, a row from this matrix may not be identical to one
 * fetched using getBlackRow(), so don't mix and match between them.
 *
 * @return The 2D array of bits for the image (true means black) or nil if image can't be binarized
 *   to make a matrix.
 */
    /**
 * Converts a 2D array of luminance data to 1 bit. As above, assume this method is expensive
 * and do not call it repeatedly. This method is intended for decoding 2D barcodes and may or
 * may not apply sharpening. Therefore, a row from this matrix may not be identical to one
 * fetched using getBlackRow(), so don't mix and match between them.
 *
 * @return The 2D array of bits for the image (true means black) or nil if image can't be binarized
 *   to make a matrix.
 */
    @objc
    func blackMatrixWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if self.matrix == nil {
            self.matrix = self.binarizer.blackMatrixWithError(error)
        }

        return self.matrix
    }
    /**
 * Returns a new object with cropped image data. Implementations may keep a reference to the
 * original data rather than a copy. Only callable if isCropSupported() is true.
 *
 * @param left The left coordinate, which must be in [0,getWidth())
 * @param top The top coordinate, which must be in [0,getHeight())
 * @param width The width of the rectangle to crop.
 * @param height The height of the rectangle to crop.
 * @return A cropped version of this object.
 */
    /**
 * Returns a new object with cropped image data. Implementations may keep a reference to the
 * original data rather than a copy. Only callable if isCropSupported() is true.
 *
 * @param left The left coordinate, which must be in [0,getWidth())
 * @param top The top coordinate, which must be in [0,getHeight())
 * @param width The width of the rectangle to crop.
 * @param height The height of the rectangle to crop.
 * @return A cropped version of this object.
 */
    @objc
    func crop(_ left: CInt, top: CInt, width aWidth: CInt, height aHeight: CInt) -> ZXBinaryBitmap? {
        let newSource = self.binarizer.luminanceSource.crop(left, top: top, width: aWidth, height: aHeight)

        return ZXBinaryBitmap(binarizer: self.binarizer.createBinarizer(newSource))
    }
    /**
 * Returns a new object with rotated image data by 90 degrees counterclockwise.
 * Only callable if `rotateSupported` is true.
 *
 * @return A rotated version of this object.
 */
    /**
 * Returns a new object with rotated image data by 90 degrees counterclockwise.
 * Only callable if `rotateSupported` is true.
 *
 * @return A rotated version of this object.
 */
    @objc
    func rotateCounterClockwise() -> ZXBinaryBitmap? {
        let newSource = self.binarizer.luminanceSource.rotateCounterClockwise()

        return ZXBinaryBitmap(binarizer: self.binarizer.createBinarizer(newSource))
    }
    /**
 * Returns a new object with rotated image data by 45 degrees counterclockwise.
 * Only callable if `rotateSupported` is true.
 *
 * @return A rotated version of this object.
 */
    /**
 * Returns a new object with rotated image data by 45 degrees counterclockwise.
 * Only callable if `rotateSupported` is true.
 *
 * @return A rotated version of this object.
 */
    @objc
    func rotateCounterClockwise45() -> ZXBinaryBitmap? {
        let newSource = self.binarizer.luminanceSource.rotateCounterClockwise45()

        return ZXBinaryBitmap(binarizer: self.binarizer.createBinarizer(newSource))
    }
    @objc
    func description() -> String {
        let matrix = self.blackMatrixWithError(nil)

        if matrix != nil {
            return matrix?.description()
        } else {
            return ""
        }
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
extension ZXBinaryBitmap {
    @objc var binarizer: ZXBinarizer! {
        return self._binarizer
    }
}