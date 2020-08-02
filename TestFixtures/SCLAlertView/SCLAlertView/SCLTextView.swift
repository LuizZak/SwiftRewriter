import UIKit

// Preprocessor directives found in file:
// #if defined(__has_feature) && __has_feature(modules)
// #else
// #import <UIKit/UIKit.h>
// #endif
// #import "SCLTextView.h"
// #define MIN_HEIGHT 30.0f
private let MIN_HEIGHT: Double = 30.0

//
//  SCLTextView.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/18/15.
//  Copyright (c) 2015-2017 AnyKey Entertainment. All rights reserved.
//
//
//  SCLTextView.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/18/15.
//  Copyright (c) 2015-2017 AnyKey Entertainment. All rights reserved.
//
class SCLTextView: UITextField {
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
        self.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: CGFloat(MIN_HEIGHT))

        self.returnKeyType = UIReturnKeyDone

        self.borderStyle = UITextBorderStyleRoundedRect

        self.autocapitalizationType = UITextAutocapitalizationTypeSentences

        self.clearButtonMode = UITextFieldViewModeWhileEditing

        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
    }
}