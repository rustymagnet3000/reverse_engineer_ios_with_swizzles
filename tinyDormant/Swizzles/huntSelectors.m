#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include "staticStrings.h"

@implementation NSObject (YDHuntMethodSelectors)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class custom = objc_getClass("tinyDormant.YDJediVC");
        int i=0;
        unsigned int mc = 0;
        Method * mlist = class_copyMethodList(custom, &mc);
        NSLog(@"🍭%d methods", mc);
        for(i=0;i<mc;i++)
            NSLog(@"🍭Method no #%d: %s", i, sel_getName(method_getName(mlist[i])));
    });
}
@end


