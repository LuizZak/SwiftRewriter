// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXAddressBookAUResultParser.h"
// #import "ZXAddressBookParsedResult.h"
// #import "ZXResult.h"
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
 * Implements KDDI AU's address book format. See http://www.au.kddi.com/ezfactory/tec/two_dimensions/index.html.
 * (Thanks to Yuzo for translating!)
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
 * Implements KDDI AU's address book format. See http://www.au.kddi.com/ezfactory/tec/two_dimensions/index.html.
 * (Thanks to Yuzo for translating!)
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
class ZXAddressBookAUResultParser: ZXResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = ZXResultParser.massagedText(result)

        if rawText?.rangeOfString("MEMORY").location == NSNotFound || rawText?.rangeOfString("\\r\\n").location == NSNotFound {
            return nil
        }

        let name: String! = type(of: self).matchSinglePrefixedField("NAME1:", rawText: rawText, endChar: "\\r", trim: true)
        let pronunciation: String! = type(of: self).matchSinglePrefixedField("NAME2:", rawText: rawText, endChar: "\\r", trim: true)
        let phoneNumbers = self.matchMultipleValuePrefix("TEL", max: 3, rawText: rawText, trim: true)
        let emails = self.matchMultipleValuePrefix("MAIL", max: 3, rawText: rawText, trim: true)
        let note: String! = type(of: self).matchSinglePrefixedField("MEMORY:", rawText: rawText, endChar: "\\r", trim: false)
        let address: String! = type(of: self).matchSinglePrefixedField("ADD:", rawText: rawText, endChar: "\\r", trim: true)
        let addresses: NSArray! = (address == nil) ? nil : [address]

        return ZXAddressBookParsedResult.addressBookParsedResultWithNames(self.maybeWrap(name), nicknames: nil, pronunciation: pronunciation, phoneNumbers: phoneNumbers, phoneTypes: nil, emails: emails, emailTypes: nil, instantMessenger: nil, note: note, addresses: addresses, addressTypes: nil, org: nil, birthday: nil, title: nil, urls: nil, geo: nil)
    }
    @objc
    func matchMultipleValuePrefix(_ prefix: String!, max: CInt, rawText: String!, trim: Bool) -> NSArray? {
        var values: NSMutableArray! = nil
        var i: CInt = 1

        while i <= max {
            defer {
                i += 1
            }

            let value: String! = type(of: self).matchSinglePrefixedField(String(format: "%@%d:", prefix, i), rawText: rawText, endChar: "\\r", trim: trim)

            if value == nil {
                break
            }

            if values == nil {
                values = NSMutableArray(capacity: max)
            }

            values?.add(value)
        }

        if values == nil {
            return nil
        }

        return values
    }
}