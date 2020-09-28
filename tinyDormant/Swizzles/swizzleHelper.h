#ifndef swizzleHelper_h
#define swizzleHelper_h
#ifdef __OBJC__
    #include <Foundation/Foundation.h>
    #include <UIKit/UIKit.h>
    #include <objc/runtime.h>
    #include <WebKit/WebKit.h>
#endif
#include "staticStrings.h"

@protocol SwizzleRules <NSObject>
@required
- (BOOL) checkClassExists;
- (BOOL) getMethodPointers;
- (BOOL) swapMethods;
- (BOOL) verifySwap;
@end


@interface SwizzleHelper: NSObject <SwizzleRules> {
    const char *rawTargetClass;
    SEL originalSelector, replacementSelector;
    Class targetClass, targetSuperClass;
    Method originalMethod, swizzledMethod;
}
 
- (id) initWithTargets: (const char *)target Original:(SEL)orig Swizzle:(SEL)swiz;
- (NSString *) getDescription;

@end

#endif /* swizzleHelper_h */
