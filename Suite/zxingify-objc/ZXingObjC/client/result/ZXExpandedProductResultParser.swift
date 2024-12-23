// Preprocessor directives found in file:
// #import "ZXResultParser.h"
// #import "ZXExpandedProductResultParser.h"
// #import "ZXExpandedProductParsedResult.h"
// #import "ZXResult.h"
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
 * Parses strings of digits that represent a RSS Extended code.
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
 * Parses strings of digits that represent a RSS Extended code.
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
class ZXExpandedProductResultParser: ZXResultParser {
    @objc
    func parse(_ result: ZXResult!) -> ZXParsedResult? {
        let format = result.barcodeFormat

        if ZXBarcodeFormat.kBarcodeFormatRSSExpanded != format {
            // ExtendedProductParsedResult NOT created. Not a RSS Expanded barcode
            return nil
        }

        let rawText = ZXResultParser.massagedText(result)
        var productID: String! = nil
        var sscc: String! = nil
        var lotNumber: String! = nil
        var productionDate: String! = nil
        var packagingDate: String! = nil
        var bestBeforeDate: String! = nil
        var expirationDate: String! = nil
        var weight: String! = nil
        var weightType: String! = nil
        var weightIncrement: String! = nil
        var price: String! = nil
        var priceIncrement: String! = nil
        var priceCurrency: String! = nil
        let uncommonAIs = NSMutableDictionary()
        var i: CInt = 0

        while i < rawText?.length() {
            let ai = self.findAIvalue(i, rawText: rawText)

            if ai == nil {
                // Error. Code doesn't match with RSS expanded pattern
                // ExtendedProductParsedResult NOT created. Not match with RSS Expanded pattern
                return nil
            }

            i += ai?.length() + 2

            let value = self.findValue(i, rawText: rawText)

            i += value?.length()

            if "00" == ai {
                sscc = value
            } else if "01" == ai {
                productID = value
            } else if "10" == ai {
                lotNumber = value
            } else if "11" == ai {
                productionDate = value
            } else if "13" == ai {
                packagingDate = value
            } else if "15" == ai {
                bestBeforeDate = value
            } else if "17" == ai {
                expirationDate = value
            } else if "3100" == ai || "3101" == ai || "3102" == ai || "3103" == ai || "3104" == ai || "3105" == ai || "3106" == ai || "3107" == ai || "3108" == ai || "3109" == ai {
                weight = value
                weightType = ZX_KILOGRAM
                weightIncrement = ai?.substringFromIndex(3)
            } else if "3200" == ai || "3201" == ai || "3202" == ai || "3203" == ai || "3204" == ai || "3205" == ai || "3206" == ai || "3207" == ai || "3208" == ai || "3209" == ai {
                weight = value
                weightType = ZX_POUND
                weightIncrement = ai?.substringFromIndex(3)
            } else if "3920" == ai || "3921" == ai || "3922" == ai || "3923" == ai {
                price = value
                priceIncrement = ai?.substringFromIndex(3)
            } else if "3930" == ai || "3931" == ai || "3932" == ai || "3933" == ai {
                if value?.length() < 4 {
                    // The value must have more of 3 symbols (3 for currency and
                    // 1 at least for the price)
                    // ExtendedProductParsedResult NOT created. Not match with RSS Expanded pattern
                    return nil
                }

                price = value?.substringFromIndex(3)
                priceCurrency = value?.substringToIndex(3)
                priceIncrement = ai?.substringFromIndex(3)
            } else {
                // No match with common AIs
                uncommonAIs[ai] = value
            }
        }

        return ZXExpandedProductParsedResult.expandedProductParsedResultWithRawText(rawText, productID: productID, sscc: sscc, lotNumber: lotNumber, productionDate: productionDate, packagingDate: packagingDate, bestBeforeDate: bestBeforeDate, expirationDate: expirationDate, weight: weight, weightType: weightType, weightIncrement: weightIncrement, price: price, priceIncrement: priceIncrement, priceCurrency: priceCurrency, uncommonAIs: uncommonAIs)
    }
    @objc
    func findAIvalue(_ i: CInt, rawText: String!) -> String? {
        let c: unichar = rawText.characterAtIndex(i)

        // First character must be a open parenthesis.If not, ERROR
        if c != "(" {
            return nil
        }

        let rawTextAux: String! = rawText.substringFromIndex(i + 1)
        let buf = NSMutableString()
        var index: CInt = 0

        while index < rawTextAux.length() {
            defer {
                index += 1
            }

            let currentChar: unichar = rawTextAux.characterAtIndex(index)

            if currentChar == ")" {
                return buf
            } else if currentChar >= "0" && currentChar <= "9" {
                buf.appendFormat("%C", currentChar)
            } else {
                return nil
            }
        }

        return buf
    }
    @objc
    func findValue(_ i: CInt, rawText: String!) -> String? {
        let buf = NSMutableString()
        let rawTextAux: String! = rawText.substringFromIndex(i)
        var index: CInt = 0

        while index < rawTextAux.length() {
            defer {
                index += 1
            }

            let c: unichar = rawTextAux.characterAtIndex(index)

            if c == "(" {
                // We look for a new AI. If it doesn't exist (ERROR), we coninue
                // with the iteration
                if self.findAIvalue(index, rawText: rawTextAux) == nil {
                    buf.append("(")
                } else {
                    break
                }
            } else {
                buf.appendFormat("%C", c)
            }
        }

        return buf
    }
}