import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXBoolArray.h"
/*
 * Copyright 2014 ZXing authors
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
 * Copyright 2014 ZXing authors
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
 * Copyright 2014 ZXing authors
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
class ZXBoolArray: NSObject {
    private unowned(unsafe) var _array: UnsafeMutablePointer<Bool>!
    private var _length: CUnsignedInt = 0
    @objc unowned(unsafe) var array: UnsafeMutablePointer<Bool>! {
        return self._array
    }
    @objc var length: CUnsignedInt {
        return self._length
    }

    @objc
    init(length: CUnsignedInt) {
        if self = super.init() {
            _array = calloc(length, MemoryLayout.size(ofValue: BOOL)) as? UnsafeMutablePointer<Bool>
            _length = length
        }

        return self
    }
    @objc
    convenience init(length: CUnsignedInt, values value1: CInt) {
        if (self = self.init(length: length)) && (length > 0) {
            let args: va_list

            va_start(args, value1)
            _array[0] = (value1 == 1) ? true : false

            var i: CInt = 1

            while i < length {
                defer {
                    i += 1
                }

                let value = 

                args

                _array[i] = (value == 1) ? true : false
            }

            va_end(args)
        }

        return self
    }

    deinit {
        if _array {
            free(_array)
        }
    }
}