import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #define ZX_AZTEC_SHIFT_TABLE_SIZE 6
var ZX_AZTEC_MODE_NAMES: NSArray!
let ZX_AZTEC_MODE_UPPER: CInt
let ZX_AZTEC_MODE_LOWER: CInt
let ZX_AZTEC_MODE_DIGIT: CInt
let ZX_AZTEC_MODE_MIXED: CInt
let ZX_AZTEC_MODE_PUNCT: CInt
var ZX_AZTEC_LATCH_TABLE: (CInt, CInt, CInt, CInt, CInt)
var ZX_AZTEC_SHIFT_TABLE: UnsafeMutablePointer<CInt>!
let ZX_AZTEC_SHIFT_TABLE_SIZE: Int = 6