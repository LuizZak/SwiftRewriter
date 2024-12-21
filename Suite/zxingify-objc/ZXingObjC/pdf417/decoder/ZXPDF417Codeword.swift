import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXPDF417Codeword.h"
let ZX_PDF417_BARCODE_ROW_UNKNOWN: CInt = 1

/*
 * Copyright 2013 ZXing authors
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
class ZXPDF417Codeword: NSObject {
    private var _startX: CInt = 0
    private var _endX: CInt = 0
    private var _bucket: CInt = 0
    private var _value: CInt = 0
    private var _rowNumber: CInt = 0
    @objc var startX: CInt {
        return self._startX
    }
    @objc var endX: CInt {
        return self._endX
    }
    @objc var bucket: CInt {
        return self._bucket
    }
    @objc var value: CInt {
        return self._value
    }
    @objc var rowNumber: CInt {
        get {
            return self._rowNumber
        }
        set {
            self._rowNumber = newValue
        }
    }

    @objc
    init(startX: CInt, endX: CInt, bucket: CInt, value: CInt) {
        _startX = startX

        _endX = endX

        _bucket = bucket

        _value = value

        _rowNumber = ZX_PDF417_BARCODE_ROW_UNKNOWN

        super.init()
    }

    @objc
    func hasValidRowNumber() -> Bool {
        return self.isValidRowNumber(self.rowNumber)
    }
    @objc
    func isValidRowNumber(_ rowNumber: CInt) -> Bool {
        return rowNumber != ZX_PDF417_BARCODE_ROW_UNKNOWN && self.bucket == (rowNumber % 3) * 3
    }
    @objc
    func setRowNumberAsRowIndicatorColumn() {
        self.rowNumber = (self.value / 30) * 3 + self.bucket / 3
    }
    @objc
    func width() -> CInt {
        return self.endX - self.startX
    }
    @objc
    func description() -> String? {
        return String(format: "%d|%d", self.rowNumber, self.value)
    }
}