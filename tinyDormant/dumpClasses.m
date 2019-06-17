#import <Foundation/Foundation.h>
#import <objc/message.h>

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

@implementation NSObject (YDClassDumper)
+ (void)load
{
    NSLog(@"[*] 🌠 Started Class introspection...");
    Class *classes = objc_copyClassList(NULL);
    Class sithvcclass = objc_getClass("tinyDormant.YDSithVC");
    
    for(Class *cursor = classes; *cursor != nil; cursor++)
    {
        NSString *foundClass = [[NSString alloc] initWithCString:(class_getName(*cursor)) encoding:NSUTF8StringEncoding];
        if([foundClass containsString:@"tiny"]){
            NSLog(@"\t\t[*]%@", foundClass);
            id sithvc = (id)[*cursor new];
            if([sithvc isKindOfClass:sithvcclass]){
                NSLog(@"\t\t\t[*]🌠 FOUND SITH -> isKindOfClass!");
            }
            if([sithvc isMemberOfClass:sithvcclass]){
                NSLog(@"\t\t\t[*]🌠 FOUND SITH -> isMemberOfClass!");
            }
        }
    }
}

@end
