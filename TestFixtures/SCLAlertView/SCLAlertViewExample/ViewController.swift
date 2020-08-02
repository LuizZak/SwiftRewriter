import UIKit

// Preprocessor directives found in file:
// #import <UIKit/UIKit.h>
// #import "ViewController.h"
// #import "SCLAlertView.h"
var kSuccessTitle: String! = "Congratulations"
var kErrorTitle: String! = "Connection error"
var kNoticeTitle: String! = "Notice"
var kWarningTitle: String! = "Warning"
var kInfoTitle: String! = "Info"
var kSubtitle: String! = "You've just displayed this awesome Pop Up View"
var kButtonTitle: String! = "Done"
var kAttributeTitle: String! = "Attributed string operation successfully completed."

//
//  ViewController.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//
class ViewController: UIViewController {
    func showSuccess(_ sender: AnyObject!) -> IBAction {
        let alert: SCLAlertView! = SCLAlertView.alloc().initWithNewWindow()
        let button = alert.addButton("First Button", target: self, selector: #selector(firstButton()))

        button.buttonFormatBlock = { (<unknown>: Void) -> NSDictionary! in
            let buttonConfig = NSMutableDictionary()

            buttonConfig["backgroundColor"] = UIColor.white
            buttonConfig["textColor"] = UIColor.black
            buttonConfig["borderWidth"] = 2.0
            buttonConfig["borderColor"] = UIColor.green

            return buttonConfig
        }

        alert.addButton("Second Button") { (<unknown>: Void) -> Void in
            NSLog("Second button tapped")
        }
        alert.soundURL = URL.fileURLWithPath(String(format: "%@/right_answer.mp3", NSBundle.mainBundle().resourcePath))
        alert.showSuccess(kSuccessTitle, subTitle: kSubtitle, closeButtonTitle: kButtonTitle, duration: 0.0)
    }
    func showSuccessWithHorizontalButtons(_ sender: AnyObject!) -> IBAction {
        let alert: SCLAlertView! = SCLAlertView.alloc().initWithNewWindow()

        alert.setHorizontalButtons(true)

        let button = alert.addButton("First Button", target: self, selector: #selector(firstButton()))

        button.buttonFormatBlock = { (<unknown>: Void) -> NSDictionary! in
            let buttonConfig = NSMutableDictionary()

            buttonConfig["backgroundColor"] = UIColor.white
            buttonConfig["textColor"] = UIColor.black
            buttonConfig["borderWidth"] = 2.0
            buttonConfig["borderColor"] = UIColor.green

            return buttonConfig
        }

        alert.addButton("Second Button") { (<unknown>: Void) -> Void in
            NSLog("Second button tapped")
        }
        alert.soundURL = URL.fileURLWithPath(String(format: "%@/right_answer.mp3", NSBundle.mainBundle().resourcePath))
        alert.showSuccess(kSuccessTitle, subTitle: kSubtitle, closeButtonTitle: kButtonTitle, duration: 0.0)
    }
    func showError(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.showError(self, title: "An error with two title is presented ...", subTitle: "You have not saved your Submission yet. Please save the Submission before accessing the Responses list. Blah de blah de blah, blah. Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, End.", closeButtonTitle: "OK", duration: 0.0)
    }
    func showNotice(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.backgroundType = SCLAlertViewBackground.SCLAlertViewBackgroundBlur
        alert.showNotice(self, title: kNoticeTitle, subTitle: "You've just displayed this awesome Pop Up View with blur effect", closeButtonTitle: kButtonTitle, duration: 0.0)
    }
    func showWarning(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.showWarning(self, title: kWarningTitle, subTitle: kSubtitle, closeButtonTitle: kButtonTitle, duration: 0.0)
    }
    func showInfo(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.shouldDismissOnTapOutside = true
        alert.alertIsDismissed { () -> Void in
            NSLog("SCLAlertView dismissed!")
        }
        alert.showInfo(self, title: kInfoTitle, subTitle: kSubtitle, closeButtonTitle: kButtonTitle, duration: 0.0)
    }
    func showEdit(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()
        let textField = alert.addTextField("Enter your name")

        alert.addButton("Show Name") { (<unknown>: Void) -> Void in
            NSLog("Text value: %@", textField.text)
        }
        alert.showEdit(self, title: kInfoTitle, subTitle: kSubtitle, closeButtonTitle: kButtonTitle, duration: 0.0)
    }
    func showEditWithHorizontalButtons(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.setHorizontalButtons(true)

        let textField = alert.addTextField("Enter your name")

        alert.hideAnimationType = SCLAlertViewHideAnimation.SCLAlertViewHideAnimationSimplyDisappear
        alert.addButton("Show Name") { (<unknown>: Void) -> Void in
            NSLog("Text value: %@", textField.text)
        }
        alert.showEdit(self, title: kInfoTitle, subTitle: kSubtitle, closeButtonTitle: kButtonTitle, duration: 0.0)
    }
    func showAdvanced(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.backgroundViewColor = UIColor.cyan
        alert.setTitleFontFamily("Superclarendon", withSize: 20.0)
        alert.setBodyTextFontFamily("TrebuchetMS", withSize: 14.0)
        alert.setButtonsTextFontFamily("Baskerville", withSize: 14.0)
        alert.addButton("First Button", target: self, selector: #selector(firstButton()))
        alert.addButton("Second Button") { (<unknown>: Void) -> Void in
            NSLog("Second button tapped")
        }

        let textField = alert.addTextField("Enter your name")

        alert.addButton("Show Name") { (<unknown>: Void) -> Void in
            NSLog("Text value: %@", textField.text)
        }
        alert.completeButtonFormatBlock = { (<unknown>: Void) -> NSDictionary! in
            let buttonConfig = NSMutableDictionary()

            buttonConfig["backgroundColor"] = UIColor.green
            buttonConfig["borderColor"] = UIColor.black
            buttonConfig["borderWidth"] = "1.0f"
            buttonConfig["textColor"] = UIColor.black

            return buttonConfig
        }
        alert.attributedFormatBlock = { (value: String!) -> NSAttributedString! in
            let subTitle: NSMutableAttributedString! = NSMutableAttributedString(string: value)
            let redRange: NSRange = value.rangeOfString("Attributed", options: NSCaseInsensitiveSearch)

            subTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: redRange)

            let greenRange: NSRange = value.rangeOfString("successfully", options: NSCaseInsensitiveSearch)

            subTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.brown, range: greenRange)

            let underline: NSRange = value.rangeOfString("completed", options: NSCaseInsensitiveSearch)

            subTitle.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyleSingle], range: underline)

            return subTitle
        }
        alert.showTitle(self, title: "Congratulations", subTitle: kAttributeTitle, style: SCLAlertViewStyle.SCLAlertViewStyleSuccess, closeButtonTitle: "Done", duration: 0.0)
    }
    func ShowAdvancedWithHorizontalButtons(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.setHorizontalButtons(true)
        alert.backgroundViewColor = UIColor.cyan
        alert.setTitleFontFamily("Superclarendon", withSize: 20.0)
        alert.setBodyTextFontFamily("TrebuchetMS", withSize: 14.0)
        alert.setButtonsTextFontFamily("Baskerville", withSize: 14.0)
        alert.addButton("First Button", target: self, selector: #selector(firstButton()))
        alert.addButton("Second Button") { (<unknown>: Void) -> Void in
            NSLog("Second button tapped")
        }

        let textField = alert.addTextField("Enter your name")

        alert.addButton("Show Name") { (<unknown>: Void) -> Void in
            NSLog("Text value: %@", textField.text)
        }
        alert.completeButtonFormatBlock = { (<unknown>: Void) -> NSDictionary! in
            let buttonConfig = NSMutableDictionary()

            buttonConfig["backgroundColor"] = UIColor.green
            buttonConfig["borderColor"] = UIColor.black
            buttonConfig["borderWidth"] = "1.0f"
            buttonConfig["textColor"] = UIColor.black

            return buttonConfig
        }
        alert.attributedFormatBlock = { (value: String!) -> NSAttributedString! in
            let subTitle: NSMutableAttributedString! = NSMutableAttributedString(string: value)
            let redRange: NSRange = value.rangeOfString("Attributed", options: NSCaseInsensitiveSearch)

            subTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: redRange)

            let greenRange: NSRange = value.rangeOfString("successfully", options: NSCaseInsensitiveSearch)

            subTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.brown, range: greenRange)

            let underline: NSRange = value.rangeOfString("completed", options: NSCaseInsensitiveSearch)

            subTitle.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyleSingle], range: underline)

            return subTitle
        }
        alert.showTitle(self, title: "Congratulations", subTitle: kAttributeTitle, style: SCLAlertViewStyle.SCLAlertViewStyleSuccess, closeButtonTitle: "Done", duration: 0.0)
    }
    func showWithDuration(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.showNotice(self, title: kNoticeTitle, subTitle: "You've just displayed this awesome Pop Up View with 5 seconds duration", closeButtonTitle: nil, duration: 5.0)
    }
    func showCustom(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()
        let color: UIColor! = UIColor(red: 65.0 / 255.0, green: 64.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)

        alert.showCustom(self, image: UIImage.imageNamed("git"), color: color, title: "Custom", subTitle: "Add a custom icon and color for your own type of alert!", closeButtonTitle: "OK", duration: 0.0)
    }
    func showValidation(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()
        let evenField = alert.addTextField("Enter an even number")

        evenField.keyboardType = UIKeyboardTypeNumberPad

        let oddField = alert.addTextField("Enter an odd number")

        oddField.keyboardType = UIKeyboardTypeNumberPad
        alert.addButton("Test Validation", validationBlock: { () -> Bool in
            if evenField.text.length == 0 {
                UIAlertView(title: "Whoops!", message: "You forgot to add an even number.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show()
                evenField.becomeFirstResponder()

                return false
            }

            if oddField.text.length == 0 {
                UIAlertView(title: "Whoops!", message: "You forgot to add an odd number.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show()
                oddField.becomeFirstResponder()

                return false
            }

            let evenFieldEntry: Int = (evenField.text).integerValue
            let evenFieldPassedValidation = evenFieldEntry % 2 == 0

            if !evenFieldPassedValidation {
                UIAlertView(title: "Whoops!", message: "That is not an even number.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show()
                evenField.becomeFirstResponder()

                return false
            }

            let oddFieldEntry: Int = (oddField.text).integerValue
            let oddFieldPassedValidation = oddFieldEntry % 2 == 1

            if !oddFieldPassedValidation {
                UIAlertView(title: "Whoops!", message: "That is not an odd number.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show()
                oddField.becomeFirstResponder()

                return false
            }

            return true
        }, actionBlock: { () -> Void in
            UIAlertView(title: "Great Job!", message: "Thanks for playing.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show()
        })
        alert.showEdit(self, title: "Validation", subTitle: "Ensure the data is correct before dismissing!", closeButtonTitle: "Cancel", duration: 0)
    }
    func showValidationWithHorizontalButtons(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.setHorizontalButtons(true)

        let evenField = alert.addTextField("Enter an even number")

        evenField.keyboardType = UIKeyboardTypeNumberPad

        let oddField = alert.addTextField("Enter an odd number")

        oddField.keyboardType = UIKeyboardTypeNumberPad
        alert.addButton("Test Validation", validationBlock: { () -> Bool in
            if evenField.text.length == 0 {
                UIAlertView(title: "Whoops!", message: "You forgot to add an even number.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show()
                evenField.becomeFirstResponder()

                return false
            }

            if oddField.text.length == 0 {
                UIAlertView(title: "Whoops!", message: "You forgot to add an odd number.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show()
                oddField.becomeFirstResponder()

                return false
            }

            let evenFieldEntry: Int = (evenField.text).integerValue
            let evenFieldPassedValidation = evenFieldEntry % 2 == 0

            if !evenFieldPassedValidation {
                UIAlertView(title: "Whoops!", message: "That is not an even number.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show()
                evenField.becomeFirstResponder()

                return false
            }

            let oddFieldEntry: Int = (oddField.text).integerValue
            let oddFieldPassedValidation = oddFieldEntry % 2 == 1

            if !oddFieldPassedValidation {
                UIAlertView(title: "Whoops!", message: "That is not an odd number.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show()
                oddField.becomeFirstResponder()

                return false
            }

            return true
        }, actionBlock: { () -> Void in
            UIAlertView(title: "Great Job!", message: "Thanks for playing.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show()
        })
        alert.showEdit(self, title: "Validation", subTitle: "Ensure the data is correct before dismissing!", closeButtonTitle: "Cancel", duration: 0)
    }
    func showWaiting(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.showAnimationType = SCLAlertViewHideAnimation.SCLAlertViewHideAnimationSlideOutToCenter
        alert.hideAnimationType = SCLAlertViewHideAnimation.SCLAlertViewHideAnimationSlideOutFromCenter
        alert.backgroundType = SCLAlertViewBackground.SCLAlertViewBackgroundTransparent
        alert.showWaiting(self, title: "Waiting...", subTitle: "You've just displayed this awesome Pop Up View with transparent background", closeButtonTitle: nil, duration: 5.0)
    }
    func showTimer(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.addTimerToButtonIndex(0, reverse: true)
        alert.showInfo(self, title: "Countdown Timer", subTitle: "This alert has a duration set, and a countdown timer on the Dismiss button to show how long is left.", closeButtonTitle: "Dismiss", duration: 10.0)
    }
    func showQuestion(_ sender: AnyObject!) -> IBAction {
        let alert = SCLAlertView()

        alert.showQuestion(self, title: "Question?", subTitle: kSubtitle, closeButtonTitle: "Dismiss", duration: 0.0)
    }
    func showSwitch(_ sender: AnyObject!) -> IBAction {
        let alert: SCLAlertView! = SCLAlertView.alloc().initWithNewWindow()

        alert.tintTopCircle = false
        alert.iconTintColor = UIColor.brown
        alert.useLargerIcon = true
        alert.cornerRadius = 13.0
        alert.addSwitchViewWithLabel("Don't show again".uppercaseString)

        SCLSwitchView.appearance().setTintColor(UIColor.brown)

        let button = alert.addButton("Done", target: self, selector: #selector(firstButton()))

        button.buttonFormatBlock = { (<unknown>: Void) -> NSDictionary! in
            let buttonConfig = NSMutableDictionary()

            buttonConfig["cornerRadius"] = "17.5f"

            return buttonConfig
        }
        alert.showCustom(self, image: UIImage.imageNamed("switch"), color: UIColor.brown, title: kInfoTitle, subTitle: kSubtitle, closeButtonTitle: nil, duration: 0.0)
    }
    func firstButton() {
        NSLog("First button tapped")
    }
    func showWithButtonCustom(_ sender: AnyObject!) -> IBAction {
        let alert: SCLAlertView! = SCLAlertView.alloc().initWithNewWindow()
        let button = alert.addButton("First Button", target: self, selector: #selector(firstButton()))

        button.buttonFormatBlock = { (<unknown>: Void) -> NSDictionary! in
            let buttonConfig = NSMutableDictionary()

            buttonConfig["backgroundColor"] = UIColor.white
            buttonConfig["textColor"] = UIColor.black
            buttonConfig["borderWidth"] = 2.0
            buttonConfig["borderColor"] = UIColor.green
            buttonConfig["font"] = UIFont.fontWithName("ComicSansMS", size: 13)

            return buttonConfig
        }

        alert.addButton("Second Button") { (<unknown>: Void) -> Void in
            NSLog("Second button tapped")
        }
        alert.soundURL = URL.fileURLWithPath(String(format: "%@/right_answer.mp3", NSBundle.mainBundle().resourcePath))
        alert.showSuccess(kSuccessTitle, subTitle: kSubtitle, closeButtonTitle: kButtonTitle, duration: 0.0)
    }
}