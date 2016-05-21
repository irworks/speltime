//
//  CustomButton.m
//  spelTime
//
//  Created by Ilja Rozhko on 21.05.16.
//  Copyright © 2016 IR Works. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [self init];
    
    if(self) {
        [self setFrame:frame];
        [self setTitle:title forState:UIControlStateNormal];
        
        [self setDefaultValues];
    }
    
    return self;
}

- (void)setDefaultValues {
    [[self layer] setCornerRadius:5.0f];
    [self setBackgroundColor:BUTTON_BACKGROUND_COLOR];
    [self setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
