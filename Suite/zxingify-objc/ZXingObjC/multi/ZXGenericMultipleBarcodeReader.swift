// Preprocessor directives found in file:
// #import "ZXMultipleBarcodeReader.h"
// #import "ZXErrors.h"
// #import "ZXGenericMultipleBarcodeReader.h"
// #import "ZXReader.h"
// #import "ZXResultPoint.h"
let ZX_MIN_DIMENSION_TO_RECUR: CInt = 100
let ZX_MAX_DEPTH: CInt = 4

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
 * Attempts to locate multiple barcodes in an image by repeatedly decoding portion of the image.
 * After one barcode is found, the areas left, above, right and below the barcode's
 * ZXResultPoints are scanned, recursively.
 *
 * A caller may want to also employ ZXByQuadrantReader when attempting to find multiple
 * 2D barcodes, like QR Codes, in an image, where the presence of multiple barcodes might prevent
 * detecting any one of them.
 *
 * That is, instead of passing an ZXReader a caller might pass
 * <code>[[ZXByQuadrantReader alloc] initWithDelegate:reader]</code>.
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
 * Attempts to locate multiple barcodes in an image by repeatedly decoding portion of the image.
 * After one barcode is found, the areas left, above, right and below the barcode's
 * ZXResultPoints are scanned, recursively.
 *
 * A caller may want to also employ ZXByQuadrantReader when attempting to find multiple
 * 2D barcodes, like QR Codes, in an image, where the presence of multiple barcodes might prevent
 * detecting any one of them.
 *
 * That is, instead of passing an ZXReader a caller might pass
 * <code>[[ZXByQuadrantReader alloc] initWithDelegate:reader]</code>.
 */
@objc
class ZXGenericMultipleBarcodeReader: NSObject, ZXMultipleBarcodeReader {
    private var _delegate: ZXReader!

    @objc
    init(delegate: ZXReader!) {
        if self = super.init() {
            _delegate = delegate
        }

        return self
    }

    @objc
    func decodeMultiple(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> NSArray {
        return self.decodeMultiple(image, hints: nil, error: error)
    }
    @objc
    func decodeMultiple(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> NSArray {
        let results = NSMutableArray()

        self.doDecodeMultiple(image, hints: hints, results: results, xOffset: 0, yOffset: 0, currentDepth: 0, error: error)

        if results.count == 0 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        return results
    }
    @objc
    func doDecodeMultiple(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, results: NSMutableArray!, xOffset: CInt, yOffset: CInt, currentDepth: CInt, error: UnsafeMutablePointer<Error?>!) {
        if currentDepth > ZX_MAX_DEPTH {
            return
        }

        let result = self.delegate.decode(image, hints: hints, error: error)

        if result == nil {
            return
        }

        var alreadyFound = false

        for existingResult in results {
            if existingResult.text() == result?.text() {
                alreadyFound = true

                break
            }
        }

        if !alreadyFound {
            results.add(self.translateResultPoints(result, xOffset: xOffset, yOffset: yOffset))
        }

        let resultPoints = result?.resultPoints

        if resultPoints == nil || resultPoints?.count == 0 {
            return
        }

        let width = image.width
        let height = image.height
        var minX: CFloat = CFloat(width)
        var minY: CFloat = CFloat(height)
        var maxX: CFloat = 0.0
        var maxY: CFloat = 0.0

        for point in resultPoints {
            if point as? AnyObject == NSNull.null() {
                continue
            }

            let x: CFloat = point.x()
            let y: CFloat = point.y()

            if x < minX {
                minX = x
            }

            if y < minY {
                minY = y
            }

            if x > maxX {
                maxX = x
            }

            if y > maxY {
                maxY = y
            }
        }

        if minX > ZX_MIN_DIMENSION_TO_RECUR {
            self.doDecodeMultiple(image.crop(0, top: 0, width: CInt(minX), height: height), hints: hints, results: results, xOffset: xOffset, yOffset: yOffset, currentDepth: currentDepth + 1, error: error)
        }

        if minY > ZX_MIN_DIMENSION_TO_RECUR {
            self.doDecodeMultiple(image.crop(0, top: 0, width: width, height: CInt(minY)), hints: hints, results: results, xOffset: xOffset, yOffset: yOffset, currentDepth: currentDepth + 1, error: error)
        }

        if maxX < width - ZX_MIN_DIMENSION_TO_RECUR {
            self.doDecodeMultiple(image.crop(CInt(maxX), top: 0, width: width - CInt(maxX), height: height), hints: hints, results: results, xOffset: xOffset + CInt(maxX), yOffset: yOffset, currentDepth: currentDepth + 1, error: error)
        }

        if maxY < height - ZX_MIN_DIMENSION_TO_RECUR {
            self.doDecodeMultiple(image.crop(0, top: CInt(maxY), width: width, height: height - CInt(maxY)), hints: hints, results: results, xOffset: xOffset, yOffset: yOffset + CInt(maxY), currentDepth: currentDepth + 1, error: error)
        }
    }
    @objc
    func translateResultPoints(_ result: ZXResult!, xOffset: CInt, yOffset: CInt) -> ZXResult? {
        let oldResultPoints = result.resultPoints

        if oldResultPoints == nil {
            return result
        }

        let newResultPoints: NSMutableArray! = NSMutableArray.arrayWithCapacity(oldResultPoints?.count())

        for oldPoint in oldResultPoints {
            if oldPoint as? AnyObject != NSNull.null() {
                newResultPoints.add(ZXResultPoint(x: oldPoint.x() + xOffset, y: oldPoint.y() + yOffset))
            }
        }

        let newResult = ZXResult.resultWithText(result.text, rawBytes: result.rawBytes, numBits: result.numBits, resultPoints: newResultPoints, format: result.barcodeFormat)

        newResult?.putAllMetadata(result.resultMetadata)

        return newResult
    }
}

// MARK: -
@objc
extension ZXGenericMultipleBarcodeReader {
    @objc var delegate: ZXReader! {
        return self._delegate
    }
}