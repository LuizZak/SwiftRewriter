// Preprocessor directives found in file:
// #import "ZXIntArray.h"
// #import "ZXModulusGF.h"
// #import "ZXModulusPoly.h"
// #import "ZXPDF417Common.h"
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
 * A field based on powers of a generator integer, modulo some modulus.
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
 * A field based on powers of a generator integer, modulo some modulus.
 */
@objc
class ZXModulusGF: NSObject {
    private unowned(unsafe) var _expTable: UnsafeMutablePointer<int32_t>!
    private unowned(unsafe) var _logTable: UnsafeMutablePointer<int32_t>!
    private var _modulus: CInt = 0
    private var _one: ZXModulusPoly!
    private var _zero: ZXModulusPoly!
    @objc var one: ZXModulusPoly! {
        return self._one
    }
    @objc var zero: ZXModulusPoly! {
        return self._zero
    }

    @objc
    init(modulus: CInt, generator: CInt) {
        if self = super.init() {
            _modulus = modulus
            _expTable = calloc(self.modulus, MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>
            _logTable = calloc(self.modulus, MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>

            var x: int32_t = 1
            var i: CInt = 0

            while i < modulus {
                defer {
                    i += 1
                }

                _expTable[i] = x
                x = (x * generator) % modulus
            }

            var i: CInt = 0

            while i < self.size - 1 {
                defer {
                    i += 1
                }

                _logTable[_expTable[i]] = i
            }

            // logTable[0] == 0 but this should never be used
            _zero = ZXModulusPoly(field: self, coefficients: ZXIntArray(length: 1))
            _one = ZXModulusPoly(field: self, coefficients: ZXIntArray(ints: 1, 1))
        }

        return self
    }

    @objc
    static func PDF417_GF() -> ZXModulusGF? {
        var pred: dispatch_once_t = 0
        var _mod: AnyObject! = nil

        dispatch_once(&pred) { () -> Void in
            autoreleasepool { () -> Void in
                _mod = ZXModulusGF(modulus: ZX_PDF417_NUMBER_OF_CODEWORDS, generator: 3)
            }
        }

        return _mod
    }
    @objc
    func buildMonomial(_ degree: CInt, coefficient: CInt) -> ZXModulusPoly? {
        if degree < 0 {
            NSException.raise(NSInvalidArgumentException, format: "Degree must be greater than 0.")
        }

        if coefficient == 0 {
            return self.zero
        }

        let coefficients = ZXIntArray(length: CUnsignedInt(degree + 1))

        coefficients.array[0] = coefficient

        return ZXModulusPoly(field: self, coefficients: coefficients)
    }
    @objc
    func add(_ a: CInt, b: CInt) -> CInt {
        return (a + b) % self.modulus
    }
    @objc
    func subtract(_ a: CInt, b: CInt) -> CInt {
        return (self.modulus + a - b) % self.modulus
    }
    @objc
    func exp(_ a: CInt) -> CInt {
        return _expTable[a]
    }
    @objc
    func log(_ a: CInt) -> CInt {
        if a == 0 {
            NSException.raise(NSInvalidArgumentException, format: "Argument must be non-zero.")
        }

        return _logTable[a]
    }
    @objc
    func inverse(_ a: CInt) -> CInt {
        if a == 0 {
            NSException.raise(NSInvalidArgumentException, format: "Argument must be non-zero.")
        }

        return _expTable[_modulus - _logTable[a] - 1]
    }
    @objc
    func multiply(_ a: CInt, b: CInt) -> CInt {
        if a == 0 || b == 0 {
            return 0
        }

        return _expTable[(_logTable[a] + _logTable[b]) % (_modulus - 1)]
    }
    @objc
    func size() -> CInt {
        return self.modulus
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
extension ZXModulusGF {
    @objc unowned(unsafe) var expTable: UnsafeMutablePointer<int32_t>! {
        return self._expTable
    }
    @objc unowned(unsafe) var logTable: UnsafeMutablePointer<int32_t>! {
        return self._logTable
    }
    @objc var modulus: CInt {
        return self._modulus
    }
}