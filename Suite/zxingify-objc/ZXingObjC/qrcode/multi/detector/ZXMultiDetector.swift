// Preprocessor directives found in file:
// #import "ZXQRCodeDetector.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXMultiDetector.h"
// #import "ZXMultiFinderPatternFinder.h"
// #import "ZXResultPointCallback.h"
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
 * Encapsulates logic that can detect one or more QR Codes in an image, even if the QR Code
 * is rotated or skewed, or partially obscured.
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
 * Encapsulates logic that can detect one or more QR Codes in an image, even if the QR Code
 * is rotated or skewed, or partially obscured.
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
class ZXMultiDetector: ZXQRCodeDetector {
    @objc
    func detectMulti(_ hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> NSArray {
        let resultPointCallback: ZXResultPointCallback! = (hints == nil) ? nil : hints.resultPointCallback
        let finder = ZXMultiFinderPatternFinder(image: self.image, resultPointCallback: resultPointCallback)
        let info = finder.findMulti(hints, error: error)

        if info.count == 0 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let result = NSMutableArray()
        var i: CInt = 0

        while i < info.count {
            defer {
                i += 1
            }

            let patternInfo = self.processFinderPatternInfo(info[Int(i)], error: nil)

            if patternInfo != nil {
                if let patternInfo = patternInfo {
                    result.add(patternInfo)
                }
            }
        }

        return result
    }
}