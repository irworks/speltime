//
//  SettingsViewController.m
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize captureSettings;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}

- (void)buildUI {
    [self setTitle:@"Settings"];
    
    yPos = UI_HORIZONTAL_MARGIN;
    
    NSLog(@"Loadded FPT: %ld", [captureSettings fpt]);
    
    timeUnitLbl = [self addTitleLabel:@"Time unit:"];
    
    [self addUiToMainScrollView:timeUnit = [[CustomSegmentedControl alloc] initWithFrameAndItem:CGRectMake(UI_HORIZONTAL_MARGIN, yPos, FULL_WIDTH, 40) items:[NSArray arrayWithObjects:@"Second", @"Minute", @"Hour", nil]]];
    
    timeValueLbl = [self addTitleLabel:@"Take a picture every"];
    [self addUiToMainScrollView:timeValue = [[UITextField alloc] initWithFrame:CGRectMake(UI_HORIZONTAL_MARGIN, yPos, FULL_WIDTH, 40)]];
    
}

- (UILabel *)addTitleLabel:(NSString *)title {
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(UI_HORIZONTAL_MARGIN, yPos, self.view.frame.size.width-UI_HORIZONTAL_MARGIN*2, 15)];
    
    [titleLbl setText:title];
    [titleLbl setFont:[UIFont systemFontOfSize:13]];
    
    [self addUiToMainScrollView:titleLbl];
    
    yPos -= UI_HORIZONTAL_MARGIN/2;
    
    return titleLbl;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
