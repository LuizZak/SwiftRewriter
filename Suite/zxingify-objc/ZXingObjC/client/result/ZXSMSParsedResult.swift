// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXSMSParsedResult.h"
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
class ZXSMSParsedResult: ZXParsedResult {
    private var _numbers: NSArray!
    private var _vias: NSArray!
    private var _subject: String!
    private var _body: String!
    @objc var numbers: NSArray! {
        return self._numbers
    }
    @objc var vias: NSArray! {
        return self._vias
    }
    @objc var subject: String! {
        return self._subject
    }
    @objc var body: String! {
        return self._body
    }

    @objc
    init(number: String!, via: String!, subject: String!, body: String!) {
        var numbers: NSArray!

        if number {
            numbers = [number]
        }

        var vias: NSArray!

        if via {
            vias = [via]
        }

        return self.init(numbers: numbers, vias: vias, subject: subject, body: body)
    }
    @objc
    init(numbers: NSArray!, vias: NSArray!, subject: String!, body: String!) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeSMS) {
            _numbers = numbers

            _vias = vias

            _subject = subject

            _body = body
        }

        return self
    }

    @objc
    static func smsParsedResultWithNumber(_ number: String!, via: String!, subject: String!, body: String!) -> AnyObject? {
        return self.init(number: number, via: via, subject: subject, body: body)
    }
    @objc
    static func smsParsedResultWithNumbers(_ numbers: NSArray!, vias: NSArray!, subject: String!, body: String!) -> AnyObject? {
        return self.init(numbers: numbers, vias: vias, subject: subject, body: body)
    }
    @objc
    func sMSURI() -> String? {
        let result: NSMutableString! = NSMutableString.stringWithString("sms:")
        var first = true
        var i: CInt = 0

        while i < (self.numbers.count ?? 0) {
            defer {
                i += 1
            }

            if first {
                first = false
            } else {
                result.append(",")
            }

            if let value = self.numbers[Int(i)] {
                result.append(value)
            }

            if self.vias != nil && self.vias[Int(i)] != NSNull.null() {
                result.append(";via=")

                if let value = self.vias[Int(i)] {
                    result.append(value)
                }
            }
        }

        let hasBody = self.body != nil
        let hasSubject = self.subject != nil

        if hasBody || hasSubject {
            result.append("?")

            if hasBody {
                result.append("body=")
                result.append(self.body)
            }

            if hasSubject {
                if hasBody {
                    result.append("&")
                }

                result.append("subject=")
                result.append(self.subject)
            }
        }

        return result
    }
    @objc
    func displayResult() -> String? {
        let result = NSMutableString(capacity: 100)

        ZXParsedResult.maybeAppendArray(self.numbers, result: result)
        ZXParsedResult.maybeAppend(self.subject, result: result)
        ZXParsedResult.maybeAppend(self.body, result: result)

        return result
    }
}