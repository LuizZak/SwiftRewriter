import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXPDF417Dimensions.h"
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
 * Data object to specify the minimum and maximum number of rows and columns for a PDF417 barcode.
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
 * Data object to specify the minimum and maximum number of rows and columns for a PDF417 barcode.
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
class ZXPDF417Dimensions: NSObject {
    private var _minCols: CInt = 0
    private var _maxCols: CInt = 0
    private var _minRows: CInt = 0
    private var _maxRows: CInt = 0
    @objc var minCols: CInt {
        return self._minCols
    }
    @objc var maxCols: CInt {
        return self._maxCols
    }
    @objc var minRows: CInt {
        return self._minRows
    }
    @objc var maxRows: CInt {
        return self._maxRows
    }

    @objc
    init(minCols: CInt, maxCols: CInt, minRows: CInt, maxRows: CInt) {
        if self = super.init() {
            _minCols = minCols

            _maxCols = maxCols

            _minRows = minRows

            _maxRows = maxRows
        }

        return self
    }
}