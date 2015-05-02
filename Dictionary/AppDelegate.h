//
//  AppDelegate.h
//  Dictionary
//
//  Created by Jeff Hokit on 10/20/13.
//  Copyright (c) 2013 Jeff Hokit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ContainerViewController *containerViewController;

@end
