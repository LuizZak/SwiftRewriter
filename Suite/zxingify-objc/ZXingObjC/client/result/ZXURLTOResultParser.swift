// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXResult.h"
// #import "ZXURIParsedResult.h"
// #import "ZXURLTOResultParser.h"
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
 * Parses the "URLTO" result format, which is of the form "URLTO:[title]:[url]".
 * This seems to be used sometimes, but I am not able to find documentation
 * on its origin or official format?
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
 * Parses the "URLTO" result format, which is of the form "URLTO:[title]:[url]".
 * This seems to be used sometimes, but I am not able to find documentation
 * on its origin or official format?
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
class ZXURLTOResultParser: ZXResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = ZXResultParser.massagedText(result)

        if !rawText?.hasPrefix("urlto:") && !rawText?.hasPrefix("URLTO:") {
            return nil
        }

        let titleEnd: UInt = rawText?.rangeOfString(":", options: NSLiteralSearch, range: NSMakeRange(6, rawText?.length() - 6)).location

        if titleEnd == NSNotFound {
            return nil
        }

        let title: String! = (titleEnd <= 6) ? nil : rawText?.substringWithRange(NSMakeRange(6, titleEnd - 6))
        let uri: String! = rawText?.substringFromIndex(titleEnd + 1)

        return ZXURIParsedResult.uriParsedResultWithUri(uri, title: title)
    }
}