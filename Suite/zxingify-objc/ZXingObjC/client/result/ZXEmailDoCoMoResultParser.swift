// Preprocessor directives found in file:
// #import "ZXAbstractDoCoMoResultParser.h"
// #import "ZXEmailAddressParsedResult.h"
// #import "ZXEmailDoCoMoResultParser.h"
// #import "ZXResult.h"
var ZX_ATEXT_ALPHANUMERIC: NSRegularExpression! = nil

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
 * Implements the "MATMSG" email message entry format.
 *
 * Supported keys: TO, SUB, BODY
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
 * Implements the "MATMSG" email message entry format.
 *
 * Supported keys: TO, SUB, BODY
 */
@objc
class ZXEmailDoCoMoResultParser: ZXAbstractDoCoMoResultParser {
    @objc
    static func initialize() {
        if self.self != ZXEmailDoCoMoResultParser.self {
            return
        }

        ZX_ATEXT_ALPHANUMERIC = NSRegularExpression(pattern: "^[a-zA-Z0-9@.!#$%&\'*+\\\\-/=?^_`{|}~]+$", options: 0, error: nil)
    }
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = ZXResultParser.massagedText(result)

        if !rawText?.hasPrefix("MATMSG:") {
            return nil
        }

        let tos: NSArray! = type(of: self).matchDoCoMoPrefixedField("TO:", rawText: rawText, trim: true)

        if tos == nil {
            return nil
        }

        for to in tos {
            if !type(of: self).isBasicallyValidEmailAddress(to) {
                return nil
            }
        }

        let subject: String! = type(of: self).matchSingleDoCoMoPrefixedField("SUB:", rawText: rawText, trim: false)
        let body: String! = type(of: self).matchSingleDoCoMoPrefixedField("BODY:", rawText: rawText, trim: false)

        return ZXEmailAddressParsedResult(tos: tos, ccs: nil, bccs: nil, subject: subject, body: body)
    }
    /**
 * This implements only the most basic checking for an email address's validity -- that it contains
 * an '@' and contains no characters disallowed by RFC 2822. This is an overly lenient definition of
 * validity. We want to generally be lenient here since this class is only intended to encapsulate what's
 * in a barcode, not "judge" it.
 */
    /**
 * This implements only the most basic checking for an email address's validity -- that it contains
 * an '@' and contains no characters disallowed by RFC 2822. This is an overly lenient definition of
 * validity. We want to generally be lenient here since this class is only intended to encapsulate what's
 * in a barcode, not "judge" it.
 */
    @objc
    static func isBasicallyValidEmailAddress(_ email: String!) -> Bool {
        return email != nil && ZX_ATEXT_ALPHANUMERIC.numberOfMatchesInString(email, options: 0, range: NSMakeRange(0, email.length)) > 0 && email.rangeOfString("@").location != NSNotFound
    }
}