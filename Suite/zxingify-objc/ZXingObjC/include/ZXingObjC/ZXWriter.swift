import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXBarcodeFormat.h"
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
 * The base class for all objects which encode/generate a barcode image.
 */
@objc
protocol ZXWriter: NSObjectProtocol {
    /**
 * Encode a barcode using the default settings.
 *
 * @param contents The contents to encode in the barcode
 * @param format The barcode format to generate
 * @param width The preferred width in pixels
 * @param height The preferred height in pixels
 * @return ZXBitMatrix representing encoded barcode image or nil if contents cannot be encoded
 *   legally in a format
 */
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix?
    /**
 *
 * @param contents The contents to encode in the barcode
 * @param format The barcode format to generate
 * @param width The preferred width in pixels
 * @param height The preferred height in pixels
 * @param hints Additional parameters to supply to the encoder
 * @return ZXBitMatrix representing encoded barcode image or nil if contents cannot be encoded
 *   legally in a format
 */
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix?
}