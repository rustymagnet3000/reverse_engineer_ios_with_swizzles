#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include "staticStrings.h"

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

#pragma mark - check YDClassDumper is not part of multiple Target Memberships

@implementation NSObject (YDClassDumper)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSLog(@"[*] 🐝 Started Class introspection...");
        Class *classes = objc_copyClassList(NULL);
        Class sithvcclass = objc_getClass(dormantClassStr);
        
        for(Class *cursor = classes; *cursor != nil; cursor++)
        {
            NSString *foundClass = [[NSString alloc] initWithCString:(class_getName(*cursor)) encoding:NSUTF8StringEncoding];

            if([foundClass containsString:@dumpClassSearchStr]){
                NSLog(@"🐝\t\t[*]%@", foundClass);
                id sithvc = (id)[*cursor new];
                if([sithvc isKindOfClass:sithvcclass]){
                    NSLog(@"\t\t\t[*]🌠 FOUND Dormant Class -> isKindOfClass!");
                }
                if([sithvc isMemberOfClass:sithvcclass]){
                    NSLog(@"\t\t\t[*]🌠 FOUND Dormant Class -> isMemberOfClass!");
                }
            }
        }
    });
}

@end
