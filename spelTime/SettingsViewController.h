//
//  SettingsViewController.h
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import "CustomViewController.h"

@interface SettingsViewController : CustomViewController {
    UILabel *timeUnitLbl;
    CustomSegmentedControl *timeUnit;
    
    UILabel *timeValueLbl;
    UITextField *timeValue;
}

@end
