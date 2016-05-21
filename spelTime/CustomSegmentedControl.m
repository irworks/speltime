//
//  CustomSegmentedControl.m
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import "CustomSegmentedControl.h"

@implementation CustomSegmentedControl

- (id)initWithFrameAndItem:(CGRect)newFrame items:(NSArray *)items {
    self = [super initWithItems:items];
    self.frame = newFrame;
    
    [self setDefaultValues];
    
    return self;
}

- (void)setDefaultValues {
    [[self layer] setCornerRadius:5.0f];
    [self setTintColor:BUTTON_BACKGROUND_COLOR];
    [self setSelectedSegmentIndex:0];
}


@end
