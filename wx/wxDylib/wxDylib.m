//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  wxDylib.m
//  wxDylib
//
//  Created by admin on 2017/8/15.
//  Copyright (c) 2017年 ahaschool. All rights reserved.
//

#import "wxDylib.h"
#import "CaptainHook.h"
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import "FishConfigurationCenter.h"

static __attribute__((constructor)) void entry(){
    NSLog(@"\n               🎉!!！congratulations!!！🎉\n👍----------------insert dylib success----------------👍");
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        CYListenServer(6666);
    }];
}

CHDeclareClass(WCDeviceStepObject)
// 微信运动步数

CHOptimizedMethod0(self, unsigned int, WCDeviceStepObject, m7StepCount)
{
    BOOL modifyToday = NO;
    if ([FishConfigurationCenter sharedInstance].lastChangeStepCountDate){
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        NSDate *today = [cal dateFromComponents:components];
        components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[FishConfigurationCenter sharedInstance].lastChangeStepCountDate];
        NSDate *otherDate = [cal dateFromComponents:components];
        if([today isEqualToDate:otherDate]) {
            modifyToday = YES;
        }
    }
    if ([FishConfigurationCenter sharedInstance].stepCount == 0 || !modifyToday) {
        [FishConfigurationCenter sharedInstance].stepCount = CHSuper0(WCDeviceStepObject, m7StepCount);
    }
    return [FishConfigurationCenter sharedInstance].stepCount;
}

CHConstructor{
    CHLoadLateClass(WCDeviceStepObject);
    CHClassHook(0, WCDeviceStepObject, m7StepCount);
}

