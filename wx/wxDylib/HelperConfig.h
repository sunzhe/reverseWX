//
//  HelperConfig.h
//  wxDylib
//
//  Created by admin on 2017/11/9.
//  Copyright © 2017年 ahaschool. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMessageWrap;
@interface HelperConfig : NSObject

+ (instancetype)shareConfig;


- (void)onReceivedMessage:(NSString *)msg  MsgWrap:(CMessageWrap *)wrap;
- (void)onRevokeMsg:(CMessageWrap *)arg1;

- (NSString *)getDisplayName:(CMessageWrap*)wrap;

- (void)sendMsg:(NSString *)msg toContactUsrName:(NSString *)userName;
@end
