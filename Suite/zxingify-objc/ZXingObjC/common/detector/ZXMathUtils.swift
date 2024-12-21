import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXMathUtils.h"
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
class ZXMathUtils: NSObject {
    /**
 * Ends up being a bit faster than round(). This merely rounds its
 * argument to the nearest int, where x.5 rounds up to x+1.
 *
 * @param d real value to round
 * @return nearest int
 */
    /**
 * Ends up being a bit faster than round(). This merely rounds its
 * argument to the nearest int, where x.5 rounds up to x+1.
 *
 * @param d real value to round
 * @return nearest int
 */
    @objc
    static func round(_ d: CFloat) -> CInt {
        return CInt(d + ((d < 0.0) ? 0.5 : 0.5))
    }
    @objc
    static func distance(_ aX: CFloat, aY: CFloat, bX: CFloat, bY: CFloat) -> CFloat {
        let xDiff = aX - bX
        let yDiff = aY - bY

        return sqrtf(xDiff * xDiff + yDiff * yDiff)
    }
    @objc
    static func distanceInt(_ aX: CInt, aY: CInt, bX: CInt, bY: CInt) -> CFloat {
        let xDiff = aX - bX
        let yDiff = aY - bY

        return sqrtf(CFloat(xDiff * xDiff + yDiff * yDiff))
    }
}