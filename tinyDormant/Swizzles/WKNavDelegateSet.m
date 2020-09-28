#include "swizzleHelper.h"
#include "YDNavDel.h"
#import "YDplistReader.h"

/*  The Target for class this swizzle is WKWebView.  It is not myapp.MyWKViewController. */

@interface Foobar : NSObject
@property (class) YDNavDel *hotDel;
@end

@implementation Foobar
static YDNavDel *_hotDel;
+ (YDNavDel *)hotDel { return _hotDel; }
+ (void)setHotDel:(YDNavDel *)newHotDel { _hotDel = newHotDel; }
@end

@implementation NSObject (YDswizzleSetNavDelegate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(setNavigationDelegate:);
        SEL swiz= @selector(YDsetNavigationDelegate:);
        
        NSString *plistName = @"YDTargetClasses";
        YDNavDel *customDel = [[YDNavDel alloc] init];
        [Foobar setHotDel:customDel];

        YDplistReader *myplist = [[YDplistReader alloc] initWithPlistName:plistName];
        NSArray *targets = [myplist arrayOfDictsFromPlist];
        
        [targets enumerateObjectsUsingBlock:^(id  _Nonnull targetName, NSUInteger idx, BOOL * _Nonnull stop) {

            NSString *target = [targetName description];
            
            if ([target isKindOfClass:[NSString class]])
            {
                NSLog(@"🍭Target class: %s", [target UTF8String]);
                __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:[target UTF8String] Original:orig Swizzle:swiz];
            }
        }];
    });
}

- (void)YDsetNavigationDelegate:(id)originalDelegate {
    NSLog(@"🍭setNavigationDelegate called from:%@", self);
    NSLog(@"🍭Swapping out:\n\t\tOLD:%@\n\t\tNEW:%@", [originalDelegate self], [Foobar hotDel]);
    [self YDsetNavigationDelegate:[Foobar hotDel]];
    #pragma mark NULL also works: [self YDsetNavigationDelegate:NULL];
}

@end
