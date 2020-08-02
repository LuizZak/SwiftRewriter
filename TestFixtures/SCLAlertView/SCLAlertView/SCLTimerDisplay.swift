import UIKit

// Preprocessor directives found in file:
// #if defined(__has_feature) && __has_feature(modules)
// #else
// #import <UIKit/UIKit.h>
// #endif
// #import "SCLButton.h"
// #import "SCLTimerDisplay.h"
// #import "SCLMacros.h"
//
//  SCLTimerDisplay.h
//  SCLAlertView
//
//  Created by Taylor Ryan on 8/18/15.
//  Copyright (c) 2015-2017 AnyKey Entertainment. All rights reserved.
//
//  Taken from https://stackoverflow.com/questions/11783439/uibutton-with-timer
class SCLTimerDisplay: UIView {
    private var currentTime: CGFloat = 0.0
    private var timerLimit: CGFloat = 0.0
    private var radius: CGFloat = 0.0
    private var lineWidth: CGFloat = 0.0
    private var timer: NSTimer!
    private var completedBlock: SCLActionBlock!
    private var _countLabel: UILabel!
    private var _color: UIColor!
    private var _reverse: Bool = false
    private(set) var currentAngle: CGFloat = 0.0
    var buttonIndex: Int = 0
    var color: UIColor! {
        get {
            return self._color
        }
        set {
            self._color = newValue
        }
    }
    var reverse: Bool {
        get {
            return self._reverse
        }
        set {
            self._reverse = newValue
        }
    }

    override init(frame: CGRect) {
        self.backgroundColor = UIColor.clear
        currentAngle = 0.0
        super.init(frame: frame)
    }
    init(origin: CGPoint, radius r: CGFloat) {
        return self.init(origin: origin as CGPoint, radius: r, lineWidth: 5.0)
    }
    init(origin: CGPoint, radius r: CGFloat, lineWidth width: CGFloat) {
        self.backgroundColor = UIColor.clear

        currentAngle = CGFloat(START_DEGREE_OFFSET)

        radius = r - (width / 2)

        lineWidth = width

        self.color = UIColor.white

        self.isUserInteractionEnabled = false

        // Add count label
        _countLabel = UILabel()
        _countLabel.textColor = UIColor.white
        _countLabel.backgroundColor = UIColor.clear
        _countLabel.font = UIFont.fontWithName("HelveticaNeue-Bold", size: 12.0)
        _countLabel.textAlignment = NSTextAlignment.center
        _countLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

        self.addSubview(_countLabel)

        super.init(frame: CGRect(x: origin.x, y: origin.y, width: r * 2, height: r * 2))
    }

    func updateFrame(_ size: CGSize) {
        let r = radius + (lineWidth / 2)
        let originX = size.width - (2 * r) - 5
        let originY = (size.height - (2 * r)) / 2

        self.frame = CGRect(x: originX, y: originY, width: r * 2, height: r * 2)
        self.countLabel.frame = CGRect(x: 0, y: 0, width: r * 2, height: r * 2)
    }
    override func draw(_ rect: CGRect) {
        let aPath: UIBezierPath! = UIBezierPath.bezierPathWithArcCenter(CGPoint(x: radius + (lineWidth / 2), y: radius + (lineWidth / 2)), radius: radius, startAngle: DEGREES_TO_RADIANS(START_DEGREE_OFFSET), endAngle: DEGREES_TO_RADIANS(currentAngle), clockwise: true)

        self.color.setStroke()

        aPath.lineWidth = lineWidth
        aPath.stroke()

        _countLabel.text = String(format: "%d", CInt(currentTime))
    }
    func startTimerWithTimeLimit(_ tl: CInt, completed: SCLActionBlock!) {
        if _reverse {
            currentTime = CGFloat(tl)
        }

        timerLimit = CGFloat(tl)

        timer = NSTimer.scheduledTimerWithTimeInterval(TIMER_STEP, target: self, selector: #selector(updateTimerButton(_:)), userInfo: nil, repeats: true)

        completedBlock = completed

        _countLabel.textColor = _color
    }
    func cancelTimer() {
        timer.invalidate()
    }
    func stopTimer() {
        timer.invalidate()
        completedBlock?()
    }
    func updateTimerButton(_ timer: NSTimer!) {
        if _reverse {
            currentTime -= CGFloat(TIMER_STEP)
            currentAngle = (currentTime / timerLimit) * 360 + START_DEGREE_OFFSET

            if currentTime <= 0 {
                self.stopTimer()
            }
        } else {
            currentTime += CGFloat(TIMER_STEP)
            currentAngle = (currentTime / timerLimit) * 360 + START_DEGREE_OFFSET

            if currentAngle >= (360 + START_DEGREE_OFFSET) {
                self.stopTimer()
            }
        }

        self.setNeedsDisplay()
    }
}

// MARK: -
//
//  SCLTimerDisplay.m
//  SCLAlertView
//
//  Created by Taylor Ryan on 8/18/15.
//  Copyright (c) 2015-2017 AnyKey Entertainment. All rights reserved.
//
extension SCLTimerDisplay {
    var countLabel: UILabel! {
        get {
            return self._countLabel
        }
        set {
            self._countLabel = newValue
        }
    }
}