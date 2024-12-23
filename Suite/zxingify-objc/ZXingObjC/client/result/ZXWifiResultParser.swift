// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXResult.h"
// #import "ZXWifiResultParser.h"
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
/**
 * Parses a WIFI configuration string.  Strings will be of the form:
 *
 * WIFI:T:[network type];S:[SSID];P:[network password];H:[hidden?];;
 *
 * The fields can appear in any order. Only "S:" is required.
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
 * Parses a WIFI configuration string.  Strings will be of the form:
 *
 * WIFI:T:[network type];S:[SSID];P:[network password];H:[hidden?];;
 *
 * The fields can appear in any order. Only "S:" is required.
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
class ZXWifiResultParser: ZXResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = ZXResultParser.massagedText(result)

        if !rawText?.hasPrefix("WIFI:") {
            return nil
        }

        let ssid: String! = type(of: self).matchSinglePrefixedField("S:", rawText: rawText, endChar: ";", trim: false)

        if ssid == nil || ssid.length == 0 {
            return nil
        }

        let pass: String! = type(of: self).matchSinglePrefixedField("P:", rawText: rawText, endChar: ";", trim: false)
        var type: String! = type(of: self).matchSinglePrefixedField("T:", rawText: rawText, endChar: ";", trim: false)

        if type == nil {
            type = "nopass"
        }

        let hidden: Bool = type(of: self).matchSinglePrefixedField("H:", rawText: rawText, endChar: ";", trim: false).boolValue()

        return ZXWifiParsedResult.wifiParsedResultWithNetworkEncryption(type, ssid: ssid, password: pass, hidden: hidden)
    }
}