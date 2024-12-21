// Preprocessor directives found in file:
// #import "ZXAbstractDoCoMoResultParser.h"
// #import "ZXBookmarkDoCoMoResultParser.h"
// #import "ZXResult.h"
// #import "ZXURIParsedResult.h"
// #import "ZXURIResultParser.h"
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
class ZXBookmarkDoCoMoResultParser: ZXAbstractDoCoMoResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = result.text

        if !rawText?.hasPrefix("MEBKM:") {
            return nil
        }

        let title: String! = type(of: self).matchSingleDoCoMoPrefixedField("TITLE:", rawText: rawText, trim: true)
        let rawUri: NSArray! = type(of: self).matchDoCoMoPrefixedField("URL:", rawText: rawText, trim: true)

        if rawUri == nil {
            return nil
        }

        let uri: String = rawUri[0]

        if !ZXURIResultParser.isBasicallyValidURI(uri) {
            return nil
        }

        return ZXURIParsedResult.uriParsedResultWithUri(uri, title: title)
    }
}