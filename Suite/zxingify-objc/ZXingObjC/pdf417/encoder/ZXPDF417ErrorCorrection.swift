// Preprocessor directives found in file:
// #import "ZXErrors.h"
// #import "ZXPDF417ErrorCorrection.h"
var ZX_PDF417_EC_COEFFICIENTS: (CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt)

/*
 * Copyright 2006 Jeremias Maerki in part, and ZXing Authors in part
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * PDF417 error correction code following the algorithm described in ISO/IEC 15438:2001(E) in
 * chapter 4.10.
 */
@objc
class ZXPDF417ErrorCorrection: NSObject {
    /**
 * Determines the number of error correction codewords for a specified error correction
 * level.
 *
 * @param errorCorrectionLevel the error correction level (0-8)
 * @return the number of codewords generated for error correction
 */
    @objc
    static func errorCorrectionCodewordCount(_ errorCorrectionLevel: CInt) -> CInt {
        if errorCorrectionLevel < 0 || errorCorrectionLevel > 8 {
            NSException.raise(NSInvalidArgumentException, format: "Error correction level must be between 0 and 8!")
        }

        return 1 << (errorCorrectionLevel + 1)
    }
    /**
 * Returns the recommended minimum error correction level as described in annex E of
 * ISO/IEC 15438:2001(E).
 *
 * @param n the number of data codewords
 * @return the recommended minimum error correction level
 */
    @objc
    static func recommendedMinimumErrorCorrectionLevel(_ n: CInt, error: UnsafeMutablePointer<Error?>!) -> CInt {
        if n <= 0 {
            NSException.raise(NSInvalidArgumentException, format: "n must be > 0")
        }

        if n <= 40 {
            return 2
        }

        if n <= 160 {
            return 3
        }

        if n <= 320 {
            return 4
        }

        if n <= 863 {
            return 5
        }

        let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "No recommendation possible"]

        if error != nil {
            error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
        }

        return 1
    }
    /**
 * Generates the error correction codewords according to 4.10 in ISO/IEC 15438:2001(E).
 *
 * @param dataCodewords        the data codewords
 * @param errorCorrectionLevel the error correction level (0-8)
 * @return the String representing the error correction codewords
 */
    @objc
    static func generateErrorCorrection(_ dataCodewords: String!, errorCorrectionLevel: CInt) -> String? {
        let k = self.errorCorrectionCodewordCount(errorCorrectionLevel)
        var e: UnsafeMutablePointer<unichar>!

        memset(e, 0, Int(k) * MemoryLayout.size(ofValue: unichar))

        let sld: CInt = CInt(dataCodewords.length)
        var i: CInt = 0

        while i < sld {
            defer {
                i += 1
            }

            let t1: CInt = (dataCodewords.characterAtIndex(i) + e[k - 1]) % 929
            var t2: CInt
            var t3: CInt
            var j = k - 1

            while j >= 1 {
                defer {
                    j -= 1
                }

                t2 = (t1 * ZX_PDF417_EC_COEFFICIENTS[errorCorrectionLevel][j]) % 929
                t3 = 929 - t2
                e[j] = ((e[j - 1] + t3) % 929) as? unichar
            }

            t2 = (t1 * ZX_PDF417_EC_COEFFICIENTS[errorCorrectionLevel][0]) % 929
            t3 = 929 - t2
            e[0] = (t3 % 929) as? unichar
        }

        let sb = NSMutableString(capacity: Int(k))
        var j = k - 1

        while j >= 0 {
            defer {
                j -= 1
            }

            if e[j] != 0 {
                e[j] = (929 - e[j]) as? unichar
            }

            sb.appendFormat("%C", e[j])
        }

        return sb
    }
}