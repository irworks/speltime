//
//  CaptureSettings.m
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import "CaptureSettings.h"

@implementation CaptureSettings
@synthesize delay, timeUnit;

- (id)settingsWithDefaultValues {
    delay    = 10;
    timeUnit = 0;
    
    /* 
     timeUnit:
        0 = seconds
        1 = minutes
        2 = hours
     */
    
    return self;
}

- (void)save {
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setInteger:delay forKey:@"delay"];
    [userDefaults setInteger:timeUnit forKey:@"timeUnit"];
}

- (void)load {
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults integerForKey:@"delay"] <= 0) {
        return;
    }
    
    delay    = [userDefaults integerForKey:@"delay"];
    timeUnit = [userDefaults integerForKey:@"timeUnit"];
}

@end
