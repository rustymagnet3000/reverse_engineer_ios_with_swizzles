#include "swizzleHelper.h"
#import <WebKit/WebKit.h>

@implementation NSHTTPCookie (YDSwizzleWKCookieStore)
 
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(initWithProperties:);
        SEL swiz = @selector(YDinitWithProperties:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:"NSHTTPCookie" Original:orig Swizzle:swiz];
    });
}

- (instancetype)YDinitWithProperties:(NSDictionary<NSHTTPCookiePropertyKey, id> *)properties;{
    NSString *secureProperty = @"Secure";

    NSDictionary *updatedProperties = properties;
    if ([updatedProperties objectForKey:secureProperty]){
        NSString *name = [updatedProperties valueForKey:@"Name"];
         NSLog(@"🍭Secure Flag on Cookie: %@", name);
            // [updatedProperties setNilValueForKey:secureProperty];
            // NSLog(@"🍭\tModified Cookie Properties: %@", updatedProperties);
    }
    
    return [self YDinitWithProperties:(NSDictionary<NSHTTPCookiePropertyKey, id> *)updatedProperties];
}

@end
