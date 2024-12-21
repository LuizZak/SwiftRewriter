// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXGeoParsedResult.h"
// #import "ZXParsedResultType.h"
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
class ZXGeoParsedResult: ZXParsedResult {
    private var _latitude: CDouble = 0.0
    private var _longitude: CDouble = 0.0
    private var _altitude: CDouble = 0.0
    private var _query: String!
    /**
 * @return latitude in degrees
 */
    @objc var latitude: CDouble {
        return self._latitude
    }
    /**
 * @return longitude in degrees
 */
    @objc var longitude: CDouble {
        return self._longitude
    }
    /**
 * @return altitude in meters. If not specified, in the geo URI, returns 0.0
 */
    @objc var altitude: CDouble {
        return self._altitude
    }
    /**
 * @return query string associated with geo URI or null if none exists
 */
    @objc var query: String! {
        return self._query
    }

    @objc
    init(latitude: CDouble, longitude: CDouble, altitude: CDouble, query: String!) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeGeo) {
            _latitude = latitude

            _longitude = longitude

            _altitude = altitude

            _query = query
        }

        return self
    }

    @objc
    static func geoParsedResultWithLatitude(_ latitude: CDouble, longitude: CDouble, altitude: CDouble, query: String!) -> AnyObject? {
        return self.init(latitude: latitude, longitude: longitude, altitude: altitude, query: query)
    }
    @objc
    func geoURI() -> String? {
        let result = NSMutableString()

        result.appendFormat("geo:%f,%f", self.latitude, self.longitude)

        if self.altitude > 0 {
            result.appendFormat(",%f", self.altitude)
        }

        if self.query != nil {
            result.appendFormat("?%@", self.query)
        }

        return result
    }
    @objc
    func displayResult() -> String? {
        let result = NSMutableString()

        result.appendFormat("%f, %f", self.latitude, self.longitude)

        if self.altitude > 0.0 {
            result.appendFormat(", %f", self.altitude)
            result.append("m")
        }

        if self.query != nil {
            result.appendFormat(" (%@)", self.query)
        }

        return result
    }
}