// Preprocessor directives found in file:
// #import "ZXReader.h"
// #import "ZXBinaryBitmap.h"
// #import "ZXByQuadrantReader.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXResult.h"
// #import "ZXResultPoint.h"
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
 * This class attempts to decode a barcode from an image, not by scanning the whole image,
 * but by scanning subsets of the image. This is important when there may be multiple barcodes in
 * an image, and detecting a barcode may find parts of multiple barcode and fail to decode
 * (e.g. QR Codes). Instead this scans the four quadrants of the image -- and also the center
 * 'quadrant' to cover the case where a barcode is found in the center.
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
 * This class attempts to decode a barcode from an image, not by scanning the whole image,
 * but by scanning subsets of the image. This is important when there may be multiple barcodes in
 * an image, and detecting a barcode may find parts of multiple barcode and fail to decode
 * (e.g. QR Codes). Instead this scans the four quadrants of the image -- and also the center
 * 'quadrant' to cover the case where a barcode is found in the center.
 */
@objc
class ZXByQuadrantReader: NSObject, ZXReader {
    private weak var _delegate: ZXReader?

    @objc
    init(delegate: ZXReader!) {
        if self = super.init() {
            _delegate = delegate
        }

        return self
    }

    @objc
    func decode(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        return self.decode(image, hints: nil, error: error)
    }
    @objc
    func decode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let width = image.width
        let height = image.height
        let halfWidth = width / 2
        let halfHeight = height / 2
        // No need to call makeAbsolute as results will be relative to original top left here
        var decodeError: Error! = nil
        var result = self.delegate?.decode(image.crop(0, top: 0, width: halfWidth, height: halfHeight), hints: hints, error: &decodeError)

        if result != nil {
            return result
        } else if decodeError?.code != ZXNotFoundError {
            if error {
                *error = decodeError
            }

            return nil
        }

        decodeError = nil
        result = self.delegate?.decode(image.crop(halfWidth, top: 0, width: halfWidth, height: halfHeight), hints: hints, error: &decodeError)

        if result != nil {
            self.makeAbsolute(result?.resultPoints, leftOffset: halfWidth, topOffset: 0)

            return result
        } else if decodeError?.code != ZXNotFoundError {
            if error {
                *error = decodeError
            }

            return nil
        }

        decodeError = nil
        result = self.delegate?.decode(image.crop(0, top: halfHeight, width: halfWidth, height: halfHeight), hints: hints, error: &decodeError)

        if result != nil {
            self.makeAbsolute(result?.resultPoints, leftOffset: 0, topOffset: halfHeight)

            return result
        } else if decodeError?.code != ZXNotFoundError {
            if error {
                *error = decodeError
            }

            return nil
        }

        decodeError = nil
        result = self.delegate?.decode(image.crop(halfWidth, top: halfHeight, width: halfWidth, height: halfHeight), hints: hints, error: &decodeError)

        if result != nil {
            self.makeAbsolute(result?.resultPoints, leftOffset: halfWidth, topOffset: halfHeight)

            return result
        } else if decodeError?.code != ZXNotFoundError {
            if error {
                *error = decodeError
            }

            return nil
        }

        let quarterWidth = halfWidth / 2
        let quarterHeight = halfHeight / 2
        let center = image.crop(quarterWidth, top: quarterHeight, width: halfWidth, height: halfHeight)

        result = self.delegate?.decode(center, hints: hints, error: error)

        if result != nil {
            self.makeAbsolute(result?.resultPoints, leftOffset: quarterWidth, topOffset: quarterHeight)
        }

        return result
    }
    @objc
    func reset() {
        self.delegate?.reset()
    }
    @objc
    func makeAbsolute(_ points: NSMutableArray!, leftOffset: CInt, topOffset: CInt) {
        if points {
            var i: CInt = 0

            while i < points.count {
                defer {
                    i += 1
                }

                let relative: ZXResultPoint! = points[Int(i)]

                if relative {
                    points[Int(i)] = ZXResultPoint(x: relative.x + CFloat(leftOffset), y: relative.y + CFloat(topOffset))
                }
            }
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
extension ZXByQuadrantReader {
    @objc weak var delegate: ZXReader? {
        return self._delegate
    }
}