#include "swizzleHelper.h"

// if you swizzle on UIViewController, viewDidAppear() is invoked twice
@implementation UITabBarController (SwizzleTB)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        const char* rawTarget = "UITabBarController";
        SEL orig = @selector(viewWillAppear:);
        SEL swiz = @selector(YDviewWillAppear:);
        
        SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:rawTarget Original:orig Swizzle:swiz];

        if (swizzle != NULL){
            NSLog(@"%@", [swizzle getDescription]);
        }
    });
}

#pragma mark - Method Swizzle - alter TabBar and add/remove View Controllers

- (void)YDviewWillAppear:(BOOL)animated {
  
    NSLog(@"🍭viewWillAppear called from: %@ || Superclass %@", self, [self superclass]);
    Class sithVcClass = objc_getClass(dormantClassStr);
    id sithvc = class_createInstance(sithVcClass, 0);
    NSLog(@"🍭Created instance of: %@ at: %p", [sithvc class], sithvc);
    
    NSMutableArray *arrayofvc = (NSMutableArray *)[self viewControllers];
    [arrayofvc addObject:sithvc];
    [arrayofvc removeObjectAtIndex:0];
    NSUInteger sithIndex = [arrayofvc indexOfObject:sithvc];
    [self setViewControllers:arrayofvc];
    [self setSelectedViewController:sithvc];
    [[self.tabBar.items objectAtIndex:sithIndex] setBadgeValue:@"99"];
    
    UIImage *sithimage = [UIImage imageNamed:@"approval"];
    [[self.tabBar.items objectAtIndex:sithIndex] setImage:sithimage];
    [self YDviewWillAppear:animated];
}
@end

