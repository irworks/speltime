//
//  CustomViewController.m
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    yPos = 0;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [mainScrollView setScrollsToTop:YES];
    [mainScrollView setBackgroundColor:WHITE_COLOR];
    
    [self.view addSubview:mainScrollView];

}

- (void)addUiToMainScrollView:(UIView *)view {
    
    [view setFrame:CGRectMake(view.frame.origin.x, yPos, view.frame.size.width, view.frame.size.height)];
    yPos += view.frame.size.height + UI_VERTICAL_MARGIN;
    
    [mainScrollView addSubview:view];
    
    [mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width, yPos)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldFinished:(id)sender {
    [sender resignFirstResponder];
}

- (void)openViewControllerWithName:(NSString *)name {
    CustomViewController *nextViewController;
    
    @try {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:name];
    }
    @catch (NSException *exception) {
        
        if ([name isEqualToString:@"ViewController"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self showUIAlertWithTitle:@"Error" message:@"The requested View is not available."];
        }
        
        return;
    }
    @finally {
        nextViewController.captureSettings = [self captureSettings];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

- (void)showUIAlertWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
