import UIKit

// Preprocessor directives found in file:
// #if defined(__has_feature) && __has_feature(modules)
// #else
// #import <UIKit/UIKit.h>
// #endif
// #import "SCLSwitchView.h"
// #import "SCLMacros.h"
// #pragma mark
// #pragma mark - Constructors
// #pragma mark - Initialization
// #pragma mark - Getters
// #pragma mark - Setters
//
//  SCLSwitchView.h
//  SCLAlertView
//
//  Created by André Felipe Santos on 27/01/16.
//  Copyright (c) 2016-2017 AnyKey Entertainment. All rights reserved.
//
class SCLSwitchView: UIView {
    private var _selected: Bool = false
    var UI_APPEARANCE_SELECTOR: UIColor!
    var selected: Bool {
        get {
            return _selected
        }
        set(selected) {
            self.switchKnob.on = selected
        }
    }
    var switchKnob: UISwitch!
    var switchLabel: UILabel!

    override init() {
        self.setup()
        super.init()
    }
    override init(coder aDecoder: NSCoder!) {
        self.setup()
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        self.setup()
        super.init(frame: frame)
    }

    func setup() {
        // Add switch knob
        self.switchKnob = UISwitch(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
        self.addSubview(self.switchKnob)

        // Add switch label
        var x: CGFloat, width: CGFloat, height: CGFloat

        x = (self.switchKnob.frame.size.width ?? 0.0) + 8.0

        width = self.frame.size.width - (self.switchKnob.frame.size.width ?? 0.0) - 8.0

        height = (self.switchKnob.frame.size.height ?? 0.0)

        self.switchLabel = UILabel(frame: CGRect(x: x, y: 0.0, width: width, height: height))

        let switchFontFamily = "HelveticaNeue-Bold"
        let switchFontSize: CGFloat = 12.0

        self.switchLabel.numberOfLines = 1
        self.switchLabel.textAlignment = NSTextAlignment.left
        self.switchLabel.lineBreakMode = NSLineBreakByTruncatingTail
        self.switchLabel.adjustsFontSizeToFitWidth = true
        self.switchLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters
        self.switchLabel.minimumScaleFactor = 0.5
        self.switchLabel.font = UIFont.fontWithName(switchFontFamily, size: switchFontSize)
        self.switchLabel.textColor = UIColorFromHEX(0x4d4d4d)

        self.addSubview(self.switchLabel)
    }
    func tintColor() -> UIColor! {
        return self.switchKnob.tintColor
    }
    func labelColor() -> UIColor! {
        return self.switchLabel.textColor
    }
    func labelFont() -> UIFont! {
        return self.switchLabel.font
    }
    func labelText() -> String! {
        return self.switchLabel.text
    }
    func isSelected() -> Bool {
        return self.switchKnob.isOn
    }
    func setTintColor(_ tintColor: UIColor!) {
        self.switchKnob.onTintColor = tintColor
    }
    func setLabelColor(_ labelColor: UIColor!) {
        self.switchLabel.textColor = labelColor
    }
    func setLabelFont(_ labelFont: UIFont!) {
        self.switchLabel.font = labelFont
    }
    func setLabelText(_ labelText: String!) {
        self.switchLabel.text = labelText
    }
}