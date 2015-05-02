//
//  AppDelegate.m
//  Dictionary
//
//  Created by Jeff Hokit on 10/20/13.
//  Copyright (c) 2013 Jeff Hokit. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+AppColors.h"

@implementation AppDelegate

//------------------------------------------------------------------------------
// For iPad get a reference to the ContainerViewConroller, which we use
// to hold instances of the UIReferenceViewController
//------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        splitViewController.delegate = self;
        _containerViewController = [splitViewController.viewControllers lastObject];
    }

    // Set the whole app tint color to our signature red, but many specific controls using the same red as *bartintcolor* will changet the tintColor to white
    self.window.tintColor = [UIColor dictionaryRed];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//------------------------------------------------------------------------------
// In this delegate method make sure that both parts of the split view
// remain onscreen
//------------------------------------------------------------------------------
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}


@end
