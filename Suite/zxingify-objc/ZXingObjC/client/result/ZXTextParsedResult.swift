// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXParsedResultType.h"
// #import "ZXTextParsedResult.h"
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
 * A simple result type encapsulating a string that has no further
 * interpretation.
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
 * A simple result type encapsulating a string that has no further
 * interpretation.
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
class ZXTextParsedResult: ZXParsedResult {
    private var _text: String!
    private var _language: String!
    @objc var text: String! {
        return self._text
    }
    @objc var language: String! {
        return self._language
    }

    @objc
    init(text: String!, language: String!) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeText) {
            _text = text
            _language = language
        }

        return self
    }

    @objc
    static func textParsedResultWithText(_ text: String!, language: String!) -> AnyObject? {
        return self.init(text: text, language: language)
    }
    @objc
    func displayResult() -> String? {
        return self.text
    }
}