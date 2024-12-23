import CoreVideo
import CoreVideo

// Preprocessor directives found in file:
// #import <CoreVideo/CoreVideo.h>
// #import "ZXLuminanceSource.h"
// #import "ZXCGImageLuminanceSourceInfo.h"
// #import <CoreVideo/CoreVideo.h>
// #import "ZXByteArray.h"
// #import "ZXCGImageLuminanceSource.h"
// #import "ZXImage.h"
// #import "ZXDecodeHints.h"
// #if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
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
class ZXCGImageLuminanceSource: ZXLuminanceSource {
    private unowned(unsafe) var _data: UnsafeMutablePointer<int8_t>!
    private var _left: size_t
    private var _top: size_t
    private unowned(unsafe) var _sourceInfo: ZXCGImageLuminanceSourceInfo!

    @objc
    init(zXImage image: ZXImage!, left: size_t, top: size_t, width: size_t, height: size_t) {
        return self.init(cGImage: image.cgimage, left: left, top: top, width: width, height: height)
    }
    @objc
    init(zXImage image: ZXImage!) {
        return self.init(cGImage: image.cgimage)
    }
    @objc
    init(cGImage image: CGImageRef, left: size_t, top: size_t, width: size_t, height: size_t) {
        if self = super.init(width: CInt(width), height: CInt(height)) {
            self.initializeWithImage(image, left: left, top: top, width: width, height: height)
        }

        return self
    }
    @objc
    init(cGImage image: CGImageRef) {
        return self.init(cGImage: image, left: 0, top: 0, width: CGImageGetWidth(image), height: CGImageGetHeight(image))
    }
    @objc
    init(cGImage image: CGImageRef, sourceInfo: ZXCGImageLuminanceSourceInfo!) {
        let width: size_t = CGImageGetWidth(image)
        let height: size_t = CGImageGetHeight(image)

        if self = super.init(width: CInt(width), height: CInt(height)) {
            _sourceInfo = sourceInfo
            self.initializeWithImage(image, left: 0, top: 0, width: width, height: height)
        }

        return self
    }
    @objc
    convenience init(buffer: CVPixelBufferRef, left: size_t, top: size_t, width: size_t, height: size_t) {
        let image = ZXCGImageLuminanceSource.createImageFromBuffer(buffer, left: left, top: top, width: width, height: height)

        self = self.init(cGImage: image)
        CGImageRelease(image)

        return self
    }
    @objc
    convenience init(buffer: CVPixelBufferRef) {
        let image = ZXCGImageLuminanceSource.createImageFromBuffer(buffer)

        self = self.init(cGImage: image)
        CGImageRelease(image)

        return self
    }

    deinit {
        if _image {
            CGImageRelease(_image)
        }

        if _data != nil {
            free(_data)
        }
    }

    @objc
    static func createImageFromBuffer(_ buffer: CVImageBufferRef) -> CGImageRef {
        return self.createImageFromBuffer(buffer, left: 0, top: 0, width: CVPixelBufferGetWidth(buffer), height: CVPixelBufferGetHeight(buffer))
    }
    @objc
    static func createImageFromBuffer(_ buffer: CVImageBufferRef, left: size_t, top: size_t, width: size_t, height: size_t) -> CGImageRef {
        let bytesPerRow: size_t = CVPixelBufferGetBytesPerRow(buffer)
        let dataWidth: size_t = CVPixelBufferGetWidth(buffer)
        let dataHeight: size_t = CVPixelBufferGetHeight(buffer)

        if left + width > dataWidth || top + height > dataHeight {
            NSException.raise(NSInvalidArgumentException, format: "Crop rectangle does not fit within image data.")
        }

        let newBytesPerRow = ((width * 4 + 0xf) >> 4) << 4

        CVPixelBufferLockBaseAddress(buffer, 0)

        let baseAddress: UnsafeMutablePointer<int8_t>! = CVPixelBufferGetBaseAddress(buffer) as? UnsafeMutablePointer<int8_t>
        let size = newBytesPerRow * height
        let bytes: UnsafeMutablePointer<int8_t>! = malloc(size * MemoryLayout.size(ofValue: int8_t)) as? UnsafeMutablePointer<int8_t>

        if newBytesPerRow == bytesPerRow {
            memcpy(bytes, baseAddress + top * bytesPerRow, size * MemoryLayout.size(ofValue: int8_t))
        } else {
            var y: CInt = 0

            while y < height {
                defer {
                    y += 1
                }

                memcpy(bytes + y * newBytesPerRow, baseAddress + left * 4 + (top + y) * bytesPerRow, newBytesPerRow * MemoryLayout.size(ofValue: int8_t))
            }
        }

        CVPixelBufferUnlockBaseAddress(buffer, 0)

        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let newContext: CGContextRef = CGBitmapContextCreate(bytes, width, height, 8, newBytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst)

        CGColorSpaceRelease(colorSpace)

        let result: CGImageRef = CGBitmapContextCreateImage(newContext)

        newContext.release()
        free(bytes)

        return result
    }
    @objc
    func rowAtY(_ y: CInt, row: ZXByteArray!) -> ZXByteArray? {
        if y < 0 || y >= self.height {
            NSException.raise(NSInvalidArgumentException, format: "Requested row is outside the image: %d", y)
        }

        if !row || row.length < self.width {
            row = ZXByteArray(length: CUnsignedInt(self.width))
        }

        let offset = y * self.width

        memcpy(row.array, self.data + offset, Int(self.width) * MemoryLayout.size(ofValue: int8_t))

        return row
    }
    @objc
    func matrix() -> ZXByteArray {
        let area = self.width * self.height
        let matrix = ZXByteArray(length: CUnsignedInt(area))

        memcpy(matrix.array, self.data, Int(area) * MemoryLayout.size(ofValue: int8_t))

        return matrix
    }
    @objc
    func initializeWithImage(_ cgimage: CGImageRef, left: size_t, top: size_t, width: size_t, height: size_t) {
        _data = 0

        _image = CGImageRetain(cgimage)

        _left = left

        _top = top

        let sourceWidth: size_t = CGImageGetWidth(cgimage)
        let sourceHeight: size_t = CGImageGetHeight(cgimage)
        let selfWidth: size_t = self.width
        let selfHeight: size_t = self.height

        if left + selfWidth > sourceWidth || top + selfHeight > sourceHeight {
            NSException.raise(NSInvalidArgumentException, format: "Crop rectangle does not fit within image data.")
        }

        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let context: CGContextRef = CGBitmapContextCreate(nil, selfWidth, selfHeight, 8, selfWidth * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast)

        CGColorSpaceRelease(colorSpace)
        context.setAllowsAntialiasing(FALSE)
        context.setInterpolationQuality(kCGInterpolationNone)

        if top || left {
            context.clip(to: CGRect(x: 0, y: 0, width: selfWidth, height: selfHeight))
        }

        context.draw(self.image, in: CGRect(x: -left, y: -top, width: selfWidth, height: selfHeight))

        let pixelData: UnsafeMutablePointer<uint32_t>! = CGBitmapContextGetData(context)

        _data = malloc(selfWidth * selfHeight * MemoryLayout.size(ofValue: int8_t)) as? UnsafeMutablePointer<int8_t>

        dispatch_apply(selfHeight, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) { (idx: size_t) -> Void in
            let stripe_start = idx * selfWidth
            let stripe_stop = stripe_start + selfWidth
            var i = stripe_start

            while i < stripe_stop {
                defer {
                    i += 1
                }

                let rgbPixelIn: uint32_t = pixelData[i]
                var rgbPixelOut: uint32_t = 0
                var red = (rgbPixelIn >> 24) & 0xff
                var green = (rgbPixelIn >> 16) & 0xff
                var blue = (rgbPixelIn >> 8) & 0xff
                let alpha = rgbPixelIn & 0xff

                // ImageIO premultiplies all PNGs, so we have to "un-premultiply them":
                // http://code.google.com/p/cocos2d-iphone/issues/detail?id=697#c26
                if alpha != 0xff {
                    red = (red > 0) ? ((red << 20) / (alpha << 2)) >> 10 : 0
                    green = (green > 0) ? ((green << 20) / (alpha << 2)) >> 10 : 0
                    blue = (blue > 0) ? ((blue << 20) / (alpha << 2)) >> 10 : 0
                }

                if red == green && green == blue {
                    rgbPixelOut = red
                } else {
                    rgbPixelOut = self.calculateRed(red, green: green, blue: blue)
                }

                if rgbPixelOut > 255 {
                    rgbPixelOut = 255
                }

                // The color of fully-transparent pixels is irrelevant. They are often, technically, fully-transparent
                // black (0 alpha, and then 0 RGB). They are often used, of course as the "white" area in a
                // barcode image. Force any such pixel to be white:
                if rgbPixelOut == 0 && alpha == 0 {
                    rgbPixelOut = 255
                }

                self._data[i] = rgbPixelOut
            }
        }

        context.release()

        _top = top

        _left = left
    }
    @objc
    func calculateRed(_ red: uint32_t, green: uint32_t, blue: uint32_t) -> uint32_t {
        // Normal formula
        if _sourceInfo == nil || _sourceInfo.type == ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceNormal {
            let ret = (306 * red + 601 * green + 117 * blue + (0x200)) >> 10 // 0x200 = 1<<9, half an lsb of the result to force rounding

            return ret
        }

        switch _sourceInfo.type {
        case ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceLuma:
            let result = red * 0.2126 + green * 0.7152 + blue * 0.0722

            return result
        case ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceShades:
            // shades formula - ref: http://www.tannerhelland.com/3643/grayscale-image-algorithm-vb6/
            if _sourceInfo.numberOfShades > 1 {
                let conversationFactor: CFloat = 255.0 / (_sourceInfo.numberOfShades - 1)
                let averageValue = (red + green + blue) / 3.0
                let result: uint32_t = ((averageValue / conversationFactor) + 0.5) * conversationFactor

                return result
            }

            return 0
        case ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceDigital:
            return green
        case ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceDecomposingMin:
            return min(min(red, green), blue)
        case ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceDecomposingMax:
            return max(max(red, green), blue)
        default:
            return 0
        }
    }
    @objc
    func rotateSupported() -> Bool {
        return true
    }
    @objc
    func rotateCounterClockwise() -> ZXLuminanceSource {
        let radians: CDouble = 270.0 * M_PI / 180
        let sourceWidth = self.width
        let sourceHeight = self.height
        let imgRect = CGRect(x: 0, y: 0, width: CGFloat(sourceWidth), height: CGFloat(sourceHeight))
        let transform: CGAffineTransform = CGAffineTransformMakeRotation(radians)
        let rotatedRect: CGRect = CGRectApplyAffineTransform(imgRect, transform)
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let context: CGContextRef = CGBitmapContextCreate(nil, rotatedRect.size.width, rotatedRect.size.height, 8, 0, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst)

        context.setAllowsAntialiasing(FALSE)
        context.setInterpolationQuality(kCGInterpolationNone)

        CGColorSpaceRelease(colorSpace)

        context.translateBy(x: +(rotatedRect.size.width / 2), y: +(rotatedRect.size.height / 2))
        context.rotate(by: radians)
        context.draw(self.image, in: CGRect(x: -imgRect.size.width / 2, y: -imgRect.size.height / 2, width: imgRect.size.width, height: imgRect.size.height))

        let rotatedImage: CGImageRef = CGBitmapContextCreateImage(context)

        CFRelease(context)

        let result = ZXCGImageLuminanceSource(cGImage: rotatedImage, left: self.top, top: sourceWidth - (self.left + self.width), width: self.height, height: self.width)

        CGImageRelease(rotatedImage)

        return result
    }
    @objc
    func crop(_ left: CInt, top: CInt, width: CInt, height: CInt) -> ZXLuminanceSource {
        let croppedImageRef: CGImageRef = CGImageCreateWithImageInRect(self.image, CGRect(x: CGFloat(left), y: CGFloat(top), width: CGFloat(width), height: CGFloat(height)))
        let result = ZXCGImageLuminanceSource(cGImage: croppedImageRef)

        CGImageRelease(croppedImageRef)

        return result
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
extension ZXCGImageLuminanceSource {
    @objc var image: CGImageRef {
    }
    @objc unowned(unsafe) var data: UnsafeMutablePointer<int8_t>! {
        return self._data
    }
    @objc var left: size_t {
        return self._left
    }
    @objc var top: size_t {
        return self._top
    }
    @objc unowned(unsafe) var sourceInfo: ZXCGImageLuminanceSourceInfo! {
        return self._sourceInfo
    }
}