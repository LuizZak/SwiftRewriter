// Preprocessor directives found in file:
// #import "ZXGenericGF.h"
// #import "ZXGenericGFPoly.h"
// #import "ZXIntArray.h"
// #import "ZXReedSolomonEncoder.h"
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
 * Implements Reed-Solomon enbcoding, as the name implies.
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
 * Implements Reed-Solomon enbcoding, as the name implies.
 */
@objc
class ZXReedSolomonEncoder: NSObject {
    private var _cachedGenerators: NSMutableArray!
    private var _field: ZXGenericGF!

    @objc
    init(field: ZXGenericGF!) {
        if self = super.init() {
            _field = field

            let one = ZXIntArray(length: 1)

            one.array[0] = 1
            _cachedGenerators = NSMutableArray.arrayWithObject(ZXGenericGFPoly(field: field, coefficients: one))
        }

        return self
    }

    @objc
    func buildGenerator(_ degree: CInt) -> ZXGenericGFPoly? {
        if degree >= (self.cachedGenerators.count ?? 0) {
            var lastGenerator: ZXGenericGFPoly! = self.cachedGenerators[self.cachedGenerators.count - 1]
            var d: UInt = UInt(UInt(self.cachedGenerators.count ?? 0))

            while d <= degree {
                defer {
                    d += 1
                }

                let next = ZXIntArray(length: 2)

                next.array[0] = 1
                next.array[1] = self.field.exp(CInt(d) - 1 + self.field.generatorBase)

                let nextGenerator = lastGenerator.multiply(ZXGenericGFPoly(field: self.field, coefficients: next))

                if let nextGenerator = nextGenerator {
                    self.cachedGenerators.add(nextGenerator)
                }

                lastGenerator = nextGenerator
            }
        }

        return self.cachedGenerators[Int(degree)] as? ZXGenericGFPoly
    }
    @objc
    func encode(_ toEncode: ZXIntArray!, ecBytes: CInt) {
        if ecBytes == 0 {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"No error correction bytes"userInfo:nil];
            */
        }

        let dataBytes: CInt = CInt(toEncode.length) - ecBytes

        if dataBytes <= 0 {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"No data bytes provided"userInfo:nil];
            */
        }

        let generator = self.buildGenerator(ecBytes)
        let infoCoefficients = ZXIntArray(length: CUnsignedInt(dataBytes))
        var i: CInt = 0

        while i < dataBytes {
            defer {
                i += 1
            }

            infoCoefficients.array[i] = toEncode.array[i]
        }

        var info: ZXGenericGFPoly! = ZXGenericGFPoly(field: self.field, coefficients: infoCoefficients)

        info = info.multiplyByMonomial(ecBytes, coefficient: 1)

        let remainder: ZXGenericGFPoly = info.divide(generator)[1]
        let coefficients = remainder.coefficients
        let numZeroCoefficients: CInt = ecBytes - CInt(CInt(coefficients?.length ?? 0))
        var i: CInt = 0

        while i < numZeroCoefficients {
            defer {
                i += 1
            }

            toEncode.array[dataBytes + i] = 0
        }

        var i: CInt = 0

        while i < (coefficients?.length ?? 0) {
            defer {
                i += 1
            }

            toEncode.array[dataBytes + numZeroCoefficients + i] = coefficients?.array[i]
        }
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
extension ZXReedSolomonEncoder {
    @objc var cachedGenerators: NSMutableArray! {
        return self._cachedGenerators
    }
    @objc var field: ZXGenericGF! {
        return self._field
    }
}