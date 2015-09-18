//
//  ContainerViewController.h
//  Dictionary
//
//  Created by Jeff Hokit on 10/27/13.
//  Copyright (c) 2013 Jeff Hokit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface ContainerViewController : UIViewController

@property (strong, nonatomic) IBOutlet SearchViewController *searchViewController;

@end
