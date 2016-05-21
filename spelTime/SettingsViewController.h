//
//  SettingsViewController.h
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import "CustomViewController.h"

@interface SettingsViewController : CustomViewController {
    
    NSArray *timeUnitStrings;
    
    UILabel *timeUnitLbl;
    CustomSegmentedControl *timeUnit;
    
    UILabel *timeValueLbl;
    CustomTextField *timeValue;
}

@end
