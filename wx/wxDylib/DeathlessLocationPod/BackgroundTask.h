//
//  BackgroundTask.h
//  wxDylib
//
//  Created by admin on 2017/9/22.
//  Copyright © 2017年 ahaschool. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundTask : NSObject



+ (instancetype)shareTask;

- (void)endBackgroundTask;

- (void)updateBackgroundTask;
@end
