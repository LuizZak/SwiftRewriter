// Preprocessor directives found in file:
// #import "ZXRSSExpandedDecodedObject.h"
// #import "ZXRSSExpandedDecodedInformation.h"
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
class ZXRSSExpandedDecodedInformation: ZXRSSExpandedDecodedObject {
    private var _theNewString: String!
    private var _remainingValue: CInt = 0
    private var _remaining: Bool = false
    @objc var theNewString: String! {
        return self._theNewString
    }
    @objc var remainingValue: CInt {
        return self._remainingValue
    }
    @objc var remaining: Bool {
        return self._remaining
    }

    @objc
    init(newPosition: CInt, newString: String!) {
        if self = super.init(newPosition: newPosition) {
            _remaining = false
            _remainingValue = 0
            _theNewString = newString
        }

        return self
    }
    @objc
    init(newPosition: CInt, newString: String!, remainingValue: CInt) {
        if self = super.init(newPosition: newPosition) {
            _remaining = true
            _remainingValue = remainingValue
            _theNewString = newString
        }

        return self
    }
}