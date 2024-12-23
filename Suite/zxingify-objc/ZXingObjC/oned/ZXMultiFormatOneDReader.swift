// Preprocessor directives found in file:
// #import "ZXOneDReader.h"
// #import "ZXCodaBarReader.h"
// #import "ZXCode128Reader.h"
// #import "ZXCode39Reader.h"
// #import "ZXCode93Reader.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXITFReader.h"
// #import "ZXMultiFormatOneDReader.h"
// #import "ZXMultiFormatUPCEANReader.h"
// #import "ZXRSS14Reader.h"
// #import "ZXRSSExpandedReader.h"
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
class ZXMultiFormatOneDReader: ZXOneDReader {
    private var _readers: NSMutableArray!

    @objc
    init(hints: ZXDecodeHints!) {
        if self = super.init() {
            let useCode39CheckDigit = hints != nil && hints.assumeCode39CheckDigit

            _readers = NSMutableArray()

            if hints != nil {
                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatEan13) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatUPCA) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatEan8) || hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatUPCE) {
                    _readers.add(ZXMultiFormatUPCEANReader(hints: hints))
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatCode39) {
                    _readers.add(ZXCode39Reader.alloc().initUsingCheckDigit(useCode39CheckDigit))
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatCode93) {
                    _readers.add(ZXCode93Reader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatCode128) {
                    _readers.add(ZXCode128Reader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatITF) {
                    _readers.add(ZXITFReader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatCodabar) {
                    _readers.add(ZXCodaBarReader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatRSS14) {
                    _readers.add(ZXRSS14Reader())
                }

                if hints.containsFormat(ZXBarcodeFormat.kBarcodeFormatRSSExpanded) {
                    _readers.add(ZXRSSExpandedReader())
                }
            }

            if _readers.count == 0 {
                _readers.add(ZXMultiFormatUPCEANReader(hints: hints))
                _readers.add(ZXCode39Reader())
                _readers.add(ZXCodaBarReader())
                _readers.add(ZXCode93Reader())
                _readers.add(ZXCode128Reader())
                _readers.add(ZXITFReader())
                _readers.add(ZXRSS14Reader())
                _readers.add(ZXRSSExpandedReader())
            }
        }

        return self
    }

    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        for reader in self.readers {
            let result: ZXResult! = reader.decodeRow(rowNumber, row: row, hints: hints, error: error)

            if result {
                return result
            }
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
extension ZXMultiFormatOneDReader {
    @objc var readers: NSMutableArray! {
        return self._readers
    }
}