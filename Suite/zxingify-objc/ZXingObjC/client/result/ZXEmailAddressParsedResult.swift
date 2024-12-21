// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXEmailAddressParsedResult.h"
// #import "ZXParsedResultType.h"
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
class ZXEmailAddressParsedResult: ZXParsedResult {
    private var _tos: NSArray!
    private var _ccs: NSArray!
    private var _bccs: NSArray!
    private var _subject: String!
    private var _body: String!
    @objc var tos: NSArray! {
        return self._tos
    }
    @objc var ccs: NSArray! {
        return self._ccs
    }
    @objc var bccs: NSArray! {
        return self._bccs
    }
    @objc var subject: String! {
        return self._subject
    }
    @objc var body: String! {
        return self._body
    }
    /**
 * @return first elements of tos or nil if none
 * @deprecated use tos
 */
    @objc var emailAddress: String! {
        return (!self.tos || self.tos.count == 0) ? nil : self.tos[0]
    }
    /**
 * @return "mailto:"
 * @deprecated without replacement
 */
    @objc var mailtoURI: String! {
        return "mailto:"
    }

    @objc
    init(to: String!) {
        return self.init(tos: [to], ccs: nil, bccs: nil, subject: nil, body: nil)
    }
    @objc
    init(tos: NSArray!, ccs: NSArray!, bccs: NSArray!, subject: String!, body: String!) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeEmailAddress) {
            _tos = tos

            _ccs = ccs

            _bccs = bccs

            _subject = subject

            _body = body
        }

        return self
    }

    @objc
    func displayResult() -> String? {
        let result = NSMutableString(capacity: 30)

        ZXParsedResult.maybeAppendArray(self.tos, result: result)
        ZXParsedResult.maybeAppendArray(self.ccs, result: result)
        ZXParsedResult.maybeAppendArray(self.bccs, result: result)
        ZXParsedResult.maybeAppend(self.subject, result: result)
        ZXParsedResult.maybeAppend(self.body, result: result)

        return result
    }
}