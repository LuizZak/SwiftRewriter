// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXEmailAddressParsedResult.h"
// #import "ZXEmailAddressResultParser.h"
// #import "ZXEmailDoCoMoResultParser.h"
// #import "ZXResult.h"
var ZX_EMAIL_ADDRESS_RESULT_COMMA: NSCharacterSet! = nil

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
 * Represents a result that encodes an e-mail address, either as a plain address
 * like "joe@example.org" or a mailto: URL like "mailto:joe@example.org".
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
 * Represents a result that encodes an e-mail address, either as a plain address
 * like "joe@example.org" or a mailto: URL like "mailto:joe@example.org".
 */
@objc
class ZXEmailAddressResultParser: ZXResultParser {
    @objc
    static func initialize() {
        if self.self != ZXEmailAddressResultParser.self {
            return
        }

        ZX_EMAIL_ADDRESS_RESULT_COMMA = NSCharacterSet.characterSetWithCharactersInString(",")
    }
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult {
        let rawText = ZXResultParser.massagedText(result)

        if rawText?.hasPrefix("mailto:") || rawText?.hasPrefix("MAILTO:") {
            // If it starts with mailto:, assume it is definitely trying to be an email address
            var hostEmail: String! = rawText?.substringFromIndex(7)
            let queryStart: UInt = hostEmail.rangeOfString("?").location

            if queryStart != NSNotFound {
                hostEmail = hostEmail.substringToIndex(queryStart)
            }

            hostEmail = type(of: self).urlDecode(hostEmail)

            var tos: NSArray!

            if hostEmail.length > 0 {
                tos = hostEmail.componentsSeparatedByCharactersInSet(ZX_EMAIL_ADDRESS_RESULT_COMMA)
            }

            let nameValues = self.parseNameValuePairs(rawText)
            var ccs: NSArray!
            var bccs: NSArray!
            var subject: String! = nil
            var body: String! = nil

            if nameValues != nil {
                if !tos {
                    let tosString: String! = nameValues["to"]

                    if tosString != nil {
                        tos = tosString?.componentsSeparatedByCharactersInSet(ZX_EMAIL_ADDRESS_RESULT_COMMA)
                    }
                }

                let ccString: String! = nameValues["cc"]

                if ccString != nil {
                    ccs = ccString?.componentsSeparatedByCharactersInSet(ZX_EMAIL_ADDRESS_RESULT_COMMA)
                }

                let bccString: String! = nameValues["bcc"]

                if bccString != nil {
                    bccs = bccString?.componentsSeparatedByCharactersInSet(ZX_EMAIL_ADDRESS_RESULT_COMMA)
                }

                subject = nameValues["subject"]
                body = nameValues["body"]
            }

            return ZXEmailAddressParsedResult(tos: tos, ccs: ccs, bccs: bccs, subject: subject, body: body)
        } else {
            if !ZXEmailDoCoMoResultParser.isBasicallyValidEmailAddress(rawText) {
                return nil
            }

            return ZXEmailAddressParsedResult(to: rawText)
        }
    }
}