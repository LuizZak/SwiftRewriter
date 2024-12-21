import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXByteMatrix.h"
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
class ZXByteMatrix: NSObject {
    private unowned(unsafe) var _array: UnsafeMutablePointer<UnsafeMutablePointer<int8_t>?>!
    private var _height: CInt = 0
    private var _width: CInt = 0
    @objc unowned(unsafe) var array: UnsafeMutablePointer<UnsafeMutablePointer<int8_t>?>! {
        return self._array
    }
    @objc var height: CInt {
        return self._height
    }
    @objc var width: CInt {
        return self._width
    }

    @objc
    init(width: CInt, height: CInt) {
        if self = super.init() {
            _width = width
            _height = height
            _array = malloc(Int(height) * MemoryLayout.size(ofValue: int8_t * )) as? UnsafeMutablePointer<UnsafeMutablePointer<int8_t>>

            var i: CInt = 0

            while i < height {
                defer {
                    i += 1
                }

                _array[i] = malloc(Int(width) * MemoryLayout.size(ofValue: int8_t)) as? UnsafeMutablePointer<int8_t>
            }

            self.clear(0)
        }

        return self
    }

    deinit {
        if _array != nil {
            var i: CInt = 0

            while i < self.height {
                defer {
                    i += 1
                }

                free(_array[i])
            }

            free(_array)
            _array = nil
        }
    }

    @objc
    func getX(_ x: CInt, y: CInt) -> int8_t {
        return self.array[y][x]
    }
    @objc
    func setX(_ x: CInt, y: CInt, byteValue value: int8_t) {
        self.array[y][x] = value
    }
    @objc
    func setX(_ x: CInt, y: CInt, intValue value: CInt) {
        self.array[y][x] = value as? int8_t
    }
    @objc
    func setX(_ x: CInt, y: CInt, boolValue value: Bool) {
        self.array[y][x] = value as? int8_t
    }
    @objc
    func clear(_ value: int8_t) {
        var y: CInt = 0

        while y < self.height {
            defer {
                y += 1
            }

            var x: CInt = 0

            while x < self.width {
                defer {
                    x += 1
                }

                self.array[y][x] = value
            }
        }
    }
    @objc
    func description() -> String? {
        let result = NSMutableString()
        var y: CInt = 0

        while y < self.height {
            defer {
                y += 1
            }

            var x: CInt = 0

            while x < self.width {
                defer {
                    x += 1
                }

                switch self.array[y][x] {
                case 0:
                    result.append(" 0")
                case 1:
                    result.append(" 1")
                default:
                    result.append("  ")
                }
            }

            result.append("\\n")
        }

        return result
    }
}