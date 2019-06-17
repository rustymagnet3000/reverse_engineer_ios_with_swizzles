#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

/*
http://alanduncan.me/2013/10/02/set-an-ivar-via-the-objective-c-runtime/
https://stackoverflow.com/questions/1972753/get-ivar-value-from-object-in-objective-c
http://jerrymarino.com/2014/01/31/objective-c-private-instance-variable-access.html
*/
@interface YDSwizzleIvars: NSObject
@end

@implementation YDSwizzleIvars
+ (void)load
{
    NSLog(@"[*] 🌠 Loading iVar inspection...");
    Class jedivcclass = objc_getClass("tinyDormant.YDJediVC");
    Ivar *ivars = class_copyIvarList(jedivcclass, NULL);
    for(Ivar *ivar = ivars; *ivar != NULL; ivar++)
    {
        id jedivc = (id)[jedivcclass new];
    //    id variable = object_getIvar(jedivc, *ivar);
    //    NSLog(@"\t\t[*]ivar:%s: %@", ivar_getName(*ivar), variable);
        NSLog(@"\t\t[*]%s", ivar_getName(*ivar));
    }
    free(ivars);
}

@end
//NSLog(@"\t\t[*]ivar:%s || type encoding:%s", ivar_getName(*ivar), ivar_getTypeEncoding(*ivar));
//if(strcmp(ivar_getTypeEncoding(*ivar), @encode(id)) == 0)
//{
//    ptrdiff_t offset = ivar_getOffset(*ivar);
    //            char *rawObject = (__bridge void *)object;
    //            char *ivarPtr = rawObject + offset;
    //            __unsafe_unretained id value;
    //            memcpy(&value, ivarPtr, sizeof(value));
