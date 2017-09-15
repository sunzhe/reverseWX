//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  wxDylib.m
//  wxDylib
//
//  Created by admin on 2017/9/14.
//  Copyright (c) 2017年 ahaschool. All rights reserved.
//

#import "wxDylib.h"
#import "CaptainHook.h"
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import "FishConfigurationCenter.h"
#import "TKToast.h"

static __attribute__((constructor)) void entry(){
    NSLog(@"\n               🎉!!！congratulations!!！🎉\n👍----------------insert dylib success----------------👍");
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        CYListenServer(6666);
    }];
}

#pragma mark ManualAuthAesReqData

CHDeclareClass(ManualAuthAesReqData)

CHOptimizedMethod1(self, void, ManualAuthAesReqData, setBundleId, NSString*, bundleId){
    bundleId = @"com.tencent.xin";
    CHSuper1(ManualAuthAesReqData, setBundleId, bundleId);
}

CHConstructor{
    CHLoadLateClass(ManualAuthAesReqData);
    CHClassHook1(ManualAuthAesReqData, setBundleId);
}

CMStepQueryHandler origHandler = nil;

CMStepQueryHandler newHandler = ^(NSInteger numberSteps, NSError *error){
    BOOL modifyToday = [FishConfigurationCenter sharedInstance].isToday;
    if([FishConfigurationCenter sharedInstance].stepCount == 0 || !modifyToday){
        [FishConfigurationCenter sharedInstance].stepCount = numberSteps;
    }else {
        if (numberSteps == 0){
            [TKToast toast:@"获取步数为0,本地时间不正确"];
        }
        numberSteps = [FishConfigurationCenter sharedInstance].stepCount;
    }
    origHandler(numberSteps,error);
};

CHDeclareClass(CMStepCounter);
//本地时间必须正确
CHOptimizedMethod4(self, void, CMStepCounter,queryStepCountStartingFrom, NSData*, from, to, NSData*, to, toQueue, NSOperationQueue*, queue, withHandler, CMStepQueryHandler, handler){
    origHandler = [handler copy];
    handler = newHandler;
    CHSuper4(CMStepCounter, queryStepCountStartingFrom, from, to, to, toQueue, queue, withHandler, handler);
}

CHConstructor{
    CHLoadLateClass(CMStepCounter);
    CHClassHook4(CMStepCounter, queryStepCountStartingFrom, to, toQueue, withHandler);
}
