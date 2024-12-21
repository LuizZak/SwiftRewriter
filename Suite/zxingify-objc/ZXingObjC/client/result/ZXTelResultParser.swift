// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXTelParsedResult.h"
// #import "ZXTelResultParser.h"
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
 * Parses a "tel:" URI result, which specifies a phone number.
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
 * Parses a "tel:" URI result, which specifies a phone number.
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
class ZXTelResultParser: ZXResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = ZXResultParser.massagedText(result)

        if !rawText?.hasPrefix("tel:") && !rawText?.hasPrefix("TEL:") {
            return nil
        }

        // Normalize "TEL:" to "tel:"
        let telURI: String! = rawText?.hasPrefix("TEL:") ? "tel:".stringByAppendingString(rawText?.substringFromIndex(4)) : rawText
        // Drop tel, query portion
        let queryStart: UInt = rawText?.rangeOfString("?", options: NSLiteralSearch, range: NSMakeRange(4, rawText?.length() - 4)).location
        let number: String! = (queryStart == NSNotFound) ? rawText?.substringFromIndex(4) : rawText?.substringWithRange(NSMakeRange(4, rawText?.length() - queryStart))

        return ZXTelParsedResult.telParsedResultWithNumber(number, telURI: telURI, title: nil)
    }
}