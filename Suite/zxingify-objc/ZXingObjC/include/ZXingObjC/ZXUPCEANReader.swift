// Preprocessor directives found in file:
// #import "ZXBarcodeFormat.h"
// #import "ZXOneDReader.h"
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
enum ZX_UPC_EAN_PATTERNS: CInt {
    case ZX_UPC_EAN_PATTERNS_L_PATTERNS = 0
    case ZX_UPC_EAN_PATTERNS_L_AND_G_PATTERNS
}

let ZX_UPC_EAN_START_END_PATTERN_LEN: CInt
var ZX_UPC_EAN_START_END_PATTERN: UnsafePointer<CInt>!
let ZX_UPC_EAN_MIDDLE_PATTERN_LEN: CInt
var ZX_UPC_EAN_MIDDLE_PATTERN: UnsafePointer<CInt>!
let ZX_UPC_EAN_L_PATTERNS_LEN: CInt
let ZX_UPC_EAN_L_PATTERNS_SUB_LEN: CInt
var ZX_UPC_EAN_L_PATTERNS: (CInt, CInt, CInt, CInt)
let ZX_UPC_EAN_L_AND_G_PATTERNS_LEN: CInt
let ZX_UPC_EAN_L_AND_G_PATTERNS_SUB_LEN: CInt
var ZX_UPC_EAN_L_AND_G_PATTERNS: (CInt, CInt, CInt, CInt)