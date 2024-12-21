import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXDimension.h"
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
/**
 * Simply encapsulates a width and height.
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
/**
 * Simply encapsulates a width and height.
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
class ZXDimension: NSObject {
    private var _height: CInt = 0
    private var _width: CInt = 0
    @objc var height: CInt {
        return self._height
    }
    @objc var width: CInt {
        return self._width
    }

    @objc
    init(width: CInt, height: CInt) {
        if width < 0 || height < 0 {
            NSException.raise(NSInvalidArgumentException, format: "Width and height must not be negative")
        }

        if self = super.init() {
            _width = width
            _height = height
        }

        return self
    }

    @objc
    func isEqual(_ other: AnyObject) -> Bool {
        if other.isKindOfClass(ZXDimension.self) {
            let d = other as? ZXDimension

            return self.width == d?.width && self.height == d?.height
        }

        return false
    }
    @objc
    func hash() -> UInt {
        return UInt(self.width * 32713 + self.height)
    }
    @objc
    func description() -> String? {
        return String(format: "%dx%d", self.width, self.height)
    }
}