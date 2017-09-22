//
//  BackgroundTask.m
//  wxDylib
//
//  Created by admin on 2017/9/22.
//  Copyright © 2017年 ahaschool. All rights reserved.
//

#import "BackgroundTask.h"
#import "CaptainHook.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DeathlessLocation.h"
@interface BackgroundTask()<AVAudioPlayerDelegate>

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier background_task;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


@end

@implementation BackgroundTask

static BackgroundTask *__task = nil;
+ (instancetype)shareTask{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __task = [BackgroundTask new];
        [__task initSetting];
    });
    return __task;
}

- (void)initSetting{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
    //[self playAuido];
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_global_queue(0, 0), ^{
        [self playAuido];
    });
}

- (void)applicationEnterBackground{
    [self endBackgroundTask];
    /*
    
    UIApplication *application = [UIApplication sharedApplication];
    self.backgroundTaskIdentifier =[application beginBackgroundTaskWithExpirationHandler:^(void) {
        [self endBackgroundTask];
    }];
    
    // 模拟一个Long-Running Task
    [_myTimer invalidate];
    self.myTimer =[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
     //*/
}
//程序进入前台
- (void)applicationDidBecomeActive
{
    //后台保持app一直运作的播放器停止工作
    [_audioPlayer stop];
}
- (void)endBackgroundTask{
    NSLog(@"%s",__FUNCTION__);
    //设置永久后台运行
    UIApplication *application = [UIApplication sharedApplication];
    __block   UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        //不管有没有完成，结束bgTask任务
        [application endBackgroundTask:bgTask];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    //当只有点播了时才会退到后台，如果不点播则后台不开启，以省电
    //开启后台任务
    
    [self applyBackgrounTaskTime];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Starting background task with %0.1f seconds remaining", application.backgroundTimeRemaining);
        [NSThread sleepForTimeInterval:600];
        NSLog(@"Finishing background task with %0.1f seconds remaining",application.backgroundTimeRemaining);
        
        //告诉系统我们完成了 也就是要告诉应用程序：“好借好还”嘛。
        //将任务标记为完成
        [application endBackgroundTask:bgTask];
        // 销毁后台任务标识符
        bgTask = UIBackgroundTaskInvalid;
    });
}
//开启后台任务
- (void)applyBackgrounTaskTime
{
    //__block UIBackgroundTaskIdentifier background_task;
    UIApplication *application = [UIApplication sharedApplication];
    //注册一个后台任务，告诉系统我们需要向系统借一些事件
    _background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
        
        //不管有没有完成，结束background_task任务
        [application endBackgroundTask: _background_task];
        _background_task = UIBackgroundTaskInvalid;
    }];
    
    //异步
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //### background task starts
        NSLog(@"Running in the background\n");
        
        //循环播放无声的MP3
        [self playAuido];
        
        [NSThread sleepForTimeInterval:2];
        //结束background_task任务
        [application endBackgroundTask: _background_task];
        _background_task = UIBackgroundTaskInvalid;
    });
}

- (void)playAuido{
    //*
    if (_audioPlayer.playing) {
        return;
    }
    if (_audioPlayer && [_audioPlayer play]) {
        return;
    }
    
    NSError *audioSessionError = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:&audioSessionError];
    audioSessionError = nil;
    if ([audioSession setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError]){
        NSLog(@"Successfully set the audio session.");
    } else {
        NSLog(@"Could not set the audio session");
    }
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *filePath = [mainBundle pathForResource:@"wusheng"ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [_audioPlayer stop];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url fileTypeHint:AVFileTypeMPEGLayer3 error:nil];
    [_audioPlayer prepareToPlay];
    [_audioPlayer setNumberOfLoops:-1];
    _audioPlayer.volume = 0;
    if ([_audioPlayer play]){
        NSLog(@"Successfully started playing...");
    } else {
        NSLog(@"Failed to play.");
    }
     //*/
}


- (void)updateBackgroundTask{
    if (_audioPlayer.isPlaying) {
        return;
    }
    if (_audioPlayer && [_audioPlayer play]) {
        return;
    }
    [self endBackgroundTask];
}
- (void)onInterruption:(NSNotification *)obj{
    [self updateBackgroundTask];
}

@end
