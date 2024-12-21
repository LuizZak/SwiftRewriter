// Preprocessor directives found in file:
// #import "ZXResultPoint.h"
// #import "ZXQRCodeAlignmentPattern.h"
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
 * Encapsulates an alignment pattern, which are the smaller square patterns found in
 * all but the simplest QR Codes.
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
 * Encapsulates an alignment pattern, which are the smaller square patterns found in
 * all but the simplest QR Codes.
 */
@objc
class ZXQRCodeAlignmentPattern: ZXResultPoint {
    private var _estimatedModuleSize: CFloat = 0.0

    @objc
    init(posX: CFloat, posY: CFloat, estimatedModuleSize: CFloat) {
        if self = super.init(x: posX, y: posY) {
            _estimatedModuleSize = estimatedModuleSize
        }

        return self
    }

    /**
 * Determines if this alignment pattern "about equals" an alignment pattern at the stated
 * position and size -- meaning, it is at nearly the same center with nearly the same size.
 */
    /**
 * Determines if this alignment pattern "about equals" an alignment pattern at the stated
 * position and size -- meaning, it is at nearly the same center with nearly the same size.
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
 * with a new estimate. It returns a new {@code FinderPattern} containing an average of the two.
 */
    /**
 * Combines this object's current estimate of a finder pattern position and module size
 * with a new estimate. It returns a new {@code FinderPattern} containing an average of the two.
 */
    @objc
    func combineEstimateI(_ i: CFloat, j: CFloat, newModuleSize: CFloat) -> ZXQRCodeAlignmentPattern? {
        let combinedX = (self.x + j) / 2.0
        let combinedY = (self.y + i) / 2.0
        let combinedModuleSize = (self.estimatedModuleSize + newModuleSize) / 2.0

        return ZXQRCodeAlignmentPattern(posX: combinedX, posY: combinedY, estimatedModuleSize: combinedModuleSize)
    }
}

// MARK: -
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
extension ZXQRCodeAlignmentPattern {
    @objc var estimatedModuleSize: CFloat {
        return self._estimatedModuleSize
    }
}