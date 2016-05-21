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
    
    [self buildUI];
}

- (void)buildUI {
    [self setTitle:APP_NAME];
    
    UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(openSettings:)];
    self.navigationItem.rightBarButtonItem = settingsBtn;
    
    [self addUiToMainScrollView:previewView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, self.view.frame.size.width, 300)]];
    [self addUiToMainScrollView:framesStatus = [[UILabel alloc] initWithFrame:CGRectMake(UI_HORIZONTAL_MARGIN, yPos, self.view.frame.size.width-UI_HORIZONTAL_MARGIN*2, 25)]];
    [framesStatus setAdjustsFontSizeToFitWidth:YES];
    [framesStatus setTextAlignment:NSTextAlignmentCenter];
    
    [self addUiToMainScrollView:[[CustomButton alloc] initWithFrame:CGRectMake(UI_HORIZONTAL_MARGIN, yPos, self.view.frame.size.width-UI_HORIZONTAL_MARGIN*2, BUTTON_HEIGHT) title:@"Start Capture"]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewTouched:)];
    [singleTap setNumberOfTapsRequired:1];
    
    [previewView setUserInteractionEnabled:YES];
    [previewView addGestureRecognizer:singleTap];
    
    [self takePhotos];
}

- (void)viewDidAppear:(BOOL)animated {
    long fps = [[self captureSettings] fpt];
    
    switch([[self captureSettings] timeUnit]) {
        case 1:
            fps /= 60;
            break;
        case 2:
            fps /= 60;
            fps /= 24;
            break;
    }
}

- (void)previewTouched:(id)sender {
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

- (void)takePhotos {
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
}

- (void)openSettings:(id)sender {
    [self openViewControllerWithName:@"SettingsViewController"];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    droppedFrames++;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    //UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    // Add your code here that uses the image.
    dispatch_async(dispatch_get_main_queue(), ^{
        capturedFrames++;
        double dropPercentage = round((double)droppedFrames / (double)(droppedFrames+capturedFrames) * 100);
        [framesStatus setText:[NSString stringWithFormat:@"Frames: %ld | Dropped: %ld (%.2f%%)", capturedFrames, droppedFrames, dropPercentage]];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
