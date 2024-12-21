// Preprocessor directives found in file:
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
 * Represents a polynomial whose coefficients are elements of a GF.
 * Instances of this class are immutable.
 *
 * Much credit is due to William Rucklidge since portions of this code are an indirect
 * port of his C++ Reed-Solomon implementation.
 */
@objc
class ZXGenericGFPoly: NSObject {
    private var _field: ZXGenericGF!
    private var _coefficients: ZXIntArray!
    @objc var coefficients: ZXIntArray! {
        return self._coefficients
    }

    @objc
    init(field: ZXGenericGF!, coefficients: ZXIntArray!) {
        if self = super.init() {
            if coefficients.length == 0 {
                /*
                @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"coefficients must have at least one element"userInfo:nil];
                */
            }

            _field = field

            let coefficientsLength: CInt = CInt(coefficients.length)

            if coefficientsLength > 1 && coefficients.array[0] == 0 {
                // Leading term must be non-zero for anything except the constant polynomial "0"
                var firstNonZero: CInt = 1

                while firstNonZero < coefficientsLength && coefficients.array[firstNonZero] == 0 {
                    firstNonZero += 1
                }

                if firstNonZero == coefficientsLength {
                    _coefficients = ZXIntArray(length: 1)
                } else {
                    _coefficients = ZXIntArray(length: CUnsignedInt(coefficientsLength - firstNonZero))

                    var i: CInt = 0

                    while i < _coefficients.length {
                        defer {
                            i += 1
                        }

                        _coefficients.array[i] = coefficients.array[firstNonZero + i]
                    }
                }
            } else {
                _coefficients = coefficients
            }
        }

        return self
    }

    /**
 * @return degree of this polynomial
 */
    @objc
    func degree() -> CInt {
        return CInt((self.coefficients.length ?? 0) - 1)
    }
    /**
 * @return true iff this polynomial is the monomial "0"
 */
    @objc
    func zero() -> Bool {
        return self.coefficients.array[0] == 0
    }
    /**
 * @return coefficient of x^degree term in this polynomial
 */
    @objc
    func coefficient(_ degree: CInt) -> CInt {
        return self.coefficients.array[(self.coefficients.length ?? 0) - 1 - degree]
    }
    /**
 * @return evaluation of this polynomial at a given point
 */
    @objc
    func evaluateAt(_ a: CInt) -> CInt {
        if a == 0 {
            return self.coefficient(0)
        }

        let size: CInt = CInt(CInt(self.coefficients.length ?? 0))
        let coefficients = self.coefficients.array
        let field = self.field

        if a == 1 {
            // Just the sum of the coefficients
            var result: CInt = 0
            var i: CInt = 0

            while i < size {
                defer {
                    i += 1
                }

                result = ZXGenericGF.addOrSubtract(result, b: coefficients?[i])
            }

            return result
        }

        var result: CInt = coefficients?[0]
        var i: CInt = 1

        while i < size {
            defer {
                i += 1
            }

            result = ZXGenericGF.addOrSubtract(field?.multiply(a, b: result), b: coefficients?[i])
        }

        return result
    }
    @objc
    func addOrSubtract(_ other: ZXGenericGFPoly!) -> ZXGenericGFPoly? {
        if self.field.isEqual(other.field) != true {
            NSException.raise(NSInvalidArgumentException, format: "ZXGenericGFPolys do not have same ZXGenericGF field")
        }

        if self.zero {
            return other
        }

        if other.zero {
            return self
        }

        var smallerCoefficients = self.coefficients
        var largerCoefficients = other.coefficients

        if (smallerCoefficients?.length ?? 0) > (largerCoefficients?.length ?? 0) {
            let temp = smallerCoefficients

            smallerCoefficients = largerCoefficients
            largerCoefficients = temp
        }

        let sumDiff = ZXIntArray(length: largerCoefficients?.length ?? 0)
        let lengthDiff: CInt = CInt((largerCoefficients?.length ?? 0) - (smallerCoefficients?.length ?? 0))

        // Copy high-order terms only found in higher-degree polynomial's coefficients
        memcpy(sumDiff.array, largerCoefficients?.array, Int(lengthDiff) * MemoryLayout.size(ofValue: int32_t))

        var i = lengthDiff

        while i < (largerCoefficients?.length ?? 0) {
            defer {
                i += 1
            }

            sumDiff.array[i] = ZXGenericGF.addOrSubtract(smallerCoefficients?.array[i - lengthDiff], b: largerCoefficients?.array[i])
        }

        return ZXGenericGFPoly(field: self.field, coefficients: sumDiff)
    }
    @objc
    func multiply(_ other: ZXGenericGFPoly!) -> ZXGenericGFPoly? {
        let field = self.field

        if self.field.isEqual(other.field) != true {
            NSException.raise(NSInvalidArgumentException, format: "ZXGenericGFPolys do not have same GenericGF field")
        }

        if self.zero || other.zero {
            return field?.zero
        }

        let aCoefficients = self.coefficients
        let aLength: CInt = CInt(CInt(aCoefficients?.length ?? 0))
        let bCoefficients = other.coefficients
        let bLength: CInt = CInt(CInt(bCoefficients?.length ?? 0))
        let product = ZXIntArray(length: CUnsignedInt(aLength + bLength - 1))
        var i: CInt = 0

        while i < aLength {
            defer {
                i += 1
            }

            let aCoeff: CInt = aCoefficients?.array[i]
            var j: CInt = 0

            while j < bLength {
                defer {
                    j += 1
                }

                product.array[i + j] = ZXGenericGF.addOrSubtract(product.array[i + j], b: field?.multiply(aCoeff, b: bCoefficients?.array[j]))
            }
        }

        return ZXGenericGFPoly(field: field, coefficients: product)
    }
    @objc
    func multiplyScalar(_ scalar: CInt) -> ZXGenericGFPoly? {
        if scalar == 0 {
            return self.field.zero
        }

        if scalar == 1 {
            return self
        }

        let size: CInt = CInt(CInt(self.coefficients.length ?? 0))
        let coefficients = self.coefficients.array
        let product = ZXIntArray(length: CUnsignedInt(size))
        var i: CInt = 0

        while i < size {
            defer {
                i += 1
            }

            product.array[i] = self.field.multiply(coefficients?[i], b: scalar)
        }

        return ZXGenericGFPoly(field: self.field, coefficients: product)
    }
    @objc
    func multiplyByMonomial(_ degree: CInt, coefficient: CInt) -> ZXGenericGFPoly? {
        if degree < 0 {
            NSException.raise(NSInvalidArgumentException, format: "Degree must be greater than 0.")
        }

        if coefficient == 0 {
            return self.field.zero
        }

        let size: CInt = CInt(CInt(self.coefficients.length ?? 0))
        let coefficients = self.coefficients.array
        let field = self.field
        let product = ZXIntArray(length: CUnsignedInt(size + degree))
        var i: CInt = 0

        while i < size {
            defer {
                i += 1
            }

            product.array[i] = field?.multiply(coefficients?[i], b: coefficient)
        }

        return ZXGenericGFPoly(field: field, coefficients: product)
    }
    @objc
    func divide(_ other: ZXGenericGFPoly!) -> NSArray {
        if self.field.isEqual(other.field) != true {
            NSException.raise(NSInvalidArgumentException, format: "ZXGenericGFPolys do not have same ZXGenericGF field")
        }

        if other.zero {
            NSException.raise(NSInvalidArgumentException, format: "Divide by 0")
        }

        var quotient = self.field.zero
        var remainder: ZXGenericGFPoly! = self
        let denominatorLeadingTerm = other.coefficient(other.degree)
        let inverseDenominatorLeadingTerm: CInt = self.field.inverse(denominatorLeadingTerm)
        let field = self.field

        while remainder.degree() >= other.degree && !remainder.zero {
            let degreeDifference = remainder.degree - other.degree
            let scale: CInt = field?.multiply(remainder.coefficient(remainder.degree), b: inverseDenominatorLeadingTerm)
            let term = other.multiplyByMonomial(degreeDifference, coefficient: scale)
            let iterationQuotient = field?.buildMonomial(degreeDifference, coefficient: scale)

            quotient = quotient?.addOrSubtract(iterationQuotient)
            remainder = remainder.addOrSubtract(term)
        }

        return [quotient, remainder]
    }
    @objc
    func description() -> String? {
        if self.zero {
            return "0"
        }

        let result = NSMutableString(capacity: Int(8 * self.degree()))
        var degree = self.degree()

        while degree >= 0 {
            defer {
                degree -= 1
            }

            var coefficient = self.coefficient(degree)

            if coefficient != 0 {
                if coefficient < 0 {
                    if degree == self.degree() {
                        result.append("-")
                    } else {
                        result.append(" - ")
                    }

                    coefficient = -coefficient
                } else if result.length() > 0 {
                    result.append(" + ")
                }

                if degree == 0 || coefficient != 1 {
                    let alphaPower: CInt = self.field.log(coefficient)

                    if alphaPower == 0 {
                        result.append("1")
                    } else if alphaPower == 1 {
                        result.append("a")
                    } else {
                        result.append("a^")
                        result.appendFormat("%d", alphaPower)
                    }
                }

                if degree != 0 {
                    if degree == 1 {
                        result.append("x")
                    } else {
                        result.append("x^")
                        result.appendFormat("%d", degree)
                    }
                }
            }
        }

        return result
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
extension ZXGenericGFPoly {
    @objc var field: ZXGenericGF! {
        return self._field
    }
}