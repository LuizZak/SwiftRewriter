import UIKit

// Preprocessor directives found in file:
// #if defined(__has_feature) && __has_feature(modules)
// #else
// #import <UIKit/UIKit.h>
// #endif
// #import "SCLButton.h"
// #import "SCLTimerDisplay.h"
// #define MARGIN_BUTTON 12.0f
// #define DEFAULT_WINDOW_WIDTH 240
// #define MIN_HEIGHT 35.0f
// #pragma mark - Button Apperance
// #pragma mark - Helpers
typealias SCLActionBlock = () -> Void
typealias SCLValidationBlock = () -> Bool
typealias CompleteButtonFormatBlock = () -> NSDictionary?
typealias ButtonFormatBlock = () -> NSDictionary?

// Action Types
enum SCLActionType: Int {
    case SCLNone
    case SCLSelector
    case SCLBlock
}

private let MARGIN_BUTTON: Double = 12.0
private let DEFAULT_WINDOW_WIDTH: Int = 240
private let MIN_HEIGHT: Double = 35.0

//
//  SCLButton.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//
//
//  SCLButton.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//
class SCLButton: UIButton {
    private var _timer: SCLTimerDisplay!
    /** Set button action type.
 *
 * Holds the button action type.
 */
    var actionType: SCLActionType = SCLActionType.SCLNone
    /** Set action button block.
 *
 * TODO
 */
    var actionBlock: SCLActionBlock!
    /** Set Validation button block.
 *
 * Set one kind of validation and keeps the alert visible until the validation is successful
 */
    var validationBlock: SCLValidationBlock!
    /** Set Complete button format block.
 *
 * Holds the complete button format block.
 * Support keys : backgroundColor, borderWidth, borderColor, textColor
 */
    var completeButtonFormatBlock: CompleteButtonFormatBlock!
    /** Set button format block.
 *
 * Holds the button format block.
 * Support keys : backgroundColor, borderWidth, borderColor, textColor
 */
    var buttonFormatBlock: ButtonFormatBlock!
    /** Set SCLButton color.
 *
 * Set SCLButton color.
 */
    var UI_APPEARANCE_SELECTOR: UIColor!
    /** Set Target object.
 *
 * Target is an object that holds the information necessary to send a message to another object when an event occurs.
 */
    var target: AnyObject!
    /** Set selector id.
 *
 * A selector is the name used to select a method to execute for an object,
 * or the unique identifier that replaces the name when the source code is compiled.
 */
    var selector: SEL
    /** Set button timer.
 *
 * Holds the button timer, if present.
 */
    var timer: SCLTimerDisplay! {
        get {
            return _timer
        }
        set(timer) {
            _timer = timer

            self.addSubview(timer)

            timer.updateFrame(self.frame.size)
            timer.color = self.titleLabel.textColor
        }
    }

    override init() {
        self.setupWithWindowWidth(CGFloat(DEFAULT_WINDOW_WIDTH))
        super.init()
    }
    init(windowWidth: CGFloat) {
        self.setupWithWindowWidth(windowWidth)
        super.init()
    }
    override init(coder aDecoder: NSCoder!) {
        self.setupWithWindowWidth(CGFloat(DEFAULT_WINDOW_WIDTH))
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        self.setupWithWindowWidth(CGFloat(DEFAULT_WINDOW_WIDTH))
        super.init(frame: frame)
    }

    func setupWithWindowWidth(_ windowWidth: CGFloat) {
        self.frame = CGRect(x: 0.0, y: 0.0, width: windowWidth - (MARGIN_BUTTON * 2), height: CGFloat(MIN_HEIGHT))

        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping
        self.titleLabel.textAlignment = NSTextAlignment.center

        self.layer.cornerRadius = 3.0
    }
    /** Adjust width of the button according to the width of the alert and
 * the number of buttons. Only used when buttons are horizontally aligned.
 *
 * @param windowWidth The width of the alert.
 * @param numberOfButtons The number of buttons in the alert.
 */
    func adjustWidthWithWindowWidth(_ windowWidth: CGFloat, numberOfButtons: UInt) {
        let allButtonsWidth = windowWidth - (MARGIN_BUTTON * 2)
        let buttonWidth = (allButtonsWidth - ((numberOfButtons - 1) * 10)) / numberOfButtons

        self.frame = CGRect(x: 0.0, y: 0.0, width: buttonWidth, height: CGFloat(MIN_HEIGHT))
    }
    override func setTitle(_ title: String!, forState state: UIControlState) {
        super.setTitle(title, forState: state)

        self.titleLabel.numberOfLines = 0
        // Update title frame.
        self.titleLabel.sizeToFit()

        // Update button frame
        self.layoutIfNeeded()

        // Get height needed to display title label completely
        let buttonHeight = CGFloat(max(self.titleLabel.frame.size.height, MIN_HEIGHT))

        // Update button frame
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: buttonHeight)
    }
    override func setHighlighted(_ highlighted: Bool) {
        self.backgroundColor = (highlighted) ? self.darkerColorForColor(_defaultBackgroundColor) : _defaultBackgroundColor
        super.setHighlighted(highlighted)
    }
    func setDefaultBackgroundColor(_ defaultBackgroundColor: UIColor!) {
        self.backgroundColor = _defaultBackgroundColor = defaultBackgroundColor
    }
    /** Parse button configuration
 *
 * Parse ButtonFormatBlock and CompleteButtonFormatBlock setting custom configuration.
 * Set keys : backgroundColor, borderWidth, borderColor, textColor
 */
    func parseConfig(_ buttonConfig: NSDictionary!) {
        if buttonConfig["backgroundColor"] != nil {
            self.defaultBackgroundColor = buttonConfig["backgroundColor"]
        }

        if buttonConfig["textColor"] != nil {
            self.setTitleColor(buttonConfig["textColor"], forState: UIControlStateNormal)
        }

        if buttonConfig["cornerRadius"] != nil {
            self.layer.cornerRadius = buttonConfig["cornerRadius"]?.floatValue()
        }

        if ((buttonConfig["borderColor"]) != nil) && ((buttonConfig["borderWidth"]) != nil) {
            self.layer.borderColor = (buttonConfig["borderColor"] as? UIColor)?.cgColor
            self.layer.borderWidth = buttonConfig["borderWidth"]?.floatValue()
        } else if buttonConfig["borderWidth"] != nil {
            self.layer.borderWidth = buttonConfig["borderWidth"]?.floatValue()
        }

        // Add Button custom font with buttonConfig parameters
        if buttonConfig["font"] != nil {
            self.titleLabel.font = buttonConfig["font"]
        }
    }
    func darkerColorForColor(_ color: UIColor!) -> UIColor! {
        var r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat

        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }

        return nil
    }
    func lighterColorForColor(_ color: UIColor!) -> UIColor! {
        var r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat

        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }

        return nil
    }
}