#include "swizzleHelper.h"
#import "YDplistReader.h"


typedef void (^YDBlockEnumerator)(id, NSUInteger, BOOL *);

@interface YDFakeUIBarButtonItem: UIBarButtonItem
@property (readwrite) NSString *sbClass, *sbID, *sbFile;
@end

@implementation YDFakeUIBarButtonItem
@end


@implementation UIViewController (YDFakeUIVC)
static const NSString *value1 = @"storyboardClassName";
static const NSString *value2 = @"storyboardID";
static const NSString *value3 = @"storyboardFile";

+ (void)load
{
    NSLog(@"🍭 loaded YDFakeUIVC Category from: %@", [self class]);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL orig = @selector(viewDidAppear:);
        SEL swiz = @selector(YDviewDidAppear:);

        SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:targetClassStr Original:orig Swizzle:swiz];

        if (swizzle != NULL){
            NSLog(@"%@", [swizzle getDescription]);
        }
    });
}

#pragma mark - add navigationItem UIBarButtons
- (void)YDviewDidAppear:(BOOL)animated {
    [self YDviewDidAppear:animated];
    NSLog(@"🍭 Swizzled. YDviewDidAppear called from: %@", self);
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    [self hijackStoryboard];
}

- (void)hijackStoryboard {
    NSString *plistName = @"YDSwizzlePlist"; // @"YDDormantStoryboards";
    YDplistReader *myplist = [[YDplistReader alloc] initWithPlistName:plistName];

     if (myplist == NULL)
         return;
    
    NSLog(@"🍭Found %lu items in plist", (unsigned long)[myplist.arrayOfDictsFromPlist count]);
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    
    YDBlockEnumerator simpleblock = ^ (id dict, NSUInteger i, BOOL *stop){
        YDFakeUIBarButtonItem *sbBarButton = [[YDFakeUIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(storyboardHijack:)];
        
        [buttons addObject:sbBarButton];

        if ([dict objectForKey:value1])
            sbBarButton.sbClass = dict[value1];
        
        if ([dict objectForKey:value2])
            sbBarButton.sbID = dict[value2];
        
        if ([dict objectForKey:value3])
            sbBarButton.sbFile = dict[value3];
    };
    

    NSLog(@"🍭 Creating %lu fake UIBarButtonItem(s) ", (unsigned long)[myplist.arrayOfDictsFromPlist count]);
    [myplist.arrayOfDictsFromPlist enumerateObjectsUsingBlock:simpleblock];
    self.navigationItem.leftBarButtonItems = buttons;
    
    UIBarButtonItem *sithBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(sithHijack:)];

    UIBarButtonItem *porgBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(porgHijack:)];

    self.navigationItem.rightBarButtonItems =@[porgBarButton, sithBarButton];
}

#pragma mark - generic Storyboard hijack
-(IBAction)storyboardHijack:(id)sender
{
    if ([sender isMemberOfClass:[YDFakeUIBarButtonItem class]]){
        NSLog(@"🍭 YDFakeUIBarButtonItem invoked. Tried to create %@", [[sender self] sbClass]);
        UIStoryboard *sb = [UIStoryboard storyboardWithName:[[sender self] sbFile] bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:[[sender self] sbID]];
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

#pragma mark - the View Controller that is not tied to a XIB or Storyboard
-(IBAction)sithHijack:(id)sender {
    NSLog(@"🍭 sithHijack");
    Class SithClass = objc_getClass(dormantClassStr);
    NSLog(@"🍭 Tried to create instance of: %@", NSStringFromClass(SithClass));
    id sithvc = class_createInstance(SithClass, 0);
    NSLog(@"🍭 Created instance of: %@ at: %p", [sithvc class], sithvc);
    NSLog(@"🍭 In class: %@ with Superclass: %@", [self class], [self superclass]);
    NSLog(@"🍭 Self navigationController: %@", [self navigationController]);
    NSLog(@"🍭 Self tabBarController: %@", [self tabBarController]);
    [[self navigationController] pushViewController:sithvc animated:YES];
}

#pragma mark - the Nib file and View Controller
-(IBAction)porgHijack:(id)sender {

    Class PorgClass = objc_getClass(dormantPorgClassStr);
    NSLog(@"🍭 Tried to create instance of: %@", NSStringFromClass(PorgClass));
    id porgvc = class_createInstance(PorgClass, 0);
    [[NSBundle mainBundle] loadNibNamed:@dormantXibStr owner:porgvc options:nil];
    [[self navigationController] pushViewController:porgvc animated:YES];
}

@end
