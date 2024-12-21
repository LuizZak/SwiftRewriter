import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXByteArray.h"
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
class ZXByteArray: NSObject {
    private unowned(unsafe) var _array: UnsafeMutablePointer<int8_t>!
    private var _length: CUnsignedInt = 0
    @objc unowned(unsafe) var array: UnsafeMutablePointer<int8_t>! {
        return self._array
    }
    @objc var length: CUnsignedInt {
        return self._length
    }

    @objc
    init(length: CUnsignedInt) {
        if self = super.init() {
            if length > 0 {
                _array = calloc(length, MemoryLayout.size(ofValue: int8_t)) as? UnsafeMutablePointer<int8_t>
            } else {
                _array = nil
            }

            _length = length
        }

        return self
    }
    @objc
    init(array: UnsafeMutablePointer<int8_t>!, length: CUnsignedInt) {
        if self = super.init() {
            _array = array
            _length = length
        }

        return self
    }
    @objc
    convenience init(length: CUnsignedInt, bytes byte1: CInt) {
        if (self = self.init(length: length)) && (length > 0) {
            let args: va_list

            va_start(args, byte1)
            _array[0] = byte1 as? int8_t

            var i: CInt = 1

            while i < length {
                defer {
                    i += 1
                }

                let byte = 

                args

                _array[i] = byte as? int8_t
            }

            va_end(args)
        }

        return self
    }
    @objc
    convenience init(bytes byte1: CInt) {
        let args: va_list

        va_start(args, byte1)

        var length: CUnsignedInt = 0
        var byte: int8_t = byte1

        while byte != 1 {
            defer {
                byte = 
            }

        }

        args


        length += 1
        va_end(args)

        if (self = self.init(length: length)) && (length > 0) {
            let args: va_list

            va_start(args, byte1)

            var i: CInt = 0
            var byte: int8_t = byte1

            while byte != 1 {
                defer {
                    byte = 
                }

            }

            args


            _array[i += 1] = byte
            va_end(args)
        }

        return self
    }

    deinit {
        if _array {
            free(_array)
        }
    }

    @objc
    func description() -> String? {
        let s: NSMutableString! = NSMutableString(format: "length=%u, array=(", self.length)
        var i: CInt = 0

        while i < self.length {
            defer {
                i += 1
            }

            s.appendFormat("%hhx", self.array[i])

            if i < self.length - 1 {
                s.append(", ")
            }
        }

        s.append(")")

        return s
    }
}