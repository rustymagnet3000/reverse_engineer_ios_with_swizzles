#include "swizzleHelper.h"

/*      Frequent hits inside in a big app        */

@implementation NSObject (YDSwizzleUILabel)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(setText:);
        SEL swiz = @selector(YDsetText:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:"UILabel" Original:orig Swizzle:swiz];
    });
}

- (void)YDsetText:(id)arg1{
    #pragma mark: arg1 is an NSString
    NSString *customStr = @"0000";
    
    #pragma mark: isEqualToString used as isKindOfClass not working as expected
    if ([NSStringFromClass([self superclass]) isEqualToString:NSStringFromClass([UIView class])]) {
        NSLog(@"\t🍭Swapped: %@\t For: %@", arg1, customStr);
        [self YDsetText:customStr];
        return;
    }
    
    NSLog(@"🍭%@\n\tsuper class:%@\n\tsuper super:%@", arg1, [self superclass],[[self superclass] superclass]);
    [self YDsetText:arg1];
}

@end
