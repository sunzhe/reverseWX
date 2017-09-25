//
//  FishConfigurationCenter.m
//  FishChat
//
//  Created by 杨萧玉 on 2017/2/26.
//
//

#import "FishConfigurationCenter.h"

#define FishConfigurationCenterKey @"FishConfigurationCenterKey"
@implementation FishConfigurationCenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.chatIgnoreInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    
}

+ (void)load{
    NSLog(@"## Load FishConfigurationCenter ##");
    NSData *centerData = [[NSUserDefaults standardUserDefaults] objectForKey:FishConfigurationCenterKey];
    if (centerData) {
        
        __ignoreSaveValue = YES;
        FishConfigurationCenter *center = [NSKeyedUnarchiver unarchiveObjectWithData:centerData];
        [FishConfigurationCenter loadInstance:center];
        __ignoreSaveValue = NO;
    }
}
BOOL __ignoreSaveValue;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FishConfigurationCenter *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[FishConfigurationCenter alloc] init];
    });
    return _instance;
}

+ (void)loadInstance:(FishConfigurationCenter *)instance
{
    FishConfigurationCenter *center = [self sharedInstance];
    center.tabRedMode = instance.tabRedMode;
    center.redMode = instance.redMode;
    center.friendMode = instance.friendMode;
    center.nightMode = instance.nightMode;
    center.revokeMsg = instance.onRevokeMsg;
    center.chatIgnoreInfo = instance.chatIgnoreInfo;
    center.currentUserName = instance.currentUserName;
    center.lastChangeStepCountDate = instance.lastChangeStepCountDate;
    center.locationInfo = instance.locationInfo;
    center.longBackgroundMode = instance.longBackgroundMode;
    if (instance.isToday) {
        center.stepCount = instance.stepCount;
    }
}


- (BOOL)isToday{
    BOOL modifyToday = NO;
    if (_lastChangeStepCountDate){
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        NSDate *today = [cal dateFromComponents:components];
        components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_lastChangeStepCountDate];
        NSDate *otherDate = [cal dateFromComponents:components];
        if([today isEqualToDate:otherDate]) {
            modifyToday = YES;
        }
    }
    return modifyToday;
}

#pragma mark - Handle Events

- (void)handleRedMode:(UISwitch *)sender{
    self.redMode = sender.isOn;
    [self saveValue];
}

- (void)handleTabRedMode:(UISwitch *)sender{
    self.tabRedMode = sender.isOn;
    [self saveValue];
}

- (void)handleFriendMode:(UISwitch *)sender{
    self.friendMode = sender.isOn;
    [self saveValue];
}

- (void)handleNightMode:(UISwitch *)sender
{
    self.nightMode = sender.isOn;
    [[self viewControllerOfResponder:sender] viewWillAppear:NO];
    [self saveValue];
}

- (void)handleStepCount:(UITextField *)sender
{
    self.stepCount = sender.text.integerValue;
    self.lastChangeStepCountDate = [NSDate date];
    [self saveValue];
}

- (void)handleIgnoreChatRoom:(UISwitch *)sender
{
    self.chatIgnoreInfo[self.currentUserName] = @(sender.isOn);
    [self saveValue];
}

- (void)handleLongBackgroundMode:(UISwitch *)sender{
    self.longBackgroundMode = sender.isOn;
    [self saveValue];
}

- (UIViewController *)viewControllerOfResponder:(UIResponder *)responder
{
    UIResponder *current = responder;
    while (current && ![current isKindOfClass:UIViewController.class]) {
        current = [current nextResponder];
    }
    return (UIViewController *)current;
}

- (void)setLocationInfo:(NSMutableDictionary *)locationInfo{
    _locationInfo = locationInfo;
    [self saveValue];
}
#pragma mark - NSCoding
- (void)saveValue{
    if (__ignoreSaveValue) {
        return;
    }
    NSData *centerData = [NSKeyedArchiver archivedDataWithRootObject:[FishConfigurationCenter sharedInstance]];
    [[NSUserDefaults standardUserDefaults] setObject:centerData forKey:@"FishConfigurationCenterKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.tabRedMode forKey:@"tabRedMode"];
    [aCoder encodeBool:self.redMode forKey:@"redMode"];
    [aCoder encodeBool:self.friendMode forKey:@"friendMode"];
    [aCoder encodeBool:self.nightMode forKey:@"nightMode"];
    [aCoder encodeInteger:self.stepCount forKey:@"stepCount"];
    [aCoder encodeBool:self.revokeMsg forKey:@"revokeMsg"];
    [aCoder encodeObject:self.chatIgnoreInfo forKey:@"chatIgnoreInfo"];
    [aCoder encodeObject:self.currentUserName forKey:@"currentUserName"];
    [aCoder encodeObject:self.lastChangeStepCountDate forKey:@"lastChangeStepCountDate"];
    [aCoder encodeObject:self.locationInfo forKey:@"locationInfo"];
    [aCoder encodeBool:self.longBackgroundMode forKey:@"longBackgroundMode"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.tabRedMode = [aDecoder decodeBoolForKey:@"tabRedMode"];
        self.redMode = [aDecoder decodeBoolForKey:@"redMode"];
        self.friendMode = [aDecoder decodeBoolForKey:@"friendMode"];
        self.nightMode = [aDecoder decodeBoolForKey:@"nightMode"];
        self.stepCount = [aDecoder decodeIntegerForKey:@"stepCount"];
        self.revokeMsg = [aDecoder decodeBoolForKey:@"revokeMsg"];
        self.chatIgnoreInfo = [aDecoder decodeObjectOfClass:NSDictionary.class forKey:@"chatIgnoreInfo"];
        self.currentUserName = [aDecoder decodeObjectOfClass:NSString.class forKey:@"currentUserName"];
        self.lastChangeStepCountDate = [aDecoder decodeObjectForKey:@"lastChangeStepCountDate"];
        self.locationInfo = [aDecoder decodeObjectForKey:@"locationInfo"];
        self.longBackgroundMode = [aDecoder decodeBoolForKey:@"longBackgroundMode"];
    }
    return self;
}

@end
