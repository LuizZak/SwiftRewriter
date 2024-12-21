// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXTelParsedResult.h"
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
class ZXTelParsedResult: ZXParsedResult {
    private var _number: String!
    private var _telURI: String!
    private var _title: String!
    @objc var number: String! {
        return self._number
    }
    @objc var telURI: String! {
        return self._telURI
    }
    @objc var title: String! {
        return self._title
    }

    @objc
    init(number: String!, telURI: String!, title: String!) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeTel) {
            _number = number
            _telURI = telURI
            _title = title
        }

        return self
    }

    @objc
    static func telParsedResultWithNumber(_ number: String!, telURI: String!, title: String!) -> AnyObject? {
        return self.init(number: number, telURI: telURI, title: title)
    }
    @objc
    func displayResult() -> String? {
        let result = NSMutableString(capacity: 20)

        ZXParsedResult.maybeAppend(self.number, result: result)
        ZXParsedResult.maybeAppend(self.title, result: result)

        return result
    }
}