import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXPDF417BarcodeMetadata.h"
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
class ZXPDF417BarcodeMetadata: NSObject {
    private var _columnCount: CInt = 0
    private var _errorCorrectionLevel: CInt = 0
    private var _rowCountUpperPart: CInt = 0
    private var _rowCountLowerPart: CInt = 0
    private var _rowCount: CInt = 0
    @objc var columnCount: CInt {
        return self._columnCount
    }
    @objc var errorCorrectionLevel: CInt {
        return self._errorCorrectionLevel
    }
    @objc var rowCountUpperPart: CInt {
        return self._rowCountUpperPart
    }
    @objc var rowCountLowerPart: CInt {
        return self._rowCountLowerPart
    }
    @objc var rowCount: CInt {
        return self._rowCount
    }

    @objc
    init(columnCount: CInt, rowCountUpperPart: CInt, rowCountLowerPart: CInt, errorCorrectionLevel: CInt) {
        _columnCount = columnCount

        _errorCorrectionLevel = errorCorrectionLevel

        _rowCountUpperPart = rowCountUpperPart

        _rowCountLowerPart = rowCountLowerPart

        _rowCount = rowCountUpperPart + rowCountLowerPart

        super.init()
    }
}