// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXURIResultParser.h"
// #import "ZXResult.h"
// #import "ZXURIParsedResult.h"
var ZX_URL_WITH_PROTOCOL_PATTERN: NSRegularExpression! = nil
var ZX_URL_WITHOUT_PROTOCOL_PATTERN: NSRegularExpression! = nil

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
 * Tries to parse results that are a URI of some kind.
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
 * Tries to parse results that are a URI of some kind.
 */
@objc
class ZXURIResultParser: ZXResultParser {
    @objc
    static func initialize() {
        if self.self != ZXURIResultParser.self {
            return
        }

        // See http://www.ietf.org/rfc/rfc2396.txt
        ZX_URL_WITH_PROTOCOL_PATTERN = NSRegularExpression(pattern: "^[a-zA-Z][a-zA-Z0-9+-.]+:", options: 0, error: nil)
        ZX_URL_WITHOUT_PROTOCOL_PATTERN = NSRegularExpression(pattern: "([a-zA-Z0-9\\\\-]+\\\\.)+[a-zA-Z]{2,}".stringByAppendingString("(:\\\\d{1,5})?").stringByAppendingString("(/|\\\\?|$)"), options: 0, error: nil)
    }
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        var rawText = ZXResultParser.massagedText(result)

        // We specifically handle the odd "URL" scheme here for simplicity and add "URI" for fun
        // Assume anything starting this way really means to be a URI
        if rawText?.hasPrefix("URL:") || rawText?.hasPrefix("URI:") {
            return ZXURIParsedResult(uri: rawText?.substringFromIndex(4).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), title: nil)
        }

        rawText = rawText?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        return type(of: self).isBasicallyValidURI(rawText) ? ZXURIParsedResult.uriParsedResultWithUri(rawText, title: nil) : nil
    }
    @objc
    static func isBasicallyValidURI(_ uri: String!) -> Bool {
        if uri.rangeOfString(" ").location != NSNotFound {
            // Quick hack check for a common case
            return false
        }

        if ZX_URL_WITH_PROTOCOL_PATTERN.numberOfMatchesInString(uri, options: NSMatchingWithoutAnchoringBounds, range: NSMakeRange(0, uri.length)) > 0 {
            // match at start only
            return true
        }

        return ZX_URL_WITHOUT_PROTOCOL_PATTERN.numberOfMatchesInString(uri, options: NSMatchingWithoutAnchoringBounds, range: NSMakeRange(0, uri.length)) > 0
    }
}