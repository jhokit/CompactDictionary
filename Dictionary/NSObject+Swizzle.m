#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)


//------------------------------------------------------------------------------
// swizzle in a replacement method to an existing class
//------------------------------------------------------------------------------
+ (void) swizzleInstanceSelector:(SEL)originalSelector
                 withNewSelector:(SEL)newSelector
{
  Method originalMethod = class_getInstanceMethod(self, originalSelector);
  Method newMethod = class_getInstanceMethod(self, newSelector);

  BOOL methodAdded = class_addMethod([self class],
                                     originalSelector,
                                     method_getImplementation(newMethod),
                                     method_getTypeEncoding(newMethod));
  
  if (methodAdded) {
    class_replaceMethod([self class], 
                        newSelector, 
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, newMethod);
  }
}

@end
