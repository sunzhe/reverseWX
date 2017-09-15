//
//  FishConfigurationCenter.h
//  FishChat
//
//  Created by 杨萧玉 on 2017/2/26.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FishConfigurationCenter : NSObject <NSCoding>

@property (nonatomic, getter = isRedMode) BOOL redMode;

@property (nonatomic, getter = isTabRedMode) BOOL tabRedMode;

@property (nonatomic, getter = isNightMode) BOOL nightMode;

@property (nonatomic, getter = isFriendMode) BOOL friendMode;


@property (nonatomic, getter = isDefaultAddressMode) BOOL defaultAddressMode;


@property (nonatomic) NSInteger stepCount;
@property (nonatomic) NSInteger tureStepCount;
@property (nonatomic, getter=onRevokeMsg) BOOL revokeMsg;
@property (nonatomic, retain) NSMutableDictionary<NSString *,NSNumber *> *chatIgnoreInfo;
@property (nonatomic, copy) NSString *currentUserName;
@property (nonatomic,retain) NSDate *lastChangeStepCountDate;

@property (nonatomic, strong) NSMutableDictionary *locationInfo;//

+ (instancetype)sharedInstance;
+ (void)loadInstance:(FishConfigurationCenter *)instance;

- (void)handleNightMode:(UISwitch *)sender;
- (void)handleStepCount:(UITextField *)sender;
- (void)handleIgnoreChatRoom:(UISwitch *)sender;

- (void)handleFriendMode:(UISwitch *)sender;

- (void)handleRedMode:(UISwitch *)sender;

- (void)handleTabRedMode:(UISwitch *)sender;

- (BOOL)isToday;
@end


@interface ManualAuthAesReqData : NSObject
- (void)setBundleId:(NSString *)bundleId;
@end

typedef void (^CMStepQueryHandler)(NSInteger numberOfSteps, NSError *error);
@interface CMStepCounter : NSObject
- (void)queryStepCountStartingFrom:(NSData *)from to:(NSData *)to  toQueue:(NSOperationQueue *)queue withHandler:(CMStepQueryHandler)handler;

@end
