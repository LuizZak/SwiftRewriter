// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXProductParsedResult.h"
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
class ZXProductParsedResult: ZXParsedResult {
    private var _normalizedProductID: String!
    private var _productID: String!
    @objc var normalizedProductID: String! {
        return self._normalizedProductID
    }
    @objc var productID: String! {
        return self._productID
    }

    @objc
    init(productID: String!) {
        return self.init(productID: productID, normalizedProductID: productID)
    }
    @objc
    init(productID: String!, normalizedProductID: String!) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeProduct) {
            _normalizedProductID = normalizedProductID
            _productID = productID
        }

        return self
    }

    @objc
    static func productParsedResultWithProductID(_ productID: String!) -> AnyObject? {
        return self.init(productID: productID)
    }
    @objc
    static func productParsedResultWithProductID(_ productID: String!, normalizedProductID: String!) -> AnyObject? {
        return self.init(productID: productID, normalizedProductID: normalizedProductID)
    }
    @objc
    func displayResult() -> String? {
        return self.productID
    }
}