import QuartzCore
import ImageIO

// Preprocessor directives found in file:
// #import <QuartzCore/QuartzCore.h>
// #import "ZXBitMatrix.h"
// #import "ZXImage.h"
// #if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
// #import <ImageIO/ImageIO.h>
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
class ZXImage: NSObject {
    private var _cgimage: CGImageRef
    @objc var cgimage: CGImageRef {
        return self._cgimage
    }

    @objc
    init(cGImageRef image: CGImageRef) {
        if self = super.init() {
            _cgimage = CGImageRetain(image)
        }

        return self
    }
    @objc
    init(uRL url: URL!) {
        if self = super.init() {
            let provider: CGDataProviderRef = CGDataProviderCreateWithURL(url as? CFURLRef)

            if provider {
                let source: CGImageSourceRef = CGImageSourceCreateWithDataProvider(provider, 0)

                if source {
                    _cgimage = CGImageSourceCreateImageAtIndex(source, 0, 0)
                    CFRelease(source)
                }

                CGDataProviderRelease(provider)
            }
        }

        return self
    }

    deinit {
        if _cgimage {
            CGImageRelease(_cgimage)
        }
    }

    @objc
    func width() -> size_t {
        return CGImageGetWidth(self.cgimage)
    }
    @objc
    func height() -> size_t {
        return CGImageGetHeight(self.cgimage)
    }
    @objc
    static func imageWithMatrix(_ matrix: ZXBitMatrix!) -> ZXImage {
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()
        let blackComponents: UnsafeMutablePointer<CGFloat>!
        let black: CGColorRef = CGColorCreate(colorSpace, blackComponents)
        let whiteComponents: UnsafeMutablePointer<CGFloat>!
        let white: CGColorRef = CGColorCreate(colorSpace, whiteComponents)

        CFRelease(colorSpace)

        let result = self.imageWithMatrix(matrix, onColor: black, offColor: white)

        CGColorRelease(white)
        CGColorRelease(black)

        return result
    }
    @objc
    static func imageWithMatrix(_ matrix: ZXBitMatrix!, onColor: CGColorRef, offColor: CGColorRef) -> ZXImage {
        let onIntensities: (uint8_t, uint8_t, uint8_t, uint8_t), offIntensities: (uint8_t, uint8_t, uint8_t, uint8_t)

        self.setColorIntensities(onIntensities, color: onColor)
        self.setColorIntensities(offIntensities, color: offColor)

        let width = matrix.width
        let height = matrix.height
        var bytes: UnsafeMutablePointer<int8_t>! = malloc(width * height * 4) as? UnsafeMutablePointer<int8_t>
        var y: CInt = 0

        while y < height {
            defer {
                y += 1
            }

            var x: CInt = 0

            while x < width {
                defer {
                    x += 1
                }

                let bit = matrix.getX(x, y: y)
                var i: CInt = 0

                while i < 4 {
                    defer {
                        i += 1
                    }

                    let intensity: int8_t = bit ? onIntensities[i] : offIntensities[i]

                    bytes[y * width * 4 + x * 4 + i] = intensity
                }
            }
        }

        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let c: CGContextRef = CGBitmapContextCreate(bytes, width, height, 8, 4 * width, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast)

        CFRelease(colorSpace)

        let image: CGImageRef = CGBitmapContextCreateImage(c)

        CFRelease(c)
        free(bytes)

        let zxImage = ZXImage(cGImageRef: image)

        CFRelease(image)

        return zxImage
    }
    @objc
    static func setColorIntensities(_ intensities: UnsafeMutablePointer<uint8_t>!, color: CGColorRef) {
        memset(intensities, 0, 4)

        let numberOfComponents: size_t = CGColorGetNumberOfComponents(color)
        let components: UnsafePointer<CGFloat>! = CGColorGetComponents(color)

        if numberOfComponents == 4 {
            var i: CInt = 0

            while i < 4 {
                defer {
                    i += 1
                }

                intensities[i] = min(1.0, Double(max(0, components[i]))) * 255
            }
        } else if numberOfComponents == 2 {
            var i: CInt = 0

            while i < 3 {
                defer {
                    i += 1
                }

                intensities[i] = min(1.0, Double(max(0, components[0]))) * 255
            }

            intensities[3] = min(1.0, Double(max(0, components[1]))) * 255
        }
    }
}