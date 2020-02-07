#include "swizzleHelper.h"
#import <Foundation/Foundation.h>


@implementation NSObject (YDSwizzleSwiftInstMethod)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        const char *target = "tinyDormant.YDJediVC";

        SEL orig = @selector(wonderfullyWeirdWithLaugh:cry:);
        SEL swiz = @selector(YDwonderfullyWeirdWithLaugh:cry:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:target Original:orig Swizzle:swiz];
    });
}

- (void)YDwonderfullyWeirdWithLaugh:(int)num cry:(id)str{
    
    NSLog(@"🍭YDwonderfullyWeird %@", str);
}

@end
