import UIKit
import AVFoundation
import AudioToolbox

// Preprocessor directives found in file:
// #if defined(__has_feature) && __has_feature(modules)
// #else
// #import <UIKit/UIKit.h>
// #endif
// #import "SCLButton.h"
// #import "SCLTextView.h"
// #import "SCLSwitchView.h"
// #pragma mark - Setters
// #pragma mark - Available later after adding
// #pragma mark - Setters
// #pragma mark - Available later after adding
// #pragma mark - Setters
// #pragma mark - Parameters
// #pragma mark - Init
// #pragma mark - Properties
// #pragma mark - Custom Setters
// #pragma mark - Builders
// #import "SCLAlertView.h"
// #import "SCLAlertViewResponder.h"
// #import "SCLAlertViewStyleKit.h"
// #import "UIImage+ImageEffects.h"
// #import "SCLTimerDisplay.h"
// #import "SCLMacros.h"
// #if defined(__has_feature) && __has_feature(modules)
// #else
// #import <AVFoundation/AVFoundation.h>
// #import <AudioToolbox/AudioToolbox.h>
// #endif
// #define KEYBOARD_HEIGHT 80
// #define PREDICTION_BAR_HEIGHT 40
// #define ADD_BUTTON_PADDING 10.0f
// #define DEFAULT_WINDOW_WIDTH 240
// #pragma mark - Initialization
// #pragma mark - Setup view
// #pragma mark - Modal Validation
// #pragma mark - View Cycle
// #pragma mark - UIViewController
// #pragma mark - Handle gesture
// #pragma mark - Custom Fonts
// #pragma mark - Background Color
// #pragma mark - Sound
// #pragma mark - Subtitle Height
// #pragma mark - ActivityIndicator
// #pragma mark - UICustomView
// #pragma mark - SwitchView
// #pragma mark - TextField
// # pragma mark - UITextFieldDelegate
// #pragma mark - Buttons
// #pragma mark - Button Timer
// #pragma mark - Show Alert
// #pragma mark - Show using UIViewController
// #pragma mark - Show using new window
// #pragma mark - Visibility
// #pragma mark - Background Effects
// #pragma mark - Show Alert
// #pragma mark - Hide Alert
// #pragma mark - Hide Animations
// #pragma mark - Show Animations
// #pragma mark - Parameters
// #pragma mark - Available later after adding
// #pragma mark - Setters
// #pragma mark - Parameters
// #pragma mark - Available later after adding
// #pragma mark - Setters
// #pragma mark - Init
// #pragma mark - Setters
// #pragma mark - Show
// #pragma mark - Setters
typealias SCLAttributedFormatBlock = (String?) -> NSAttributedString?
typealias SCLDismissBlock = () -> Void
typealias SCLDismissAnimationCompletionBlock = () -> Void
typealias SCLShowAnimationCompletionBlock = () -> Void
typealias SCLForceHideBlock = () -> Void

/** Alert Styles
 *
 * Set SCLAlertView Style
 */
enum SCLAlertViewStyle: Int {
    case SCLAlertViewStyleSuccess
    case SCLAlertViewStyleError
    case SCLAlertViewStyleNotice
    case SCLAlertViewStyleWarning
    case SCLAlertViewStyleInfo
    case SCLAlertViewStyleEdit
    case SCLAlertViewStyleWaiting
    case SCLAlertViewStyleQuestion
    case SCLAlertViewStyleCustom
}
/** Alert hide animation styles
 *
 * Set SCLAlertView hide animation type.
 */
enum SCLAlertViewHideAnimation: Int {
    case SCLAlertViewHideAnimationFadeOut
    case SCLAlertViewHideAnimationSlideOutToBottom
    case SCLAlertViewHideAnimationSlideOutToTop
    case SCLAlertViewHideAnimationSlideOutToLeft
    case SCLAlertViewHideAnimationSlideOutToRight
    case SCLAlertViewHideAnimationSlideOutToCenter
    case SCLAlertViewHideAnimationSlideOutFromCenter
    case SCLAlertViewHideAnimationSimplyDisappear
}
/** Alert show animation styles
 *
 * Set SCLAlertView show animation type.
 */
enum SCLAlertViewShowAnimation: Int {
    case SCLAlertViewShowAnimationFadeIn
    case SCLAlertViewShowAnimationSlideInFromBottom
    case SCLAlertViewShowAnimationSlideInFromTop
    case SCLAlertViewShowAnimationSlideInFromLeft
    case SCLAlertViewShowAnimationSlideInFromRight
    case SCLAlertViewShowAnimationSlideInFromCenter
    case SCLAlertViewShowAnimationSlideInToCenter
    case SCLAlertViewShowAnimationSimplyAppear
}
/** Alert background styles
 *
 * Set SCLAlertView background type.
 */
enum SCLAlertViewBackground: Int {
    case SCLAlertViewBackgroundShadow
    case SCLAlertViewBackgroundBlur
    case SCLAlertViewBackgroundTransparent
}

private let KEYBOARD_HEIGHT: Int = 80
private let PREDICTION_BAR_HEIGHT: Int = 40
private let ADD_BUTTON_PADDING: Double = 10.0
private let DEFAULT_WINDOW_WIDTH: Int = 240

protocol SCLItemsBuilder__Protocol__Fluent {
    func setupFluent()
}

class SCLAlertView: UIViewController {
    private var _inputs: NSMutableArray!
    private var _customViews: NSMutableArray!
    private var _buttons: NSMutableArray!
    private var _circleIconImageView: UIImageView!
    private var _circleView: UIView!
    private var _circleViewBackground: UIView!
    private var _contentView: UIView!
    private var _backgroundView: UIImageView!
    private var _gestureRecognizer: UITapGestureRecognizer!
    private var _titleFontFamily: String!
    private var _bodyTextFontFamily: String!
    private var _buttonsFontFamily: String!
    private var _SCLAlertWindow: UIWindow!
    private weak var _rootViewController: UIViewController?
    private weak var _restoreInteractivePopGestureDelegate: UIGestureRecognizerDelegate?
    private var _soundID: SystemSoundID
    private var _canAddObservers: Bool = false
    private var _keyboardIsVisible: Bool = false
    private var _usingNewWindow: Bool = false
    private var _restoreInteractivePopGestureEnabled: Bool = false
    private var _backgroundOpacity: CGFloat = 0.0
    private var _titleFontSize: CGFloat = 0.0
    private var _bodyFontSize: CGFloat = 0.0
    private var _buttonsFontSize: CGFloat = 0.0
    private var _windowHeight: CGFloat = 0.0
    private var _windowWidth: CGFloat = 0.0
    private var _titleHeight: CGFloat = 0.0
    private var _subTitleHeight: CGFloat = 0.0
    private var _subTitleY: CGFloat = 0.0
    private var _useLargerIcon: Bool = false
    private var _labelTitle: UILabel!
    private var _viewText: UITextView!
    private var _activityIndicatorView: UIActivityIndicatorView!
    private var _shouldDismissOnTapOutside: Bool = false
    private var _soundURL: URL!
    private var _attributedFormatBlock: SCLAttributedFormatBlock!
    private var _completeButtonFormatBlock: CompleteButtonFormatBlock!
    private var _buttonFormatBlock: ButtonFormatBlock!
    private var _forceHideBlock: SCLForceHideBlock!
    private var _hideAnimationType: SCLAlertViewHideAnimation = SCLAlertViewHideAnimation.SCLAlertViewHideAnimationFadeOut
    private var _showAnimationType: SCLAlertViewShowAnimation = SCLAlertViewShowAnimation.SCLAlertViewShowAnimationFadeIn
    private var _backgroundType: SCLAlertViewBackground = SCLAlertViewBackground.SCLAlertViewBackgroundShadow
    private var _customViewColor: UIColor!
    private var _backgroundViewColor: UIColor!
    private var _circleIconHeight: CGFloat = 0.0
    private var _extensionBounds: CGRect = CGRect()
    private var _horizontalButtons: Bool = false
    /** Content view corner radius
 *
 * A float value that replaces the standard content viuew corner radius.
 */
    var cornerRadius: CGFloat = 0.0
    /** Tint top circle
 *
 * A boolean value that determines whether to tint the SCLAlertView top circle.
 * (Default: YES)
 */
    var tintTopCircle: Bool = false
    /** Use larger icon
 *
 * A boolean value that determines whether to make the SCLAlertView top circle icon larger.
 * (Default: NO)
 */
    var useLargerIcon: Bool {
        get {
            return self._useLargerIcon
        }
        set {
            self._useLargerIcon = newValue
        }
    }
    /** Title Label
 *
 * The text displayed as title.
 */
    var labelTitle: UILabel! {
        get {
            return self._labelTitle
        }
        set {
            self._labelTitle = newValue
        }
    }
    /** Text view with the body message
 *
 * Holds the textview.
 */
    var viewText: UITextView! {
        get {
            return self._viewText
        }
        set {
            self._viewText = newValue
        }
    }
    /** Activity Indicator
 *
 * Holds the activityIndicator.
 */
    var activityIndicatorView: UIActivityIndicatorView! {
        get {
            return self._activityIndicatorView
        }
        set {
            self._activityIndicatorView = newValue
        }
    }
    /** Dismiss on tap outside
 *
 * A boolean value that determines whether to dismiss when tapping outside the SCLAlertView.
 * (Default: NO)
 */
    var shouldDismissOnTapOutside: Bool {
        get {
            return _shouldDismissOnTapOutside
        }
        set(shouldDismissOnTapOutside) {
            _shouldDismissOnTapOutside = shouldDismissOnTapOutside

            if _shouldDismissOnTapOutside {
                self.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                _backgroundView.addGestureRecognizer(_gestureRecognizer)
            }
        }
    }
    /** Sound URL
 *
 * Holds the sound NSURL path.
 */
    var soundURL: URL! {
        get {
            return _soundURL
        }
        set(soundURL) {
            _soundURL = soundURL

            AudioServicesDisposeSystemSoundID(_soundID)

            //DisposeSound
            AudioServicesCreateSystemSoundID(_soundURL as? __bridge, &_soundID)

            AudioServicesPlaySystemSound(_soundID)
        }
    }
    /** Set text attributed format block
 *
 * Holds the attributed string.
 */
    var attributedFormatBlock: SCLAttributedFormatBlock! {
        get {
            return self._attributedFormatBlock
        }
        set {
            self._attributedFormatBlock = newValue
        }
    }
    /** Set Complete button format block.
 *
 * Holds the button format block.
 * Support keys : backgroundColor, borderWidth, borderColor, textColor
 */
    var completeButtonFormatBlock: CompleteButtonFormatBlock! {
        get {
            return self._completeButtonFormatBlock
        }
        set {
            self._completeButtonFormatBlock = newValue
        }
    }
    /** Set button format block.
 *
 * Holds the button format block.
 * Support keys : backgroundColor, borderWidth, borderColor, textColor
 */
    var buttonFormatBlock: ButtonFormatBlock! {
        get {
            return self._buttonFormatBlock
        }
        set {
            self._buttonFormatBlock = newValue
        }
    }
    /** Set force hide block.
 *
 * When set force hideview method invocation.
 */
    var forceHideBlock: SCLForceHideBlock! {
        get {
            return self._forceHideBlock
        }
        set {
            self._forceHideBlock = newValue
        }
    }
    /** Hide animation type
 *
 * Holds the hide animation type.
 * (Default: FadeOut)
 */
    var hideAnimationType: SCLAlertViewHideAnimation {
        get {
            return self._hideAnimationType
        }
        set {
            self._hideAnimationType = newValue
        }
    }
    /** Show animation type
 *
 * Holds the show animation type.
 * (Default: SlideInFromTop)
 */
    var showAnimationType: SCLAlertViewShowAnimation {
        get {
            return self._showAnimationType
        }
        set {
            self._showAnimationType = newValue
        }
    }
    /** Set SCLAlertView background type.
 *
 * SCLAlertView background type.
 * (Default: Shadow)
 */
    var backgroundType: SCLAlertViewBackground {
        get {
            return self._backgroundType
        }
        set {
            self._backgroundType = newValue
        }
    }
    /** Set custom color to SCLAlertView.
 *
 * SCLAlertView custom color.
 * (Buttons, top circle and borders)
 */
    var customViewColor: UIColor! {
        get {
            return self._customViewColor
        }
        set {
            self._customViewColor = newValue
        }
    }
    /** Set custom color to SCLAlertView background.
 *
 * SCLAlertView background custom color.
 */
    var backgroundViewColor: UIColor! {
        get {
            return _backgroundViewColor
        }
        set(backgroundViewColor) {
            _backgroundViewColor = backgroundViewColor

            _circleViewBackground.backgroundColor = _backgroundViewColor

            _contentView.backgroundColor = _backgroundViewColor

            _viewText.backgroundColor = _backgroundViewColor
        }
    }
    /** Set custom tint color for icon image.
 *
 * SCLAlertView icon tint color
 */
    var iconTintColor: UIColor!
    /** Set custom circle icon height.
 *
 * Circle icon height
 */
    var circleIconHeight: CGFloat {
        get {
            return self._circleIconHeight
        }
        set {
            self._circleIconHeight = newValue
        }
    }
    /** Set SCLAlertView extension bounds.
 *
 * Set new bounds (EXTENSION ONLY)
 */
    var extensionBounds: CGRect {
        get {
            return self._extensionBounds
        }
        set {
            self._extensionBounds = newValue
        }
    }
    /** Set status bar hidden.
 *
 * Status bar hidden
 */
    var statusBarHidden: Bool = false
    /** Set status bar style.
 *
 * Status bar style
 */
    var statusBarStyle: UIStatusBarStyle
    /** Set horizontal alignment for buttons
 *
 * Horizontal aligment instead of vertically if YES
 */
    var horizontalButtons: Bool {
        get {
            return self._horizontalButtons
        }
        set {
            self._horizontalButtons = newValue
        }
    }
    var previousWindow: UIWindow!
    var dismissBlock: SCLDismissBlock!
    var dismissAnimationCompletionBlock: SCLDismissAnimationCompletionBlock!
    var showAnimationCompletionBlock: SCLShowAnimationCompletionBlock!

    init(coder aDecoder: NSCoder!) {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:@"NSCoding not supported"userInfo:nil];
        */
    }
    override init() {
        self.setupViewWindowWidth(CGFloat(DEFAULT_WINDOW_WIDTH))
        super.init()
    }
    init(windowWidth: CGFloat) {
        self.setupViewWindowWidth(windowWidth)
        super.init()
    }
    convenience init(newWindowWidth windowWidth: CGFloat) {
        self.setupNewWindow()
        self.init(windowWidth: windowWidth)
    }

    deinit {
        self.removeObservers()
        self.restoreInteractivePopGesture()
    }

    /** Initialize SCLAlertView using a new window.
 *
 * Init with new window
 */
    func initWithNewWindow() -> SCLAlertView {
        self = self.init(windowWidth: CGFloat(DEFAULT_WINDOW_WIDTH))

        if self {
            self.setupNewWindow()
        }

        return self
    }
    func addObservers() {
        if _canAddObservers {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
            _canAddObservers = false
        }
    }
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    func setupViewWindowWidth(_ windowWidth: CGFloat) {
        // Default values
        kCircleBackgroundTopPosition = 15.0

        kCircleHeight = 56.0

        kCircleHeightBackground = 62.0

        kActivityIndicatorHeight = 40.0

        kTitleTop = 30.0

        self.titleHeight = 40.0

        self.subTitleY = 70.0

        self.subTitleHeight = 90.0

        self.circleIconHeight = 20.0

        self.windowWidth = windowWidth

        self.windowHeight = 178.0

        self.shouldDismissOnTapOutside = false

        self.usingNewWindow = false

        self.canAddObservers = true

        self.keyboardIsVisible = false

        self.hideAnimationType = SCLAlertViewHideAnimation.SCLAlertViewHideAnimationFadeOut

        self.showAnimationType = SCLAlertViewShowAnimation.SCLAlertViewShowAnimationSlideInFromTop

        self.backgroundType = SCLAlertViewBackground.SCLAlertViewBackgroundShadow

        self.tintTopCircle = true

        // Font
        _titleFontFamily = "HelveticaNeue"

        _bodyTextFontFamily = "HelveticaNeue"

        _buttonsFontFamily = "HelveticaNeue-Bold"

        _titleFontSize = 20.0

        _bodyFontSize = 14.0

        _buttonsFontSize = 14.0

        // Init
        _labelTitle = UILabel()

        _viewText = UITextView()
        _viewText.accessibilityTraits = UIAccessibilityTraitStaticText

        _contentView = UIView()

        _circleView = UIView()

        _circleViewBackground = UIView(frame: CGRect(x: 0.0, y: 0.0, width: kCircleHeightBackground, height: kCircleHeightBackground))

        _circleIconImageView = UIImageView()

        _backgroundView = UIImageView(frame: self.mainScreenFrame())

        _buttons = NSMutableArray()

        _inputs = NSMutableArray()

        _customViews = NSMutableArray()

        self.view.accessibilityViewIsModal = true
        // Add Subviews
        self.view.addSubview(_contentView)
        self.view.addSubview(_circleViewBackground)

        // Circle View
        var x: CGFloat = (kCircleHeightBackground - kCircleHeight) / 2

        _circleView.frame = CGRect(x: x, y: x, width: kCircleHeight, height: kCircleHeight)
        _circleView.layer.cornerRadius = _circleView.frame.size.height / 2

        // Circle Background View
        _circleViewBackground.backgroundColor = UIColor.white
        _circleViewBackground.layer.cornerRadius = _circleViewBackground.frame.size.height / 2

        x = (kCircleHeight - _circleIconHeight) / 2

        // Circle Image View
        _circleIconImageView.frame = CGRect(x: x, y: x, width: _circleIconHeight, height: _circleIconHeight)
        _circleIconImageView.contentMode = UIViewContentModeScaleAspectFill

        _circleViewBackground.addSubview(_circleView)

        _circleView.addSubview(_circleIconImageView)

        // Background View
        _backgroundView.isUserInteractionEnabled = true

        // Title
        _labelTitle.numberOfLines = 2
        _labelTitle.lineBreakMode = NSLineBreakByWordWrapping
        _labelTitle.textAlignment = NSTextAlignment.center
        _labelTitle.font = UIFont.fontWithName(_titleFontFamily, size: _titleFontSize)
        _labelTitle.frame = CGRect(x: 12.0, y: kTitleTop, width: _windowWidth - 24.0, height: _titleHeight)

        // View text
        _viewText.editable = false
        _viewText.allowsEditingTextAttributes = true
        _viewText.textAlignment = NSTextAlignment.center
        _viewText.font = UIFont.fontWithName(_bodyTextFontFamily, size: _bodyFontSize)
        _viewText.frame = CGRect(x: 12.0, y: _subTitleY, width: _windowWidth - 24.0, height: _subTitleHeight)
        _viewText.textContainerInset = UIEdgeInsetsZero
        _viewText.textContainer.lineFragmentPadding = 0

        self.automaticallyAdjustsScrollViewInsets = false

        // Content View
        _contentView.backgroundColor = UIColor.white
        _contentView.layer.cornerRadius = 5.0
        _contentView.layer.masksToBounds = true
        _contentView.layer.borderWidth = 0.5
        _contentView.addSubview(_viewText)
        _contentView.addSubview(_labelTitle)

        // Colors
        self.backgroundViewColor = UIColor.white

        _labelTitle.textColor = UIColorFromHEX(0x4d4d4d) //Dark Grey

        _viewText.textColor = UIColorFromHEX(0x4d4d4d) //Dark Grey

        _contentView.layer.borderColor = UIColorFromHEX(0xcccccc).CGColor //Light Grey
    }
    func setupNewWindow() {
        // Save previous window
        self.previousWindow = UIApplication.sharedApplication().keyWindow

        // Create a new one to show the alert
        let alertWindow = UIWindow(frame: self.mainScreenFrame())

        alertWindow.windowLevel = UIWindowLevelAlert
        alertWindow.backgroundColor = UIColor.clear
        alertWindow.rootViewController = UIViewController()
        alertWindow.accessibilityViewIsModal = true

        self.SCLAlertWindow = alertWindow

        self.usingNewWindow = true
    }
    func isModal() -> Bool {
        return _rootViewController != nil && _rootViewController?.presentingViewController
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        var sz = self.mainScreenFrame().size

        // Check for larger top circle icon flag
        if _useLargerIcon {
            // Adjust icon
            _circleIconHeight = 70.0

            // Adjust coordinate variables for larger sized top circle
            kCircleBackgroundTopPosition = 61.0

            kCircleHeight = 106.0

            kCircleHeightBackground = 122.0

            // Reposition inner circle appropriately
            var x: CGFloat = (kCircleHeightBackground - kCircleHeight) / 2

            _circleView.frame = CGRect(x: x, y: x, width: kCircleHeight, height: kCircleHeight)

            if _labelTitle.text == nil {
                kTitleTop = kCircleHeightBackground / 2
            }
        } else {
            kCircleBackgroundTopPosition = -(kCircleHeightBackground / 2)
        }

        // Check if the rootViewController is modal, if so we need to get the modal size not the main screen size
        if self.isModal() && !_usingNewWindow {
            sz = (_rootViewController?.view.frame.size ?? CGSize())
        }

        // Set new main frame
        var r: CGRect

        if self.view.superview != nil {
            // View is showing, position at center of screen
            r = CGRect(x: (sz.width - _windowWidth) / 2, y: (sz.height - _windowHeight) / 2, width: _windowWidth, height: _windowHeight)
        } else {
            // View is not visible, position outside screen bounds
            r = CGRect(x: (sz.width - _windowWidth) / 2, y: -_windowHeight, width: _windowWidth, height: _windowHeight)
        }

        self.view.frame = r

        // Set new background frame
        var newBackgroundFrame = self.backgroundView.frame ?? CGRect()

        newBackgroundFrame.size = sz

        self.backgroundView.frame = newBackgroundFrame

        // Set frames
        _contentView.frame = CGRect(x: 0.0, y: 0.0, width: _windowWidth, height: _windowHeight)

        _circleViewBackground.frame = CGRect(x: _windowWidth / 2 - kCircleHeightBackground / 2, y: kCircleBackgroundTopPosition, width: kCircleHeightBackground, height: kCircleHeightBackground)
        _circleViewBackground.layer.cornerRadius = _circleViewBackground.frame.size.height / 2

        _circleView.layer.cornerRadius = _circleView.frame.size.height / 2

        _circleIconImageView.frame = CGRect(x: kCircleHeight / 2 - _circleIconHeight / 2, y: kCircleHeight / 2 - _circleIconHeight / 2, width: _circleIconHeight, height: _circleIconHeight)

        _labelTitle.frame = CGRect(x: 12.0, y: kTitleTop, width: _windowWidth - 24.0, height: _titleHeight)

        // Text fields
        var y: CGFloat = (_labelTitle.text == nil) ? kTitleTop : (_titleHeight - 10.0) + _labelTitle.frame.size.height

        _viewText.frame = CGRect(x: 12.0, y: y, width: _windowWidth - 24.0, height: _subTitleHeight)

        if !_labelTitle && !_viewText {
            y = 0.0
        }

        y += _subTitleHeight + 14.0

        for textField in _inputs {
            textField.frame = CGRect(x: 12.0, y: y, width: _windowWidth - 24.0, height: textField.frame.size.height)
            textField.layer.cornerRadius = 3.0
            y += textField.frame.size.height + 10.0
        }

        // Custom views
        for view in _customViews {
            view.frame = CGRect(x: 12.0, y: y, width: view.frame.size.width, height: view.frame.size.height)
            y += view.frame.size.height + 10.0
        }

        // Buttons
        var x: CGFloat = 12.0

        for btn in _buttons {
            btn.frame = CGRect(x: x, y: y, width: btn.frame.size.width, height: btn.frame.size.height)

            // Add horizontal or vertical offset acording on _horizontalButtons parameter
            if _horizontalButtons {
                x += btn.frame.size.width + 10.0
            } else {
                y += btn.frame.size.height + 10.0
            }
        }

        // Adapt window height according to icon size
        self.windowHeight = _useLargerIcon ? y : self.windowHeight
        _contentView.frame = CGRect(x: _contentView.frame.origin.x, y: _contentView.frame.origin.y, width: _windowWidth, height: _windowHeight)
        // Adjust corner radius, if a value has been passed
        _contentView.layer.cornerRadius = self.cornerRadius != 0 ? self.cornerRadius : 5.0
    }
    func prefersStatusBarHidden() -> Bool {
        return self.statusBarHidden
    }
    func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.statusBarStyle
    }
    func handleTap(_ gesture: UITapGestureRecognizer!) {
        if _shouldDismissOnTapOutside {
            var hide = _shouldDismissOnTapOutside

            for txt in _inputs {
                // Check if there is any keyboard on screen and dismiss
                if txt.editing {
                    txt.resignFirstResponder()
                    hide = false
                }
            }

            if hide {
                self.hideView()
            }
        }
    }
    func disableInteractivePopGesture() {
        var navigationController: UINavigationController!

        if _rootViewController?.isKindOfClass(UINavigationController.self) {
            navigationController = (_rootViewController as? UINavigationController)
        } else {
            navigationController = _rootViewController?.navigationController
        }

        // Disable iOS 7 back gesture
        if navigationController.responds(to: #selector(interactivePopGestureRecognizer())) {
            _restoreInteractivePopGestureEnabled = navigationController.interactivePopGestureRecognizer.enabled

            _restoreInteractivePopGestureDelegate = navigationController.interactivePopGestureRecognizer.delegate

            navigationController.interactivePopGestureRecognizer.enabled = false
            navigationController.interactivePopGestureRecognizer.delegate = self
        }
    }
    func restoreInteractivePopGesture() {
        var navigationController: UINavigationController!

        if _rootViewController?.isKindOfClass(UINavigationController.self) {
            navigationController = (_rootViewController as? UINavigationController)
        } else {
            navigationController = _rootViewController?.navigationController
        }

        // Restore iOS 7 back gesture
        if navigationController.responds(to: #selector(interactivePopGestureRecognizer())) {
            navigationController.interactivePopGestureRecognizer.enabled = _restoreInteractivePopGestureEnabled
            navigationController.interactivePopGestureRecognizer.delegate = _restoreInteractivePopGestureDelegate
        }
    }
    /** Set Title font family and size
 *
 * @param titleFontFamily The family name used to displayed the title.
 * @param size Font size.
 */
    func setTitleFontFamily(_ titleFontFamily: String!, withSize size: CGFloat) {
        self.titleFontFamily = titleFontFamily
        self.titleFontSize = size
        self.labelTitle.font = UIFont.fontWithName(_titleFontFamily, size: _titleFontSize)
    }
    /** Set Text field font family and size
 *
 * @param bodyTextFontFamily The family name used to displayed the text field.
 * @param size Font size.
 */
    func setBodyTextFontFamily(_ bodyTextFontFamily: String!, withSize size: CGFloat) {
        self.bodyTextFontFamily = bodyTextFontFamily
        self.bodyFontSize = size
        self.viewText.font = UIFont.fontWithName(_bodyTextFontFamily, size: _bodyFontSize)
    }
    /** Set Buttons font family and size
 *
 * @param buttonsFontFamily The family name used to displayed the buttons.
 * @param size Font size.
 */
    func setButtonsTextFontFamily(_ buttonsFontFamily: String!, withSize size: CGFloat) {
        self.buttonsFontFamily = buttonsFontFamily
        self.buttonsFontSize = size
    }
    func addActivityIndicatorView() {
        // Add UIActivityIndicatorView
        _activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge)
        _activityIndicatorView.frame = CGRect(x: kCircleHeight / 2 - kActivityIndicatorHeight / 2, y: kCircleHeight / 2 - kActivityIndicatorHeight / 2, width: kActivityIndicatorHeight, height: kActivityIndicatorHeight)
        _circleView.addSubview(_activityIndicatorView)
    }
    /** Add a custom UIView
 *
 * @param customView UIView object to be added above the first SCLButton.
 */
    func addCustomView(_ customView: UIView!) -> UIView! {
        // Update view height
        self.windowHeight += customView.bounds.size.height + 10.0
        _contentView.addSubview(customView)
        _customViews.add(customView)

        return customView
    }
    /** Add a switch view
 *
 * @param label The label displayed for the switch.
 */
    func addSwitchViewWithLabel(_ label: String!) -> SCLSwitchView {
        // Add switch view
        let switchView = SCLSwitchView(frame: CGRect(x: 0, y: 0, width: self.windowWidth, height: 31.0))

        // Update view height
        self.windowHeight += switchView.bounds.size.height + 10.0

        if label != nil {
            switchView.labelText = label
        }

        _contentView.addSubview(switchView)
        _inputs.add(switchView)

        return switchView
    }
    /** Add Text Field
 *
 * @param title The text displayed on the textfield.
 */
    func addTextField(_ title: String!) -> SCLTextView {
        self.addObservers()

        // Add text field
        let txt = SCLTextView()

        txt.font = UIFont.fontWithName(_bodyTextFontFamily, size: _bodyFontSize)
        txt.delegate = self
        // Update view height
        self.windowHeight += txt.bounds.size.height + 10.0

        if title != nil {
            txt.placeholder = title
        }

        _contentView.addSubview(txt)
        _inputs.add(txt)

        // If there are other fields in the inputs array, get the previous field and set the
        // return key type on that to next.
        if _inputs.count > 1 {
            let indexOfCurrentField = UInt(_inputs.index(of: txt))
            let priorField = _inputs[indexOfCurrentField - 1]

            priorField.returnKeyType = UIReturnKeyNext
        }

        return txt
    }
    /** Add a custom Text Field
 *
 * @param textField The custom textfield provided by the programmer.
 */
    func addCustomTextField(_ textField: UITextField!) {
        // Update view height
        self.windowHeight += textField.bounds.size.height + 10.0
        _contentView.addSubview(textField)
        _inputs.add(textField)

        // If there are other fields in the inputs array, get the previous field and set the
        // return key type on that to next.
        if _inputs.count > 1 {
            let indexOfCurrentField = UInt(_inputs.index(of: textField))
            let priorField = _inputs[indexOfCurrentField - 1]

            priorField.returnKeyType = UIReturnKeyNext
        }
    }
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        // If this is the last object in the inputs array, resign first responder
        // as the form is at the end.
        if textField == _inputs.lastObject {
            textField.resignFirstResponder()
        } else {
            // Otherwise find the next field and make it first responder.
            let indexOfCurrentField = UInt(_inputs.index(of: textField))
            let nextField = _inputs[indexOfCurrentField + 1]

            nextField.becomeFirstResponder()
        }

        return false
    }
    func keyboardWillShow(_ notification: Notification!) {
        if _keyboardIsVisible {
            return
        }

        UIView.animate(withDuration: 0.2) {
            var f = self.view.frame

            f.origin.y -= CGFloat(KEYBOARD_HEIGHT + PREDICTION_BAR_HEIGHT)
            self.view.frame = f
        }
        _keyboardIsVisible = true
    }
    func keyboardWillHide(_ notification: Notification!) {
        if !_keyboardIsVisible {
            return
        }

        UIView.animate(withDuration: 0.2) {
            var f = self.view.frame

            f.origin.y += CGFloat(KEYBOARD_HEIGHT + PREDICTION_BAR_HEIGHT)
            self.view.frame = f
        }
        _keyboardIsVisible = false
    }
    func addButton(_ title: String!) -> SCLButton {
        // Add button
        let btn = SCLButton(windowWidth: self.windowWidth)

        btn.layer.masksToBounds = true
        btn.setTitle(title, forState: UIControlStateNormal)
        btn.titleLabel.font = UIFont.fontWithName(_buttonsFontFamily, size: _buttonsFontSize)

        _contentView.addSubview(btn)

        _buttons.add(btn)

        if _horizontalButtons {
            // Update buttons width according to the number of buttons
            for bttn in _buttons {
                bttn.adjustWidthWithWindowWidth(self.windowWidth, numberOfButtons: _buttons.count())
            }

            // Update view height
            if !(_buttons.count > 1) {
                self.windowHeight += (btn.frame.size.height + ADD_BUTTON_PADDING)
            }
        } else {
            // Update view height
            self.windowHeight += (btn.frame.size.height + ADD_BUTTON_PADDING)
        }

        return btn
    }
    func addDoneButtonWithTitle(_ title: String!) -> SCLButton {
        let btn = self.addButton(title)

        if _completeButtonFormatBlock != nil {
            btn.completeButtonFormatBlock = _completeButtonFormatBlock
        }

        btn.addTarget(self, action: #selector(hideView()), for: UIControl.Event.touchUpInside)

        return btn
    }
    /** Add a Button with a title and a block to handle when the button is pressed.
 *
 * @param title The text displayed on the button.
 * @param action A block of code to be executed when the button is pressed.
 */
    func addButton(_ title: String!, actionBlock action: SCLActionBlock!) -> SCLButton {
        let btn = self.addButton(title)

        if _buttonFormatBlock != nil {
            btn.buttonFormatBlock = _buttonFormatBlock
        }

        btn.actionType = SCLActionType.SCLBlock
        btn.actionBlock = action
        btn.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControl.Event.touchUpInside)

        return btn
    }
    /** Add a Button with a title, a block to handle validation, and a block to handle when the button is pressed and validation succeeds.
 *
 * @param title The text displayed on the button.
 * @param validationBlock A block of code that will allow you to validate fields or do any other logic you may want to do to determine if the alert should be dismissed or not. Inside of this block, return a BOOL indicating whether or not the action block should be called and the alert dismissed.
 * @param action A block of code to be executed when the button is pressed and validation passes.
 */
    func addButton(_ title: String!, validationBlock: SCLValidationBlock!, actionBlock action: SCLActionBlock!) -> SCLButton {
        let btn = self.addButton(title, actionBlock: action)

        btn.validationBlock = validationBlock

        return btn
    }
    /** Add a Button with a title, a target and a selector to handle when the button is pressed.
 *
 * @param title The text displayed on the button.
 * @param target Add target for particular event.
 * @param selector A method to be executed when the button is pressed.
 */
    func addButton(_ title: String!, target: AnyObject!, selector: SEL) -> SCLButton {
        let btn = self.addButton(title)

        btn.actionType = SCLActionType.SCLSelector
        btn.target = target
        btn.selector = selector
        btn.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControl.Event.touchUpInside)

        return btn
    }
    func buttonTapped(_ btn: SCLButton!) {
        // Cancel Countdown timer
        buttonTimer.cancelTimer()

        // If the button has a validation block, and the validation block returns NO, validation
        // failed, so we should bail.
        if btn.validationBlock && !btn.validationBlock() {
            return
        }

        if btn.actionType == SCLActionType.SCLBlock {
            if btn.actionBlock {
                btn.actionBlock?()
            }
        } else if btn.actionType == SCLActionType.SCLSelector {
            let ctrl = UIControl()

            ctrl.sendAction(btn.selector, to: btn.target, forEvent: nil)
        } else {
            NSLog("Unknown action type for button")
        }

        if self.isVisible() {
            self.hideView()
        }
    }
    /** Add Timer Display
 *
 * @param buttonIndex The index of the button to add the timer display to.
 * @param reverse Convert timer to countdown.
 */
    func addTimerToButtonIndex(_ buttonIndex: Int, reverse: Bool) {
        buttonIndex = max(buttonIndex, 0)
        buttonIndex = min(buttonIndex, _buttons.count())

        buttonTimer = SCLTimerDisplay(origin: CGPoint(x: 5, y: 5), radius: 13, lineWidth: 4)
        buttonTimer.buttonIndex = buttonIndex
        buttonTimer.reverse = reverse
    }
    func showTitle(_ vc: UIViewController!, image: UIImage!, color: UIColor!, title: String!, subTitle: String!, duration: TimeInterval, completeText: String!, style: SCLAlertViewStyle) -> SCLAlertViewResponder! {
        if _usingNewWindow {
            self.backgroundView.frame = _SCLAlertWindow.bounds

            // Add window subview
            _SCLAlertWindow.rootViewController.addChildViewController(self)
            _SCLAlertWindow.rootViewController.view.addSubview(_backgroundView)
            _SCLAlertWindow.rootViewController.view.addSubview(self.view)
        } else {
            _rootViewController = vc

            self.disableInteractivePopGesture()

            self.backgroundView.frame = vc.view.bounds

            // Add view controller subviews
            _rootViewController?.addChildViewController(self)
            _rootViewController?.view.addSubview(_backgroundView)
            _rootViewController?.view.addSubview(self.view)
        }

        self.view.alpha = 0.0
        self.setBackground()

        // Alert color/icon
        var viewColor: UIColor!
        var iconImage: UIImage!

        // Icon style
        switch style {
        case SCLAlertViewStyle.SCLAlertViewStyleSuccess:
            viewColor = UIColorFromHEX(0x22b573)
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark
        case SCLAlertViewStyle.SCLAlertViewStyleError:
            viewColor = UIColorFromHEX(0xc1272d)
            iconImage = SCLAlertViewStyleKit.imageOfCross
        case SCLAlertViewStyle.SCLAlertViewStyleNotice:
            viewColor = UIColorFromHEX(0x727375)
            iconImage = SCLAlertViewStyleKit.imageOfNotice
        case SCLAlertViewStyle.SCLAlertViewStyleWarning:
            viewColor = UIColorFromHEX(0xffd110)
            iconImage = SCLAlertViewStyleKit.imageOfWarning
        case SCLAlertViewStyle.SCLAlertViewStyleInfo:
            viewColor = UIColorFromHEX(0x2866bf)
            iconImage = SCLAlertViewStyleKit.imageOfInfo
        case SCLAlertViewStyle.SCLAlertViewStyleEdit:
            viewColor = UIColorFromHEX(0xa429ff)
            iconImage = SCLAlertViewStyleKit.imageOfEdit
        case SCLAlertViewStyle.SCLAlertViewStyleWaiting:
            viewColor = UIColorFromHEX(0x6c125d)
        case SCLAlertViewStyle.SCLAlertViewStyleQuestion:
            viewColor = UIColorFromHEX(0x727375)
            iconImage = SCLAlertViewStyleKit.imageOfQuestion
        case SCLAlertViewStyle.SCLAlertViewStyleCustom:
            viewColor = color
            iconImage = image
            self.circleIconHeight *= 2.0
        default:
            break
        }

        // Custom Alert color
        if _customViewColor {
            viewColor = _customViewColor
        }

        // Title
        if title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).length > 0 {
            self.labelTitle.text = title

            // Adjust text view size, if necessary
            let sz = CGSize(width: _windowWidth - 24.0, height: CGFLOAT_MAX)
            let size = _labelTitle.sizeThatFits(sz)
            let ht = CGFloat(ceil(size.height))

            if ht > _titleHeight {
                self.windowHeight += (ht - _titleHeight)
                self.titleHeight = ht
                self.subTitleY += 20
            }
        } else {
            // Title is nil, we can move the body message to center and remove it from superView
            self.windowHeight -= _labelTitle.frame.size.height

            _labelTitle.removeFromSuperview()
            _labelTitle = nil

            _subTitleY = kCircleHeight - 20
        }

        // Subtitle
        if subTitle.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).length > 0 {
            // No custom text
            if _attributedFormatBlock == nil {
                _viewText.text = subTitle
            } else {
                self.viewText.font = UIFont.fontWithName(_bodyTextFontFamily, size: _bodyFontSize)
                _viewText.attributedText = self.attributedFormatBlock(subTitle)
            }

            // Adjust text view size, if necessary
            let sz = CGSize(width: _windowWidth - 24.0, height: CGFLOAT_MAX)
            let size = _viewText.sizeThatFits(sz)
            let ht = CGFloat(ceil(size.height))

            if ht < _subTitleHeight {
                self.windowHeight -= (_subTitleHeight - ht)
                self.subTitleHeight = ht
            } else {
                self.windowHeight += (ht - _subTitleHeight)
                self.subTitleHeight = ht
            }
        } else {
            // Subtitle is nil, we can move the title to center and remove it from superView
            self.subTitleHeight = 0.0

            self.windowHeight -= _viewText.frame.size.height

            _viewText.removeFromSuperview()
            _viewText = nil

            // Move up
            _labelTitle.frame = CGRect(x: 12.0, y: 37.0, width: _windowWidth - 24.0, height: _titleHeight)
        }

        if !_labelTitle && !_viewText {
            self.windowHeight -= kTitleTop
        }

        // Add button, if necessary
        if completeText != nil {
            self.addDoneButtonWithTitle(completeText)
        }

        // Alert view color and images
        self.circleView.backgroundColor = self.tintTopCircle ? viewColor : _backgroundViewColor

        if style == SCLAlertViewStyle.SCLAlertViewStyleWaiting {
            self.activityIndicatorView.startAnimating()
        } else {
            if self.iconTintColor {
                self.circleIconImageView.tintColor = self.iconTintColor
                iconImage = iconImage.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
            }

            self.circleIconImageView.image = iconImage
        }

        for textField in _inputs {
            textField.layer.borderColor = viewColor.cgColor
        }

        for btn in _buttons {
            if style == SCLAlertViewStyle.SCLAlertViewStyleWarning {
                btn.setTitleColor(UIColor.black, forState: UIControlStateNormal)
            }

            if !btn.defaultBackgroundColor {
                btn.defaultBackgroundColor = viewColor
            }

            if btn.completeButtonFormatBlock != nil {
                btn.parseConfig(btn.completeButtonFormatBlock())
            } else if btn.buttonFormatBlock != nil {
                btn.parseConfig(btn.buttonFormatBlock())
            }
        }

        // Adding duration
        if duration > 0 {
            durationTimer.invalidate()

            if buttonTimer && _buttons.count > 0 {
                var btn: SCLButton! = _buttons[buttonTimer.buttonIndex]

                btn.timer = buttonTimer

                let weakSelf = self

                buttonTimer.startTimerWithTimeLimit(duration) { () -> Void in
                    weakSelf.buttonTapped(btn)
                }
            } else {
                durationTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(hideView()), userInfo: nil, repeats: false)
            }
        }

        if _usingNewWindow {
            _SCLAlertWindow.makeKeyAndVisible()
        }

        // Show the alert view
        self.showView()

        // Chainable objects
        return SCLAlertViewResponder.alloc().init(self)
    }
    /** Show Success SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
    func showSuccess(_ vc: UIViewController!, title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(vc, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleSuccess)
    }
    /** Show Error SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
    func showError(_ vc: UIViewController!, title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(vc, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleError)
    }
    /** Show Notice SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
    func showNotice(_ vc: UIViewController!, title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(vc, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleNotice)
    }
    /** Show Warning SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
    func showWarning(_ vc: UIViewController!, title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(vc, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleWarning)
    }
    /** Show Info SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
    func showInfo(_ vc: UIViewController!, title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(vc, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleInfo)
    }
    /** Show Edit SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
    func showEdit(_ vc: UIViewController!, title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(vc, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleEdit)
    }
    /** Show Title SCLAlertView using a predefined type
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param style One of predefined SCLAlertView styles.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
    func showTitle(_ vc: UIViewController!, title: String!, subTitle: String!, style: SCLAlertViewStyle, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(vc, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: style)
    }
    /** Shows a custom SCLAlertView without using a predefined type, allowing for a custom image and color to be specified.
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param image A UIImage object to be used as the icon for the alert view.
 * @param color A UIColor object to be used to tint the background of the icon circle and the buttons.
 * @param title The title text of the alert view.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
    func showCustom(_ vc: UIViewController!, image: UIImage!, color: UIColor!, title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(vc, image: image, color: color, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleCustom)
    }
    /** Show Waiting SCLAlertView with UIActityIndicator.
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
    func showWaiting(_ vc: UIViewController!, title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.addActivityIndicatorView()
        self.showTitle(vc, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleWaiting)
    }
    /** Show Question SCLAlertView
 *
 * @param vc The view controller the alert view will be displayed in.
 * @param title The text displayed on the button.
 * @param subTitle The subtitle text of the alert view.
 * @param closeButtonTitle The text for the close button.
 * @param duration The amount of time the alert will remain on screen until it is automatically dismissed. If automatic dismissal is not desired, set to 0.
 */
    func showQuestion(_ vc: UIViewController!, title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(vc, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleQuestion)
    }
    func showSuccess(_ title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(nil, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleSuccess)
    }
    func showError(_ title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(nil, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleError)
    }
    func showNotice(_ title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(nil, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleNotice)
    }
    func showWarning(_ title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(nil, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleWarning)
    }
    func showInfo(_ title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(nil, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleInfo)
    }
    func showEdit(_ title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(nil, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleEdit)
    }
    func showTitle(_ title: String!, subTitle: String!, style: SCLAlertViewStyle, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(nil, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: style)
    }
    func showCustom(_ image: UIImage!, color: UIColor!, title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(nil, image: image, color: color, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleCustom)
    }
    func showWaiting(_ title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.addActivityIndicatorView()
        self.showTitle(nil, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleWaiting)
    }
    func showQuestion(_ title: String!, subTitle: String!, closeButtonTitle: String!, duration: TimeInterval) {
        self.showTitle(nil, image: nil, color: nil, title: title, subTitle: subTitle, duration: duration, completeText: closeButtonTitle, style: SCLAlertViewStyle.SCLAlertViewStyleQuestion)
    }
    /** Remove Top Circle
 *
 * Remove top circle from SCLAlertView.
 */
    func removeTopCircle() {
        _circleViewBackground.removeFromSuperview()
        _circleView.removeFromSuperview()
    }
    /** SCLAlertView visibility
 *
 * Returns if the alert is visible or not.
 */
    func isVisible() -> Bool {
        return self.view.alpha != 0
    }
    /** Warns that alerts is gone
 *
 * Warns that alerts is gone using block
 */
    func alertIsDismissed(_ dismissBlock: SCLDismissBlock!) {
        self.dismissBlock = dismissBlock
    }
    /** Warns that alerts dismiss animation is completed
 *
 * Warns that alerts dismiss animation is completed
 */
    func alertDismissAnimationIsCompleted(_ dismissAnimationCompletionBlock: SCLDismissAnimationCompletionBlock!) {
        self.dismissAnimationCompletionBlock = dismissAnimationCompletionBlock
    }
    /** Warns that alerts show animation is completed
 *
 * Warns that alerts show animation is completed
 */
    func alertShowAnimationIsCompleted(_ showAnimationCompletionBlock: SCLShowAnimationCompletionBlock!) {
        self.showAnimationCompletionBlock = showAnimationCompletionBlock
    }
    func forceHideBlock(_ forceHideBlock: SCLForceHideBlock!) -> SCLForceHideBlock! {
        _forceHideBlock = forceHideBlock

        if _forceHideBlock {
            self.hideView()
        }

        return _forceHideBlock
    }
    func mainScreenFrame() -> CGRect {
        return self.isAppExtension() ? _extensionBounds : UIApplication.sharedApplication().keyWindow.bounds
    }
    func isAppExtension() -> Bool {
        return NSBundle.mainBundle().executablePath.rangeOfString(".appex/").location != NSNotFound
    }
    func makeShadowBackground() {
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
        _backgroundView.backgroundColor = UIColor.black
        _backgroundView.alpha = 0.7

        _backgroundOpacity = 0.7
    }
    func makeBlurBackground() {
        let appView: UIView! = (_usingNewWindow) ? UIApplication.sharedApplication().keyWindow.subviews.lastObject : _rootViewController?.view
        let image = UIImage.convertViewToImage(appView)
        let blurSnapshotImage = image?.applyBlurWithRadius(5.0, tintColor: UIColor(white: 0.2, alpha: 0.7), saturationDeltaFactor: 1.8, maskImage: nil)

        _backgroundView.image = blurSnapshotImage
        _backgroundView.alpha = 0.0
        _backgroundOpacity = 1.0
    }
    func makeTransparentBackground() {
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
        _backgroundView.backgroundColor = UIColor.clear
        _backgroundView.alpha = 0.0

        _backgroundOpacity = 1.0
    }
    func setBackground() {
        switch _backgroundType {
        case SCLAlertViewBackground.SCLAlertViewBackgroundShadow:
            self.makeShadowBackground()
        case SCLAlertViewBackground.SCLAlertViewBackgroundBlur:
            self.makeBlurBackground()
        case SCLAlertViewBackground.SCLAlertViewBackgroundTransparent:
            self.makeTransparentBackground()
        default:
            break
        }
    }
    func showView() {
        switch _showAnimationType {
        case SCLAlertViewShowAnimation.SCLAlertViewShowAnimationFadeIn:
            self.fadeIn()
        case SCLAlertViewShowAnimation.SCLAlertViewShowAnimationSlideInFromBottom:
            self.slideInFromBottom()
        case SCLAlertViewShowAnimation.SCLAlertViewShowAnimationSlideInFromTop:
            self.slideInFromTop()
        case SCLAlertViewShowAnimation.SCLAlertViewShowAnimationSlideInFromLeft:
            self.slideInFromLeft()
        case SCLAlertViewShowAnimation.SCLAlertViewShowAnimationSlideInFromRight:
            self.slideInFromRight()
        case SCLAlertViewShowAnimation.SCLAlertViewShowAnimationSlideInFromCenter:
            self.slideInFromCenter()
        case SCLAlertViewShowAnimation.SCLAlertViewShowAnimationSlideInToCenter:
            self.slideInToCenter()
        case SCLAlertViewShowAnimation.SCLAlertViewShowAnimationSimplyAppear:
            self.simplyAppear()
        default:
            break
        }
    }
    /** Hide SCLAlertView
 *
 * Hide SCLAlertView using animation and removing from super view.
 */
    func hideView() {
        switch _hideAnimationType {
        case SCLAlertViewHideAnimation.SCLAlertViewHideAnimationFadeOut:
            self.fadeOut()
        case SCLAlertViewHideAnimation.SCLAlertViewHideAnimationSlideOutToBottom:
            self.slideOutToBottom()
        case SCLAlertViewHideAnimation.SCLAlertViewHideAnimationSlideOutToTop:
            self.slideOutToTop()
        case SCLAlertViewHideAnimation.SCLAlertViewHideAnimationSlideOutToLeft:
            self.slideOutToLeft()
        case SCLAlertViewHideAnimation.SCLAlertViewHideAnimationSlideOutToRight:
            self.slideOutToRight()
        case SCLAlertViewHideAnimation.SCLAlertViewHideAnimationSlideOutToCenter:
            self.slideOutToCenter()
        case SCLAlertViewHideAnimation.SCLAlertViewHideAnimationSlideOutFromCenter:
            self.slideOutFromCenter()
        case SCLAlertViewHideAnimation.SCLAlertViewHideAnimationSimplyDisappear:
            self.simplyDisappear()
        default:
            break
        }

        if _activityIndicatorView {
            _activityIndicatorView.stopAnimating()
        }

        if durationTimer {
            durationTimer.invalidate()
        }

        if self.dismissBlock {
            self.dismissBlock?()
        }

        if _usingNewWindow {
            // Restore previous window
            self.previousWindow.makeKeyAndVisible()
            self.previousWindow = nil
        }

        for btn in _buttons {
            btn.actionBlock = nil
            btn.target = nil
            btn.selector = nil
        }
    }
    func fadeOut() {
        self.fadeOutWithDuration(0.3)
    }
    func fadeOutWithDuration(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.backgroundView.alpha = 0.0
            self.view.alpha = 0.0
        }, completion: { (completed: Bool) -> Void in
            self.backgroundView.removeFromSuperview()
            self.view.removeFromSuperview()
            self.removeFromParentViewController()

            if self.usingNewWindow {
                // Remove current window
                self.SCLAlertWindow.setHidden(true)
                self.SCLAlertWindow = nil
            }

            if self.dismissAnimationCompletionBlock {
                self.dismissAnimationCompletionBlock?()
            }
        })
    }
    func slideOutToBottom() {
        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.view.frame

            frame.origin.y += (self.backgroundView.frame.size.height ?? 0.0)
            self.view.frame = frame
        }, completion: { (completed: Bool) -> Void in
            self.fadeOut()
        })
    }
    func slideOutToTop() {
        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.view.frame

            frame.origin.y -= (self.backgroundView.frame.size.height ?? 0.0)
            self.view.frame = frame
        }, completion: { (completed: Bool) -> Void in
            self.fadeOut()
        })
    }
    func slideOutToLeft() {
        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.view.frame

            frame.origin.x -= (self.backgroundView.frame.size.width ?? 0.0)
            self.view.frame = frame
        }, completion: { (completed: Bool) -> Void in
            self.fadeOut()
        })
    }
    func slideOutToRight() {
        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.view.frame

            frame.origin.x += (self.backgroundView.frame.size.width ?? 0.0)
            self.view.frame = frame
        }, completion: { (completed: Bool) -> Void in
            self.fadeOut()
        })
    }
    func slideOutToCenter() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(0.1, 0.1))
            self.view.alpha = 0.0
        }, completion: { (completed: Bool) -> Void in
            self.fadeOut()
        })
    }
    func slideOutFromCenter() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(3.0, 3.0))
            self.view.alpha = 0.0
        }, completion: { (completed: Bool) -> Void in
            self.fadeOut()
        })
    }
    func simplyDisappear() {
        self.backgroundView.alpha = self.backgroundOpacity
        self.view.alpha = 1.0
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.fadeOutWithDuration(0)
        }
    }
    func fadeIn() {
        self.backgroundView.alpha = 0.0
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.backgroundView.alpha = self.backgroundOpacity
            self.view.alpha = 1.0
        }, completion: { (finished: Bool) -> Void in
            if self.showAnimationCompletionBlock {
                self.showAnimationCompletionBlock?()
            }
        })
    }
    func slideInFromTop() {
        //From Frame
        var frame = self.backgroundView.frame ?? CGRect()

        frame.origin.y = -(self.backgroundView.frame.size.height ?? 0.0)
        self.view.frame = frame
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: 0, animations: { () -> Void in
            self.backgroundView.alpha = self.backgroundOpacity

            //To Frame
            var frame = self.backgroundView.frame ?? CGRect()

            frame.origin.y = 0.0
            self.view.frame = frame
            self.view.alpha = 1.0
        }, completion: { (finished: Bool) -> Void in
            if self.showAnimationCompletionBlock {
                self.showAnimationCompletionBlock?()
            }
        })
    }
    func slideInFromBottom() {
        //From Frame
        var frame = self.backgroundView.frame ?? CGRect()

        frame.origin.y = (self.backgroundView.frame.size.height ?? 0.0)
        self.view.frame = frame
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = self.backgroundOpacity

            //To Frame
            var frame = self.backgroundView.frame ?? CGRect()

            frame.origin.y = 0.0
            self.view.frame = frame
            self.view.alpha = 1.0
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.view.center = (self.backgroundView.center ?? CGPoint())
            }, completion: { (finished: Bool) -> Void in
                if self.showAnimationCompletionBlock {
                    self.showAnimationCompletionBlock?()
                }
            })
        })
    }
    func slideInFromLeft() {
        //From Frame
        var frame = self.backgroundView.frame ?? CGRect()

        frame.origin.x = -(self.backgroundView.frame.size.width ?? 0.0)
        self.view.frame = frame
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = self.backgroundOpacity

            //To Frame
            var frame = self.backgroundView.frame ?? CGRect()

            frame.origin.x = 0.0
            self.view.frame = frame
            self.view.alpha = 1.0
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.view.center = (self.backgroundView.center ?? CGPoint())
            }, completion: { (finished: Bool) -> Void in
                if self.showAnimationCompletionBlock {
                    self.showAnimationCompletionBlock?()
                }
            })
        })
    }
    func slideInFromRight() {
        //From Frame
        var frame = self.backgroundView.frame ?? CGRect()

        frame.origin.x = (self.backgroundView.frame.size.width ?? 0.0)
        self.view.frame = frame
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = self.backgroundOpacity

            //To Frame
            var frame = self.backgroundView.frame ?? CGRect()

            frame.origin.x = 0.0
            self.view.frame = frame
            self.view.alpha = 1.0
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.view.center = (self.backgroundView.center ?? CGPoint())
            }, completion: { (finished: Bool) -> Void in
                if self.showAnimationCompletionBlock {
                    self.showAnimationCompletionBlock?()
                }
            })
        })
    }
    func slideInFromCenter() {
        //From Frame
        self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(3.0, 3.0))
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = self.backgroundOpacity
            //To Frame
            self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0, 1.0))
            self.view.alpha = 1.0
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.view.center = (self.backgroundView.center ?? CGPoint())
            }, completion: { (finished: Bool) -> Void in
                if self.showAnimationCompletionBlock {
                    self.showAnimationCompletionBlock?()
                }
            })
        })
    }
    func slideInToCenter() {
        //From Frame
        self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(0.1, 0.1))
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = self.backgroundOpacity
            //To Frame
            self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0, 1.0))
            self.view.alpha = 1.0
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.view.center = (self.backgroundView.center ?? CGPoint())
            }, completion: { (finished: Bool) -> Void in
                if self.showAnimationCompletionBlock {
                    self.showAnimationCompletionBlock?()
                }
            })
        })
    }
    func simplyAppear() {
        self.backgroundView.alpha = 0.0
        self.view.alpha = 0.0
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.backgroundView.alpha = self.backgroundOpacity
            self.view.alpha = 1.0

            if self.showAnimationCompletionBlock {
                self.showAnimationCompletionBlock?()
            }
        }
    }
}
class SCLAlertViewBuilder__WithFluent: NSObject, SCLItemsBuilder__Protocol__Fluent {
    override init() {
        if self = super.init() {
            self.setupFluent()
        }

        return self
    }

    func setupFluent() {
    }
}
class SCLALertViewTextFieldBuilder: SCLAlertViewBuilder__WithFluent {
    weak var textField: SCLTextView?
    var title: ((String?) -> SCLALertViewTextFieldBuilder?)!
    var parameterTitle: String!

    func setupFluent() {
        weak var weakSelf = self

        self.title = { (title: String!) -> Void in
            weakSelf?.parameterTitle = title

            return weakSelf
        }
    }
}
class SCLALertViewButtonBuilder: SCLAlertViewBuilder__WithFluent {
    weak var button: SCLButton?
    var title: ((String?) -> SCLALertViewButtonBuilder?)!
    var target: ((AnyObject?) -> SCLALertViewButtonBuilder?)!
    var selector: ((SEL) -> SCLALertViewButtonBuilder?)!
    var actionBlock: (((() -> Void)?) -> SCLALertViewButtonBuilder?)!
    var validationBlock: (((() -> Bool)?) -> SCLALertViewButtonBuilder?)!
    var parameterTitle: String!
    weak var parameterTarget: AnyObject?
    var parameterSelector: SEL
    var parameterActionBlock: (() -> Void)!
    var parameterValidationBlock: (() -> Bool)!

    func setupFluent() {
        weak var weakSelf = self

        self.title = { (title: String!) -> Void in
            weakSelf?.parameterTitle = title

            return weakSelf
        }

        self.target = { (target: AnyObject!) -> Void in
            weakSelf?.parameterTarget = target

            return weakSelf
        }

        self.selector = { (selector: SEL) -> Void in
            weakSelf?.parameterSelector = selector

            return weakSelf
        }

        self.actionBlock = { (actionBlock: (() -> Void)!) -> Void in
            weakSelf?.parameterActionBlock = actionBlock

            return weakSelf
        }

        self.validationBlock = { (validationBlock: (() -> Bool)!) -> Void in
            weakSelf?.parameterValidationBlock = validationBlock

            return weakSelf
        }
    }
}
class SCLAlertViewBuilder: SCLAlertViewBuilder__WithFluent {
    var alertView: SCLAlertView!
    var cornerRadius: ((CGFloat) -> SCLAlertViewBuilder?)!
    var tintTopCircle: ((Bool) -> SCLAlertViewBuilder?)!
    var useLargerIcon: ((Bool) -> SCLAlertViewBuilder?)!
    var labelTitle: ((UILabel?) -> SCLAlertViewBuilder?)!
    var viewText: ((UITextView?) -> SCLAlertViewBuilder?)!
    var activityIndicatorView: ((UIActivityIndicatorView?) -> SCLAlertViewBuilder?)!
    var shouldDismissOnTapOutside: ((Bool) -> SCLAlertViewBuilder?)!
    var soundURL: ((URL?) -> SCLAlertViewBuilder?)!
    var attributedFormatBlock: ((SCLAttributedFormatBlock?) -> SCLAlertViewBuilder?)!
    var completeButtonFormatBlock: ((CompleteButtonFormatBlock?) -> SCLAlertViewBuilder?)!
    var buttonFormatBlock: ((ButtonFormatBlock?) -> SCLAlertViewBuilder?)!
    var forceHideBlock: ((SCLForceHideBlock?) -> SCLAlertViewBuilder?)!
    var hideAnimationType: ((SCLAlertViewHideAnimation) -> SCLAlertViewBuilder?)!
    var showAnimationType: ((SCLAlertViewShowAnimation) -> SCLAlertViewBuilder?)!
    var backgroundType: ((SCLAlertViewBackground) -> SCLAlertViewBuilder?)!
    var customViewColor: ((UIColor?) -> SCLAlertViewBuilder?)!
    var backgroundViewColor: ((UIColor?) -> SCLAlertViewBuilder?)!
    var iconTintColor: ((UIColor?) -> SCLAlertViewBuilder?)!
    var circleIconHeight: ((CGFloat) -> SCLAlertViewBuilder?)!
    var extensionBounds: ((CGRect) -> SCLAlertViewBuilder?)!
    var statusBarHidden: ((Bool) -> SCLAlertViewBuilder?)!
    var statusBarStyle: ((UIStatusBarStyle) -> SCLAlertViewBuilder?)!
    var alertIsDismissed: ((SCLDismissBlock?) -> SCLAlertViewBuilder?)!
    var alertDismissAnimationIsCompleted: ((SCLDismissAnimationCompletionBlock?) -> SCLAlertViewBuilder?)!
    var alertShowAnimationIsCompleted: ((SCLShowAnimationCompletionBlock?) -> SCLAlertViewBuilder?)!
    var removeTopCircle: (() -> SCLAlertViewBuilder?)!
    var addCustomView: ((UIView?) -> SCLAlertViewBuilder?)!
    var addTextField: ((String?) -> SCLAlertViewBuilder?)!
    var addCustomTextField: ((UITextField?) -> SCLAlertViewBuilder?)!
    var addSwitchViewWithLabelTitle: ((String?) -> SCLAlertViewBuilder?)!
    var addTimerToButtonIndex: ((Int, Bool) -> SCLAlertViewBuilder?)!
    var setTitleFontFamily: ((String?, CGFloat) -> SCLAlertViewBuilder?)!
    var setBodyTextFontFamily: ((String?, CGFloat) -> SCLAlertViewBuilder?)!
    var setButtonsTextFontFamily: ((String?, CGFloat) -> SCLAlertViewBuilder?)!
    var addButtonWithActionBlock: ((String?, SCLActionBlock?) -> SCLAlertViewBuilder?)!
    var addButtonWithValidationBlock: ((String?, SCLValidationBlock?, SCLActionBlock?) -> SCLAlertViewBuilder?)!
    var addButtonWithTarget: ((String?, AnyObject?, SEL) -> SCLAlertViewBuilder?)!
    var addButtonWithBuilder: ((SCLALertViewButtonBuilder?) -> SCLAlertViewBuilder?)!
    var addTextFieldWithBuilder: ((SCLALertViewTextFieldBuilder?) -> SCLAlertViewBuilder?)!

    override init() {
        self.alertView = SCLAlertView()
        super.init()
    }
    init(newWindowWidth width: CGFloat) {
        self.alertView = SCLAlertView(newWindowWidth: width)
        super.init()
    }

    func setupFluent() {
        weak var weakSelf = self

        self.cornerRadius = { (cornerRadius: CGFloat) -> Void in
            weakSelf?.alertView.cornerRadius = cornerRadius

            return weakSelf
        }

        self.tintTopCircle = { (tintTopCircle: Bool) -> Void in
            weakSelf?.alertView.tintTopCircle = tintTopCircle

            return weakSelf
        }

        self.useLargerIcon = { (useLargerIcon: Bool) -> Void in
            weakSelf?.alertView.useLargerIcon = useLargerIcon

            return weakSelf
        }

        self.labelTitle = { (labelTitle: UILabel!) -> Void in
            weakSelf?.alertView.labelTitle = labelTitle

            return weakSelf
        }

        self.viewText = { (viewText: UITextView!) -> Void in
            weakSelf?.alertView.viewText = viewText

            return weakSelf
        }

        self.activityIndicatorView = { (activityIndicatorView: UIActivityIndicatorView!) -> Void in
            weakSelf?.alertView.activityIndicatorView = activityIndicatorView

            return weakSelf
        }

        self.shouldDismissOnTapOutside = { (shouldDismissOnTapOutside: Bool) -> Void in
            weakSelf?.alertView.shouldDismissOnTapOutside = shouldDismissOnTapOutside

            return weakSelf
        }

        self.soundURL = { (soundURL: URL!) -> Void in
            weakSelf?.alertView.soundURL = soundURL

            return weakSelf
        }

        self.attributedFormatBlock = { (attributedFormatBlock: SCLAttributedFormatBlock) -> Void in
            weakSelf?.alertView.attributedFormatBlock = attributedFormatBlock

            return weakSelf
        }

        self.completeButtonFormatBlock = { (completeButtonFormatBlock: CompleteButtonFormatBlock) -> Void in
            weakSelf?.alertView.completeButtonFormatBlock = completeButtonFormatBlock

            return weakSelf
        }

        self.buttonFormatBlock = { (buttonFormatBlock: ButtonFormatBlock) -> Void in
            weakSelf?.alertView.buttonFormatBlock = buttonFormatBlock

            return weakSelf
        }

        self.forceHideBlock = { (forceHideBlock: SCLForceHideBlock) -> Void in
            weakSelf?.alertView.forceHideBlock = forceHideBlock

            return weakSelf
        }

        self.hideAnimationType = { (hideAnimationType: SCLAlertViewHideAnimation) -> Void in
            weakSelf?.alertView.hideAnimationType = hideAnimationType

            return weakSelf
        }

        self.showAnimationType = { (showAnimationType: SCLAlertViewShowAnimation) -> Void in
            weakSelf?.alertView.showAnimationType = showAnimationType

            return weakSelf
        }

        self.backgroundType = { (backgroundType: SCLAlertViewBackground) -> Void in
            weakSelf?.alertView.backgroundType = backgroundType

            return weakSelf
        }

        self.customViewColor = { (customViewColor: UIColor!) -> Void in
            weakSelf?.alertView.customViewColor = customViewColor

            return weakSelf
        }

        self.backgroundViewColor = { (backgroundViewColor: UIColor!) -> Void in
            weakSelf?.alertView.backgroundViewColor = backgroundViewColor

            return weakSelf
        }

        self.iconTintColor = { (iconTintColor: UIColor!) -> Void in
            weakSelf?.alertView.iconTintColor = iconTintColor

            return weakSelf
        }

        self.circleIconHeight = { (circleIconHeight: CGFloat) -> Void in
            weakSelf?.alertView.circleIconHeight = circleIconHeight

            return weakSelf
        }

        self.extensionBounds = { (extensionBounds: CGRect) -> Void in
            weakSelf?.alertView.extensionBounds = extensionBounds

            return weakSelf
        }

        self.statusBarHidden = { (statusBarHidden: Bool) -> Void in
            weakSelf?.alertView.statusBarHidden = statusBarHidden

            return weakSelf
        }

        self.statusBarStyle = { (statusBarStyle: UIStatusBarStyle) -> Void in
            weakSelf?.alertView.statusBarStyle = statusBarStyle

            return weakSelf
        }

        self.alertIsDismissed = { (dismissBlock: SCLDismissBlock) -> Void in
            weakSelf?.alertView.alertIsDismissed(dismissBlock)

            return weakSelf
        }

        self.alertDismissAnimationIsCompleted = { (dismissAnimationCompletionBlock: SCLDismissAnimationCompletionBlock) -> Void in
            weakSelf?.alertView.alertDismissAnimationIsCompleted(dismissAnimationCompletionBlock)

            return weakSelf
        }

        self.alertShowAnimationIsCompleted = { (showAnimationCompletionBlock: SCLShowAnimationCompletionBlock) -> Void in
            weakSelf?.alertView.alertShowAnimationIsCompleted(showAnimationCompletionBlock)

            return weakSelf
        }

        self.removeTopCircle = { (<unknown>: Void) -> Void in
            weakSelf?.alertView.removeTopCircle()

            return weakSelf
        }

        self.addCustomView = { (view: UIView!) -> Void in
            weakSelf?.alertView.addCustomView(view)

            return weakSelf
        }

        self.addTextField = { (title: String!) -> Void in
            weakSelf?.alertView.addTextField(title)

            return weakSelf
        }

        self.addCustomTextField = { (textField: UITextField!) -> Void in
            weakSelf?.alertView.addCustomTextField(textField)

            return weakSelf
        }

        self.addSwitchViewWithLabelTitle = { (title: String!) -> Void in
            weakSelf?.alertView.addSwitchViewWithLabel(title)

            return weakSelf
        }

        self.addTimerToButtonIndex = { (buttonIndex: Int, reverse: Bool) -> Void in
            weakSelf?.alertView.addTimerToButtonIndex(buttonIndex, reverse: reverse)

            return weakSelf
        }

        self.setTitleFontFamily = { (titleFontFamily: String!, size: CGFloat) -> Void in
            weakSelf?.alertView.setTitleFontFamily(titleFontFamily, withSize: size)

            return weakSelf
        }

        self.setBodyTextFontFamily = { (bodyTextFontFamily: String!, size: CGFloat) -> Void in
            weakSelf?.alertView.setBodyTextFontFamily(bodyTextFontFamily, withSize: size)

            return weakSelf
        }

        self.setButtonsTextFontFamily = { (buttonsFontFamily: String!, size: CGFloat) -> Void in
            weakSelf?.alertView.setButtonsTextFontFamily(buttonsFontFamily, withSize: size)

            return weakSelf
        }

        self.addButtonWithActionBlock = { (title: String!, action: SCLActionBlock) -> Void in
            weakSelf?.alertView.addButton(title, actionBlock: action)

            return weakSelf
        }

        self.addButtonWithValidationBlock = { (title: String!, validationBlock: SCLValidationBlock, action: SCLActionBlock) -> Void in
            weakSelf?.alertView.addButton(title, validationBlock: validationBlock, actionBlock: action)

            return weakSelf
        }

        self.addButtonWithTarget = { (title: String!, target: AnyObject!, selector: SEL) -> Void in
            weakSelf?.alertView.addButton(title, target: target, selector: selector)

            return weakSelf
        }

        self.addButtonWithBuilder = { (builder: SCLALertViewButtonBuilder!) -> Void in
            var button: SCLButton! = nil

            if (builder.parameterTarget != nil) && builder.parameterSelector {
                button = weakSelf?.alertView.addButton(builder.parameterTitle, target: builder.parameterTarget, selector: builder.parameterSelector)
            } else if builder.parameterValidationBlock && builder.parameterActionBlock {
                button = weakSelf?.alertView.addButton(builder.parameterTitle, validationBlock: builder.parameterValidationBlock, actionBlock: builder.parameterActionBlock)
            } else if builder.parameterActionBlock {
                button = weakSelf?.alertView.addButton(builder.parameterTitle, actionBlock: builder.parameterActionBlock)
            }

            builder.button = button

            return weakSelf
        }

        self.addTextFieldWithBuilder = { (builder: SCLALertViewTextFieldBuilder!) -> Void in
            builder.textField = weakSelf?.alertView.addTextField(builder.parameterTitle)

            return weakSelf
        }
    }
    func initWithNewWindow() -> SCLAlertViewBuilder {
        self = super.init()

        if self {
            self.alertView = SCLAlertView.alloc().initWithNewWindow()
        }

        return self
    }
}
class SCLAlertViewShowBuilder: SCLAlertViewBuilder__WithFluent {
    weak var parameterViewController: UIViewController?
    var parameterImage: UIImage!
    var parameterColor: UIColor!
    var parameterTitle: String!
    var parameterSubTitle: String!
    var parameterCompleteText: String!
    var parameterCloseButtonTitle: String!
    var parameterStyle: SCLAlertViewStyle = SCLAlertViewStyle.SCLAlertViewStyleSuccess
    var parameterDuration: TimeInterval
    var viewController: ((UIViewController?) -> SCLAlertViewShowBuilder?)!
    var image: ((UIImage?) -> SCLAlertViewShowBuilder?)!
    var color: ((UIColor?) -> SCLAlertViewShowBuilder?)!
    var title: ((String?) -> SCLAlertViewShowBuilder?)!
    var subTitle: ((String?) -> SCLAlertViewShowBuilder?)!
    var completeText: ((String?) -> SCLAlertViewShowBuilder?)!
    var style: ((SCLAlertViewStyle) -> SCLAlertViewShowBuilder?)!
    var closeButtonTitle: ((String?) -> SCLAlertViewShowBuilder?)!
    var duration: ((TimeInterval) -> SCLAlertViewShowBuilder?)!
    var show: ((SCLAlertView?, UIViewController?) -> Void)!

    func setupFluent() {
        weak var weakSelf = self

        self.viewController = { (viewController: UIViewController!) -> Void in
            weakSelf?.parameterViewController = viewController

            return weakSelf
        }

        self.image = { (image: UIImage!) -> Void in
            weakSelf?.parameterImage = image

            return weakSelf
        }

        self.color = { (color: UIColor!) -> Void in
            weakSelf?.parameterColor = color

            return weakSelf
        }

        self.title = { (title: String!) -> Void in
            weakSelf?.parameterTitle = title

            return weakSelf
        }

        self.subTitle = { (subTitle: String!) -> Void in
            weakSelf?.parameterSubTitle = subTitle

            return weakSelf
        }

        self.completeText = { (completeText: String!) -> Void in
            weakSelf?.parameterCompleteText = completeText

            return weakSelf
        }

        self.style = { (style: SCLAlertViewStyle) -> Void in
            weakSelf?.parameterStyle = style

            return weakSelf
        }

        self.closeButtonTitle = { (closeButtonTitle: String!) -> Void in
            weakSelf?.parameterCloseButtonTitle = closeButtonTitle

            return weakSelf
        }

        self.duration = { (duration: TimeInterval) -> Void in
            weakSelf?.parameterDuration = duration

            return weakSelf
        }

        self.show = { (view: SCLAlertView!, controller: UIViewController!) -> Void in
            weakSelf?.showAlertView(view, onViewController: controller)
        }
    }
    func showAlertView(_ alertView: SCLAlertView!) {
        self.showAlertView(alertView, onViewController: self.parameterViewController)
    }
    func showAlertView(_ alertView: SCLAlertView!, onViewController controller: UIViewController!) {
        let targetController: UIViewController! = controller ? controller : self.parameterViewController

        if self.parameterImage || self.parameterColor {
            alertView.showTitle(targetController, image: self.parameterImage, color: self.parameterColor, title: self.parameterTitle, subTitle: self.parameterSubTitle, duration: self.parameterDuration, completeText: self.parameterCloseButtonTitle, style: self.parameterStyle)
        } else {
            alertView.showTitle(targetController, title: self.parameterTitle, subTitle: self.parameterSubTitle, style: self.parameterStyle, closeButtonTitle: self.parameterCloseButtonTitle, duration: self.parameterDuration)
        }
    }
}

// MARK: -
//
//  SCLAlertView.m
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//
extension SCLAlertView: UITextFieldDelegate, UIGestureRecognizerDelegate {
    var inputs: NSMutableArray! {
        get {
            return self._inputs
        }
        set {
            self._inputs = newValue
        }
    }
    var customViews: NSMutableArray! {
        get {
            return self._customViews
        }
        set {
            self._customViews = newValue
        }
    }
    var buttons: NSMutableArray! {
        get {
            return self._buttons
        }
        set {
            self._buttons = newValue
        }
    }
    var circleIconImageView: UIImageView! {
        get {
            return self._circleIconImageView
        }
        set {
            self._circleIconImageView = newValue
        }
    }
    var circleView: UIView! {
        get {
            return self._circleView
        }
        set {
            self._circleView = newValue
        }
    }
    var circleViewBackground: UIView! {
        get {
            return self._circleViewBackground
        }
        set {
            self._circleViewBackground = newValue
        }
    }
    var contentView: UIView! {
        get {
            return self._contentView
        }
        set {
            self._contentView = newValue
        }
    }
    var backgroundView: UIImageView! {
        get {
            return self._backgroundView
        }
        set {
            self._backgroundView = newValue
        }
    }
    var gestureRecognizer: UITapGestureRecognizer! {
        get {
            return self._gestureRecognizer
        }
        set {
            self._gestureRecognizer = newValue
        }
    }
    var titleFontFamily: String! {
        get {
            return self._titleFontFamily
        }
        set {
            self._titleFontFamily = newValue
        }
    }
    var bodyTextFontFamily: String! {
        get {
            return self._bodyTextFontFamily
        }
        set {
            self._bodyTextFontFamily = newValue
        }
    }
    var buttonsFontFamily: String! {
        get {
            return self._buttonsFontFamily
        }
        set {
            self._buttonsFontFamily = newValue
        }
    }
    var SCLAlertWindow: UIWindow! {
        get {
            return self._SCLAlertWindow
        }
        set {
            self._SCLAlertWindow = newValue
        }
    }
    weak var rootViewController: UIViewController? {
        get {
            return self._rootViewController
        }
        set {
            self._rootViewController = newValue
        }
    }
    weak var restoreInteractivePopGestureDelegate: UIGestureRecognizerDelegate? {
        get {
            return self._restoreInteractivePopGestureDelegate
        }
        set {
            self._restoreInteractivePopGestureDelegate = newValue
        }
    }
    var soundID: SystemSoundID {
        get {
            return self._soundID
        }
        set {
            self._soundID = newValue
        }
    }
    var canAddObservers: Bool {
        get {
            return self._canAddObservers
        }
        set {
            self._canAddObservers = newValue
        }
    }
    var keyboardIsVisible: Bool {
        get {
            return self._keyboardIsVisible
        }
        set {
            self._keyboardIsVisible = newValue
        }
    }
    var usingNewWindow: Bool {
        get {
            return self._usingNewWindow
        }
        set {
            self._usingNewWindow = newValue
        }
    }
    var restoreInteractivePopGestureEnabled: Bool {
        get {
            return self._restoreInteractivePopGestureEnabled
        }
        set {
            self._restoreInteractivePopGestureEnabled = newValue
        }
    }
    var backgroundOpacity: CGFloat {
        get {
            return self._backgroundOpacity
        }
        set {
            self._backgroundOpacity = newValue
        }
    }
    var titleFontSize: CGFloat {
        get {
            return self._titleFontSize
        }
        set {
            self._titleFontSize = newValue
        }
    }
    var bodyFontSize: CGFloat {
        get {
            return self._bodyFontSize
        }
        set {
            self._bodyFontSize = newValue
        }
    }
    var buttonsFontSize: CGFloat {
        get {
            return self._buttonsFontSize
        }
        set {
            self._buttonsFontSize = newValue
        }
    }
    var windowHeight: CGFloat {
        get {
            return self._windowHeight
        }
        set {
            self._windowHeight = newValue
        }
    }
    var windowWidth: CGFloat {
        get {
            return self._windowWidth
        }
        set {
            self._windowWidth = newValue
        }
    }
    var titleHeight: CGFloat {
        get {
            return self._titleHeight
        }
        set {
            self._titleHeight = newValue
        }
    }
    var subTitleHeight: CGFloat {
        get {
            return _subTitleHeight
        }
        set(value) {
            _subTitleHeight = value
        }
    }
    var subTitleY: CGFloat {
        get {
            return self._subTitleY
        }
        set {
            self._subTitleY = newValue
        }
    }
}