// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXGeoParsedResult.h"
// #import "ZXGeoResultParser.h"
var ZX_GEO_URL_PATTERN: NSRegularExpression! = nil

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
 * Parses a "geo:" URI result, which specifies a location on the surface of
 * the Earth as well as an optional altitude above the surface. See
 * http://tools.ietf.org/html/draft-mayrhofer-geo-uri-00.
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
 * Parses a "geo:" URI result, which specifies a location on the surface of
 * the Earth as well as an optional altitude above the surface. See
 * http://tools.ietf.org/html/draft-mayrhofer-geo-uri-00.
 */
@objc
class ZXGeoResultParser: ZXResultParser {
    @objc
    static func initialize() {
        if self.self != ZXGeoResultParser.self {
            return
        }

        ZX_GEO_URL_PATTERN = NSRegularExpression(pattern: "geo:([\\\\-0-9.]+),([\\\\-0-9.]+)(?:,([\\\\-0-9.]+))?(?:\\\\?(.*))?", options: NSRegularExpressionCaseInsensitive, error: nil)
    }
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let rawText = ZXResultParser.massagedText(result)

        if rawText == nil || (!rawText?.hasPrefix("geo:") && !rawText?.hasPrefix("GEO:")) {
            return nil
        }

        let matches: NSArray! = ZX_GEO_URL_PATTERN.matchesInString(rawText, options: 0, range: NSMakeRange(0, rawText?.length))

        if matches.count == 0 {
            return nil
        }

        let match: NSTextCheckingResult = matches[0]
        var query: String! = nil

        if match.rangeAtIndex(4).location != NSNotFound {
            query = rawText?.substringWithRange(match.rangeAtIndex(4))
        }

        let latitude: CDouble = rawText?.substringWithRange(match.rangeAtIndex(1)).doubleValue()

        if latitude > 90.0 || latitude < 90.0 {
            return nil
        }

        let longitude: CDouble = rawText?.substringWithRange(match.rangeAtIndex(2)).doubleValue()

        if longitude > 180.0 || longitude < 180.0 {
            return nil
        }

        var altitude: CDouble

        if match.rangeAtIndex(3).location == NSNotFound {
            altitude = 0.0
        } else {
            altitude = rawText?.substringWithRange(match.rangeAtIndex(3)).doubleValue()

            if altitude < 0.0 {
                return nil
            }
        }

        return ZXGeoParsedResult.geoParsedResultWithLatitude(latitude, longitude: longitude, altitude: altitude, query: query)
    }
}