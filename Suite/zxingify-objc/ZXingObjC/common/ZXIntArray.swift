import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXIntArray.h"
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
class ZXIntArray: NSObject, NSCopying {
    private unowned(unsafe) var _array: UnsafeMutablePointer<int32_t>!
    private var _length: CUnsignedInt = 0
    @objc unowned(unsafe) var array: UnsafeMutablePointer<int32_t>! {
        return self._array
    }
    @objc var length: CUnsignedInt {
        return self._length
    }

    @objc
    init(length: CUnsignedInt) {
        if self = super.init() {
            if length > 0 {
                _array = calloc(length, MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>
            } else {
                _array = nil
            }

            _length = length
        }

        return self
    }
    @objc
    convenience init(ints int1: int32_t) {
        let args: va_list

        va_start(args, int1)

        var length: CUnsignedInt = 0
        var i = int1

        while i != 1 {
            defer {
                i = 
            }

        }

        args


        length += 1
        va_end(args)

        if (self = self.init(length: length)) && (length > 0) {
            let args: va_list

            va_start(args, int1)

            var i: CInt = 0
            var c = int1

            while c != 1 {
                defer {
                    c = 
                }

            }

            args


            _array[i += 1] = c
            va_end(args)
        }

        return self
    }

    deinit {
        if _array != nil {
            free(_array)
        }
    }

    @objc
    func isEqual(_ o: AnyObject) -> Bool {
        if !o.isKindOfClass(type(of: self)) {
            return false
        }

        let other = o as? ZXIntArray

        if other == self {
            return true
        }

        if other?.length != self.length {
            return false
        }

        var i: CInt = 0

        while i < self.length {
            defer {
                i += 1
            }

            if other?.array[i] != self.array[i] {
                return false
            }
        }

        return true
    }
    @objc
    func copyWithZone(_ zone: UnsafeMutablePointer<NSZone>!) -> AnyObject? {
        let copy: ZXIntArray! = ZXIntArray.allocWithZone(zone).init(length: self.length)

        memcpy(copy.array, self.array, Int(self.length) * MemoryLayout.size(ofValue: int32_t))

        return copy
    }
    @objc
    func clear() {
        memset(self.array, 0, Int(self.length) * MemoryLayout.size(ofValue: int32_t))
    }
    @objc
    func sum() -> CInt {
        var sum: CInt = 0
        let array = self.array
        var i: CInt = 0

        while i < self.length {
            defer {
                i += 1
            }

            sum += array?[i]
        }

        return sum
    }
    @objc
    func description() -> String? {
        let s: NSMutableString! = NSMutableString(format: "length=%u, array=(", self.length)
        var i: CInt = 0

        while i < self.length {
            defer {
                i += 1
            }

            s.appendFormat("%d", self.array[i])

            if i < self.length - 1 {
                s.append(", ")
            }
        }

        s.append(")")

        return s
    }
}