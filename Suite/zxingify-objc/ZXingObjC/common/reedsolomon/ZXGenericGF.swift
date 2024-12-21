import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXGenericGF.h"
// #import "ZXGenericGFPoly.h"
// #import "ZXIntArray.h"
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
 * This class contains utility methods for performing mathematical operations over
 * the Galois Fields. Operations use a given primitive polynomial in calculations.
 *
 * Throughout this package, elements of the GF are represented as an int
 * for convenience and speed (but at the cost of memory).
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
 * This class contains utility methods for performing mathematical operations over
 * the Galois Fields. Operations use a given primitive polynomial in calculations.
 *
 * Throughout this package, elements of the GF are represented as an int
 * for convenience and speed (but at the cost of memory).
 */
@objc
class ZXGenericGF: NSObject {
    private var _one: ZXGenericGFPoly!
    private var _zero: ZXGenericGFPoly!
    private unowned(unsafe) var _expTable: UnsafeMutablePointer<int32_t>!
    private unowned(unsafe) var _logTable: UnsafeMutablePointer<int32_t>!
    private var _primitive: CInt = 0
    private var _size: int32_t
    private var _generatorBase: int32_t
    @objc var zero: ZXGenericGFPoly!
    @objc var one: ZXGenericGFPoly!
    @objc var size: int32_t {
        return self._size
    }
    @objc var generatorBase: int32_t {
        return self._generatorBase
    }

    @objc
    init(primitive: CInt, size: CInt, b: CInt) {
        if self = super.init() {
            _primitive = primitive

            _size = size

            _generatorBase = b

            _expTable = calloc(self.size, MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>

            _logTable = calloc(self.size, MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>

            var x: int32_t = 1
            var i: CInt = 0

            while i < self.size {
                defer {
                    i += 1
                }

                _expTable[i] = x
                x <<= 1 // we're assuming the generator alpha is 2

                if x >= self.size {
                    x ^= self.primitive as? int32_t
                    x &= self.size as int32_t - 1
                }
            }

            var i: int32_t = 0

            while i < self.size as int32_t - 1 {
                defer {
                    i += 1
                }

                _logTable[_expTable[i]] = i
            }

            // logTable[0] == 0 but this should never be used
            _zero = ZXGenericGFPoly(field: self, coefficients: ZXIntArray(length: 1))
            _one = ZXGenericGFPoly(field: self, coefficients: ZXIntArray(ints: 1, 1))
        }

        return self
    }

    @objc
    static func AztecData12() -> ZXGenericGF? {
        var AztecData12: ZXGenericGF! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            AztecData12 = ZXGenericGF(primitive: 0x1069, size: 4096, b: 1) // x^12 + x^6 + x^5 + x^3 + 1
        }

        return AztecData12
    }
    @objc
    static func AztecData10() -> ZXGenericGF? {
        var AztecData10: ZXGenericGF! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            AztecData10 = ZXGenericGF(primitive: 0x409, size: 1024, b: 1) // x^10 + x^3 + 1
        }

        return AztecData10
    }
    @objc
    static func AztecData6() -> ZXGenericGF? {
        var AztecData6: ZXGenericGF! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            AztecData6 = ZXGenericGF(primitive: 0x43, size: 64, b: 1) // x^6 + x + 1
        }

        return AztecData6
    }
    @objc
    static func AztecParam() -> ZXGenericGF? {
        var AztecParam: ZXGenericGF! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            AztecParam = ZXGenericGF(primitive: 0x13, size: 16, b: 1) // x^4 + x + 1
        }

        return AztecParam
    }
    @objc
    static func QrCodeField256() -> ZXGenericGF? {
        var QrCodeField256: ZXGenericGF! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            QrCodeField256 = ZXGenericGF(primitive: 0x11d, size: 256, b: 0) // x^8 + x^4 + x^3 + x^2 + 1
        }

        return QrCodeField256
    }
    @objc
    static func DataMatrixField256() -> ZXGenericGF? {
        var DataMatrixField256: ZXGenericGF! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            DataMatrixField256 = ZXGenericGF(primitive: 0x12d, size: 256, b: 1) // x^8 + x^5 + x^3 + x^2 + 1
        }

        return DataMatrixField256
    }
    @objc
    static func AztecData8() -> ZXGenericGF? {
        return self.DataMatrixField256()
    }
    @objc
    static func MaxiCodeField64() -> ZXGenericGF? {
        return self.AztecData6()
    }
    /**
 * @return the monomial representing coefficient * x^degree
 */
    /**
 * @return the monomial representing coefficient * x^degree
 */
    @objc
    func buildMonomial(_ degree: CInt, coefficient: int32_t) -> ZXGenericGFPoly? {
        if degree < 0 {
            NSException.raise(NSInvalidArgumentException, format: "Degree must be greater than 0.")
        }

        if coefficient == 0 {
            return self.zero
        }

        let coefficients = ZXIntArray(length: CUnsignedInt(degree + 1))

        coefficients.array[0] = coefficient

        return ZXGenericGFPoly(field: self, coefficients: coefficients)
    }
    /**
 * Implements both addition and subtraction -- they are the same in GF(size).
 *
 * @return sum/difference of a and b
 */
    /**
 * Implements both addition and subtraction -- they are the same in GF(size).
 *
 * @return sum/difference of a and b
 */
    @objc
    static func addOrSubtract(_ a: int32_t, b: int32_t) -> int32_t {
        return a ^ b
    }
    /**
 * @return 2 to the power of a in GF(size)
 */
    /**
 * @return 2 to the power of a in GF(size)
 */
    @objc
    func exp(_ a: CInt) -> int32_t {
        return _expTable[a]
    }
    /**
 * @return base 2 log of a in GF(size)
 */
    /**
 * @return base 2 log of a in GF(size)
 */
    @objc
    func log(_ a: CInt) -> int32_t {
        if a == 0 {
            NSException.raise(NSInvalidArgumentException, format: "Argument must be non-zero.")
        }

        return _logTable[a]
    }
    /**
 * @return multiplicative inverse of a
 */
    /**
 * @return multiplicative inverse of a
 */
    @objc
    func inverse(_ a: CInt) -> int32_t {
        if a == 0 {
            NSException.raise(NSInvalidArgumentException, format: "Argument must be non-zero.")
        }

        return _expTable[_size - _logTable[a] - 1]
    }
    /**
 * @return product of a and b in GF(size)
 */
    /**
 * @return product of a and b in GF(size)
 */
    @objc
    func multiply(_ a: CInt, b: CInt) -> int32_t {
        if a == 0 || b == 0 {
            return 0
        }

        return _expTable[(_logTable[a] + _logTable[b]) % (_size - 1)]
    }
    @objc
    func isEqual(_ object: ZXGenericGF!) -> Bool {
        return self.primitive == object.primitive && self.size == object.size
    }
    @objc
    func description() -> String? {
        return String(format: "GF(0x%X,%d)", self.primitive, self.size)
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
extension ZXGenericGF {
    @objc unowned(unsafe) var expTable: UnsafeMutablePointer<int32_t>! {
        return self._expTable
    }
    @objc unowned(unsafe) var logTable: UnsafeMutablePointer<int32_t>! {
        return self._logTable
    }
    @objc var primitive: CInt {
        return self._primitive
    }
}