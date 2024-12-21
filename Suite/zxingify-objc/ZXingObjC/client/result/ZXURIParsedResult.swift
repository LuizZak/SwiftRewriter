// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXResultParser.h"
// #import "ZXURIParsedResult.h"
var ZX_USER_IN_HOST: NSRegularExpression! = nil

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
class ZXURIParsedResult: ZXParsedResult {
    private var _uri: String!
    private var _title: String!
    @objc var uri: String! {
        return self._uri
    }
    @objc var title: String! {
        return self._title
    }

    @objc
    init(uri: String!, title: String!) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeURI) {
            _uri = self.massageURI(uri)
            _title = title
        }

        return self
    }

    @objc
    static func initialize() {
        if self.self != ZXURIParsedResult.self {
            return
        }

        ZX_USER_IN_HOST = NSRegularExpression(pattern: ":/*([^/@]+)@[^/]+", options: 0, error: nil)
    }
    @objc
    static func uriParsedResultWithUri(_ uri: String!, title: String!) -> AnyObject? {
        return self.init(uri: uri, title: title)
    }
    /**
 * @return true if the URI contains suspicious patterns that may suggest it intends to
 *  mislead the user about its true nature. At the moment this looks for the presence
 *  of user/password syntax in the host/authority portion of a URI which may be used
 *  in attempts to make the URI's host appear to be other than it is. Example:
 *  http://yourbank.com@phisher.com  This URI connects to phisher.com but may appear
 *  to connect to yourbank.com at first glance.
 */
    /**
 * @return true if the URI contains suspicious patterns that may suggest it intends to
 *  mislead the user about its true nature. At the moment this looks for the presence
 *  of user/password syntax in the host/authority portion of a URI which may be used
 *  in attempts to make the URI's host appear to be other than it is. Example:
 *  http://yourbank.com@phisher.com  This URI connects to phisher.com but may appear
 *  to connect to yourbank.com at first glance.
 */
    @objc
    func possiblyMaliciousURI() -> Bool {
        return ZX_USER_IN_HOST.numberOfMatchesInString(self.uri, options: 0, range: NSMakeRange(0, self.uri.length)) > 0
    }
    @objc
    func displayResult() -> String? {
        let result = NSMutableString(capacity: 30)

        ZXParsedResult.maybeAppend(self.title, result: result)
        ZXParsedResult.maybeAppend(self.uri, result: result)

        return result
    }
    /**
 * Transforms a string that represents a URI into something more proper, by adding or canonicalizing
 * the protocol.
 */
    @objc
    func massageURI(_ uri: String!) -> String {
        var massagedUri: String! = uri.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let protocolEnd: UInt = massagedUri.rangeOfString(":").location

        if protocolEnd == NSNotFound {
            // No protocol, assume http
            massagedUri = String(format: "http://%@", massagedUri)
        } else if self.isColonFollowedByPortNumber(massagedUri, protocolEnd: CInt(protocolEnd)) {
            // Found a colon, but it looks like it is after the host, so the protocol is still missing
            massagedUri = String(format: "http://%@", massagedUri)
        }

        return massagedUri
    }
    @objc
    func isColonFollowedByPortNumber(_ uri: String!, protocolEnd: CInt) -> Bool {
        let start = protocolEnd + 1
        var nextSlash: UInt = uri.rangeOfString("/", options: 0, range: NSMakeRange(start, uri.length() - start)).location

        if nextSlash == NSNotFound {
            nextSlash = uri.length()
        }

        return ZXResultParser.isSubstringOfDigits(uri, offset: start, length: CInt(nextSlash) - start)
    }
}