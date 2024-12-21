// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXAddressBookParsedResult.h"
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
class ZXAddressBookParsedResult: ZXParsedResult {
    private var _names: NSArray!
    private var _nicknames: NSArray!
    private var _pronunciation: String!
    private var _phoneNumbers: NSArray!
    private var _phoneTypes: NSArray!
    private var _emails: NSArray!
    private var _emailTypes: NSArray!
    private var _instantMessenger: String!
    private var _note: String!
    private var _addresses: NSArray!
    private var _addressTypes: NSArray!
    private var _title: String!
    private var _org: String!
    private var _urls: NSArray!
    private var _birthday: String!
    private var _geo: NSArray!
    @objc var names: NSArray! {
        return self._names
    }
    @objc var nicknames: NSArray! {
        return self._nicknames
    }
    /**
 * In Japanese, the name is written in kanji, which can have multiple readings. Therefore a hint
 * is often provided, called furigana, which spells the name phonetically.
 *
 * @return The pronunciation of the names property, often in hiragana or katakana.
 */
    @objc var pronunciation: String! {
        return self._pronunciation
    }
    @objc var phoneNumbers: NSArray! {
        return self._phoneNumbers
    }
    /**
 * @return optional descriptions of the type of each phone number. It could be like "HOME", but,
 *  there is no guaranteed or standard format.
 */
    @objc var phoneTypes: NSArray! {
        return self._phoneTypes
    }
    @objc var emails: NSArray! {
        return self._emails
    }
    /**
 * @return optional descriptions of the type of each e-mail. It could be like "WORK", but,
 *  there is no guaranteed or standard format.
 */
    @objc var emailTypes: NSArray! {
        return self._emailTypes
    }
    @objc var instantMessenger: String! {
        return self._instantMessenger
    }
    @objc var note: String! {
        return self._note
    }
    @objc var addresses: NSArray! {
        return self._addresses
    }
    /**
 * @return optional descriptions of the type of each e-mail. It could be like "WORK", but,
 *  there is no guaranteed or standard format.
 */
    @objc var addressTypes: NSArray! {
        return self._addressTypes
    }
    @objc var title: String! {
        return self._title
    }
    @objc var org: String! {
        return self._org
    }
    @objc var urls: NSArray! {
        return self._urls
    }
    /**
 * @return birthday formatted as yyyyMMdd (e.g. 19780917)
 */
    @objc var birthday: String! {
        return self._birthday
    }
    /**
 * @return a location as a latitude/longitude pair
 */
    @objc var geo: NSArray! {
        return self._geo
    }

    @objc
    init(names: NSArray!, phoneNumbers: NSArray!, phoneTypes: NSArray!, emails: NSArray!, emailTypes: NSArray!, addresses: NSArray!, addressTypes: NSArray!) {
        return self.init(names: names, nicknames: nil, pronunciation: nil, phoneNumbers: phoneNumbers, phoneTypes: phoneNumbers, emails: emails, emailTypes: _emailTypes, instantMessenger: nil, note: nil, addresses: addresses, addressTypes: addressTypes, org: nil, birthday: nil, title: nil, urls: nil, geo: nil)
    }
    @objc
    init(names: NSArray!, nicknames: NSArray!, pronunciation: String!, phoneNumbers: NSArray!, phoneTypes: NSArray!, emails: NSArray!, emailTypes: NSArray!, instantMessenger: String!, note: String!, addresses: NSArray!, addressTypes: NSArray!, org: String!, birthday: String!, title: String!, urls: NSArray!, geo: NSArray!) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeAddressBook) {
            _names = names

            _nicknames = nicknames

            _pronunciation = pronunciation

            _phoneNumbers = phoneNumbers

            _phoneTypes = phoneTypes

            _emails = emails

            _emailTypes = emailTypes

            _instantMessenger = instantMessenger

            _note = note

            _addresses = addresses

            _addressTypes = addressTypes

            _org = org

            _birthday = birthday

            _title = title

            _urls = urls

            _geo = geo
        }

        return self
    }

    @objc
    static func addressBookParsedResultWithNames(_ names: NSArray!, phoneNumbers: NSArray!, phoneTypes: NSArray!, emails: NSArray!, emailTypes: NSArray!, addresses: NSArray!, addressTypes: NSArray!) -> AnyObject? {
        return self.init(names: names, phoneNumbers: phoneNumbers, phoneTypes: phoneTypes, emails: emails, emailTypes: emailTypes, addresses: addresses, addressTypes: addressTypes)
    }
    @objc
    static func addressBookParsedResultWithNames(_ names: NSArray!, nicknames: NSArray!, pronunciation: String!, phoneNumbers: NSArray!, phoneTypes: NSArray!, emails: NSArray!, emailTypes: NSArray!, instantMessenger: String!, note: String!, addresses: NSArray!, addressTypes: NSArray!, org: String!, birthday: String!, title: String!, urls: NSArray!, geo: NSArray!) -> AnyObject? {
        return self.init(names: names, nicknames: nicknames, pronunciation: pronunciation, phoneNumbers: phoneNumbers, phoneTypes: phoneTypes, emails: emails, emailTypes: emailTypes, instantMessenger: instantMessenger, note: note, addresses: addresses, addressTypes: addressTypes, org: org, birthday: birthday, title: title, urls: urls, geo: geo)
    }
    @objc
    func displayResult() -> String? {
        let result = NSMutableString()

        ZXParsedResult.maybeAppendArray(self.names, result: result)
        ZXParsedResult.maybeAppendArray(self.nicknames, result: result)
        ZXParsedResult.maybeAppend(self.pronunciation, result: result)
        ZXParsedResult.maybeAppend(self.title, result: result)
        ZXParsedResult.maybeAppend(self.org, result: result)
        ZXParsedResult.maybeAppendArray(self.addresses, result: result)
        ZXParsedResult.maybeAppendArray(self.phoneNumbers, result: result)
        ZXParsedResult.maybeAppendArray(self.emails, result: result)
        ZXParsedResult.maybeAppend(self.instantMessenger, result: result)
        ZXParsedResult.maybeAppendArray(self.urls, result: result)
        ZXParsedResult.maybeAppend(self.birthday, result: result)
        ZXParsedResult.maybeAppendArray(self.geo, result: result)
        ZXParsedResult.maybeAppend(self.note, result: result)

        return result
    }
}