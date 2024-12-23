// Preprocessor directives found in file:
// #import "ZXErrors.h"
// #import "ZXGenericGF.h"
// #import "ZXGenericGFPoly.h"
// #import "ZXIntArray.h"
// #import "ZXReedSolomonDecoder.h"
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
 * Implements Reed-Solomon decoding, as the name implies.
 *
 * The algorithm will not be explained here, but the following references were helpful
 * in creating this implementation:
 *
 * Bruce Maggs.
 * http://www.cs.cmu.edu/afs/cs.cmu.edu/project/pscico-guyb/realworld/www/rs_decode.ps
 * "Decoding Reed-Solomon Codes" (see discussion of Forney's Formula)
 *
 * J.I. Hall. www.mth.msu.edu/~jhall/classes/codenotes/GRS.pdf
 * "Chapter 5. Generalized Reed-Solomon Codes"
 * (see discussion of Euclidean algorithm)
 *
 * Much credit is due to William Rucklidge since portions of this code are an indirect
 * port of his C++ Reed-Solomon implementation.
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
 * Implements Reed-Solomon decoding, as the name implies.
 *
 * The algorithm will not be explained here, but the following references were helpful
 * in creating this implementation:
 *
 * Bruce Maggs.
 * http://www.cs.cmu.edu/afs/cs.cmu.edu/project/pscico-guyb/realworld/www/rs_decode.ps
 * "Decoding Reed-Solomon Codes" (see discussion of Forney's Formula)
 *
 * J.I. Hall. www.mth.msu.edu/~jhall/classes/codenotes/GRS.pdf
 * "Chapter 5. Generalized Reed-Solomon Codes"
 * (see discussion of Euclidean algorithm)
 *
 * Much credit is due to William Rucklidge since portions of this code are an indirect
 * port of his C++ Reed-Solomon implementation.
 */
@objc
class ZXReedSolomonDecoder: NSObject {
    private var _field: ZXGenericGF!

    @objc
    init(field: ZXGenericGF!) {
        if self = super.init() {
            _field = field
        }

        return self
    }

    /**
 * Decodes given set of received codewords, which include both data and error-correction
 * codewords. Really, this means it uses Reed-Solomon to detect and correct errors, in-place,
 * in the input.
 *
 * @param received data and error-correction codewords
 * @param twoS number of error-correction codewords available
 * @return NO if decoding fails for any reason
 */
    /**
 * Decodes given set of received codewords, which include both data and error-correction
 * codewords. Really, this means it uses Reed-Solomon to detect and correct errors, in-place,
 * in the input.
 *
 * @param received data and error-correction codewords
 * @param twoS number of error-correction codewords available
 * @return NO if decoding fails for any reason
 */
    @objc
    func decode(_ received: ZXIntArray!, twoS: CInt, error: UnsafeMutablePointer<Error?>!) -> Bool {
        let poly = ZXGenericGFPoly(field: self.field, coefficients: received)
        let syndromeCoefficients = ZXIntArray(length: CUnsignedInt(twoS))
        var noError = true
        var i: CInt = 0

        while i < twoS {
            defer {
                i += 1
            }

            let eval = poly.evaluateAt(self.field.exp(i + self.field.generatorBase))

            syndromeCoefficients.array[syndromeCoefficients.length - 1 - i] = eval

            if eval != 0 {
                noError = false
            }
        }

        if noError {
            return true
        }

        let syndrome = ZXGenericGFPoly(field: self.field, coefficients: syndromeCoefficients)
        let sigmaOmega = self.runEuclideanAlgorithm(self.field.buildMonomial(twoS, coefficient: 1), b: syndrome, R: twoS, error: error)

        if sigmaOmega == nil {
            return false
        }

        let sigma: ZXGenericGFPoly! = sigmaOmega?[0]
        let omega: ZXGenericGFPoly! = sigmaOmega?[1]
        let errorLocations = self.findErrorLocations(sigma, error: error)

        if !errorLocations {
            return false
        }

        let errorMagnitudes = self.findErrorMagnitudes(omega, errorLocations: errorLocations)
        var i: CInt = 0

        while i < errorLocations.length {
            defer {
                i += 1
            }

            let position = received.length - 1 - self.field.log(errorLocations.array[i])

            if position < 0 {
                let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Bad error location"]

                if error != nil {
                    error.pointee = Error(domain: ZXErrorDomain, code: ZXReedSolomonError, userInfo: userInfo)
                }

                return false
            }

            received.array[position] = ZXGenericGF.addOrSubtract(received.array[position], b: errorMagnitudes.array[i])
        }

        return true
    }
    @objc
    func runEuclideanAlgorithm(_ a: ZXGenericGFPoly!, b: ZXGenericGFPoly!, R: CInt, error: UnsafeMutablePointer<Error?>!) -> NSArray? {
        if a.degree < b.degree {
            let temp = a

            a = b
            b = temp
        }

        var rLast = a
        var r = b
        var tLast = self.field.zero
        var t = self.field.one

        while (r?.degree() ?? 0) >= R / 2 {
            let rLastLast = rLast
            let tLastLast = tLast

            rLast = r
            tLast = t

            if rLast?.zero() == true {
                let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "r_{i-1} was zero"]

                if error != nil {
                    error.pointee = Error(domain: ZXErrorDomain, code: ZXReedSolomonError, userInfo: userInfo)
                }

                return nil
            }

            r = rLastLast

            var q = self.field.zero
            let denominatorLeadingTerm = rLast?.coefficient(rLast?.degree() ?? 0) ?? 0
            let dltInverse: CInt = self.field.inverse(denominatorLeadingTerm)

            while (r?.degree() ?? 0) >= (rLast?.degree() ?? 0) && !r?.zero() {
                let degreeDiff = (r?.degree() ?? 0) - (rLast?.degree() ?? 0)
                let scale: CInt = self.field.multiply(r?.coefficient(r?.degree() ?? 0) ?? 0, b: dltInverse)

                q = q?.addOrSubtract(self.field.buildMonomial(degreeDiff, coefficient: scale))
                r = r?.addOrSubtract(rLast?.multiplyByMonomial(degreeDiff, coefficient: scale))
            }

            t = q?.multiply(tLast).addOrSubtract(tLastLast)

            if r?.degree >= rLast?.degree {
                /*
                @throw[NSExceptionexceptionWithName:@"IllegalStateException"reason:@"Division algorithm failed to reduce polynomial?"userInfo:nil];
                */
            }
        }

        let sigmaTildeAtZero = t?.coefficient(0) ?? 0

        if sigmaTildeAtZero == 0 {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "sigmaTilde(0) was zero"]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXReedSolomonError, userInfo: userInfo)
            }

            return nil
        }

        let inverse: CInt = self.field.inverse(sigmaTildeAtZero)
        let sigma = t?.multiplyScalar(inverse)
        let omega = r?.multiplyScalar(inverse)

        return [sigma, omega]
    }
    @objc
    func findErrorLocations(_ errorLocator: ZXGenericGFPoly!, error: UnsafeMutablePointer<Error?>!) -> ZXIntArray {
        let numErrors = errorLocator.degree()

        if numErrors == 1 {
            let array = ZXIntArray(length: 1)

            array.array[0] = errorLocator.coefficient(1)

            return array
        }

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
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Error locator degree does not match number of roots"]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXReedSolomonError, userInfo: userInfo)
            }

            return nil
        }

        return result
    }
    @objc
    func findErrorMagnitudes(_ errorEvaluator: ZXGenericGFPoly!, errorLocations: ZXIntArray!) -> ZXIntArray {
        let s: CInt = CInt(errorLocations.length)
        let result = ZXIntArray(length: CUnsignedInt(s))
        let field = self.field
        var i: CInt = 0

        while i < s {
            defer {
                i += 1
            }

            let xiInverse: CInt = field?.inverse(errorLocations.array[i])
            var denominator: CInt = 1
            var j: CInt = 0

            while j < s {
                defer {
                    j += 1
                }

                if i != j {
                    //denominator = field.multiply(denominator,
                    //    GenericGF.addOrSubtract(1, field.multiply(errorLocations[j], xiInverse)));
                    // Above should work but fails on some Apple and Linux JDKs due to a Hotspot bug.
                    // Below is a funny-looking workaround from Steven Parkes
                    let term: CInt = field?.multiply(errorLocations.array[j], b: xiInverse)
                    let termPlus1 = ((term & 0x1) == 0) ? term | 1 : term & ~1

                    denominator = field?.multiply(denominator, b: termPlus1)
                }
            }

            result.array[i] = field?.multiply(errorEvaluator.evaluateAt(xiInverse), b: field?.inverse(denominator))

            if field?.generatorBase != 0 {
                result.array[i] = field?.multiply(result.array[i], b: xiInverse)
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
extension ZXReedSolomonDecoder {
    @objc var field: ZXGenericGF! {
        return self._field
    }
}