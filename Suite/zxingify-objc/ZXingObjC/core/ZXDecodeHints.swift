import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXBarcodeFormat.h"
// #import "ZXDecodeHints.h"
// #import "ZXResultPointCallback.h"
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
 * Encapsulates hints that a caller may pass to a barcode reader to help it
 * more quickly or accurately decode it. It is up to implementations to decide what,
 * if anything, to do with the information that is supplied.
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
 * Encapsulates hints that a caller may pass to a barcode reader to help it
 * more quickly or accurately decode it. It is up to implementations to decide what,
 * if anything, to do with the information that is supplied.
 */
@objc
class ZXDecodeHints: NSObject, NSCopying {
    private var _barcodeFormats: NSMutableArray!
    /**
 * Assume Code 39 codes employ a check digit.
 */
    @objc var assumeCode39CheckDigit: Bool = false
    /**
 * Assume the barcode is being processed as a GS1 barcode, and modify behavior as needed.
 * For example this affects FNC1 handling for Code 128 (aka GS1-128).
 */
    @objc var assumeGS1: Bool = false
    /**
 * Allowed lengths of encoded data -- reject anything else.
 */
    @objc var allowedLengths: NSArray!
    /**
 * Specifies what character encoding to use when decoding, where applicable (type String)
 */
    @objc var encoding: NSStringEncoding
    /**
 * Unspecified, application-specific hint.
 */
    @objc var other: AnyObject!
    /**
 * Image is a pure monochrome image of a barcode.
 */
    @objc var pureBarcode: Bool = false
    /**
 * If true, return the start and end digits in a Codabar barcode instead of stripping them. They
 * are alpha, whereas the rest are numeric. By default, they are stripped, but this causes them
 * to not be.
 */
    @objc var returnCodaBarStartEnd: Bool = false
    /**
 * The caller needs to be notified via callback when a possible ZXResultPoint
 * is found.
 */
    @objc var resultPointCallback: ZXResultPointCallback!
    /**
 * Spend more time to try to find a barcode; optimize for accuracy, not speed.
 */
    @objc var tryHarder: Bool = false
    /**
 * Allowed extension lengths for EAN or UPC barcodes. Other formats will ignore this.
 * Maps to an ZXIntArray of the allowed extension lengths, for example [2], [5], or [2, 5].
 * If it is optional to have an extension, do not set this hint. If this is set,
 * and a UPC or EAN barcode is found but an extension is not, then no result will be returned
 * at all.
 */
    @objc var allowedEANExtensions: ZXIntArray!
    /**
 * Image is known to be of one of a few possible formats.
 */
    @objc var substitutions: NSDictionary!

    @objc
    override init() {
        if self = super.init() {
            _barcodeFormats = NSMutableArray()
        }

        return self
    }

    @objc
    static func hints() -> AnyObject? {
        return self.init()
    }
    @objc
    func copyWithZone(_ zone: UnsafeMutablePointer<NSZone>!) -> AnyObject? {
        let result: ZXDecodeHints! = type(of: self).allocWithZone(zone).init()

        if result {
            result.assumeCode39CheckDigit = self.assumeCode39CheckDigit
            result.allowedLengths = self.allowedLengths.copy()

            for formatNumber in self.barcodeFormats {
                result.addPossibleFormat(formatNumber.intValue())
            }

            result.encoding = self.encoding
            result.other = self.other
            result.pureBarcode = self.pureBarcode
            result.returnCodaBarStartEnd = self.returnCodaBarStartEnd
            result.resultPointCallback = self.resultPointCallback
            result.tryHarder = self.tryHarder
        }

        return result
    }
    @objc
    func addPossibleFormat(_ format: ZXBarcodeFormat) {
        self.barcodeFormats.add(format)
    }
    @objc
    func containsFormat(_ format: ZXBarcodeFormat) -> Bool {
        return self.barcodeFormats.contains(format) == true
    }
    @objc
    func numberOfPossibleFormats() -> CInt {
        return CInt(self.barcodeFormats.count ?? 0)
    }
    @objc
    func removePossibleFormat(_ format: ZXBarcodeFormat) {
        self.barcodeFormats.remove(format)
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
extension ZXDecodeHints {
    @objc var barcodeFormats: NSMutableArray! {
        return self._barcodeFormats
    }
}