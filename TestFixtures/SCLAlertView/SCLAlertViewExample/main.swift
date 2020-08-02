import UIKit

// Preprocessor directives found in file:
// #import <UIKit/UIKit.h>
// #import "AppDelegate.h"
//
//  main.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2016 AnyKey Entertainment. All rights reserved.
//
func main(_ argc: CInt, _ argv: UnsafeMutablePointer<CChar>!) -> CInt {
    autoreleasepool { () -> Void in
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.self))
    }
}