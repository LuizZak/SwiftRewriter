// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXResult.h"
// #import "ZXSMSMMSResultParser.h"
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
/**
 * Parses an "sms:" URI result, which specifies a number to SMS.
 * See http://tools.ietf.org/html/rfc5724 on this.
 *
 * This class supports "via" syntax for numbers, which is not part of the spec.
 * For example "+12125551212;via=+12124440101" may appear as a number.
 * It also supports a "subject" query parameter, which is not mentioned in the spec.
 * These are included since they were mentioned in earlier IETF drafts and might be
 * used.
 *
 * This actually also parses URIs starting with "mms:" and treats them all the same way,
 * and effectively converts them to an "sms:" URI for purposes of forwarding to the platform.
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
 * Parses an "sms:" URI result, which specifies a number to SMS.
 * See http://tools.ietf.org/html/rfc5724 on this.
 *
 * This class supports "via" syntax for numbers, which is not part of the spec.
 * For example "+12125551212;via=+12124440101" may appear as a number.
 * It also supports a "subject" query parameter, which is not mentioned in the spec.
 * These are included since they were mentioned in earlier IETF drafts and might be
 * used.
 *
 * This actually also parses URIs starting with "mms:" and treats them all the same way,
 * and effectively converts them to an "sms:" URI for purposes of forwarding to the platform.
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
class ZXSMSMMSResultParser: ZXResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = ZXResultParser.massagedText(result)

        if !(rawText?.hasPrefix("sms:") || rawText?.hasPrefix("SMS:") || rawText?.hasPrefix("mms:") || rawText?.hasPrefix("MMS:")) {
            return nil
        }

        // Check up front if this is a URI syntax string with query arguments
        let nameValuePairs = self.parseNameValuePairs(rawText)
        var subject: String! = nil
        var body: String! = nil
        var querySyntax = false

        if nameValuePairs != nil && nameValuePairs.count > 0 {
            subject = nameValuePairs["subject"]
            body = nameValuePairs["body"]
            querySyntax = true
        }

        // Drop sms, query portion
        let queryStart: UInt = rawText?.rangeOfString("?", options: NSLiteralSearch, range: NSMakeRange(4, rawText?.length() - 4)).location
        var smsURIWithoutQuery: String!

        // If it's not query syntax, the question mark is part of the subject or message
        if queryStart == NSNotFound || !querySyntax {
            smsURIWithoutQuery = rawText?.substringFromIndex(4)
        } else {
            smsURIWithoutQuery = rawText?.substringWithRange(NSMakeRange(4, queryStart - 4))
        }

        var lastComma: CInt = 1
        var comma: Int
        let numbers: NSMutableArray! = NSMutableArray.arrayWithCapacity(1)
        let vias: NSMutableArray! = NSMutableArray.arrayWithCapacity(1)

        while (comma = smsURIWithoutQuery.rangeOfString(",", options: NSLiteralSearch, range: NSMakeRange(lastComma + 1, CInt(smsURIWithoutQuery.length()) - lastComma - 1)).location) > lastComma && comma != NSNotFound {
            let numberPart: String! = smsURIWithoutQuery.substringWithRange(NSMakeRange(lastComma + 1, comma - Int(lastComma) - 1))

            self.addNumberVia(numbers, vias: vias, numberPart: numberPart)
            lastComma = CInt(comma)
        }

        self.addNumberVia(numbers, vias: vias, numberPart: smsURIWithoutQuery.substringFromIndex(lastComma + 1))

        return ZXSMSParsedResult.smsParsedResultWithNumbers(numbers, vias: vias, subject: subject, body: body)
    }
    @objc
    func addNumberVia(_ numbers: NSMutableArray!, vias: NSMutableArray!, numberPart: String!) {
        let numberEnd: UInt = numberPart.rangeOfString(";").location

        if numberEnd == NSNotFound {
            numbers.add(numberPart)
            vias.add(NSNull.null())
        } else {
            numbers.add(numberPart.substringToIndex(numberEnd))

            let maybeVia: String! = numberPart.substringFromIndex(numberEnd + 1)

            if maybeVia.hasPrefix("via=") {
                vias.add(maybeVia.substringFromIndex(4))
            } else {
                vias.add(NSNull.null())
            }
        }
    }
}