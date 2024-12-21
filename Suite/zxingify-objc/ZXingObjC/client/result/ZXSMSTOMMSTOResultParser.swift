// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXResult.h"
// #import "ZXSMSTOMMSTOResultParser.h"
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
 * Parses an "smsto:" URI result, whose format is not standardized but appears to be like:
 * smsto:number(:body).
 *
 * This actually also parses URIs starting with "smsto:", "mmsto:", "SMSTO:", and
 * "MMSTO:", and treats them all the same way, and effectively converts them to an "sms:" URI
 * for purposes of forwarding to the platform.
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
 * Parses an "smsto:" URI result, whose format is not standardized but appears to be like:
 * smsto:number(:body).
 *
 * This actually also parses URIs starting with "smsto:", "mmsto:", "SMSTO:", and
 * "MMSTO:", and treats them all the same way, and effectively converts them to an "sms:" URI
 * for purposes of forwarding to the platform.
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
class ZXSMSTOMMSTOResultParser: ZXResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = ZXResultParser.massagedText(result)

        if !(rawText?.hasPrefix("smsto:") || rawText?.hasPrefix("SMSTO:") || rawText?.hasPrefix("mmsto:") || rawText?.hasPrefix("MMSTO:")) {
            return nil
        }

        // Thanks to dominik.wild for suggesting this enhancement to support
        // smsto:number:body URIs
        var number: String! = rawText?.substringFromIndex(6)
        var body: String! = nil
        let bodyStart: UInt = number.rangeOfString(":").location

        if bodyStart != NSNotFound {
            body = number.substringFromIndex(bodyStart + 1)
            number = number.substringToIndex(bodyStart)
        }

        return ZXSMSParsedResult.smsParsedResultWithNumber(number, via: nil, subject: nil, body: body)
    }
}