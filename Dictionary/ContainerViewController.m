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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Add a navigation view to fill the screen until the first definition is shown
    
// This code installs a view contoller withing the UINavigationController, so we can set a title. Decided not to do this for now, just more noise.
//   UIViewController *placeholderViewController = [[UIViewController alloc] init];
//   placeholderViewController.title = @"Compact Dictionary";
//   UINavigationController *placeholder = [[UINavigationController alloc] initWithRootViewController:placeholderViewController];
    
    UINavigationController *placeholder = [[UINavigationController alloc] init];
    [self addChildViewController:placeholder];
    placeholder.view.frame = self.view.bounds;
    [self.view addSubview:placeholder.view];
    [placeholder didMoveToParentViewController:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end


