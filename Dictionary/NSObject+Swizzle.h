#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

+ (void)swizzleInstanceSelector:(SEL)originalSelector 
                withNewSelector:(SEL)newSelector;

@end