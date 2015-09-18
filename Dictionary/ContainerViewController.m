//
//  ContainerViewController.m
//  Dictionary
//
//  Created by Jeff Hokit on 10/27/13.
//  Copyright (c) 2013 Jeff Hokit. All rights reserved.
//

#import "ContainerViewController.h"


@implementation ContainerViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

//------------------------------------------------------------------------------
// Add a navigation view to fill the screen until the first definition is shown
//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Add a navigation view to fill the screen until the first definition is shown
    UINavigationController *placeholder = [[UINavigationController alloc] init];
    [self addChildViewController:placeholder];
    placeholder.view.frame = self.view.bounds;
    [self.view addSubview:placeholder.view];
    [placeholder didMoveToParentViewController:self];
}






@end


