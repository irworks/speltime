//
//  CustomViewController.h
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import "const.h"
#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "CustomSegmentedControl.h"
#import "CustomTextField.h"
#import "CaptureSettings.h"

#define FULL_WIDTH self.view.frame.size.width-UI_HORIZONTAL_MARGIN*2

@interface CustomViewController : UIViewController<UINavigationControllerDelegate> {
    UIScrollView *mainScrollView;
    float yPos;
}

@property (strong, nonatomic) CaptureSettings *captureSettings;

- (void)addUiToMainScrollView:(UIView *)view;
- (void)openViewControllerWithName:(NSString *)name;
- (IBAction)textFieldFinished:(id)sender;

@end
