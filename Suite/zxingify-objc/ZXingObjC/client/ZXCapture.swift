import AVFoundation
import ImageIO

// Preprocessor directives found in file:
// #import <AVFoundation/AVFoundation.h>
// #if defined(__MAC_10_12) && __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_12 || defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// #endif
// #import <ImageIO/ImageIO.h>
// #import "ZXBinaryBitmap.h"
// #import "ZXCapture.h"
// #import "ZXCaptureDelegate.h"
// #import "ZXCGImageLuminanceSource.h"
// #import "ZXDecodeHints.h"
// #import "ZXHybridBinarizer.h"
// #import "ZXReader.h"
// #import "ZXResult.h"
// #pragma mark - Property Getters
// #pragma mark - Property Setters
// #pragma mark - Back, Front, Torch
// #pragma mark - Binary
// #pragma mark - Luminance
// #pragma mark - Start, Stop
// #pragma mark - CAAction
// #pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
// #pragma mark - Private
// #if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
// #endif
/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
@objc
class ZXCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, CAAction {
    private var _captureDeviceIndex: CInt = 0
    private var _captureQueue: dispatch_queue_t
    private var _hardStop: Bool = false
    private var _layer: AVCaptureVideoPreviewLayer!
    private var _orderInSkip: CInt = 0
    private var _orderOutSkip: CInt = 0
    private var _onScreen: Bool = false
    private var _output: AVCaptureVideoDataOutput!
    private var _running: Bool = false
    private var _session: AVCaptureSession!
    private var _heuristic: Bool = false
    private var _parallelQueue: dispatch_queue_t
    private var _camera: CInt = 0
    private weak var _delegate: ZXCaptureDelegate?
    private var _focusMode: AVCaptureFocusMode
    private var _hints: ZXDecodeHints!
    private var _lastScannedImage: CGImageRef
    private var _mirror: Bool = false
    private var _reader: ZXReader!
    private var _rotation: CGFloat = 0.0
    private var _scanRect: CGRect = CGRect()
    private var _torch: Bool = false
    private var _transform: CGAffineTransform
    private var _captureFramesPerSec: CGFloat = 0.0
    @objc var camera: CInt {
        get {
            return _camera
        }
        set(camera) {
            if _camera != camera {
                _camera = camera

                self.captureDeviceIndex = 1

                self.captureDevice = nil

                self.replaceInput()
            }
        }
    }
    @objc var captureDevice: AVCaptureDevice!
    @objc var captureToFilename: String!
    @objc weak var delegate: ZXCaptureDelegate? {
        get {
            return _delegate
        }
        set(delegate) {
            _delegate = delegate

            if delegate != nil {
                self.hardStop = false
            }

            self.startStop()
        }
    }
    @objc var focusMode: AVCaptureFocusMode {
        get {
            return _focusMode
        }
        set(focusMode) {
            if self.input.device.isFocusModeSupported(focusMode) && self.input.device.focusMode != focusMode {
                _focusMode = focusMode

                self.input.device.lockForConfiguration(nil)
                self.input.device.focusMode = focusMode
                self.input.device.unlockForConfiguration()
            }
        }
    }
    @objc var hints: ZXDecodeHints! {
        get {
            return self._hints
        }
        set {
            self._hints = newValue
        }
    }
    @objc var lastScannedImage: CGImageRef {
        get {
            return _lastScannedImage
        }
        set(lastScannedImage) {
            if _lastScannedImage {
                CGImageRelease(_lastScannedImage)
            }

            if lastScannedImage {
                CGImageRetain(lastScannedImage)
            }

            _lastScannedImage = lastScannedImage
        }
    }
    @objc var invert: Bool = false
    @objc var layer: CALayer! {
        var layer = _layer as? AVCaptureVideoPreviewLayer

        if !_layer {
            layer = AVCaptureVideoPreviewLayer(session: self.session)
            layer?.affineTransform = self.transform
            layer?.delegate = self
            layer?.videoGravity = AVLayerVideoGravityResizeAspectFill

            _layer = layer
        }

        return layer
    }
    @objc var mirror: Bool {
        get {
            return _mirror
        }
        set(mirror) {
            if _mirror != mirror {
                _mirror = mirror

                if self.layer {
                    var transform = self.transform

                    transform.a = -transform.a
                    self.transform = transform
                    self.layer.setAffineTransform(self.transform)
                }
            }
        }
    }
    @objc var output: AVCaptureVideoDataOutput! {
        if !_output {
            _output = AVCaptureVideoDataOutput()
            _output.setVideoSettings([kCVPixelBufferPixelFormatTypeKey as? String: NSNumber.numberWithUnsignedInt(kCVPixelFormatType_32BGRA)])
            _output.setAlwaysDiscardsLateVideoFrames(true)
            _output.setSampleBufferDelegate(self, queue: _captureQueue)

            self.session.addOutput(_output)
        }

        return _output
    }
    @objc var reader: ZXReader! {
        get {
            return self._reader
        }
        set {
            self._reader = newValue
        }
    }
    @objc var rotation: CGFloat {
        get {
            return self._rotation
        }
        set {
            self._rotation = newValue
        }
    }
    @objc var running: Bool {
        return self._running
    }
    @objc var scanRect: CGRect {
        get {
            return self._scanRect
        }
        set {
            self._scanRect = newValue
        }
    }
    @objc var sessionPreset: String!
    @objc var torch: Bool {
        get {
            return _torch
        }
        set(torch) {
            _torch = torch
            self.input.device.lockForConfiguration(nil)

            let torchMode: AVCaptureTorchMode = self.torch ? AVCaptureTorchModeOn : AVCaptureTorchModeOff

            if self.input.device.isTorchModeSupported(torchMode) {
                self.input.device.torchMode = torchMode
            }

            self.input.device.unlockForConfiguration()
        }
    }
    @objc var transform: CGAffineTransform {
        get {
            return _transform
        }
        set(transform) {
            _transform = transform
            self.layer.setAffineTransform(transform)
        }
    }
    @objc var captureFramesPerSec: CGFloat {
        get {
            return self._captureFramesPerSec
        }
        set {
            self._captureFramesPerSec = newValue
        }
    }
    @objc var binaryLayer: CALayer!
    @objc var cameraIsReady: Bool = false
    @objc var input: AVCaptureDeviceInput!
    @objc var luminanceLayer: CALayer!

    @objc
    override init() {
        if self = super.init() {
            _captureDeviceIndex = 1

            _captureQueue = dispatch_queue_create("com.zxing.captureQueue", nil)

            _focusMode = AVCaptureFocusModeContinuousAutoFocus

            _hardStop = false

            _hints = ZXDecodeHints.hints()

            _lastScannedImage = nil

            _onScreen = false

            _orderInSkip = 0

            _orderOutSkip = 0

            _captureFramesPerSec = 3.0

            if NSClassFromString("ZXMultiFormatReader") {
                _reader = NSClassFromString("ZXMultiFormatReader").performSelector(#selector(reader()))
            }

            _rotation = 0.0

            _running = false

            _transform = CGAffineTransformIdentity

            _scanRect = CGRect.zero
        }

        return self
    }

    deinit {
        if _lastScannedImage {
            CGImageRelease(_lastScannedImage)
        }

        if _session && _session.inputs {
            for input in _session.inputs {
                _session.removeInput(input)
            }
        }

        if _session && _session.outputs {
            for output in _session.outputs {
                _session.removeOutput(output)
            }
        }
    }

    /**
 * This enables `ZXCapture` to try additional heuristics to decode
 * the barcode.
 *
 * @see `ZXCGImageLuminanceSourceInfo`
 * Currently: make the grayscale image darker to process
 */
    /**
 * This enables `ZXCapture` to try additional heuristics to decode
 * the barcode.
 *
 * @see `ZXCGImageLuminanceSourceInfo`
 * Currently: make the grayscale image darker to process
 */
    @objc
    func enableHeuristic() {
        if _heuristic {
            return
        }

        _heuristic = true
        _parallelQueue = dispatch_queue_create("com.zxing.parallelQueue", DISPATCH_QUEUE_CONCURRENT)
    }
    @objc
    func back() -> CInt {
        return 1
    }
    @objc
    func front() -> CInt {
        return 0
    }
    @objc
    func hasFront() -> Bool {
        let captureDeviceDiscoverySession: AVCaptureDeviceDiscoverySession! = AVCaptureDeviceDiscoverySession.discoverySessionWithDeviceTypes([AVCaptureDeviceTypeBuiltInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePositionFront)
        let devices: NSArray! = captureDeviceDiscoverySession.devices()

        return devices.count > 0
    }
    @objc
    func hasBack() -> Bool {
        let captureDeviceDiscoverySession: AVCaptureDeviceDiscoverySession! = AVCaptureDeviceDiscoverySession.discoverySessionWithDeviceTypes([AVCaptureDeviceTypeBuiltInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePositionBack)
        let devices: NSArray! = captureDeviceDiscoverySession.devices()

        return devices.count > 0
    }
    @objc
    func hasTorch() -> Bool {
        if self.device() {
            return self.device().hasTorch
        } else {
            return false
        }
    }
    @objc
    func binary() -> CALayer? {
        return self.binaryLayer
    }
    @objc
    func setBinary(_ on: Bool) {
        if on && !self.binaryLayer {
            self.binaryLayer = CALayer.layer()
        } else if !on && self.binaryLayer {
            self.binaryLayer = nil
        }
    }
    @objc
    func luminance() -> CALayer? {
        return self.luminanceLayer
    }
    @objc
    func setLuminance(_ on: Bool) {
        if on && !self.luminanceLayer {
            self.luminanceLayer = CALayer.layer()
        } else if !on && self.luminanceLayer {
            self.luminanceLayer = nil
        }
    }
    @objc
    func hard_stop() {
        self.hardStop = true

        if self.running {
            self.stop()
        }
    }
    @objc
    func order_skip() {
        self.orderInSkip = 1
        self.orderOutSkip = 1
    }
    @objc
    func start() {
        if self.hardStop {
            return
        }

        if (self.delegate != nil) || self.luminanceLayer || self.binaryLayer {
            self.output as? Void
        }

        if !self.session.running {
            var i: CInt = 0

            if i += 1 == 2 {
                abort()
            }

            self.session.startRunning()
        }

        self.running = true
    }
    @objc
    func stop() {
        if !self.running {
            return
        }

        if self.session.running {
            self.session.stopRunning()
        }

        self.running = false
    }
    @objc
    func actionForLayer(_ _layer: CALayer!, forKey event: String!) -> CAAction? {
        CATransaction.setValue(NSNumber.numberWithFloat(0.0), forKey: kCATransactionAnimationDuration)

        if event == kCAOnOrderIn || event == kCAOnOrderOut {
            return self
        }

        return nil
    }
    @objc
    func runActionForKey(_ key: String!, object anObject: AnyObject!, arguments dict: NSDictionary!) {
        if key == kCAOnOrderIn {
            if self.orderInSkip != 0 {
                self.orderInSkip -= 1

                return
            }

            self.onScreen = true
            self.startStop()
        } else if key == kCAOnOrderOut {
            if self.orderOutSkip != 0 {
                self.orderOutSkip -= 1

                return
            }

            self.onScreen = false
            self.startStop()
        }
    }
    @objc
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBufferRef, fromConnection connection: AVCaptureConnection!) {
        if !self.running {
            return
        }

        autoreleasepool { () -> Void in
            if !self.cameraIsReady {
                self.cameraIsReady = true

                if self.delegate?.responds(to: #selector(captureCameraIsReady(_:))) == true {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.delegate?.captureCameraIsReady?(self)
                    }
                }
            }

            if !self.captureToFilename && !self.luminanceLayer && !self.binaryLayer && (self.delegate == nil) {
                return
            }

            // reduce CPU usage by around 30%, reference: https://github.com/TheLevelUp/ZXingObjC/issues/314
            // Default capture 3 frames per second or customize them. if you want lower CPU usage, can adjust captureFramesPerSec to 1.0f make a better performace.
            let kMinMargin: CFloat = CFloat(1.0 / _captureFramesPerSec)
            // Gets the timestamp for each frame.
            let presentTimeStamp: CMTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            var curFrameTimeStamp: CDouble = 0
            var lastFrameTimeStamp: CDouble = 0

            curFrameTimeStamp = CDouble(presentTimeStamp.value) / presentTimeStamp.timescale

            if curFrameTimeStamp - lastFrameTimeStamp > kMinMargin {
                lastFrameTimeStamp = curFrameTimeStamp

                let videoFrame: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)
                let videoFrameImage = ZXCGImageLuminanceSource.createImageFromBuffer(videoFrame)

                self.decodeImage(videoFrameImage)
            }
        }
    }
    @objc
    func decodeImage(_ image: CGImageRef) {
        // If scanRect is set, crop the current image to include only the desired rect
        if !self.scanRect.isEmpty {
            let croppedImage: CGImageRef = CGImageCreateWithImageInRect(image, self.scanRect)

            CGImageRelease(image)
            image = croppedImage
        }

        let rotatedImage = self.createRotatedImage(image, degrees: CFloat(self.rotation))

        CGImageRelease(image)
        self.lastScannedImage = rotatedImage

        if self.captureToFilename {
            let url: URL! = URL.fileURLWithPath(self.captureToFilename)
            let dest: CGImageDestinationRef = CGImageDestinationCreateWithURL(url as? CFURLRef, "public.png" as? CFStringRef, 1, nil)

            CGImageDestinationAddImage(dest, rotatedImage, nil)

            CGImageDestinationFinalize(dest)

            CFRelease(dest)

            self.captureToFilename = nil
        }

        if _heuristic {
            self.decodeImageAdv(rotatedImage)
        }

        let source = ZXCGImageLuminanceSource(cGImage: rotatedImage)

        CGImageRelease(rotatedImage)

        if self.luminanceLayer {
            var image = source.image

            CGImageRetain(image)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue()) { () -> Void in
                self.luminanceLayer.contents = image as? AnyObject
                CGImageRelease(image)
            }
        }

        if !self.binaryLayer && (self.delegate == nil) {
            return
        }

        let binarizer = ZXHybridBinarizer(source: source)

        if self.binaryLayer {
            var image = binarizer.createImage()

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue()) { () -> Void in
                self.binaryLayer.contents = image as? AnyObject
                CGImageRelease(image)
            }
        }

        if self.delegate != nil {
            let bitmap = ZXBinaryBitmap(binarizer: binarizer)
            var error: Error!
            let result = self.reader.decode(bitmap, hints: self.hints, error: &error)

            if result != nil {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.delegate?.captureResult(self, result: result)
                }

                return
            }
        }

        // Try decoding inverted image
        if self.binaryLayer || (self.delegate != nil) {
            let invertedBinarizer = ZXHybridBinarizer(source: source.invert())

            if self.binaryLayer {
                var image = invertedBinarizer.createImage()

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue()) { () -> Void in
                    self.binaryLayer.contents = image as? AnyObject
                    CGImageRelease(image)
                }
            }

            if self.delegate != nil {
                let bitmap = ZXBinaryBitmap(binarizer: invertedBinarizer)
                var error: Error!
                let result = self.reader.decode(bitmap, hints: self.hints, error: &error)

                if result != nil {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.delegate?.captureResult(self, result: result)
                    }
                }
            }
        }
    }
    /**
 * This function try to make the grayscale image darker to process
 */
    @objc
    func decodeImageAdv(_ cgImage: CGImageRef) {
        let img: CGImageRef = CGImageCreateCopy(cgImage)

        dispatch_async(_parallelQueue) { () -> Void in
            let sourceInfo: ZXCGImageLuminanceSourceInfo! = ZXCGImageLuminanceSourceInfo.alloc().initWithDecomposingMin()
            let source = ZXCGImageLuminanceSource(cGImage: img, sourceInfo: sourceInfo)

            CGImageRelease(img)

            let binarizer = ZXHybridBinarizer(source: source)
            let bitmap = ZXBinaryBitmap(binarizer: binarizer)
            var error: Error!
            let result = self.reader.decode(bitmap, hints: self.hints, error: &error)

            if (result != nil) && (self.delegate?.responds(to: #selector(captureResult(_:result:))) == true) {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.delegate?.captureResult(self, result: result)
                }
            }
        }
    }
    // Adapted from http://blog.coriolis.ch/2009/09/04/arbitrary-rotation-of-a-cgimage/ and https://github.com/JanX2/CreateRotateWriteCGImage
    @objc
    func createRotatedImage(_ original: CGImageRef, degrees: CFloat) -> CGImageRef {
        if degrees == 0.0 {
            CGImageRetain(original)

            return original
        } else {
            let radians: CDouble = degrees * M_PI / 180
            let _width: size_t = CGImageGetWidth(original)
            let _height: size_t = CGImageGetHeight(original)
            let imgRect = CGRect(x: 0, y: 0, width: _width, height: _height)
            let __transform: CGAffineTransform = CGAffineTransformMakeRotation(radians)
            let rotatedRect: CGRect = CGRectApplyAffineTransform(imgRect, __transform)
            let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
            let context: CGContextRef = CGBitmapContextCreate(nil, rotatedRect.size.width, rotatedRect.size.height, CGImageGetBitsPerComponent(original), 0, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst)

            context.setAllowsAntialiasing(FALSE)
            context.setInterpolationQuality(kCGInterpolationNone)

            CGColorSpaceRelease(colorSpace)

            context.translateBy(x: +(rotatedRect.size.width / 2), y: +(rotatedRect.size.height / 2))
            context.rotate(by: radians)
            context.draw(original, in: CGRect(x: -imgRect.size.width / 2, y: -imgRect.size.height / 2, width: imgRect.size.width, height: imgRect.size.height))

            let rotatedImage: CGImageRef = CGBitmapContextCreateImage(context)

            CFRelease(context)

            return rotatedImage
        }
    }
    @objc
    func device() -> AVCaptureDevice? {
        if self.captureDevice {
            return self.captureDevice
        }

        var zxd: AVCaptureDevice! = nil
        let captureDeviceDiscoverySession: AVCaptureDeviceDiscoverySession! = AVCaptureDeviceDiscoverySession.discoverySessionWithDeviceTypes([AVCaptureDeviceTypeBuiltInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePositionUnspecified)
        let devices: NSArray! = captureDeviceDiscoverySession.devices()

        if devices.count > 0 {
            if self.captureDeviceIndex == 1 {
                var position: AVCaptureDevicePosition = AVCaptureDevicePositionBack

                if self.camera == self.front {
                    position = AVCaptureDevicePositionFront
                }

                var i: CUnsignedInt = 0

                while i < devices.count {
                    defer {
                        i += 1
                    }

                    let dev: AVCaptureDevice = devices.object(at: Int(i))

                    if dev.position == position {
                        self.captureDeviceIndex = CInt(i)
                        zxd = dev

                        break
                    }
                }
            }

            if (zxd == nil) && self.captureDeviceIndex != 1 {
                zxd = devices.object(at: Int(self.captureDeviceIndex))
            }
        }

        if zxd == nil {
            zxd = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        }

        self.captureDevice = zxd

        return zxd
    }
    @objc
    func replaceInput() {
        self.session.beginConfiguration()

        if self.session && self.input {
            self.session.removeInput(self.input)
            self.input = nil
        }

        let zxd = self.device()

        if zxd != nil {
            self.input = AVCaptureDeviceInput.deviceInputWithDevice(zxd, error: nil)
            self.focusMode = self.focusMode
        }

        if self.input {
            if !self.sessionPreset {
                self.sessionPreset = AVCaptureSessionPreset1280x720
            }

            self.session.sessionPreset = self.sessionPreset
            self.session.addInput(self.input)
        }

        self.session.commitConfiguration()
    }
    @objc
    func session() -> AVCaptureSession? {
        if !_session {
            _session = AVCaptureSession()
            self.replaceInput()
        }

        return _session
    }
    @objc
    func startStop() {
        if (!self.running && ((self.delegate != nil) || self.onScreen)) || (!self.output && ((self.delegate != nil) || (self.onScreen && (self.luminanceLayer || self.binaryLayer)))) {
            self.start()
        }

        if self.running && (self.delegate == nil) && !self.onScreen {
            self.stop()
        }
    }
}

// MARK: -
/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
@objc
extension ZXCapture {
    @objc var captureDeviceIndex: CInt {
        get {
            return self._captureDeviceIndex
        }
        set {
            self._captureDeviceIndex = newValue
        }
    }
    @objc var captureQueue: dispatch_queue_t {
        get {
            return self._captureQueue
        }
        set {
            self._captureQueue = newValue
        }
    }
    @objc var hardStop: Bool {
        get {
            return self._hardStop
        }
        set {
            self._hardStop = newValue
        }
    }
    @objc var layer: AVCaptureVideoPreviewLayer! {
        get {
            return self._layer
        }
        set {
            self._layer = newValue
        }
    }
    @objc var orderInSkip: CInt {
        get {
            return self._orderInSkip
        }
        set {
            self._orderInSkip = newValue
        }
    }
    @objc var orderOutSkip: CInt {
        get {
            return self._orderOutSkip
        }
        set {
            self._orderOutSkip = newValue
        }
    }
    @objc var onScreen: Bool {
        get {
            return self._onScreen
        }
        set {
            self._onScreen = newValue
        }
    }
    @objc var output: AVCaptureVideoDataOutput! {
        get {
            return self._output
        }
        set {
            self._output = newValue
        }
    }
    @objc var running: Bool {
        get {
            return self._running
        }
        set {
            self._running = newValue
        }
    }
    @objc var session: AVCaptureSession! {
        get {
            return self._session
        }
        set {
            self._session = newValue
        }
    }
    @objc var heuristic: Bool {
        get {
            return self._heuristic
        }
        set {
            self._heuristic = newValue
        }
    }
    @objc var parallelQueue: dispatch_queue_t {
        get {
            return self._parallelQueue
        }
        set {
            self._parallelQueue = newValue
        }
    }
}