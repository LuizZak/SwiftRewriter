// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXAbstractDoCoMoResultParser.h"
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
 * See DoCoMo's documentation http://www.nttdocomo.co.jp/english/service/imode/make/content/barcode/about/s2.html
 * about the result types represented by subclasses of this class.
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
 * See DoCoMo's documentation http://www.nttdocomo.co.jp/english/service/imode/make/content/barcode/about/s2.html
 * about the result types represented by subclasses of this class.
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
class ZXAbstractDoCoMoResultParser: ZXResultParser {
    @objc
    static func matchDoCoMoPrefixedField(_ prefix: String!, rawText: String!, trim: Bool) -> NSArray? {
        return self.matchPrefixedField(prefix, rawText: rawText, endChar: ';', trim: trim)
    }
    @objc
    static func matchSingleDoCoMoPrefixedField(_ prefix: String!, rawText: String!, trim: Bool) -> String? {
        return self.matchSinglePrefixedField(prefix, rawText: rawText, endChar: ';', trim: trim)
    }
}