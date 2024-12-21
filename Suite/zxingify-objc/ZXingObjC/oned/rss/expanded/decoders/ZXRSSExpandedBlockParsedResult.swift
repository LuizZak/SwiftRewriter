import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXRSSExpandedBlockParsedResult.h"
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
class ZXRSSExpandedBlockParsedResult: NSObject {
    private var _decodedInformation: ZXRSSExpandedDecodedInformation!
    private var _finished: Bool = false
    @objc var decodedInformation: ZXRSSExpandedDecodedInformation! {
        return self._decodedInformation
    }
    @objc var finished: Bool {
        return self._finished
    }

    @objc
    init(finished: Bool) {
        return self.init(information: nil, finished: finished)
    }
    @objc
    init(information: ZXRSSExpandedDecodedInformation!, finished: Bool) {
        if self = super.init() {
            _decodedInformation = information
            _finished = finished
        }

        return self
    }
}