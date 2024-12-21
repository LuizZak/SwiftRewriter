import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXPDF417BarcodeValue.h"
// #import "ZXPDF417Common.h"
/*
 * Copyright 2013 ZXing authors
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
class ZXPDF417BarcodeValue: NSObject {
    private var _values: NSMutableDictionary!

    @objc
    override init() {
        _values = NSMutableDictionary()
        super.init()
    }

    /**
 * Add an occurrence of a value
 */
    @objc
    func setValue(_ value: CInt) {
        var confidence: NSNumber! = self.values[value]

        if confidence == nil {
            confidence = 0
        }

        confidence = confidence?.intValue() + 1
        self.values[value] = confidence
    }
    /**
 * Determines the maximum occurrence of a set value and returns all values which were set with this occurrence.
 * @return an array of int, containing the values with the highest occurrence, or null, if no value was set
 */
    @objc
    func value() -> ZXIntArray {
        var maxConfidence: CInt = 1
        let result = NSMutableArray()

        for key in self.values.allKeys {
            let value: NSNumber! = self.values[key]

            if value.intValue() > maxConfidence {
                maxConfidence = value.intValue()
                result.removeAllObjects()
                result.add(key)
            } else if value.intValue() == maxConfidence {
                result.add(key)
            }
        }

        let array: NSArray! = result.sortedArrayUsingSelector(#selector(compare(_:))).reverseObjectEnumerator().allObjects()

        return ZXPDF417Common.toIntArray(array)
    }
    @objc
    func confidence(_ value: CInt) -> NSNumber? {
        return self.values[value]
    }
}

// MARK: -
/*
 * Copyright 2013 ZXing authors
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
extension ZXPDF417BarcodeValue {
    @objc var values: NSMutableDictionary! {
        return self._values
    }
}