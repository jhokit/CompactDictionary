//
//  UINavigationBar+Tint.m
//  Dictionary
//
//  Created by Jeff Hokit on 12/1/13.
//  Copyright (c) 2013 Jeff Hokit. All rights reserved.
//

#import "UINavigationBar+Tint.h"
#import "NSObject+Swizzle.h"
#import "UIColor+AppColors.h"

@implementation UINavigationBar (Tint)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setDelegate:)
                      withNewSelector:@selector(nuSetDelegate:)];
    });
}

-(void)nuSetDelegate:(id)delegate
{
    [self nuSetDelegate:delegate];
    [self setBarTintColor:[UIColor dictionaryRed]];
    [self setTintColor:[UIColor whiteColor]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor dictionaryGold]} ];
}

@end
