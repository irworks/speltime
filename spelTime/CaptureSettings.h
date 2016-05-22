//
//  CaptureSettings.h
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaptureSettings : NSObject

@property int delay;
@property int timeUnit;

- (id)settingsWithDefaultValues;

@end
