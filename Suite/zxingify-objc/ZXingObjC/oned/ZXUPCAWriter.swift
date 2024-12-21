// Preprocessor directives found in file:
// #import "ZXWriter.h"
// #import "ZXEAN13Writer.h"
// #import "ZXUPCAWriter.h"
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
 * This object renders a UPC-A code as a ZXBitMatrix.
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
 * This object renders a UPC-A code as a ZXBitMatrix.
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
class ZXUPCAWriter: NSObject, ZXWriter {
    @objc
    func subWriter() -> ZXEAN13Writer? {
        var subWriter: ZXEAN13Writer! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            subWriter = ZXEAN13Writer()
        }

        return subWriter
    }
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        return self.encode(contents, format: format, width: width, height: height, hints: nil, error: error)
    }
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if format != ZXBarcodeFormat.kBarcodeFormatUPCA {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:[NSStringstringWithFormat:@"Can only encode UPC-A, but got %d",format]userInfo:nil];
            */
        }

        // Transform a UPC-A code into the equivalent EAN-13 code and write it that way
        return self.subWriter.encode(String(format: "0%@", contents), format: ZXBarcodeFormat.kBarcodeFormatEan13, width: width, height: height, hints: hints, error: error)
    }
}