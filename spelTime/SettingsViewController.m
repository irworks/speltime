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
    
    timeUnitStrings = [NSArray arrayWithObjects:@"Second", @"Minute", @"Hour", nil];
    
    [self buildUI];
}

- (void)buildUI {
    [self setTitle:@"Settings"];
    
    yPos = UI_HORIZONTAL_MARGIN;
    
    NSLog(@"Loadded FPT: %d", [captureSettings delay]);
    
    timeUnitLbl = [self addTitleLabel:@"Time unit:"];
    
    [self addUiToMainScrollView:timeUnit = [[CustomSegmentedControl alloc] initWithFrameAndItem:CGRectMake(UI_HORIZONTAL_MARGIN, yPos, FULL_WIDTH, 40) items:timeUnitStrings]];
    [timeUnit addTarget:self action:@selector(changedTimeUnit:) forControlEvents:UIControlEventValueChanged];
    
    if([[self captureSettings] timeUnit] < [timeUnitStrings count]) {
        [timeUnit setSelectedSegmentIndex:[[self captureSettings] timeUnit]];
    }
    
    timeValueLbl = [self addTitleLabel:@""];
    [self updateTimeValueLbl];
    [self addUiToMainScrollView:timeValue = [[CustomTextField alloc] initWithFrame:CGRectMake(UI_HORIZONTAL_MARGIN, yPos, FULL_WIDTH, 40)]];
    [timeValue setText:[NSString stringWithFormat:@"%d", [captureSettings delay]]];
    [timeValue setKeyboardType:UIKeyboardTypeNumberPad];
    
    UIToolbar *keyboardOverlay = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [keyboardOverlay setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeTimeValue:)],
                            nil]];
    
    [timeValue setInputAccessoryView:keyboardOverlay];
    
}

- (void)closeTimeValue:(id)sender {
    
    if([[timeValue text] intValue] <= 0) {
        [self showUIAlertWithTitle:APP_NAME message:@"Please enter a valid number. (number > 0)"];
        [timeValue setText:[NSString stringWithFormat:@"%d", [captureSettings delay]]];
    }
    
    [timeValue resignFirstResponder];
}

- (UILabel *)addTitleLabel:(NSString *)title {
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(UI_HORIZONTAL_MARGIN, yPos, self.view.frame.size.width-UI_HORIZONTAL_MARGIN*2, 15)];
    
    [titleLbl setText:title];
    [titleLbl setFont:[UIFont systemFontOfSize:13]];
    
    [self addUiToMainScrollView:titleLbl];
    
    yPos -= UI_HORIZONTAL_MARGIN/2;
    
    return titleLbl;
}

- (void)changedTimeUnit:(UISegmentedControl *)segment {
    [self updateTimeValueLbl];
}

- (void)updateTimeValueLbl {
    [timeValueLbl setText:[NSString stringWithFormat:@"Delay between pictues (in %@s):", [timeUnitStrings objectAtIndex:timeUnit.selectedSegmentIndex]]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self captureSettings] setDelay:[[timeValue text] intValue]];
    [[self captureSettings] setTimeUnit:(int)timeUnit.selectedSegmentIndex];
    [[self captureSettings] save];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
