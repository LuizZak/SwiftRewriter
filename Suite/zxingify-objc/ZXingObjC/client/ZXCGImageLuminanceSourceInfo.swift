import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXCGImageLuminanceSourceInfo.h"
/*
 * Copyright 2018 ZXing contributors
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
enum ZXCGImageLuminanceSourceType: CInt {
    case ZXCGImageLuminanceSourceNormal = 0
    case ZXCGImageLuminanceSourceLuma
    case ZXCGImageLuminanceSourceShades
    case ZXCGImageLuminanceSourceDigital
    case ZXCGImageLuminanceSourceDecomposingMax
    case ZXCGImageLuminanceSourceDecomposingMin
}

/*
 * Copyright 2018 ZXing contributors
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
class ZXCGImageLuminanceSourceInfo: NSObject {
    private var _numberOfShades: uint32_t
    private var _type: ZXCGImageLuminanceSourceType = ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceNormal
    @objc var numberOfShades: uint32_t {
        return self._numberOfShades
    }
    @objc var type: ZXCGImageLuminanceSourceType {
        return self._type
    }

    @objc
    init(shades numberOfShades: uint32_t) {
        _type = ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceShades
        _numberOfShades = numberOfShades
        super.init()
    }
    @objc
    init() {
    }

    @objc
    func initWithNormal() -> ZXCGImageLuminanceSourceInfo {
        self = super.init()

        if self {
            _type = ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceNormal
        }

        return self
    }
    @objc
    func initWithLuma() -> ZXCGImageLuminanceSourceInfo {
        self = super.init()

        if self {
            _type = ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceLuma
        }

        return self
    }
    @objc
    func initWithDigital() -> ZXCGImageLuminanceSourceInfo {
        self = super.init()

        if self {
            _type = ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceDigital
        }

        return self
    }
    @objc
    func initWithDecomposingMax() -> ZXCGImageLuminanceSourceInfo {
        self = super.init()

        if self {
            _type = ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceDecomposingMax
        }

        return self
    }
    @objc
    func initWithDecomposingMin() -> ZXCGImageLuminanceSourceInfo {
        self = super.init()

        if self {
            _type = ZXCGImageLuminanceSourceType.ZXCGImageLuminanceSourceDecomposingMin
        }

        return self
    }
}