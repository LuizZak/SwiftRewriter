// Preprocessor directives found in file:
// #import "ZXIntArray.h"
// #import "ZXRSSUtils.h"
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
 * Adapted from listings in ISO/IEC 24724 Appendix B and Appendix G.
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
 * Adapted from listings in ISO/IEC 24724 Appendix B and Appendix G.
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
class ZXRSSUtils: NSObject {
    //+ (NSArray *)rssWidths:(int)val n:(int)n elements:(int)elements maxWidth:(int)maxWidth noNarrow:(BOOL)noNarrow;
    //+ (NSArray *)rssWidths:(int)val n:(int)n elements:(int)elements maxWidth:(int)maxWidth noNarrow:(BOOL)noNarrow;
    /*
+ (NSArray *)rssWidths:(int)val n:(int)n elements:(int)elements maxWidth:(int)maxWidth noNarrow:(BOOL)noNarrow {
  NSMutableArray *widths = [NSMutableArray arrayWithCapacity:elements];
  int bar;
  int narrowMask = 0;
  for (bar = 0; bar < elements - 1; bar++) {
    narrowMask |= 1 << bar;
    int elmWidth = 1;
    int subVal;
    while (YES) {
      subVal = [self combins:n - elmWidth - 1 r:elements - bar - 2];
      if (noNarrow && (narrowMask == 0) && (n - elmWidth - (elements - bar - 1) >= elements - bar - 1)) {
        subVal -= [self combins:n - elmWidth - (elements - bar) r:elements - bar - 2];
      }
      if (elements - bar - 1 > 1) {
        int lessVal = 0;
        for (int mxwElement = n - elmWidth - (elements - bar - 2); mxwElement > maxWidth; mxwElement--) {
          lessVal += [self combins:n - elmWidth - mxwElement - 1 r:elements - bar - 3];
        }
        subVal -= lessVal * (elements - 1 - bar);
      } else if (n - elmWidth > maxWidth) {
        subVal--;
      }
      val -= subVal;
      if (val < 0) {
        break;
      }
      elmWidth++;
      narrowMask &= ~(1 << bar);
    }
    val += subVal;
    n -= elmWidth;
    [widths addObject:@(elmWidth)];
  }

  [widths addObject:@(n)];
  return widths;
}
*/
    @objc
    static func rssValue(_ widths: ZXIntArray!, maxWidth: CInt, noNarrow: Bool) -> CInt {
        let elements: CInt = CInt(widths.length)
        var n: CInt = 0
        var i: CInt = 0

        while i < elements {
            defer {
                i += 1
            }

            n += widths.array[i]
        }

        var val: CInt = 0
        var narrowMask: CInt = 0
        var bar: CInt = 0

        while bar < elements - 1 {
            defer {
                bar += 1
            }

            var elmWidth: CInt

            elmWidth = 1
            narrowMask |= 1 << bar

            while elmWidth < widths.array[bar] {
                defer {
                    elmWidth += 1
                    narrowMask &= ~(1 << bar)
                }

                var subVal = self.combins(n - elmWidth - 1, r: elements - bar - 2)

                if noNarrow && (narrowMask == 0) && (n - elmWidth - (elements - bar - 1) >= elements - bar - 1) {
                    subVal -= self.combins(n - elmWidth - (elements - bar), r: elements - bar - 2)
                }

                if elements - bar - 1 > 1 {
                    var lessVal: CInt = 0
                    var mxwElement = n - elmWidth - (elements - bar - 2)

                    while mxwElement > maxWidth {
                        defer {
                            mxwElement -= 1
                        }

                        lessVal += self.combins(n - elmWidth - mxwElement - 1, r: elements - bar - 3)
                    }

                    subVal -= lessVal * (elements - 1 - bar)
                } else if n - elmWidth > maxWidth {
                    subVal -= 1
                }

                val += subVal
            }

            n -= elmWidth
        }

        return val
    }
    @objc
    static func combins(_ n: CInt, r: CInt) -> CInt {
        var maxDenom: CInt
        var minDenom: CInt

        if n - r > r {
            minDenom = r
            maxDenom = n - r
        } else {
            minDenom = n - r
            maxDenom = r
        }

        var val: CInt = 1
        var j: CInt = 1
        var i = n

        while i > maxDenom {
            defer {
                i -= 1
            }

            val *= i

            if j <= minDenom {
                val /= j
                j += 1
            }
        }

        while j <= minDenom {
            val /= j
            j += 1
        }

        return val
    }
}