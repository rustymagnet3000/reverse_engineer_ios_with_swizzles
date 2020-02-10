#include "swizzleHelper.h"

/*      Frequent output in a big app        */

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
    id view = [self superclass];
    NSLog(@"🍭view class: %@", [view class]);
    if([view isMemberOfClass:[UIView class]]) {
        NSLog(@"🍭isMemberOfClass: %@", [view class]);
        NSLog(@"🍭%@", arg1);
        [self YDsetText:customStr];
    }
    else {
        NSLog(@"\t🍭%@", arg1);
        [self YDsetText:arg1];
    }
}

@end
