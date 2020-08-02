import Foundation
import UIKit

// Preprocessor directives found in file:
// #if defined(__has_feature) && __has_feature(modules)
// #else
// #import <Foundation/Foundation.h>
// #import <UIKit/UIKit.h>
// #endif
// #import "SCLButton.h"
// #import "SCLAlertViewStyleKit.h"
// #pragma mark - Cache
// #pragma mark - Initialization
// #pragma mark - Drawing Methods
// #pragma mark - Images
var imageOfCheckmark: UIImage! = nil
var imageOfCross: UIImage! = nil
var imageOfNotice: UIImage! = nil
var imageOfWarning: UIImage! = nil
var imageOfInfo: UIImage! = nil
var imageOfEdit: UIImage! = nil
var imageOfQuestion: UIImage! = nil

//
//  SCLAlertViewStyleKit.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//
class SCLAlertViewStyleKit: NSObject {
    static func initialize() {
    }
    /** TODO
 *
 * TODO
 */
    static func drawCheckmark() {
        // Checkmark Shape Drawing
        let checkmarkShapePath = UIBezierPath()

        checkmarkShapePath.moveToPoint(CGPoint(x: 73.25, y: 14.05))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 64.51, y: 13.86), controlPoint1: CGPoint(x: 70.98, y: 11.44), controlPoint2: CGPoint(x: 66.78, y: 11.26))
        checkmarkShapePath.addLineToPoint(CGPoint(x: 27.46, y: 52))
        checkmarkShapePath.addLineToPoint(CGPoint(x: 15.75, y: 39.54))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 6.84, y: 39.54), controlPoint1: CGPoint(x: 13.48, y: 36.93), controlPoint2: CGPoint(x: 9.28, y: 36.93))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 6.84, y: 49.02), controlPoint1: CGPoint(x: 4.39, y: 42.14), controlPoint2: CGPoint(x: 4.39, y: 46.42))
        checkmarkShapePath.addLineToPoint(CGPoint(x: 22.91, y: 66.14))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 27.28, y: 68), controlPoint1: CGPoint(x: 24.14, y: 67.44), controlPoint2: CGPoint(x: 25.71, y: 68))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 31.65, y: 66.14), controlPoint1: CGPoint(x: 28.86, y: 68), controlPoint2: CGPoint(x: 30.43, y: 67.26))
        checkmarkShapePath.addLineToPoint(CGPoint(x: 73.08, y: 23.35))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 73.25, y: 14.05), controlPoint1: CGPoint(x: 75.52, y: 20.75), controlPoint2: CGPoint(x: 75.7, y: 16.65))
        checkmarkShapePath.closePath()
        checkmarkShapePath.miterLimit = 4

        UIColor.white.setFill()

        checkmarkShapePath.fill()
    }
    /** TODO
 *
 * TODO
 */
    static func drawCross() {
        // Cross Shape Drawing
        let crossShapePath = UIBezierPath()

        crossShapePath.moveToPoint(CGPoint(x: 10, y: 70))
        crossShapePath.addLineToPoint(CGPoint(x: 70, y: 10))
        crossShapePath.moveToPoint(CGPoint(x: 10, y: 10))
        crossShapePath.addLineToPoint(CGPoint(x: 70, y: 70))
        crossShapePath.lineCapStyle = kCGLineCapRound
        crossShapePath.lineJoinStyle = kCGLineJoinRound

        UIColor.white.setStroke()

        crossShapePath.lineWidth = 14
        crossShapePath.stroke()
    }
    /** TODO
 *
 * TODO
 */
    static func drawNotice() {
        // Notice Shape Drawing
        let noticeShapePath = UIBezierPath()

        noticeShapePath.moveToPoint(CGPoint(x: 72, y: 48.54))
        noticeShapePath.addLineToPoint(CGPoint(x: 72, y: 39.9))
        noticeShapePath.addCurveToPoint(CGPoint(x: 66.38, y: 34.01), controlPoint1: CGPoint(x: 72, y: 36.76), controlPoint2: CGPoint(x: 69.48, y: 34.01))
        noticeShapePath.addCurveToPoint(CGPoint(x: 61.53, y: 35.97), controlPoint1: CGPoint(x: 64.82, y: 34.01), controlPoint2: CGPoint(x: 62.69, y: 34.8))
        noticeShapePath.addCurveToPoint(CGPoint(x: 60.36, y: 35.78), controlPoint1: CGPoint(x: 61.33, y: 35.97), controlPoint2: CGPoint(x: 62.3, y: 35.78))
        noticeShapePath.addLineToPoint(CGPoint(x: 60.36, y: 33.22))
        noticeShapePath.addCurveToPoint(CGPoint(x: 54.16, y: 26.16), controlPoint1: CGPoint(x: 60.36, y: 29.3), controlPoint2: CGPoint(x: 57.65, y: 26.16))
        noticeShapePath.addCurveToPoint(CGPoint(x: 48.73, y: 29.89), controlPoint1: CGPoint(x: 51.64, y: 26.16), controlPoint2: CGPoint(x: 50.67, y: 27.73))
        noticeShapePath.addLineToPoint(CGPoint(x: 48.73, y: 28.71))
        noticeShapePath.addCurveToPoint(CGPoint(x: 43.49, y: 21.64), controlPoint1: CGPoint(x: 48.73, y: 24.78), controlPoint2: CGPoint(x: 46.98, y: 21.64))
        noticeShapePath.addCurveToPoint(CGPoint(x: 39.03, y: 25.37), controlPoint1: CGPoint(x: 40.97, y: 21.64), controlPoint2: CGPoint(x: 39.03, y: 23.01))
        noticeShapePath.addLineToPoint(CGPoint(x: 39.03, y: 9.07))
        noticeShapePath.addCurveToPoint(CGPoint(x: 32.24, y: 2), controlPoint1: CGPoint(x: 39.03, y: 5.14), controlPoint2: CGPoint(x: 35.73, y: 2))
        noticeShapePath.addCurveToPoint(CGPoint(x: 25.45, y: 9.07), controlPoint1: CGPoint(x: 28.56, y: 2), controlPoint2: CGPoint(x: 25.45, y: 5.14))
        noticeShapePath.addLineToPoint(CGPoint(x: 25.45, y: 41.47))
        noticeShapePath.addCurveToPoint(CGPoint(x: 24.29, y: 43.44), controlPoint1: CGPoint(x: 25.45, y: 42.45), controlPoint2: CGPoint(x: 24.68, y: 43.04))
        noticeShapePath.addCurveToPoint(CGPoint(x: 9.55, y: 43.04), controlPoint1: CGPoint(x: 16.73, y: 40.88), controlPoint2: CGPoint(x: 11.88, y: 40.69))
        noticeShapePath.addCurveToPoint(CGPoint(x: 8, y: 46.58), controlPoint1: CGPoint(x: 8.58, y: 43.83), controlPoint2: CGPoint(x: 8, y: 45.2))
        noticeShapePath.addCurveToPoint(CGPoint(x: 14.4, y: 55.81), controlPoint1: CGPoint(x: 8.19, y: 50.31), controlPoint2: CGPoint(x: 12.07, y: 53.84))
        noticeShapePath.addLineToPoint(CGPoint(x: 27.2, y: 69.56))
        noticeShapePath.addCurveToPoint(CGPoint(x: 42.91, y: 77.8), controlPoint1: CGPoint(x: 30.5, y: 74.47), controlPoint2: CGPoint(x: 35.73, y: 77.21))
        noticeShapePath.addCurveToPoint(CGPoint(x: 43.88, y: 77.8), controlPoint1: CGPoint(x: 43.3, y: 77.8), controlPoint2: CGPoint(x: 43.68, y: 77.8))
        noticeShapePath.addCurveToPoint(CGPoint(x: 47.18, y: 78), controlPoint1: CGPoint(x: 45.04, y: 77.8), controlPoint2: CGPoint(x: 46.01, y: 78))
        noticeShapePath.addLineToPoint(CGPoint(x: 48.34, y: 78))
        noticeShapePath.addLineToPoint(CGPoint(x: 48.34, y: 78))
        noticeShapePath.addCurveToPoint(CGPoint(x: 71.61, y: 52.08), controlPoint1: CGPoint(x: 56.48, y: 78), controlPoint2: CGPoint(x: 69.87, y: 75.05))
        noticeShapePath.addCurveToPoint(CGPoint(x: 72, y: 48.54), controlPoint1: CGPoint(x: 71.81, y: 51.29), controlPoint2: CGPoint(x: 72, y: 49.72))
        noticeShapePath.closePath()
        noticeShapePath.miterLimit = 4

        UIColor.white.setFill()

        noticeShapePath.fill()
    }
    /** TODO
 *
 * TODO
 */
    static func drawWarning() {
        // Color Declarations
        let greyColor: UIColor! = UIColor(red: 0.236, green: 0.236, blue: 0.236, alpha: 1.0)
        // Warning Group
        // Warning Circle Drawing
        let warningCirclePath = UIBezierPath()

        warningCirclePath.moveToPoint(CGPoint(x: 40.94, y: 63.39))
        warningCirclePath.addCurveToPoint(CGPoint(x: 36.03, y: 65.55), controlPoint1: CGPoint(x: 39.06, y: 63.39), controlPoint2: CGPoint(x: 37.36, y: 64.18))
        warningCirclePath.addCurveToPoint(CGPoint(x: 34.14, y: 70.45), controlPoint1: CGPoint(x: 34.9, y: 66.92), controlPoint2: CGPoint(x: 34.14, y: 68.49))
        warningCirclePath.addCurveToPoint(CGPoint(x: 36.22, y: 75.54), controlPoint1: CGPoint(x: 34.14, y: 72.41), controlPoint2: CGPoint(x: 34.9, y: 74.17))
        warningCirclePath.addCurveToPoint(CGPoint(x: 40.94, y: 77.5), controlPoint1: CGPoint(x: 37.54, y: 76.91), controlPoint2: CGPoint(x: 39.06, y: 77.5))
        warningCirclePath.addCurveToPoint(CGPoint(x: 45.86, y: 75.35), controlPoint1: CGPoint(x: 42.83, y: 77.5), controlPoint2: CGPoint(x: 44.53, y: 76.72))
        warningCirclePath.addCurveToPoint(CGPoint(x: 47.93, y: 70.45), controlPoint1: CGPoint(x: 47.18, y: 74.17), controlPoint2: CGPoint(x: 47.93, y: 72.41))
        warningCirclePath.addCurveToPoint(CGPoint(x: 45.86, y: 65.35), controlPoint1: CGPoint(x: 47.93, y: 68.49), controlPoint2: CGPoint(x: 47.18, y: 66.72))
        warningCirclePath.addCurveToPoint(CGPoint(x: 40.94, y: 63.39), controlPoint1: CGPoint(x: 44.53, y: 64.18), controlPoint2: CGPoint(x: 42.83, y: 63.39))
        warningCirclePath.closePath()
        warningCirclePath.miterLimit = 4

        greyColor.setFill()

        warningCirclePath.fill()

        //// Warning Shape Drawing
        let warningShapePath = UIBezierPath()

        warningShapePath.moveToPoint(CGPoint(x: 46.23, y: 4.26))
        warningShapePath.addCurveToPoint(CGPoint(x: 40.94, y: 2.5), controlPoint1: CGPoint(x: 44.91, y: 3.09), controlPoint2: CGPoint(x: 43.02, y: 2.5))
        warningShapePath.addCurveToPoint(CGPoint(x: 34.71, y: 4.26), controlPoint1: CGPoint(x: 38.68, y: 2.5), controlPoint2: CGPoint(x: 36.03, y: 3.09))
        warningShapePath.addCurveToPoint(CGPoint(x: 31.5, y: 8.77), controlPoint1: CGPoint(x: 33.01, y: 5.44), controlPoint2: CGPoint(x: 31.5, y: 7.01))
        warningShapePath.addLineToPoint(CGPoint(x: 31.5, y: 19.36))
        warningShapePath.addLineToPoint(CGPoint(x: 34.71, y: 54.44))
        warningShapePath.addCurveToPoint(CGPoint(x: 40.38, y: 58.16), controlPoint1: CGPoint(x: 34.9, y: 56.2), controlPoint2: CGPoint(x: 36.41, y: 58.16))
        warningShapePath.addCurveToPoint(CGPoint(x: 45.67, y: 54.44), controlPoint1: CGPoint(x: 44.34, y: 58.16), controlPoint2: CGPoint(x: 45.67, y: 56.01))
        warningShapePath.addLineToPoint(CGPoint(x: 48.5, y: 19.36))
        warningShapePath.addLineToPoint(CGPoint(x: 48.5, y: 8.77))
        warningShapePath.addCurveToPoint(CGPoint(x: 46.23, y: 4.26), controlPoint1: CGPoint(x: 48.5, y: 7.01), controlPoint2: CGPoint(x: 47.74, y: 5.44))
        warningShapePath.closePath()
        warningShapePath.miterLimit = 4

        greyColor.setFill()

        warningShapePath.fill()
    }
    /** TODO
 *
 * TODO
 */
    static func drawInfo() {
        // Color Declarations
        let color0: UIColor! = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Info Shape Drawing
        let infoShapePath = UIBezierPath()

        infoShapePath.moveToPoint(CGPoint(x: 45.66, y: 15.96))
        infoShapePath.addCurveToPoint(CGPoint(x: 45.66, y: 5.22), controlPoint1: CGPoint(x: 48.78, y: 12.99), controlPoint2: CGPoint(x: 48.78, y: 8.19))
        infoShapePath.addCurveToPoint(CGPoint(x: 34.34, y: 5.22), controlPoint1: CGPoint(x: 42.53, y: 2.26), controlPoint2: CGPoint(x: 37.47, y: 2.26))
        infoShapePath.addCurveToPoint(CGPoint(x: 34.34, y: 15.96), controlPoint1: CGPoint(x: 31.22, y: 8.19), controlPoint2: CGPoint(x: 31.22, y: 12.99))
        infoShapePath.addCurveToPoint(CGPoint(x: 45.66, y: 15.96), controlPoint1: CGPoint(x: 37.47, y: 18.92), controlPoint2: CGPoint(x: 42.53, y: 18.92))
        infoShapePath.closePath()
        infoShapePath.moveToPoint(CGPoint(x: 48, y: 69.41))
        infoShapePath.addCurveToPoint(CGPoint(x: 40, y: 77), controlPoint1: CGPoint(x: 48, y: 73.58), controlPoint2: CGPoint(x: 44.4, y: 77))
        infoShapePath.addLineToPoint(CGPoint(x: 40, y: 77))
        infoShapePath.addCurveToPoint(CGPoint(x: 32, y: 69.41), controlPoint1: CGPoint(x: 35.6, y: 77), controlPoint2: CGPoint(x: 32, y: 73.58))
        infoShapePath.addLineToPoint(CGPoint(x: 32, y: 35.26))
        infoShapePath.addCurveToPoint(CGPoint(x: 40, y: 27.67), controlPoint1: CGPoint(x: 32, y: 31.08), controlPoint2: CGPoint(x: 35.6, y: 27.67))
        infoShapePath.addLineToPoint(CGPoint(x: 40, y: 27.67))
        infoShapePath.addCurveToPoint(CGPoint(x: 48, y: 35.26), controlPoint1: CGPoint(x: 44.4, y: 27.67), controlPoint2: CGPoint(x: 48, y: 31.08))
        infoShapePath.addLineToPoint(CGPoint(x: 48, y: 69.41))
        infoShapePath.closePath()

        color0.setFill()

        infoShapePath.fill()
    }
    /** TODO
 *
 * TODO
 */
    static func drawEdit() {
        // Color Declarations
        let color: UIColor! = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Edit shape Drawing
        let editPathPath = UIBezierPath()

        editPathPath.moveToPoint(CGPoint(x: 71, y: 2.7))
        editPathPath.addCurveToPoint(CGPoint(x: 71.9, y: 15.2), controlPoint1: CGPoint(x: 74.7, y: 5.9), controlPoint2: CGPoint(x: 75.1, y: 11.6))
        editPathPath.addLineToPoint(CGPoint(x: 64.5, y: 23.7))
        editPathPath.addLineToPoint(CGPoint(x: 49.9, y: 11.1))
        editPathPath.addLineToPoint(CGPoint(x: 57.3, y: 2.6))
        editPathPath.addCurveToPoint(CGPoint(x: 69.7, y: 1.7), controlPoint1: CGPoint(x: 60.4, y: 1.1), controlPoint2: CGPoint(x: 66.1, y: 1.5))
        editPathPath.addLineToPoint(CGPoint(x: 71, y: 2.7))
        editPathPath.addLineToPoint(CGPoint(x: 71, y: 2.7))
        editPathPath.closePath()
        editPathPath.moveToPoint(CGPoint(x: 47.8, y: 13.5))
        editPathPath.addLineToPoint(CGPoint(x: 13.4, y: 53.1))
        editPathPath.addLineToPoint(CGPoint(x: 15.7, y: 55.1))
        editPathPath.addLineToPoint(CGPoint(x: 50.1, y: 15.5))
        editPathPath.addLineToPoint(CGPoint(x: 47.8, y: 13.5))
        editPathPath.addLineToPoint(CGPoint(x: 47.8, y: 13.5))
        editPathPath.closePath()
        editPathPath.moveToPoint(CGPoint(x: 17.7, y: 56.7))
        editPathPath.addLineToPoint(CGPoint(x: 23.8, y: 62.2))
        editPathPath.addLineToPoint(CGPoint(x: 58.2, y: 22.6))
        editPathPath.addLineToPoint(CGPoint(x: 52, y: 17.1))
        editPathPath.addLineToPoint(CGPoint(x: 17.7, y: 56.7))
        editPathPath.addLineToPoint(CGPoint(x: 17.7, y: 56.7))
        editPathPath.closePath()
        editPathPath.moveToPoint(CGPoint(x: 25.8, y: 63.8))
        editPathPath.addLineToPoint(CGPoint(x: 60.1, y: 24.2))
        editPathPath.addLineToPoint(CGPoint(x: 62.3, y: 26.1))
        editPathPath.addLineToPoint(CGPoint(x: 28.1, y: 65.7))
        editPathPath.addLineToPoint(CGPoint(x: 25.8, y: 63.8))
        editPathPath.addLineToPoint(CGPoint(x: 25.8, y: 63.8))
        editPathPath.closePath()
        editPathPath.moveToPoint(CGPoint(x: 25.9, y: 68.1))
        editPathPath.addLineToPoint(CGPoint(x: 4.2, y: 79.5))
        editPathPath.addLineToPoint(CGPoint(x: 11.3, y: 55.5))
        editPathPath.addLineToPoint(CGPoint(x: 25.9, y: 68.1))
        editPathPath.closePath()
        editPathPath.miterLimit = 4
        editPathPath.usesEvenOddFillRule = true

        color.setFill()

        editPathPath.fill()
    }
    /** TODO
 *
 * TODO
 */
    static func drawQuestion() {
        // Color Declarations
        let color: UIColor! = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Questionmark Shape Drawing
        let questionShapePath = UIBezierPath()

        questionShapePath.moveToPoint(CGPoint(x: 33.75, y: 54.1))
        questionShapePath.addLineToPoint(CGPoint(x: 44.15, y: 54.1))
        questionShapePath.addLineToPoint(CGPoint(x: 44.15, y: 47.5))
        questionShapePath.addCurveToPoint(CGPoint(x: 51.85, y: 37.2), controlPoint1: CGPoint(x: 44.15, y: 42.9), controlPoint2: CGPoint(x: 46.75, y: 41.2))
        questionShapePath.addCurveToPoint(CGPoint(x: 61.95, y: 19.9), controlPoint1: CGPoint(x: 59.05, y: 31.6), controlPoint2: CGPoint(x: 61.95, y: 28.5))
        questionShapePath.addCurveToPoint(CGPoint(x: 41.45, y: 2.8), controlPoint1: CGPoint(x: 61.95, y: 7.6), controlPoint2: CGPoint(x: 52.85, y: 2.8))
        questionShapePath.addCurveToPoint(CGPoint(x: 25.05, y: 5.8), controlPoint1: CGPoint(x: 34.75, y: 2.8), controlPoint2: CGPoint(x: 29.65, y: 3.8))
        questionShapePath.addLineToPoint(CGPoint(x: 25.05, y: 14.4))
        questionShapePath.addCurveToPoint(CGPoint(x: 38.15, y: 12.3), controlPoint1: CGPoint(x: 29.15, y: 13.2), controlPoint2: CGPoint(x: 32.35, y: 12.3))
        questionShapePath.addCurveToPoint(CGPoint(x: 49.65, y: 20.8), controlPoint1: CGPoint(x: 45.65, y: 12.3), controlPoint2: CGPoint(x: 49.65, y: 14.4))
        questionShapePath.addCurveToPoint(CGPoint(x: 43.65, y: 31.7), controlPoint1: CGPoint(x: 49.65, y: 26), controlPoint2: CGPoint(x: 47.95, y: 28.4))
        questionShapePath.addCurveToPoint(CGPoint(x: 33.75, y: 46.6), controlPoint1: CGPoint(x: 37.15, y: 36.9), controlPoint2: CGPoint(x: 33.75, y: 39.7))
        questionShapePath.addLineToPoint(CGPoint(x: 33.75, y: 54.1))
        questionShapePath.closePath()
        questionShapePath.moveToPoint(CGPoint(x: 33.15, y: 75.4))
        questionShapePath.addLineToPoint(CGPoint(x: 45.35, y: 75.4))
        questionShapePath.addLineToPoint(CGPoint(x: 45.35, y: 63.7))
        questionShapePath.addLineToPoint(CGPoint(x: 33.15, y: 63.7))
        questionShapePath.addLineToPoint(CGPoint(x: 33.15, y: 75.4))
        questionShapePath.closePath()

        color.setFill()

        questionShapePath.fill()
    }
    // Images
    /** TODO
 *
 * TODO
 */
    static func imageOfCheckmark() -> UIImage! {
        if imageOfCheckmark != nil {
            return imageOfCheckmark
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)

        SCLAlertViewStyleKit.drawCheckmark()

        imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return imageOfCheckmark
    }
    /** TODO
 *
 * TODO
 */
    static func imageOfCross() -> UIImage! {
        if imageOfCross != nil {
            return imageOfCross
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)

        SCLAlertViewStyleKit.drawCross()

        imageOfCross = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return imageOfCross
    }
    /** TODO
 *
 * TODO
 */
    static func imageOfNotice() -> UIImage! {
        if imageOfNotice != nil {
            return imageOfNotice
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)

        SCLAlertViewStyleKit.drawNotice()

        imageOfNotice = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return imageOfNotice
    }
    /** TODO
 *
 * TODO
 */
    static func imageOfWarning() -> UIImage! {
        if imageOfWarning != nil {
            return imageOfWarning
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)

        SCLAlertViewStyleKit.drawWarning()

        imageOfWarning = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return imageOfWarning
    }
    /** TODO
 *
 * TODO
 */
    static func imageOfInfo() -> UIImage! {
        if imageOfInfo != nil {
            return imageOfInfo
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)

        SCLAlertViewStyleKit.drawInfo()

        imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return imageOfInfo
    }
    /** TODO
 *
 * TODO
 */
    static func imageOfEdit() -> UIImage! {
        if imageOfEdit != nil {
            return imageOfEdit
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)

        SCLAlertViewStyleKit.drawEdit()

        imageOfEdit = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return imageOfEdit
    }
    /** TODO
 *
 * TODO
 */
    static func imageOfQuestion() -> UIImage! {
        if imageOfQuestion != nil {
            return imageOfQuestion
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)

        SCLAlertViewStyleKit.drawQuestion()

        imageOfQuestion = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return imageOfQuestion
    }
}