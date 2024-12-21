// Preprocessor directives found in file:
// #import "ZXAbstractDoCoMoResultParser.h"
// #import "ZXResult.h"
// #import "ZXAddressBookDoCoMoResultParser.h"
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
 * Implements the "MECARD" address book entry format.
 *
 * Supported keys: N, SOUND, TEL, EMAIL, NOTE, ADR, BDAY, URL, plus ORG
 * Unsupported keys: TEL-AV, NICKNAME
 *
 * Except for TEL, multiple values for keys are also not supported;
 * the first one found takes precedence.
 *
 * Our understanding of the MECARD format is based on this document:
 *
 * http://www.mobicode.org.tw/files/OMIA%20Mobile%20Bar%20Code%20Standard%20v3.2.1.doc
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
 * Implements the "MECARD" address book entry format.
 *
 * Supported keys: N, SOUND, TEL, EMAIL, NOTE, ADR, BDAY, URL, plus ORG
 * Unsupported keys: TEL-AV, NICKNAME
 *
 * Except for TEL, multiple values for keys are also not supported;
 * the first one found takes precedence.
 *
 * Our understanding of the MECARD format is based on this document:
 *
 * http://www.mobicode.org.tw/files/OMIA%20Mobile%20Bar%20Code%20Standard%20v3.2.1.doc
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
class ZXAddressBookDoCoMoResultParser: ZXAbstractDoCoMoResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = ZXResultParser.massagedText(result)

        if !rawText?.hasPrefix("MECARD:") {
            return nil
        }

        let rawName: NSArray! = type(of: self).matchDoCoMoPrefixedField("N:", rawText: rawText, trim: true)

        if rawName == nil {
            return nil
        }

        let name = self.parseName(rawName[0])
        let pronunciation: String! = type(of: self).matchSingleDoCoMoPrefixedField("SOUND:", rawText: rawText, trim: true)
        let phoneNumbers: NSArray! = type(of: self).matchDoCoMoPrefixedField("TEL:", rawText: rawText, trim: true)
        let emails: NSArray! = type(of: self).matchDoCoMoPrefixedField("EMAIL:", rawText: rawText, trim: true)
        let note: String! = type(of: self).matchSingleDoCoMoPrefixedField("NOTE:", rawText: rawText, trim: false)
        let addresses: NSArray! = type(of: self).matchDoCoMoPrefixedField("ADR:", rawText: rawText, trim: true)
        var birthday: String! = type(of: self).matchSingleDoCoMoPrefixedField("BDAY:", rawText: rawText, trim: true)

        if !type(of: self).isStringOfDigits(birthday, length: 8) {
            birthday = nil
        }

        let urls: NSArray! = type(of: self).matchDoCoMoPrefixedField("URL:", rawText: rawText, trim: true)
        // Although ORG may not be strictly legal in MECARD, it does exist in VCARD and we might as well
        // honor it when found in the wild.
        let org: String! = type(of: self).matchSingleDoCoMoPrefixedField("ORG:", rawText: rawText, trim: true)

        return ZXAddressBookParsedResult.addressBookParsedResultWithNames(self.maybeWrap(name), nicknames: nil, pronunciation: pronunciation, phoneNumbers: phoneNumbers, phoneTypes: nil, emails: emails, emailTypes: nil, instantMessenger: nil, note: note, addresses: addresses, addressTypes: nil, org: org, birthday: birthday, title: nil, urls: urls, geo: nil)
    }
    @objc
    func parseName(_ name: String!) -> String? {
        let comma: UInt = name.rangeOfString(",").location

        if comma != NSNotFound {
            // Format may be last,first; switch it around
            return String(format: "%@ %@", name.substringFromIndex(comma + 1), name.substringToIndex(comma))
        }

        return name
    }
}