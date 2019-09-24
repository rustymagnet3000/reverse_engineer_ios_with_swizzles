#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDplistReader : NSObject
@property (readonly) NSArray *arrayOfDictsFromPlist;
@property (strong, nonatomic) NSString *name;

- (instancetype)initWithPlistName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
