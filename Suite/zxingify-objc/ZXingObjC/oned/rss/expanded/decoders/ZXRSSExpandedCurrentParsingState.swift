import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXRSSExpandedCurrentParsingState.h"
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
class ZXRSSExpandedCurrentParsingState: NSObject {
    private var _encoding: CInt = 0
    private var _position: CInt = 0
    @objc var position: CInt {
        get {
            return self._position
        }
        set {
            self._position = newValue
        }
    }

    @objc
    override init() {
        if self = super.init() {
            _position = 0
            _encoding = ZX_NUMERIC_STATE
        }

        return self
    }

    @objc
    func alpha() -> Bool {
        return self.encoding == ZX_ALPHA_STATE
    }
    @objc
    func numeric() -> Bool {
        return self.encoding == ZX_NUMERIC_STATE
    }
    @objc
    func isoIec646() -> Bool {
        return self.encoding == ZX_ISO_IEC_646_STATE
    }
    @objc
    func setNumeric() {
        self.encoding = ZX_NUMERIC_STATE
    }
    @objc
    func setAlpha() {
        self.encoding = ZX_ALPHA_STATE
    }
    @objc
    func setIsoIec646() {
        self.encoding = ZX_ISO_IEC_646_STATE
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
extension ZXRSSExpandedCurrentParsingState {
    @objc var encoding: CInt {
        get {
            return self._encoding
        }
        set {
            self._encoding = newValue
        }
    }
}