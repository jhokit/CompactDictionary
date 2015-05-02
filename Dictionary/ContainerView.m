//
//  ContainerView.m
//  Dictionary
//
//  Created by Jeff Hokit on 10/27/13.
//  Copyright (c) 2013 Jeff Hokit. All rights reserved.
//

#import "ContainerView.h"

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// A do-nothing placeholder class that is here for breakpoints and possible
// future use
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

@implementation ContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)addSubview:(UIView *)view
{
    [super addSubview:view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
