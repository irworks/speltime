//
//  CustomTextField.m
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self setDefaultValues];
    
    return  self;
}

- (void)setDefaultValues {
    [self setBorderStyle:UITextBorderStyleRoundedRect];
    [self setTintColor:BUTTON_BACKGROUND_COLOR];
}

@end
