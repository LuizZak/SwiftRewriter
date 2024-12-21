import CoreGraphics
import UIKit

// Preprocessor directives found in file:
// #import <CoreGraphics/CoreGraphics.h>
// #import "ZXBitArray.h"
// #import "ZXBitMatrix.h"
// #import "ZXLuminanceSource.h"
// #import "ZXBinarizer.h"
// #if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR || TARGET_OS_MACCATALYST
// #import <UIKit/UIKit.h>
// #define ZXBlack [[UIColor blackColor] CGColor]
// #define ZXWhite [[UIColor whiteColor] CGColor]
// #else
// #define ZXBlack CGColorGetConstantColor(kCGColorBlack)
// #define ZXWhite CGColorGetConstantColor(kCGColorWhite)
// #endif
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
 * This class hierarchy provides a set of methods to convert luminance data to 1 bit data.
 * It allows the algorithm to vary polymorphically, for example allowing a very expensive
 * thresholding technique for servers and a fast one for mobile. It also permits the implementation
 * to vary, e.g. a JNI version for Android and a Java fallback version for other platforms.
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
 * This class hierarchy provides a set of methods to convert luminance data to 1 bit data.
 * It allows the algorithm to vary polymorphically, for example allowing a very expensive
 * thresholding technique for servers and a fast one for mobile. It also permits the implementation
 * to vary, e.g. a JNI version for Android and a Java fallback version for other platforms.
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
class ZXBinarizer: NSObject {
    private var _luminanceSource: ZXLuminanceSource!
    @objc var luminanceSource: ZXLuminanceSource! {
        return self._luminanceSource
    }
    @objc var width: CInt {
        return self.luminanceSource.width ?? 0
    }
    @objc var height: CInt {
        return self.luminanceSource.height ?? 0
    }

    @objc
    init(source: ZXLuminanceSource!) {
        if self = super.init() {
            _luminanceSource = source
        }

        return self
    }
    @objc
    init(luminanceSource source: ZXLuminanceSource!) {
        return self.init(source: source)
    }

    @objc
    static func binarizerWithSource(_ source: ZXLuminanceSource!) -> AnyObject? {
        return self.init(luminanceSource: source)
    }
    /**
 * Converts one row of luminance data to 1 bit data. May actually do the conversion, or return
 * cached data. Callers should assume this method is expensive and call it as seldom as possible.
 * This method is intended for decoding 1D barcodes and may choose to apply sharpening.
 * For callers which only examine one row of pixels at a time, the same BitArray should be reused
 * and passed in with each call for performance. However it is legal to keep more than one row
 * at a time if needed.
 *
 * @param y The row to fetch, which must be in [0, bitmap height)
 * @param row An optional preallocated array. If null or too small, it will be ignored.
 *            If used, the Binarizer will call ZXBitArray clear. Always use the returned object.
 * @return The array of bits for this row (true means black) or nil if row can't be binarized.
 */
    /**
 * Converts one row of luminance data to 1 bit data. May actually do the conversion, or return
 * cached data. Callers should assume this method is expensive and call it as seldom as possible.
 * This method is intended for decoding 1D barcodes and may choose to apply sharpening.
 * For callers which only examine one row of pixels at a time, the same BitArray should be reused
 * and passed in with each call for performance. However it is legal to keep more than one row
 * at a time if needed.
 *
 * @param y The row to fetch, which must be in [0, bitmap height)
 * @param row An optional preallocated array. If null or too small, it will be ignored.
 *            If used, the Binarizer will call ZXBitArray clear. Always use the returned object.
 * @return The array of bits for this row (true means black) or nil if row can't be binarized.
 */
    @objc
    func blackRow(_ y: CInt, row: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> ZXBitArray {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
    /**
 * Converts a 2D array of luminance data to 1 bit data. As above, assume this method is expensive
 * and do not call it repeatedly. This method is intended for decoding 2D barcodes and may or
 * may not apply sharpening. Therefore, a row from this matrix may not be identical to one
 * fetched using getBlackRow(), so don't mix and match between them.
 *
 * @return The 2D array of bits for the image (true means black) or nil if image can't be binarized
 * to make a matrix.
 */
    /**
 * Converts a 2D array of luminance data to 1 bit data. As above, assume this method is expensive
 * and do not call it repeatedly. This method is intended for decoding 2D barcodes and may or
 * may not apply sharpening. Therefore, a row from this matrix may not be identical to one
 * fetched using getBlackRow(), so don't mix and match between them.
 *
 * @return The 2D array of bits for the image (true means black) or nil if image can't be binarized
 * to make a matrix.
 */
    @objc
    func blackMatrixWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
    /**
 * Creates a new object with the same type as this Binarizer implementation, but with pristine
 * state. This is needed because Binarizer implementations may be stateful, e.g. keeping a cache
 * of 1 bit data. See Effective Java for why we can't use Java's clone() method.
 *
 * @param source The LuminanceSource this Binarizer will operate on.
 * @return A new concrete Binarizer implementation object.
 */
    /**
 * Creates a new object with the same type as this Binarizer implementation, but with pristine
 * state. This is needed because Binarizer implementations may be stateful, e.g. keeping a cache
 * of 1 bit data. See Effective Java for why we can't use Java's clone() method.
 *
 * @param source The LuminanceSource this Binarizer will operate on.
 * @return A new concrete Binarizer implementation object.
 */
    @objc
    func createBinarizer(_ source: ZXLuminanceSource!) -> ZXBinarizer {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
    @objc
    func createImage() -> CGImageRef {
        let matrix = self.blackMatrixWithError(nil)

        if !matrix {
            return nil
        }

        let source = self.luminanceSource
        let width = source?.width ?? 0
        let height = source?.height ?? 0
        let bytesPerRow = ((width & 0xf) >> 4) << 4
        let gray: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()
        let context: CGContextRef = CGBitmapContextCreate(0, width, height, 8, bytesPerRow, gray, kCGBitmapAlphaInfoMask & kCGImageAlphaNone)

        // bits per component
        CGColorSpaceRelease(gray)

        var r = CGRect.zero

        r.size.width = CGFloat(width)
        r.size.height = CGFloat(height)

        context.setFillColor(ZXBlack)
        context.fill(r)

        r.size.width = 1
        r.size.height = 1

        context.setFillColor(ZXWhite)

        var y: CInt = 0

        while y < height {
            defer {
                y += 1
            }

            r.origin.y = CGFloat(height - 1 - y)

            var x: CInt = 0

            while x < width {
                defer {
                    x += 1
                }

                if !matrix.getX(x, y: y) {
                    r.origin.x = CGFloat(x)
                    context.fill(r)
                }
            }
        }

        let binary: CGImageRef = CGBitmapContextCreateImage(context)

        context.release()

        return binary
    }
}