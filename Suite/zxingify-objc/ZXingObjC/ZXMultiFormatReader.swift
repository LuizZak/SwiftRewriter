import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXReader.h"
// #import "ZXBinaryBitmap.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXMultiFormatReader.h"
// #import "ZXResult.h"
// #if defined(ZXINGOBJC_AZTEC) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXAztecReader.h"
// #endif
// #if defined(ZXINGOBJC_DATAMATRIX) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXDataMatrixReader.h"
// #endif
// #if defined(ZXINGOBJC_MAXICODE) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXMaxiCodeReader.h"
// #endif
// #if defined(ZXINGOBJC_ONED) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXMultiFormatOneDReader.h"
// #endif
// #if defined(ZXINGOBJC_PDF417) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXPDF417Reader.h"
// #endif
// #if defined(ZXINGOBJC_QRCODE) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXQRCodeReader.h"
// #endif
// #if defined(ZXINGOBJC_ONED) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_QRCODE) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_DATAMATRIX) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_AZTEC) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_PDF417) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_MAXICODE) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_ONED) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_ONED) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_QRCODE) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_DATAMATRIX) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_AZTEC) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_PDF417) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_MAXICODE) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_ONED) || !defined(ZXINGOBJC_USE_SUBSPECS)
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
 * ZXMultiFormatReader is a convenience class and the main entry point into the library for most uses.
 * By default it attempts to decode all barcode formats that the library supports. Optionally, you
 * can provide a hints object to request different behavior, for example only decoding QR codes.
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
 * ZXMultiFormatReader is a convenience class and the main entry point into the library for most uses.
 * By default it attempts to decode all barcode formats that the library supports. Optionally, you
 * can provide a hints object to request different behavior, for example only decoding QR codes.
 */
@objc
class ZXMultiFormatReader: NSObject, ZXReader {
    private var _readers: NSMutableArray!
    private var _hints: ZXDecodeHints!
    /**
 * This method adds state to the MultiFormatReader. By setting the hints once, subsequent calls
 * to decodeWithState(image) can reuse the same set of readers without reallocating memory. This
 * is important for performance in continuous scan clients.
 *
 * @param hints The set of hints to use for subsequent calls to decode(image)
 */
    @objc var hints: ZXDecodeHints! {
        get {
            return _hints
        }
        set(hints) {
            _hints = hints

            let tryHarder = hints != nil && hints.tryHarder

            self.readers.removeAllObjects()

            if hints != nil {
                let addZXOneDReader = hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatUPCA) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatUPCE) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatEan13) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatEan8) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatCodabar) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatCode39) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatCode93) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatCode128) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatITF) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatRSS14) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatRSSExpanded)

                if addZXOneDReader && !tryHarder {
                    self.readers.add(ZXMultiFormatOneDReader(hints: hints))
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatQRCode) {
                    self.readers.add(ZXQRCodeReader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatDataMatrix) {
                    self.readers.add(ZXDataMatrixReader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatAztec) {
                    self.readers.add(ZXAztecReader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatPDF417) {
                    self.readers.add(ZXPDF417Reader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatMaxiCode) {
                    self.readers.add(ZXMaxiCodeReader())
                }

                if addZXOneDReader && tryHarder {
                    self.readers.add(ZXMultiFormatOneDReader(hints: hints))
                }
            }

            if self.readers.count == 0 {
                if !tryHarder {
                    self.readers.add(ZXMultiFormatOneDReader(hints: hints))
                }

                self.readers.add(ZXQRCodeReader())
                self.readers.add(ZXDataMatrixReader())
                self.readers.add(ZXAztecReader())
                self.readers.add(ZXPDF417Reader())
                self.readers.add(ZXMaxiCodeReader())

                if tryHarder {
                    self.readers.add(ZXMultiFormatOneDReader(hints: hints))
                }
            }
        }
    }

    @objc
    override init() {
        if self = super.init() {
            _readers = NSMutableArray()
        }

        return self
    }

    @objc
    static func reader() -> AnyObject? {
        return ZXMultiFormatReader()
    }
    /**
 * This version of decode honors the intent of Reader.decode(BinaryBitmap) in that it
 * passes null as a hint to the decoders. However, that makes it inefficient to call repeatedly.
 * Use setHints() followed by decodeWithState() for continuous scan applications.
 *
 * @param image The pixel data to decode
 * @return The contents of the image or nil if any errors occurred
 */
    @objc
    func decode(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        self.hints = nil

        return self.decodeInternal(image, error: error)
    }
    /**
 * Decode an image using the hints provided. Does not honor existing state.
 *
 * @param image The pixel data to decode
 * @param hints The hints to use, clearing the previous state.
 * @return The contents of the image or nil if any errors occurred
 */
    @objc
    func decode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        self.hints = hints

        return self.decodeInternal(image, error: error)
    }
    /**
 * Decode an image using the state set up by calling setHints() previously. Continuous scan
 * clients will get a <b>large</b> speed increase by using this instead of decode().
 *
 * @param image The pixel data to decode
 * @return The contents of the image or nil if any errors occurred
 */
    /**
 * Decode an image using the state set up by calling setHints() previously. Continuous scan
 * clients will get a <b>large</b> speed increase by using this instead of decode().
 *
 * @param image The pixel data to decode
 * @return The contents of the image or nil if any errors occurred
 */
    @objc
    func decodeWithState(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        if self.readers == nil {
            self.hints = nil
        }

        return self.decodeInternal(image, error: error)
    }
    @objc
    func reset() {
        if self.readers != nil {
            for reader in self.readers {
                reader.reset()
            }
        }
    }
    @objc
    func decodeInternal(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        if self.readers != nil {
            for reader in self.readers {
                let result: ZXResult! = reader.decode(image, hints: self.hints, error: nil)

                if result {
                    return result
                }
            }
        }

        if error != nil {
            error.pointee = ZXNotFoundErrorInstance()
        }

        return nil
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
extension ZXMultiFormatReader {
    @objc var readers: NSMutableArray! {
        return self._readers
    }
}