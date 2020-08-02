import Foundation

// Preprocessor directives found in file:
// #if defined(__has_feature) && __has_feature(modules)
// #else
// #import <Foundation/Foundation.h>
// #endif
// #import "SCLAlertView.h"
// #import "SCLAlertViewResponder.h"
//
//  SCLAlertViewResponder.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//
class SCLAlertViewResponder: NSObject {
    var alertview: SCLAlertView!

    init(_ alertview: SCLAlertView!) {
        self.alertview = alertview

        return self
    }

    func setTitletitle(_ title: String!) {
        self.alertview.labelTitle.text = title
    }
    func setSubTitle(_ subTitle: String!) {
        self.alertview.viewText.text = subTitle
    }
    /** TODO
 *
 * TODO
 */
    func close() {
        self.alertview.hideView()
    }
}