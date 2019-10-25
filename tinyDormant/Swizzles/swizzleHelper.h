#ifndef swizzleHelper_h
#define swizzleHelper_h
#ifdef __OBJC__
    #import <Foundation/Foundation.h>
    #import <UIKit/UIKit.h>
    #include <objc/runtime.h>
#endif
#include "staticStrings.h"

@interface SwizzleHelper: NSObject {
    SEL originalSelector, replacementSelector;
    Class targetClass, targetSuperClass;
    Method originalMethod, swizzledMethod;
}
 
- (id) initWithTargets: (const char *)target Original:(SEL)orig Swizzle:(SEL)swiz;
- (NSString *) getDescription;

@end

#endif /* swizzleHelper_h */
