// Preprocessor directives found in file:
// #import "ZXBitArray.h"
// #import "ZXBitArrayBuilder.h"
// #import "ZXRSSDataCharacter.h"
// #import "ZXRSSExpandedPair.h"
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
class ZXBitArrayBuilder: NSObject {
    @objc
    static func buildBitArray(_ pairs: NSArray!) -> ZXBitArray {
        var charNumber: CInt = (CInt(pairs.count) * 2) - 1

        if pairs[pairs.count - 1].rightChar() == nil {
            charNumber -= 1
        }

        let size = 12 * charNumber
        let binary = ZXBitArray(size: size)
        var accPos: CInt = 0
        let firstPair: ZXRSSExpandedPair = pairs[0]
        let firstValue = firstPair.rightChar.value ?? 0
        var i: CInt = 11

        while i >= 0 {
            defer {
                i -= 1
            }

            if (firstValue & (1 << i)) != 0 {
                binary.set(accPos)
            }

            accPos += 1
        }

        var i: CInt = 1

        while i < pairs.count {
            defer {
                i += 1
            }

            let currentPair: ZXRSSExpandedPair! = pairs[Int(i)]
            let leftValue = currentPair.leftChar.value ?? 0
            var j: CInt = 11

            while j >= 0 {
                defer {
                    j -= 1
                }

                if (leftValue & (1 << j)) != 0 {
                    binary.set(accPos)
                }

                accPos += 1
            }

            if currentPair.rightChar != nil {
                let rightValue = currentPair.rightChar.value ?? 0
                var j: CInt = 11

                while j >= 0 {
                    defer {
                        j -= 1
                    }

                    if (rightValue & (1 << j)) != 0 {
                        binary.set(accPos)
                    }

                    accPos += 1
                }
            }
        }

        return binary
    }
}