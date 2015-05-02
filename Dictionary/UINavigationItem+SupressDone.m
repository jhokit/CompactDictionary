//
//  UINavigationItem+SupressDone.h
//  Dictionary
//
//  Created by Jeff Hokit on 10/27/13.
//  Copyright (c) 2013 Jeff Hokit. All rights reserved.
//

#import "UINavigationItem+SupressDone.h"
#import "NSObject+Swizzle.h"

@implementation UINavigationItem (SupressDone)


//------------------------------------------------------------------------------
// Patch the UIReferenceLibraryViewController to hide the done button
//  when it is presented in our containter view.
//
// By patching UINavigationItem we're able to intercept when it's being
// added to the bar.
//
// Could not simply search for and hide the done button, as it is repeatedly
// added and removed as navigation proceeds within UIReferenceLibraryViewController
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// For all instances of UINavigationItem, substitute (swizzle) in our implementation
// of setRightBarButtonItem:animated:
//------------------------------------------------------------------------------
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setRightBarButtonItem:animated:)
                      withNewSelector:@selector(nuSetRightBarButtonItem:animated:)];
    });
}


//------------------------------------------------------------------------------
// Our implementation is looking for the use of a UINavigationItem within
// a UIReferenceLibraryViewController
//------------------------------------------------------------------------------
- (void)nuSetRightBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    // call the old implementation, now under the new message signature
    [self nuSetRightBarButtonItem:item animated:animated];
    
    // on iPad only
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        // if the target of the button item being added is a UIReferenceLibraryViewController,
        // thus assuring us that we've found the correct UIBarButtonItem
        if ([item.target isKindOfClass:[UIReferenceLibraryViewController class]])
        {
            // Set the title to a null string as a way of hiding it.
            // UIBarButtonItem does not have a isHidden or alpha property, more common ways to hide
            item.title = @"";
        }
    }
}

@end
