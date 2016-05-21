//
//  ViewController.h
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomViewController.h"

@interface ViewController : CustomViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *session;
    AVCaptureDevice *captureDevice;
    
    UILabel *framesStatus;
    UIView *previewView;
    
    long capturedFrames;
    long droppedFrames;
}


@end

