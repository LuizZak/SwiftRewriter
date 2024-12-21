// Preprocessor directives found in file:
// #import "ZXResultPoint.h"
// #import "ZXQRCodeFinderPattern.h"
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
 * Encapsulates a finder pattern, which are the three square patterns found in
 * the corners of QR Codes. It also encapsulates a count of similar finder patterns,
 * as a convenience to the finder's bookkeeping.
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
 * Encapsulates a finder pattern, which are the three square patterns found in
 * the corners of QR Codes. It also encapsulates a count of similar finder patterns,
 * as a convenience to the finder's bookkeeping.
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
class ZXQRCodeFinderPattern: ZXResultPoint {
    private var _count: CInt = 0
    private var _estimatedModuleSize: CFloat = 0.0
    @objc var count: CInt {
        return self._count
    }
    @objc var estimatedModuleSize: CFloat {
        return self._estimatedModuleSize
    }

    @objc
    init(posX: CFloat, posY: CFloat, estimatedModuleSize: CFloat) {
        return self.init(posX: posX, posY: posY, estimatedModuleSize: estimatedModuleSize, count: 1)
    }
    @objc
    init(posX: CFloat, posY: CFloat, estimatedModuleSize: CFloat, count: CInt) {
        if self = super.init(x: posX, y: posY) {
            _estimatedModuleSize = estimatedModuleSize
            _count = count
        }

        return self
    }

    //- (void)incrementCount;
    /**
 * Determines if this finder pattern "about equals" a finder pattern at the stated
 * position and size -- meaning, it is at nearly the same center with nearly the same size.
 */
    //- (void)incrementCount;
    /**
 * Determines if this finder pattern "about equals" a finder pattern at the stated
 * position and size -- meaning, it is at nearly the same center with nearly the same size.
 */
    /*
- (void)incrementCount {
  self.count++;
}
*/
    @objc
    func aboutEquals(_ moduleSize: CFloat, i: CFloat, j: CFloat) -> Bool {
        if fabsf(i - self.y) <= moduleSize && fabsf(j - self.x) <= moduleSize {
            let moduleSizeDiff = fabsf(moduleSize - self.estimatedModuleSize)

            return moduleSizeDiff <= 1.0 || moduleSizeDiff <= self.estimatedModuleSize
        }

        return false
    }
    /**
 * Combines this object's current estimate of a finder pattern position and module size
 * with a new estimate. It returns a new ZXFinderPattern containing a weighted average
 * based on count.
 */
    /**
 * Combines this object's current estimate of a finder pattern position and module size
 * with a new estimate. It returns a new ZXFinderPattern containing a weighted average
 * based on count.
 */
    @objc
    func combineEstimateI(_ i: CFloat, j: CFloat, newModuleSize: CFloat) -> ZXQRCodeFinderPattern? {
        let combinedCount = self.count + 1
        let combinedX: CFloat = (CFloat(self.count) * self.x + j) / combinedCount
        let combinedY: CFloat = (CFloat(self.count) * self.y + i) / combinedCount
        let combinedModuleSize: CFloat = (CFloat(self.count) * self.estimatedModuleSize + newModuleSize) / combinedCount

        return ZXQRCodeFinderPattern(posX: combinedX, posY: combinedY, estimatedModuleSize: combinedModuleSize, count: combinedCount)
    }
}