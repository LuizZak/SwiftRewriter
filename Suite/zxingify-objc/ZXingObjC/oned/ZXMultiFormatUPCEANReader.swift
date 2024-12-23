// Preprocessor directives found in file:
// #import "ZXOneDReader.h"
// #import "ZXDecodeHints.h"
// #import "ZXEAN8Reader.h"
// #import "ZXEAN13Reader.h"
// #import "ZXErrors.h"
// #import "ZXMultiFormatUPCEANReader.h"
// #import "ZXReader.h"
// #import "ZXResult.h"
// #import "ZXUPCAReader.h"
// #import "ZXUPCEReader.h"
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
 * A reader that can read all available UPC/EAN formats. If a caller wants to try to
 * read all such formats, it is most efficient to use this implementation rather than invoke
 * individual readers.
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
 * A reader that can read all available UPC/EAN formats. If a caller wants to try to
 * read all such formats, it is most efficient to use this implementation rather than invoke
 * individual readers.
 */
@objc
class ZXMultiFormatUPCEANReader: ZXOneDReader {
    private var _readers: NSMutableArray!

    @objc
    init(hints: ZXDecodeHints!) {
        if self = super.init() {
            _readers = NSMutableArray()

            if hints != nil {
                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatEan13) {
                    _readers.add(ZXEAN13Reader())
                } else if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatUPCA) {
                    _readers.add(ZXUPCAReader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatEan8) {
                    _readers.add(ZXEAN8Reader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatUPCE) {
                    _readers.add(ZXUPCEReader())
                }
            }

            if _readers.count == 0 {
                _readers.add(ZXEAN13Reader())
                _readers.add(ZXEAN8Reader())
                _readers.add(ZXUPCEReader())
            }
        }

        return self
    }

    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let startGuardPattern = ZXUPCEANReader.findStartGuardPattern(row, error: error)

        if startGuardPattern.location == NSNotFound {
            return nil
        }

        for reader in self.readers {
            let result: ZXResult! = reader.decodeRow(rowNumber, row: row, startGuardRange: startGuardPattern, hints: hints, error: error)

            if !result {
                continue
            }

            // Special case: a 12-digit code encoded in UPC-A is identical to a "0"
            // followed by those 12 digits encoded as EAN-13. Each will recognize such a code,
            // UPC-A as a 12-digit string and EAN-13 as a 13-digit string starting with "0".
            // Individually these are correct and their readers will both read such a code
            // and correctly call it EAN-13, or UPC-A, respectively.
            //
            // In this case, if we've been looking for both types, we'd like to call it
            // a UPC-A code. But for efficiency we only run the EAN-13 decoder to also read
            // UPC-A. So we special case it here, and convert an EAN-13 result to a UPC-A
            // result if appropriate.
            //
            // But, don't return UPC-A if UPC-A was not a requested format!
            let ean13MayBeUPCA = ZXBarcodeFormat.kBarcodeFormatEan13 == result.barcodeFormat && result.text.characterAtIndex(0) == "0"
            let canReturnUPCA = hints == nil || hints.numberOfPossibleFormats() == 0 || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatUPCA)

            if ean13MayBeUPCA && canReturnUPCA {
                // Transfer the metdata across
                let resultUPCA = ZXResult.resultWithText(result.text.substringFromIndex(1), rawBytes: result.rawBytes, resultPoints: result.resultPoints, format: ZXBarcodeFormat.kBarcodeFormatUPCA)

                resultUPCA?.putAllMetadata(result.resultMetadata)

                return resultUPCA
            }

            return result
        }

        if error != nil {
            error.pointee = ZXNotFoundErrorInstance()
        }

        return nil
    }
    @objc
    func reset() {
        for reader in self.readers {
            reader.reset()
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
extension ZXMultiFormatUPCEANReader {
    @objc var readers: NSMutableArray! {
        return self._readers
    }
}