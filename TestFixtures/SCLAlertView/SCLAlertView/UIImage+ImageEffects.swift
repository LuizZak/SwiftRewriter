import UIKit
import Accelerate
import float

// Preprocessor directives found in file:
// #if defined(__has_feature) && __has_feature(modules)
// #else
// #import <UIKit/UIKit.h>
// #endif
// #import "UIImage+ImageEffects.h"
// #import "SCLMacros.h"
// #if defined(__has_feature) && __has_feature(modules)
// #else
// #import <Accelerate/Accelerate.h>
// #endif
// #import <float.h>
// MARK: - ImageEffects
/*
 File: UIImage+ImageEffects.h
 Abstract: This is a category of UIImage that adds methods to apply blur and tint effects to an image. This is the code you’ll want to look out to find out how to use vImage to efficiently calculate a blur.
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 
 Copyright © 2013 Apple Inc. All rights reserved.
 WWDC 2013 License
 
 NOTE: This Apple Software was supplied by Apple as part of a WWDC 2013
 Session. Please refer to the applicable WWDC 2013 Session for further
 information.
 
 IMPORTANT: This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and
 your use, installation, modification or redistribution of this Apple
 software constitutes acceptance of these terms. If you do not agree with
 these terms, please do not use, install, modify or redistribute this
 Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple
 Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple. Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis. APPLE MAKES
 NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
 IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 EA1002
 5/3/2013
 */
/*
 File: UIImage+ImageEffects.m
 Abstract: This is a category of UIImage that adds methods to apply blur and tint effects to an image. This is the code you’ll want to look out to find out how to use vImage to efficiently calculate a blur.
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 
 Copyright © 2013 Apple Inc. All rights reserved.
 WWDC 2013 License
 
 NOTE: This Apple Software was supplied by Apple as part of a WWDC 2013
 Session. Please refer to the applicable WWDC 2013 Session for further
 information.
 
 IMPORTANT: This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and
 your use, installation, modification or redistribution of this Apple
 software constitutes acceptance of these terms. If you do not agree with
 these terms, please do not use, install, modify or redistribute this
 Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple
 Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple. Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis. APPLE MAKES
 NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
 IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 EA1002
 5/3/2013
 */
extension UIImage {
    func applyLightEffect() -> UIImage! {
        let tintColor: UIColor! = UIColor(white: 1.0, alpha: 0.3)

        return self.applyBlurWithRadius(30, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    func applyExtraLightEffect() -> UIImage! {
        let tintColor: UIColor! = UIColor(white: 0.97, alpha: 0.82)

        return self.applyBlurWithRadius(20, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    func applyDarkEffect() -> UIImage! {
        let tintColor: UIColor! = UIColor(white: 0.11, alpha: 0.73)

        return self.applyBlurWithRadius(20, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    func applyTintEffectWithColor(_ tintColor: UIColor!) -> UIImage! {
        let EffectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        let componentCount = CGColorGetNumberOfComponents(tintColor.cgColor)

        if componentCount == 2 {
            var b: CGFloat

            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: EffectColorAlpha)
            }
        } else {
            var r: CGFloat, g: CGFloat, b: CGFloat

            if tintColor.getRed(&r, green: &g, blue: &b, alpha: nil) {
                effectColor = UIColor(red: r, green: g, blue: b, alpha: EffectColorAlpha)
            }
        }

        return self.applyBlurWithRadius(10, tintColor: effectColor, saturationDeltaFactor: 1.0, maskImage: nil)
    }
    func applyBlurWithRadius(_ blurRadius: CGFloat, tintColor: UIColor!, saturationDeltaFactor: CGFloat, maskImage: UIImage!) -> UIImage! {
        // Check pre-conditions.
        if self.size.width < 1 || self.size.height < 1 {
            NSLog("*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self)

            return nil
        }

        if !self.CGImage {
            NSLog("*** error: image must be backed by a CGImage: %@", self)

            return nil
        }

        if maskImage && !maskImage.CGImage {
            NSLog("*** error: maskImage must be backed by a CGImage: %@", maskImage)

            return nil
        }

        let imageRect: CGRect
        var effectImage = self
        let hasBlur: Bool = blurRadius > __FLT_EPSILON__
        let hasSaturationChange: Bool = fabs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__

        if hasBlur || hasSaturationChange {
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen().scale())

            let effectInContext = UIGraphicsGetCurrentContext()

            effectInContext?.scale(x: 1.0, y: 1.0)
            effectInContext?.translateBy(x: 0, y: -self.size.height)
            effectInContext?.draw(self.CGImage, in: imageRect)

            var effectInBuffer: vImage_Buffer

            effectInBuffer.data = CGBitmapContextGetData(effectInContext)
            effectInBuffer.width = CGBitmapContextGetWidth(effectInContext)
            effectInBuffer.height = CGBitmapContextGetHeight(effectInContext)
            effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext)

            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen().scale())

            let effectOutContext = UIGraphicsGetCurrentContext()
            var effectOutBuffer: vImage_Buffer

            effectOutBuffer.data = CGBitmapContextGetData(effectOutContext)
            effectOutBuffer.width = CGBitmapContextGetWidth(effectOutContext)
            effectOutBuffer.height = CGBitmapContextGetHeight(effectOutContext)
            effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext)

            if hasBlur {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                let inputRadius: CGFloat = blurRadius * UIScreen.mainScreen().scale()
                var radius = floor(inputRadius * 3.0 * sqrt(2 * M_PI) / 4 + 0.5)

                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }

                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, 0, kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, 0, kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, 0, kvImageEdgeExtend)
            }

            var effectImageBuffersAreSwapped = false

            if hasSaturationChange {
                let s = saturationDeltaFactor
                let floatingPointSaturationMatrix: CGFloat
                let divisor: int32_t = 256
                let matrixSize = UInt(MemoryLayout.size(ofValue: floatingPointSaturationMatrix) / MemoryLayout.size(ofValue: floatingPointSaturationMatrix[0]))
                var saturationMatrix: int16_t
                var i: UInt = 0

                while i < matrixSize {
                    defer {
                        i += 1
                    }

                    saturationMatrix[i] = round(floatingPointSaturationMatrix[i] * divisor) as? int16_t
                }

                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, nil, nil, kvImageNoFlags)
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, nil, nil, kvImageNoFlags)
                }
            }

            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }

            UIGraphicsEndImageContext()

            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }

            UIGraphicsEndImageContext()
        }

        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen().scale())

        let outputContext = UIGraphicsGetCurrentContext()

        outputContext?.scale(x: 1.0, y: 1.0)
        outputContext?.translateBy(x: 0, y: -self.size.height)
        // Draw base image.
        outputContext?.draw(self.CGImage, in: imageRect)

        // Draw effect image.
        if hasBlur {
            outputContext?.saveGState()

            if maskImage {
                outputContext?.clip(to: imageRect, mask: maskImage.CGImage)
            }

            outputContext?.draw(effectImage.CGImage, in: imageRect)
            outputContext?.restoreGState()
        }

        // Add in color tint.
        if tintColor {
            outputContext?.saveGState()
            outputContext?.setFillColor(tintColor.cgColor)
            outputContext?.fill(imageRect)
            outputContext?.restoreGState()
        }

        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return outputImage
    }
    static func imageWithColor(_ color: UIColor!) -> UIImage! {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor())
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
    static func convertViewToImage() -> UIImage! {
        let keyWindow: UIWindow! = UIApplication.sharedApplication().keyWindow()
        let rect = keyWindow.bounds

        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)

        let context = UIGraphicsGetCurrentContext()

        keyWindow.layer.renderInContext(context)

        let capturedScreen = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return capturedScreen
    }
    static func convertViewToImage(_ view: UIView!) -> UIImage! {
        let scale: CGFloat = UIScreen.mainScreen().scale
        var capturedScreen: UIImage!

        //Optimized/fast method for rendering a UIView as image on iOS 7 and later versions.
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, scale)

        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)

        capturedScreen = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return capturedScreen
    }
}