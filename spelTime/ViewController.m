//
//  ViewController.m
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize captureSettings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setCaptureSettings:[[CaptureSettings alloc] settingsWithDefaultValues]];
    saveMode = NO;
    
    [self buildUI];
    [self checkPermissions];
}

- (void)buildUI {
    [self setTitle:APP_NAME];
    
    UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(openSettings:)];
    self.navigationItem.rightBarButtonItem = settingsBtn;
    
    [self addUiToMainScrollView:previewView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, self.view.frame.size.width, 300)]];
    [self addUiToMainScrollView:framesStatus = [[UILabel alloc] initWithFrame:CGRectMake(UI_HORIZONTAL_MARGIN, yPos, self.view.frame.size.width-UI_HORIZONTAL_MARGIN*2, 25)]];
    [framesStatus setAdjustsFontSizeToFitWidth:YES];
    [framesStatus setTextAlignment:NSTextAlignmentCenter];
    
    [self addUiToMainScrollView:toggleCaptureButton = [[CustomButton alloc] initWithFrame:CGRectMake(UI_HORIZONTAL_MARGIN, yPos, self.view.frame.size.width-UI_HORIZONTAL_MARGIN*2, BUTTON_HEIGHT) title:@"Start Capture"]];
    [toggleCaptureButton addTarget:self action:@selector(toggleCapture:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewTouched:)];
    [singleTap setNumberOfTapsRequired:1];
    
    [previewView setUserInteractionEnabled:YES];
    [previewView addGestureRecognizer:singleTap];
}

- (void)checkPermissions {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if(granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startPreview];
            });
        }else{
            [self showUIAlertWithTitle:APP_NAME message:[NSString stringWithFormat:@"%@ needs to have access to your camera to work properly. Please grant the permission and restart the application.", APP_NAME]];
        }
    }];
}

- (void)toggleCapture:(id)sender {
    saveMode = !saveMode;
    droppedFrames = 0;
    capturedFrames = 0;
    
    if(saveMode) {
        [toggleCaptureButton setTitle:@"Stop Capture" forState:UIControlStateNormal];
        
        long frameEvery = [[self captureSettings] delay];
        
        switch([[self captureSettings] timeUnit]) {
            case 1:
                frameEvery *= 60;
                break;
            case 2:
                frameEvery = 60 * 60 * frameEvery;
                break;
        }
        
        mainTimer = [NSTimer scheduledTimerWithTimeInterval:frameEvery target:self selector:@selector(timerFireEvent:) userInfo:nil repeats:YES];
        [self stopSession:nil];
        
    }else{
        
        if(mainTimer != nil) {
            [mainTimer invalidate];
        }
        
        [toggleCaptureButton setTitle:@"Start Capture" forState:UIControlStateNormal];
    }
    
    [self resetFramerate:nil];
}

- (void)timerFireEvent:(id)sender {
    if(![session isRunning]) {
        [session startRunning];
    }
}

- (void)stopSession:(id)sender {
    if([session isRunning]) {
        [session stopRunning];
    }
}

- (void)previewTouched:(id)sender {
    if(![session isRunning]){
        [session startRunning];
    }
    [self setPreviewFrameRate:15];
    
    [self performSelector:@selector(resetFramerate:) withObject:nil afterDelay:10.0f];
}

- (void)resetFramerate:(id)sender {
    [self setPreviewFrameRate:1];
}

- (void)setPreviewFrameRate:(int)fps {
    [captureDevice lockForConfiguration:nil];
    [captureDevice setActiveVideoMinFrameDuration:CMTimeMake(1, fps)];
    [captureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1, fps)];
    [captureDevice unlockForConfiguration];
}

- (void)startPreview {
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];

    if([session canAddInput:input]) {
        NSLog(@"Adding input: %@", input);
        [session addInput:input];
    }
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL)];

    [output setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    if([session canAddOutput:output]) {
        NSLog(@"Adding output: %@", output);
        [session addOutput:output];
    }
    
    NSLog(@"Error: %@", [error localizedDescription]);
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    previewLayer.backgroundColor = [[UIColor blackColor] CGColor];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    CALayer *rootLayer = [previewView layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:previewLayer];
    
    [session startRunning];
    [self previewTouched:nil];
}

- (void)openSettings:(id)sender {
    [self openViewControllerWithName:@"SettingsViewController"];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    droppedFrames++;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    if(saveMode) {
        NSLog(@"Saving frame...");
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self stopSession:nil];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        capturedFrames++;
        double dropPercentage = round((double)droppedFrames / (double)(droppedFrames+capturedFrames) * 100);
        [framesStatus setText:[NSString stringWithFormat:@"Frames: %ld | Dropped: %ld (%.2f%%)", capturedFrames, droppedFrames, dropPercentage]];
    });
}


/* FROM: https://developer.apple.com/library/ios/qa/qa1702/_index.html */
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
