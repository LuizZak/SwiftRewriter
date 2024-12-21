// Preprocessor directives found in file:
// #import "ZXBarcodeFormat.h"
// #import "ZXResultMetadataType.h"
// #import "ZXByteArray.h"
// #import "ZXResult.h"
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
 * Encapsulates the result of decoding a barcode within an image.
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
 * Encapsulates the result of decoding a barcode within an image.
 */
@objc
class ZXResult: NSObject {
    private var _resultMetadata: NSMutableDictionary!
    private var _resultPoints: NSMutableArray!
    private var _text: String!
    private var _rawBytes: ZXByteArray!
    private var _numBits: CInt = 0
    private var _barcodeFormat: ZXBarcodeFormat = ZXBarcodeFormat.kBarcodeFormatAztec
    private var _timestamp: CLong = 0
    /**
 * @return raw text encoded by the barcode
 */
    @objc var text: String! {
        return self._text
    }
    /**
 * @return raw bytes encoded by the barcode, if applicable, otherwise nil
 */
    @objc var rawBytes: ZXByteArray! {
        return self._rawBytes
    }
    /**
 * @return how many bits of `rawBytes` are valid; typically 8 times its length
 */
    @objc var numBits: CInt {
        get {
            return self._numBits
        }
        set {
            self._numBits = newValue
        }
    }
    /**
 * @return points related to the barcode in the image. These are typically points
 *         identifying finder patterns or the corners of the barcode. The exact meaning is
 *         specific to the type of barcode that was decoded.
 */
    @objc var resultPoints: NSMutableArray! {
        return self._resultPoints
    }
    /**
 * @return ZXBarcodeFormat representing the format of the barcode that was decoded
 */
    @objc var barcodeFormat: ZXBarcodeFormat {
        return self._barcodeFormat
    }
    /**
 * @return NSDictionary mapping ZXResultMetadataType keys to values. May be
 *   nil. This contains optional metadata about what was detected about the barcode,
 *   like orientation.
 */
    @objc var resultMetadata: NSMutableDictionary! {
        return self._resultMetadata
    }
    @objc var timestamp: CLong {
        return self._timestamp
    }

    @objc
    init(text: String!, rawBytes: ZXByteArray!, resultPoints: NSArray!, format: ZXBarcodeFormat) {
        return self.init(text: text, rawBytes: rawBytes, resultPoints: resultPoints, format: format, timestamp: CFAbsoluteTimeGetCurrent())
    }
    @objc
    init(text: String!, rawBytes: ZXByteArray!, numBits: CInt, resultPoints: NSArray!, format: ZXBarcodeFormat) {
        return self.init(text: text, rawBytes: rawBytes, numBits: numBits, resultPoints: resultPoints, format: format, timestamp: CFAbsoluteTimeGetCurrent())
    }
    @objc
    init(text: String!, rawBytes: ZXByteArray!, resultPoints: NSArray!, format: ZXBarcodeFormat, timestamp: CLong) {
        if self = super.init() {
            _text = text

            _rawBytes = rawBytes

            _numBits = (rawBytes == nil) ? 0 : 8 * rawBytes.length

            _resultPoints = resultPoints.mutableCopy()

            _barcodeFormat = format

            _resultMetadata = nil

            _timestamp = timestamp
        }

        return self
    }
    @objc
    init(text: String!, rawBytes: ZXByteArray!, numBits: CInt, resultPoints: NSArray!, format: ZXBarcodeFormat, timestamp: CLong) {
        if self = super.init() {
            _text = text

            _rawBytes = rawBytes

            _numBits = numBits

            _resultPoints = resultPoints.mutableCopy()

            _barcodeFormat = format

            _resultMetadata = nil

            _timestamp = timestamp
        }

        return self
    }

    @objc
    static func resultWithText(_ text: String!, rawBytes: ZXByteArray!, resultPoints: NSArray!, format: ZXBarcodeFormat) -> AnyObject? {
        return self.init(text: text, rawBytes: rawBytes, resultPoints: resultPoints, format: format)
    }
    @objc
    static func resultWithText(_ text: String!, rawBytes: ZXByteArray!, numBits: CInt, resultPoints: NSArray!, format: ZXBarcodeFormat) -> AnyObject? {
        return self.init(text: text, rawBytes: rawBytes, numBits: numBits, resultPoints: resultPoints, format: format)
    }
    @objc
    static func resultWithText(_ text: String!, rawBytes: ZXByteArray!, resultPoints: NSArray!, format: ZXBarcodeFormat, timestamp: CLong) -> AnyObject? {
        return self.init(text: text, rawBytes: rawBytes, resultPoints: resultPoints, format: format, timestamp: timestamp)
    }
    @objc
    static func resultWithText(_ text: String!, rawBytes: ZXByteArray!, numBits: CInt, resultPoints: NSArray!, format: ZXBarcodeFormat, timestamp: CLong) -> AnyObject? {
        return self.init(text: text, rawBytes: rawBytes, numBits: numBits, resultPoints: resultPoints, format: format, timestamp: timestamp)
    }
    @objc
    func putMetadata(_ type: ZXResultMetadataType, value: AnyObject!) {
        if self.resultMetadata == nil {
            self.resultMetadata = NSMutableDictionary()
        }

        self.resultMetadata[type] = value
    }
    @objc
    func putAllMetadata(_ metadata: NSMutableDictionary!) {
        if metadata != nil {
            if self.resultMetadata == nil {
                self.resultMetadata = metadata
            } else {
                self.resultMetadata.addEntriesFromDictionary(metadata)
            }
        }
    }
    @objc
    func addResultPoints(_ newPoints: NSArray!) {
        if self.resultPoints == nil {
            self.resultPoints = newPoints.mutableCopy()
        } else if newPoints != nil && newPoints.count > 0 {
            self.resultPoints.addObjects(from: newPoints)
        }
    }
    @objc
    func description() -> String? {
        return self.text
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
extension ZXResult {
    @objc var resultMetadata: NSMutableDictionary! {
        get {
            return self._resultMetadata
        }
        set {
            self._resultMetadata = newValue
        }
    }
    @objc var resultPoints: NSMutableArray! {
        get {
            return self._resultPoints
        }
        set {
            self._resultPoints = newValue
        }
    }
}