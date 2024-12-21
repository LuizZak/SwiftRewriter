// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXByteArray.h"
// #import "ZXErrors.h"
// #import "ZXMaxiCodeBitMatrixParser.h"
var ZX_BITNR: (CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt)

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
class ZXMaxiCodeBitMatrixParser: NSObject {
    private var _bitMatrix: ZXBitMatrix!

    @objc
    init(bitMatrix: ZXBitMatrix!, error: UnsafeMutablePointer<Error?>!) {
        if self = super.init() {
            _bitMatrix = bitMatrix
        }

        return self
    }

    @objc
    func readCodewords() -> ZXByteArray {
        let result = ZXByteArray(length: 144)
        let height = self.bitMatrix.height ?? 0
        let width = self.bitMatrix.width ?? 0
        var y: CInt = 0

        while y < height {
            defer {
                y += 1
            }

            let bitnrRow: UnsafeMutablePointer<CInt>! = ZX_BITNR[y] as? UnsafeMutablePointer<CInt>
            var x: CInt = 0

            while x < width {
                defer {
                    x += 1
                }

                let bit: CInt = bitnrRow[x]

                if bit >= 0 && (self.bitMatrix.getX(x, y: y) == true) {
                    result.array[bit / 6] |= (1 << (5 - (bit % 6))) as? int8_t
                }
            }
        }

        return result
    }
}

// MARK: -
@objc
extension ZXMaxiCodeBitMatrixParser {
    @objc var bitMatrix: ZXBitMatrix! {
        return self._bitMatrix
    }
}