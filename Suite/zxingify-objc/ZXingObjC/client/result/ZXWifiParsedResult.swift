// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXParsedResultType.h"
// #import "ZXWifiParsedResult.h"
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
class ZXWifiParsedResult: ZXParsedResult {
    private var _ssid: String!
    private var _networkEncryption: String!
    private var _password: String!
    private var _hidden: Bool = false
    @objc var ssid: String! {
        return self._ssid
    }
    @objc var networkEncryption: String! {
        return self._networkEncryption
    }
    @objc var password: String! {
        return self._password
    }
    @objc var hidden: Bool {
        return self._hidden
    }

    @objc
    init(networkEncryption: String!, ssid: String!, password: String!) {
        return self.init(networkEncryption: networkEncryption, ssid: ssid, password: password)
    }
    @objc
    init(networkEncryption: String!, ssid: String!, password: String!, hidden: Bool) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeWifi) {
            _ssid = ssid

            _networkEncryption = networkEncryption

            _password = password

            _hidden = hidden
        }

        return self
    }

    @objc
    static func wifiParsedResultWithNetworkEncryption(_ networkEncryption: String!, ssid: String!, password: String!) -> AnyObject? {
        return self.init(networkEncryption: networkEncryption, ssid: ssid, password: password)
    }
    @objc
    static func wifiParsedResultWithNetworkEncryption(_ networkEncryption: String!, ssid: String!, password: String!, hidden: Bool) -> AnyObject? {
        return self.init(networkEncryption: networkEncryption, ssid: ssid, password: password, hidden: hidden)
    }
    @objc
    func displayResult() -> String? {
        let result = NSMutableString(capacity: 80)

        ZXParsedResult.maybeAppend(self.ssid, result: result)
        ZXParsedResult.maybeAppend(self.networkEncryption, result: result)
        ZXParsedResult.maybeAppend(self.password, result: result)
        ZXParsedResult.maybeAppend(self.hidden.stringValue(), result: result)

        return result
    }
}