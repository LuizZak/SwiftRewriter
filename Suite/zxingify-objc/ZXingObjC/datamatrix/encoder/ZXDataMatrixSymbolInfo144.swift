// Preprocessor directives found in file:
// #import "ZXDataMatrixSymbolInfo.h"
// #import "ZXDataMatrixSymbolInfo144.h"
/*
 * Copyright 2013 ZXing authors
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
 * Copyright 2013 ZXing authors
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
class ZXDataMatrixSymbolInfo144: ZXDataMatrixSymbolInfo {
    @objc
    override init() {
        return super.init(rectangular: false, dataCapacity: 1558, errorCodewords: 620, matrixWidth: 22, matrixHeight: 22, dataRegions: 36, rsBlockData: 1, rsBlockError: 62)
    }

    @objc
    func interleavedBlockCount() -> CInt {
        return 10
    }
    @objc
    func dataLengthForInterleavedBlock(_ index: CInt) -> CInt {
        return (index <= 8) ? 156 : 155
    }
}