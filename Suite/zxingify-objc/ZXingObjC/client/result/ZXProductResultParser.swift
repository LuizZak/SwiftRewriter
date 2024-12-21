// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXBarcodeFormat.h"
// #import "ZXProductParsedResult.h"
// #import "ZXProductResultParser.h"
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
 * Parses strings of digits that represent a UPC code.
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
 * Parses strings of digits that represent a UPC code.
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
class ZXProductResultParser: ZXResultParser {
    // Treat all UPC and EAN variants as UPCs, in the sense that they are all product barcodes.
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let format = result.barcodeFormat

        if !(format == ZXBarcodeFormat.kBarcodeFormatUPCA || format == ZXBarcodeFormat.kBarcodeFormatUPCE || format == ZXBarcodeFormat.kBarcodeFormatEan8 || format == ZXBarcodeFormat.kBarcodeFormatEan13) {
            return nil
        }

        let rawText = ZXResultParser.massagedText(result)

        if !type(of: self).isStringOfDigits(rawText, length: CUnsignedInt(rawText?.length())) {
            return nil
        }

        // Not actually checking the checksum again here
        var normalizedProductID: String!

        if format == ZXBarcodeFormat.kBarcodeFormatUPCE && rawText?.length() == 8 {
            normalizedProductID = ZXUPCEReader.convertUPCEtoUPCA(rawText)
        } else {
            normalizedProductID = rawText
        }

        return ZXProductParsedResult.productParsedResultWithProductID(rawText, normalizedProductID: normalizedProductID)
    }
}