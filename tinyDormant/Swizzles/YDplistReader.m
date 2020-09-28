#import "YDplistReader.h"

@implementation YDplistReader

- (instancetype)init {
    self = [self initWithPlistName:@""];
    return self;
}

- (instancetype)initWithPlistName:(NSString *)name {
    self = [super init];
    NSLog(@"🍭Looking for Property List file: %@", name);
    if (self) {
        _name = name;
        
        NSString *fwPath = [[[NSBundle mainBundle] privateFrameworksPath] stringByAppendingPathComponent:@"tinySwizzle.framework"];
        NSBundle *bundle = [NSBundle bundleWithPath:fwPath];
        NSString *file = [bundle pathForResource:name ofType:@"plist"];
        
        if (bundle == NULL || file == NULL) {
            NSLog(@"🍭Can't find framework or swizzle plist file");
            return NULL;
        }

        NSArray *foundItems = [NSArray arrayWithContentsOfFile:file];

        if (foundItems == NULL){
            NSLog(@"Could not read file");
            return NULL;
        }
        _arrayOfDictsFromPlist = foundItems;
    }
    return self;
}

@end

