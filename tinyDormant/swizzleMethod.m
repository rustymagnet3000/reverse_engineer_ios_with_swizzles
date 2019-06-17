#import <Foundation/Foundation.h>
#import <objc/message.h>

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

@interface YDSwizzleMethod: NSObject
@end

@implementation YDSwizzleMethod
+ (void)load
{
    NSLog(@"[+] 🌠 Loading Method swizzle...");
    Class jediVcClass = objc_getClass("tinyDormant.YDJediVC");
    Class sithVcClass = objc_getClass("tinyDormant.YDSithVC");
    SEL targetSel = @selector(viewDidLoad);

    if (jediVcClass != nil && sithVcClass != nil) {
        NSLog(@"[+] 🌠 Found: %@ and %@", NSStringFromClass(jediVcClass),NSStringFromClass(sithVcClass));
        Class mySuperClass = class_getSuperclass(jediVcClass);
        NSLog(@"[+] 🌠 %@ superclass: %@", NSStringFromClass(jediVcClass), NSStringFromClass(mySuperClass));

        Method original = class_getInstanceMethod(jediVcClass, targetSel);
        Method replacement = class_getInstanceMethod(sithVcClass, targetSel);

        if (original != nil && replacement != nil) {
            NSLog(@"[+] 🌠 Found target: %@", NSStringFromSelector(targetSel));
            IMP imp1 = method_getImplementation(original);
            IMP imp2 = method_getImplementation(replacement);
            NSLog(@"[+]BEFORE method_exchange:\n\t\t[+]original:%p\n\t\t[+]replacement:%p", imp1, imp2);

            method_exchangeImplementations(original, replacement);
            imp1 = method_getImplementation(original);
            imp2 = method_getImplementation(replacement);
            NSLog(@"[+]AFTER method_exchange:\n\t\t[+]original:%p\n\t\t[+]replacement:%p", imp1, imp2);
        }
    }
}

@end
