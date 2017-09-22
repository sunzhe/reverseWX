//
//  DeathlessLocation.m
//  DeathlessLocation
//
//  Created by mw on 17/8/18.
//  Copyright © 2017年 No One. All rights reserved.
//

#import "DeathlessLocation.h"
#import "BGTask.h"
#import <UserNotifications/UserNotifications.h>
#import "BackgroundTask.h"
@interface DeathlessLocation()
@property (strong , nonatomic) BGTask *bgTask;                      //后台任务
@property (strong , nonatomic) NSTimer *restarTimer;                //重新开启后台任务定时器
@property (strong , nonatomic) NSTimer *closeCollectLocationTimer;  //关闭定位定时器 （目的是减少耗电）
@property (assign , nonatomic) BOOL  isWorking;                     //定位进行中
@end


void  customPushLog(NSString *log){
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.badge = @(1);
    content.body = log;
    //推送类型
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"log" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        //NSLog(@"iOS 10 发送推送， error：%@", error);
    }];
}

@implementation DeathlessLocation

#pragma mark - 初始化

//单例
+ (DeathlessLocation *)sharedInstance
{
    static DeathlessLocation *_sharedInstance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[DeathlessLocation alloc] init];
    });
    return _sharedInstance;
}
+ (CLLocationManager *)shareBGLocation
{
    static CLLocationManager *_locationManager;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.allowsBackgroundLocationUpdates = YES;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
    });
    return _locationManager;
}
//初始化
- (instancetype)init
{
    if(self == [super init])
    {
        _bgTask = [BGTask shareBGTask];
        _isWorking = NO;
        //监听进入后台通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillTerminate)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}
- (void)applicationWillTerminate{
    
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    date = [date dateByAddingTimeInterval: interval];
    
    [[NSUserDefaults standardUserDefaults] setObject:date.description forKey:@"__applicationWillTerminateDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidBecomeActive{
    CLLocationManager *locationManager = [DeathlessLocation shareBGLocation];
    [locationManager stopUpdatingLocation];
    [locationManager stopMonitoringSignificantLocationChanges];
}

//后台监听方法
- (void)applicationEnterBackground
{
    //[self applicationWillTerminate];
    customPushLog(@" in background");
    CLLocationManager *locationManager = [DeathlessLocation shareBGLocation];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0)
    {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
    [_bgTask beginNewBackgroundTask];
}

#pragma mark - 定位

//开启服务
- (void)startLocation {
    customPushLog(@"开启定位");
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        customPushLog(@"locationServicesEnabled false");
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
    } else {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            customPushLog(@"authorizationStatus failed");
        } else {
            customPushLog(@"authorizationStatus authorized");
            CLLocationManager *locationManager = [DeathlessLocation shareBGLocation];
            locationManager.distanceFilter = kCLDistanceFilterNone;
            
            if([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
                [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
            [locationManager startMonitoringSignificantLocationChanges];
        }
    }
}

//停止后台定位
-(void)stopLocation
{
    customPushLog(@"停止定位");
    _isWorking = NO;
    CLLocationManager *locationManager = [DeathlessLocation shareBGLocation];
    [locationManager stopUpdatingLocation];
    [locationManager stopMonitoringSignificantLocationChanges];
}

//重启定位服务
-(void)restartLocation
{
    customPushLog(@"重新启动定位");
    CLLocationManager *locationManager = [DeathlessLocation shareBGLocation];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
    [self.bgTask beginNewBackgroundTask];
    
    [[BackgroundTask shareTask] updateBackgroundTask];
}

#pragma mark - delegate
//定位回调里执行重启定位和关闭定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self sendNotifycation:[(CLLocation *)locations.firstObject coordinate]];
    NSLog(@"定位收集");
    //如果正在10秒定时收集的时间，不需要执行延时开启和关闭定位
    if (_isWorking)
    {
        return;
    }
    [self performSelector:@selector(restartLocation) withObject:nil afterDelay:100];
    [self performSelector:@selector(stopLocation) withObject:nil afterDelay:10];
    _isWorking = YES;//标记正在定位
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            // nothing
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"应用没有开启定位，便不能保持后台运行,需要在在设置/通用/后台应用刷新开启"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}


- (void)sendNotifycation:(CLLocationCoordinate2D)coor
{
    NSString *title = [NSString stringWithFormat:@"WGS84 维度:%.6f, 经度:%.6f", coor.latitude, coor.longitude];
    customPushLog(title);
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"locationSuc" object:nil userInfo:@{@"message": [content.body stringByAppendingString:content.title]}];
}

@end
