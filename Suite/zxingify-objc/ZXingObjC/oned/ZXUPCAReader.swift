// Preprocessor directives found in file:
// #import "ZXUPCEANReader.h"
// #import "ZXEAN13Reader.h"
// #import "ZXErrors.h"
// #import "ZXResult.h"
// #import "ZXUPCAReader.h"
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
 * Implements decoding of the UPC-A format.
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
 * Implements decoding of the UPC-A format.
 */
@objc
class ZXUPCAReader: ZXUPCEANReader {
    private var _ean13Reader: ZXUPCEANReader!

    @objc
    override init() {
        if self = super.init() {
            _ean13Reader = ZXEAN13Reader()
        }

        return self
    }

    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, startGuardRange: NSRange, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult {
        var result = self.ean13Reader.decodeRow(rowNumber, row: row, startGuardRange: startGuardRange, hints: hints, error: error)

        if result != nil {
            result = self.maybeReturnResult(result)

            if result == nil {
                if error {
                    *error = ZXFormatErrorInstance()
                }

                return nil
            }

            return result
        } else {
            return nil
        }
    }
    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult {
        var result = self.ean13Reader.decodeRow(rowNumber, row: row, hints: hints, error: error)

        if result != nil {
            result = self.maybeReturnResult(result)

            if result == nil {
                if error {
                    *error = ZXFormatErrorInstance()
                }

                return nil
            }

            return result
        } else {
            return nil
        }
    }
    @objc
    func decode(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult {
        var result = self.ean13Reader.decode(image, error: error)

        if result != nil {
            result = self.maybeReturnResult(result)

            if result == nil {
                if error {
                    *error = ZXFormatErrorInstance()
                }

                return nil
            }

            return result
        } else {
            return nil
        }
    }
    @objc
    func decode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult {
        var result = self.ean13Reader.decode(image, hints: hints, error: error)

        if result != nil {
            result = self.maybeReturnResult(result)

            if result == nil {
                if error {
                    *error = ZXFormatErrorInstance()
                }

                return nil
            }

            return result
        } else {
            return nil
        }
    }
    @objc
    func barcodeFormat() -> ZXBarcodeFormat {
        return ZXBarcodeFormat.kBarcodeFormatUPCA
    }
    @objc
    func decodeMiddle(_ row: ZXBitArray!, startRange: NSRange, result: NSMutableString!, error: UnsafeMutablePointer<Error?>!) -> CInt {
        return self.ean13Reader.decodeMiddle(row, startRange: startRange, result: result, error: error) ?? 0
    }
    @objc
    func maybeReturnResult(_ result: ZXResult!) -> ZXResult {
        let text = result.text

        if text?.characterAtIndex(0) == '0' {
            let upcaResult = ZXResult.resultWithText(text?.substringFromIndex(1), rawBytes: nil, resultPoints: result.resultPoints, format: ZXBarcodeFormat.kBarcodeFormatUPCA)

            upcaResult?.putAllMetadata(result.resultMetadata())

            return upcaResult
        } else {
            return nil
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
extension ZXUPCAReader {
    @objc var ean13Reader: ZXUPCEANReader! {
        return self._ean13Reader
    }
}