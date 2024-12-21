// Preprocessor directives found in file:
// #import "ZXAbstractDoCoMoResultParser.h"
// #import "ZXAddressBookParsedResult.h"
// #import "ZXBizcardResultParser.h"
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
 * Implements the "BIZCARD" address book entry format, though this has been
 * largely reverse-engineered from examples observed in the wild -- still
 * looking for a definitive reference.
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
 * Implements the "BIZCARD" address book entry format, though this has been
 * largely reverse-engineered from examples observed in the wild -- still
 * looking for a definitive reference.
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
class ZXBizcardResultParser: ZXAbstractDoCoMoResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = ZXResultParser.massagedText(result)

        if !rawText?.hasPrefix("BIZCARD:") {
            return nil
        }

        let firstName: String! = type(of: self).matchSingleDoCoMoPrefixedField("N:", rawText: rawText, trim: true)
        let lastName: String! = type(of: self).matchSingleDoCoMoPrefixedField("X:", rawText: rawText, trim: true)
        let fullName = self.buildName(firstName, lastName: lastName)
        let title: String! = type(of: self).matchSingleDoCoMoPrefixedField("T:", rawText: rawText, trim: true)
        let org: String! = type(of: self).matchSingleDoCoMoPrefixedField("C:", rawText: rawText, trim: true)
        let addresses: NSArray! = type(of: self).matchDoCoMoPrefixedField("A:", rawText: rawText, trim: true)
        let phoneNumber1: String! = type(of: self).matchSingleDoCoMoPrefixedField("B:", rawText: rawText, trim: true)
        let phoneNumber2: String! = type(of: self).matchSingleDoCoMoPrefixedField("M:", rawText: rawText, trim: true)
        let phoneNumber3: String! = type(of: self).matchSingleDoCoMoPrefixedField("F:", rawText: rawText, trim: true)
        let email: String! = type(of: self).matchSingleDoCoMoPrefixedField("E:", rawText: rawText, trim: true)

        return ZXAddressBookParsedResult.addressBookParsedResultWithNames(self.maybeWrap(fullName), nicknames: nil, pronunciation: nil, phoneNumbers: self.buildPhoneNumbers(phoneNumber1, number2: phoneNumber2, number3: phoneNumber3), phoneTypes: nil, emails: self.maybeWrap(email), emailTypes: nil, instantMessenger: nil, note: nil, addresses: addresses, addressTypes: nil, org: org, birthday: nil, title: title, urls: nil, geo: nil)
    }
    @objc
    func buildPhoneNumbers(_ number1: String!, number2: String!, number3: String!) -> NSArray {
        let numbers: NSMutableArray! = NSMutableArray.arrayWithCapacity(3)

        if number1 != nil {
            numbers.add(number1)
        }

        if number2 != nil {
            numbers.add(number2)
        }

        if number3 != nil {
            numbers.add(number3)
        }

        let size: UInt = UInt(numbers.count)

        if size == 0 {
            return nil
        }

        let result: NSMutableArray! = NSMutableArray.arrayWithCapacity(size)
        var i: CInt = 0

        while i < size {
            defer {
                i += 1
            }

            result.add(numbers[Int(i)])
        }

        return result
    }
    @objc
    func buildName(_ firstName: String!, lastName: String!) -> String {
        if firstName == nil {
            return lastName
        } else {
            return (lastName == nil) ? firstName : firstName.stringByAppendingString(" ").stringByAppendingString(lastName)
        }
    }
}