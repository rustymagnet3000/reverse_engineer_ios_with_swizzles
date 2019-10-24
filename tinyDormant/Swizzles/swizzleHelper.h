#ifndef swizzleHelper_h
#define swizzleHelper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <objc/runtime.h>
#include "staticStrings.h"

@interface SwizzleHelper: NSObject

@property (readwrite) SEL originalSelector, replacementSelector;
@property (readwrite) Class targetClass, targetSuperClass;
@property (readwrite) Method originalMethod, swizzledMethod;
 
- (id) initWithTargets: (const char *)target Original:(SEL)orig Swizzle:(SEL)swiz;
- (NSString *) getDescription;

@end

#endif /* swizzleHelper_h */
