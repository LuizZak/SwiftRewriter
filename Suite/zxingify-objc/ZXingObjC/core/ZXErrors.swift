import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #define ZXErrorDomain @"ZXErrorDomain"
// #import "ZXErrors.h"
let ZXErrorDomain: String = "ZXErrorDomain"

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
   * Thrown when a barcode was successfully detected and decoded, but
   * was not returned because its checksum feature failed.
   */
/**
   * Thrown when a barcode was successfully detected, but some aspect of
   * the content did not conform to the barcode's format rules. This could have
   * been due to a mis-detection.
   */
/**
   * Thrown when a barcode was not found in the image. It might have been
   * partially detected but could not be confirmed.
   */
/**
   * Thrown when an exception occurs during Reed-Solomon decoding, such as when
   * there are too many errors to correct.
   */
/**
   * This general error is thrown when something goes wrong during decoding of a barcode.
   * This includes, but is not limited to, failing checksums / error correction algorithms, being
   * unable to locate finder timing patterns, and so on.
   */
/**
   * Covers the range of error which may occur when encoding a barcode using the Writer framework.
   */
// Helper methods for error instances
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
func ZXChecksumErrorInstance() -> Error? {
    let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "This barcode failed its checksum"]

    return Error(domain: ZXErrorDomain, code: ZXChecksumError, userInfo: userInfo)
}
func ZXFormatErrorInstance() -> Error? {
    let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "This barcode does not confirm to the format\'s rules"]

    return Error(domain: ZXErrorDomain, code: ZXFormatError, userInfo: userInfo)
}
func ZXNotFoundErrorInstance() -> Error? {
    let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "A barcode was not found in this image"]

    return Error(domain: ZXErrorDomain, code: ZXNotFoundError, userInfo: userInfo)
}