// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXVINParsedResult.h"
/*
 * Copyright 2014 ZXing authors
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
 * Copyright 2014 ZXing authors
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
 * Copyright 2014 ZXing authors
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
class ZXVINParsedResult: ZXParsedResult {
    private var _vin: String!
    private var _worldManufacturerID: String!
    private var _vehicleDescriptorSection: String!
    private var _vehicleIdentifierSection: String!
    private var _countryCode: String!
    private var _vehicleAttributes: String!
    private var _modelYear: CInt = 0
    private var _plantCode: unichar
    private var _sequentialNumber: String!
    @objc var vin: String! {
        return self._vin
    }
    @objc var worldManufacturerID: String! {
        return self._worldManufacturerID
    }
    @objc var vehicleDescriptorSection: String! {
        return self._vehicleDescriptorSection
    }
    @objc var vehicleIdentifierSection: String! {
        return self._vehicleIdentifierSection
    }
    @objc var countryCode: String! {
        return self._countryCode
    }
    @objc var vehicleAttributes: String! {
        return self._vehicleAttributes
    }
    @objc var modelYear: CInt {
        return self._modelYear
    }
    @objc var plantCode: unichar {
        return self._plantCode
    }
    @objc var sequentialNumber: String! {
        return self._sequentialNumber
    }

    @objc
    init(vIN vin: String!, worldManufacturerID: String!, vehicleDescriptorSection: String!, vehicleIdentifierSection: String!, countryCode: String!, vehicleAttributes: String!, modelYear: CInt, plantCode: unichar, sequentialNumber: String!) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeVIN) {
            _vin = vin

            _worldManufacturerID = worldManufacturerID

            _vehicleDescriptorSection = vehicleDescriptorSection

            _vehicleIdentifierSection = vehicleIdentifierSection

            _countryCode = countryCode

            _vehicleAttributes = vehicleAttributes

            _modelYear = modelYear

            _plantCode = plantCode

            _sequentialNumber = sequentialNumber
        }

        return self
    }

    @objc
    func displayResult() -> String? {
        let result = NSMutableString(capacity: 50)

        result.appendFormat("%@ ", self.worldManufacturerID)
        result.appendFormat("%@ ", self.vehicleDescriptorSection)
        result.appendFormat("%@\\n", self.vehicleIdentifierSection)

        if self.countryCode {
            result.appendFormat("%@ ", self.countryCode)
        }

        result.appendFormat("%d ", self.modelYear)
        result.appendFormat("%C ", self.plantCode)
        result.appendFormat("%@\\n", self.sequentialNumber)

        return String.stringWithString(result)
    }
}