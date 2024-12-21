import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXIntArray.h"
// #import "ZXModulusGF.h"
// #import "ZXModulusPoly.h"
// #import "ZXPDF417ECErrorCorrection.h"
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
 * PDF417 error correction implementation.
 *
 * This example <http://en.wikipedia.org/wiki/Reed%E2%80%93Solomon_error_correction#Example>
 * is quite useful in understanding the algorithm.
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
 * PDF417 error correction implementation.
 *
 * This example <http://en.wikipedia.org/wiki/Reed%E2%80%93Solomon_error_correction#Example>
 * is quite useful in understanding the algorithm.
 */
@objc
class ZXPDF417ECErrorCorrection: NSObject {
    private var _field: ZXModulusGF!

    @objc
    override init() {
        if self = super.init() {
            _field = ZXModulusGF.PDF417_GF()
        }

        return self
    }

    /**
 * @param received received codewords
 * @param numECCodewords number of those codewords used for EC
 * @param erasures location of erasures
 * @return number of errors or nil if errors cannot be corrected, maybe because of too many errors
 */
    /**
 * @param received received codewords
 * @param numECCodewords number of those codewords used for EC
 * @param erasures location of erasures
 * @return number of errors or nil if errors cannot be corrected, maybe because of too many errors
 */
    @objc
    func decode(_ received: ZXIntArray!, numECCodewords: CInt, erasures: ZXIntArray!) -> CInt {
        let poly = ZXModulusPoly(field: self.field, coefficients: received)
        let S = ZXIntArray(length: CUnsignedInt(numECCodewords))
        var error = false
        var i = numECCodewords

        while i > 0 {
            defer {
                i -= 1
            }

            let eval = poly.evaluateAt(self.field.exp(i) ?? 0)

            S.array[numECCodewords - i] = eval

            if eval != 0 {
                error = true
            }
        }

        if !error {
            return 0
        }

        var knownErrors = self.field.one

        if erasures {
            var i: CInt = 0

            while i < erasures.length {
                defer {
                    i += 1
                }

                let erasure: CInt = erasures.array[i]
                let b = self.field.exp(CInt(received.length - 1) - erasure) ?? 0
                // Add (1 - bx) term:
                let term = ZXModulusPoly(field: self.field, coefficients: ZXIntArray(ints: self.field.subtract(0, b: b) ?? 0, 1, 1))

                knownErrors = knownErrors?.multiply(term)
            }
        }

        let syndrome = ZXModulusPoly(field: self.field, coefficients: S)
        //[syndrome multiply:knownErrors];
        let sigmaOmega = self.runEuclideanAlgorithm(self.field.buildMonomial(numECCodewords, coefficient: 1), b: syndrome, R: numECCodewords)

        if sigmaOmega == nil {
            return 1
        }

        let sigma: ZXModulusPoly! = sigmaOmega?[0]
        let omega: ZXModulusPoly! = sigmaOmega?[1]
        //sigma = [sigma multiply:knownErrors];
        let errorLocations = self.findErrorLocations(sigma)

        if !errorLocations {
            return 1
        }

        let errorMagnitudes = self.findErrorMagnitudes(omega, errorLocator: sigma, errorLocations: errorLocations)
        var i: CInt = 0

        while i < errorLocations.length {
            defer {
                i += 1
            }

            let position: CInt = CInt(received.length - 1) - (self.field.log(errorLocations.array[i]) ?? 0)

            if position < 0 {
                return 1
            }

            received.array[position] = self.field.subtract(received.array[position], b: errorMagnitudes.array[i])
        }

        return CInt(errorLocations.length)
    }
    @objc
    func runEuclideanAlgorithm(_ a: ZXModulusPoly!, b: ZXModulusPoly!, R: CInt) -> NSArray? {
        // Assume a's degree is >= b's
        if a.degree < b.degree {
            let temp = a

            a = b
            b = temp
        }

        var rLast = a
        var r = b
        var tLast = self.field.zero
        var t = self.field.one

        // Run Euclidean algorithm until r's degree is less than R/2
        while r?.degree >= R / 2 {
            let rLastLast = rLast
            let tLastLast = tLast

            rLast = r
            tLast = t

            // Divide rLastLast by rLast, with quotient in q and remainder in r
            if rLast?.zero != nil {
                // Oops, Euclidean algorithm already terminated?
                return nil
            }

            r = rLastLast

            var q = self.field.zero
            let denominatorLeadingTerm = rLast?.coefficient(rLast?.degree) ?? 0
            let dltInverse = self.field.inverse(denominatorLeadingTerm) ?? 0

            while r?.degree >= rLast?.degree && (r?.zero == nil) {
                let degreeDiff = r?.degree - rLast?.degree
                let scale = self.field.multiply(r?.coefficient(r?.degree) ?? 0, b: dltInverse) ?? 0

                q = q?.add(self.field.buildMonomial(degreeDiff, coefficient: scale))
                r = r?.subtract(rLast?.multiplyByMonomial(degreeDiff, coefficient: scale))
            }

            t = q?.multiply(tLast).subtract(tLastLast).negative()
        }

        let sigmaTildeAtZero = t?.coefficient(0) ?? 0

        if sigmaTildeAtZero == 0 {
            return nil
        }

        let inverse = self.field.inverse(sigmaTildeAtZero) ?? 0
        let sigma = t?.multiplyScalar(inverse)
        let omega = r?.multiplyScalar(inverse)

        return [sigma, omega]
    }
    @objc
    func findErrorLocations(_ errorLocator: ZXModulusPoly!) -> ZXIntArray {
        // This is a direct application of Chien's search
        let numErrors: CInt = errorLocator.degree
        let result = ZXIntArray(length: CUnsignedInt(numErrors))
        var e: CInt = 0
        var i: CInt = 1

        while i < self.field.size && e < numErrors {
            defer {
                i += 1
            }

            if errorLocator.evaluateAt(i) == 0 {
                result.array[e] = self.field.inverse(i)
                e += 1
            }
        }

        if e != numErrors {
            return nil
        }

        return result
    }
    @objc
    func findErrorMagnitudes(_ errorEvaluator: ZXModulusPoly!, errorLocator: ZXModulusPoly!, errorLocations: ZXIntArray!) -> ZXIntArray {
        let errorLocatorDegree: CInt = errorLocator.degree
        let formalDerivativeCoefficients = ZXIntArray(length: CUnsignedInt(errorLocatorDegree))
        var i: CInt = 1

        while i <= errorLocatorDegree {
            defer {
                i += 1
            }

            formalDerivativeCoefficients.array[errorLocatorDegree - i] = self.field.multiply(i, b: errorLocator.coefficient(i))
        }

        let formalDerivative = ZXModulusPoly(field: self.field, coefficients: formalDerivativeCoefficients)
        // This is directly applying Forney's Formula
        let s: CInt = CInt(errorLocations.length)
        let result = ZXIntArray(length: CUnsignedInt(s))
        var i: CInt = 0

        while i < s {
            defer {
                i += 1
            }

            let xiInverse = self.field.inverse(errorLocations.array[i]) ?? 0
            let numerator = self.field.subtract(0, b: errorEvaluator.evaluateAt(xiInverse)) ?? 0
            let denominator = self.field.inverse(formalDerivative.evaluateAt(xiInverse)) ?? 0

            result.array[i] = self.field.multiply(numerator, b: denominator)
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
extension ZXPDF417ECErrorCorrection {
    @objc var field: ZXModulusGF! {
        return self._field
    }
}