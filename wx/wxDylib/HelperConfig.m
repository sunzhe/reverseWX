//
//  HelperConfig.m
//  wxDylib
//
//  Created by admin on 2017/11/9.
//  Copyright © 2017年 ahaschool. All rights reserved.
//

#import "HelperConfig.h"
#import "WeChatRedEnvelop.h"
#import "WeChatRedEnvelopParam.h"
#import "WBSettingViewController.h"
#import "WBReceiveRedEnvelopOperation.h"
#import "WBRedEnvelopTaskManager.h"
#import "WBRedEnvelopConfig.h"
#import "WBRedEnvelopParamQueue.h"

#import "FishConfigurationCenter.h"
#import "MapView.h"
#import "XMLReader.h"
#import "WeChatRobot.h"

#import "BackgroundTask.h"

@implementation HelperConfig
static HelperConfig *__congif;
+ (instancetype)shareConfig{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __congif = [HelperConfig new];
    });
    return __congif;
}

- (NSString *)getDisplayName:(CMessageWrap*)wrap{
    CContactMgr *contactMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CContactMgr")];
    NSString *name;
    if (wrap.m_nsRealChatUsr.length) {//ingroup
        CContact *groupContact = [contactMgr getContactByName:wrap.m_nsFromUsr];
        CContact *contact = [contactMgr getContactByName:wrap.m_nsRealChatUsr];
        name = [groupContact getChatRoomMemberDisplayName:contact];
        name = [groupContact.getContactDisplayName stringByAppendingFormat:@"@%@", name];
    }else {
        CContact *contact = [contactMgr getContactByName:wrap.m_nsFromUsr];
        name = contact.getContactDisplayName;
    }
    return name;
}

- (void)onReceivedMessage:(NSString *)msg  MsgWrap:(CMessageWrap *)wrap{
    CContactMgr *contactManager = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CContactMgr") class]];
    CContact *selfContact = [contactManager getSelfContact];
    CContact *contact = [contactManager getContactByName:wrap.m_nsFromUsr];
    
    switch(wrap.m_uiMessageType) {
        case 49: { // AppNode
            /** 是否为红包消息 */
            BOOL (^isRedEnvelopMessage)() = ^BOOL() {
                return [wrap.m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound;
            };
            
            if (isRedEnvelopMessage()) { // 红包
                
                BOOL (^isSender)() = ^BOOL() {
                    return [wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName];
                };
                
                /** 是否别人在群聊中发消息 */
                BOOL (^isGroupReceiver)() = ^BOOL() {
                    return [wrap.m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound;
                };
                
                /** 是否自己在群聊中发消息 */
                BOOL (^isGroupSender)() = ^BOOL() {
                    return isSender() && [wrap.m_nsToUsr rangeOfString:@"chatroom"].location != NSNotFound;
                };
                
                NSError *error;
                NSMutableString *str = [NSMutableString stringWithString:wrap.m_nsContent];
                if (isGroupReceiver()) {//群聊中
                    [str deleteCharactersInRange:NSMakeRange(0, wrap.m_nsRealChatUsr.length+2)];
                }
                NSDictionary *msgDict = [XMLReader dictionaryForXMLString:str error:&error];
                NSString *sendertitle = [msgDict valueForKeyPath:@"msg.appmsg.wcpayinfo.sendertitle.text"];
                
                /** 是否抢自己发的红包 */
                BOOL (^isReceiveSelfRedEnvelop)() = ^BOOL() {
                    return [WBRedEnvelopConfig sharedConfig].receiveSelfRedEnvelop;
                };
                
                /** 检查关键字 */
                BOOL (^isHaveTestWord)(NSString *string) = ^BOOL(NSString *string) {
                    return [string rangeOfString:@"测"].length != 0;
                };
                
                /** 是否在黑名单中 */
                BOOL (^isGroupInBlackList)() = ^BOOL() {
                    return [[WBRedEnvelopConfig sharedConfig].blackList containsObject:wrap.m_nsFromUsr];
                };
                
                /** 是否自动抢红包 */
                BOOL (^shouldReceiveRedEnvelop)() = ^BOOL() {
                    if (![WBRedEnvelopConfig sharedConfig].autoReceiveEnable) { return NO; }
                    if (isGroupInBlackList() || isHaveTestWord(sendertitle)) { return NO; }
                    
                    return isGroupReceiver() || (isGroupSender() && isReceiveSelfRedEnvelop());
                };
                
                NSDictionary *(^parseNativeUrl)(NSString *nativeUrl) = ^(NSString *nativeUrl) {
                    nativeUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
                    return [objc_getClass("WCBizUtil") dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
                };
                
                /** 获取服务端验证参数 */
                void (^queryRedEnvelopesReqeust)(NSDictionary *nativeUrlDict) = ^(NSDictionary *nativeUrlDict) {
                    NSMutableDictionary *params = [@{} mutableCopy];
                    params[@"agreeDuty"] = @"0";
                    params[@"channelId"] = [nativeUrlDict stringForKey:@"channelid"];
                    params[@"inWay"] = @"0";
                    params[@"msgType"] = [nativeUrlDict stringForKey:@"msgtype"];
                    params[@"nativeUrl"] = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                    params[@"sendId"] = [nativeUrlDict stringForKey:@"sendid"];
                    
                    WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
                    [logicMgr ReceiverQueryRedEnvelopesRequest:params];
                };
                
                /** 储存参数 */
                void (^enqueueParam)(NSDictionary *nativeUrlDict) = ^(NSDictionary *nativeUrlDict) {
                    WeChatRedEnvelopParam *mgrParams = [[WeChatRedEnvelopParam alloc] init];
                    mgrParams.msgType = [nativeUrlDict stringForKey:@"msgtype"];
                    mgrParams.sendId = [nativeUrlDict stringForKey:@"sendid"];
                    mgrParams.channelId = [nativeUrlDict stringForKey:@"channelid"];
                    mgrParams.nickName = [selfContact getContactDisplayName];
                    mgrParams.headImg = [selfContact m_nsHeadImgUrl];
                    mgrParams.nativeUrl = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                    mgrParams.sessionUserName = isGroupSender() ? wrap.m_nsToUsr : wrap.m_nsFromUsr;
                    mgrParams.sign = [nativeUrlDict stringForKey:@"sign"];
                    
                    mgrParams.isGroupSender = isGroupSender();
                    
                    [[WBRedEnvelopParamQueue sharedQueue] enqueue:mgrParams];
                };
                
                if (shouldReceiveRedEnvelop()) {
                    NSString *nativeUrl = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                    NSDictionary *nativeUrlDict = parseNativeUrl(nativeUrl);
                    
                    queryRedEnvelopesReqeust(nativeUrlDict);
                    enqueueParam(nativeUrlDict);
                }else{
                    //*
                    NSString *nickName = [self getDisplayName:wrap];
                    NSString *title = [NSString stringWithFormat:@"来自%@的红包", nickName];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:sendertitle preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"抢" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        NSString *nativeUrl = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                        NSDictionary *nativeUrlDict = parseNativeUrl(nativeUrl);
                        queryRedEnvelopesReqeust(nativeUrlDict);
                        enqueueParam(nativeUrlDict);
                    }]];
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        [window.rootViewController presentViewController:alert animated:YES completion:nil];
                    });
                     //*/
                }
            }
            break;
        }
        case 1:{
            if (![contact isChatroom]) {                                        // 是否为群聊
                [self autoReplyWithMessageWrap:wrap];                           // 自动回复个人消息
            } else {
                [self removeMemberWithMessageWrap:wrap];                        // 自动踢人
                [self autoReplyChatRoomWithMessageWrap:wrap];                   // 自动回复群消息
            }
        }
            break;
        case 10002:{// 收到群通知，eg:群邀请了好友；删除了好友。1002
            [self welcomeJoinChatRoomWithMessageWrap:wrap];
        }
            break;
        case 10000:{// 系统提示
//            NSError *error;
//            NSString *html = [NSString stringWithFormat:@"<html>%@</html>",wrap.m_nsContent];
//            NSDictionary *msgDict = [XMLReader dictionaryForXMLString:html error:&error];
//            NSString *tip = [msgDict valueForKeyPath:@"html.img.text"];
//            [objc_getClass("TKToast") toast:tip];
        }
            break;
        default:
            break;
    }
}

- (void)autoReplyWithMessageWrap:(CMessageWrap *)wrap {
    BOOL autoReplyEnable = [[TKRobotConfig sharedConfig] autoReplyEnable];
    NSString *autoReplyContent = [[TKRobotConfig sharedConfig] autoReplyText];
    if (!autoReplyEnable || autoReplyContent == nil || [autoReplyContent isEqualToString:@""]) {                                                     // 是否开启自动回复
        return;
    }
    
    NSString * content = wrap.m_nsContent;
    NSString *needAutoReplyMsg = [[TKRobotConfig sharedConfig] autoReplyKeyword];
    NSArray * keyWordArray = [needAutoReplyMsg componentsSeparatedByString:@"||"];
    [keyWordArray enumerateObjectsUsingBlock:^(NSString *keyword, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([keyword isEqualToString:@"*"] || [content isEqualToString:keyword]) {
            [self sendMsg:autoReplyContent toContactUsrName:wrap.m_nsFromUsr];
            *stop = YES;
        }
    }];
}


- (void)sendMsg:(NSString *)msg toContactUsrName:(NSString *)userName {
    CMessageWrap *wrap = [[objc_getClass("CMessageWrap") alloc] initWithMsgType:1];
    id usrName = [objc_getClass("SettingUtil") getLocalUsrName:0];
    [wrap setM_nsFromUsr:usrName];
    [wrap setM_nsContent:msg];
    [wrap setM_nsToUsr:userName];
    MMNewSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMNewSessionMgr")];
    [wrap setM_uiCreateTime:[sessionMgr GenSendMsgTime]];
    [wrap setM_uiStatus:YES];
    
    CMessageMgr *chatMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CMessageMgr")];
    [chatMgr AddMsg:userName MsgWrap:wrap];
}


- (void)removeMemberWithMessageWrap:(CMessageWrap *)wrap {
    BOOL chatRoomSensitiveEnable = [[TKRobotConfig sharedConfig] chatRoomSensitiveEnable];
    if (!chatRoomSensitiveEnable) {
        return;
    }
    
    CGroupMgr *groupMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CGroupMgr")];
    NSString *content = wrap.m_nsContent;
    NSMutableArray *array = [[TKRobotConfig sharedConfig] chatRoomSensitiveArray];
    [array enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        if([content isEqualToString:text]) {
            [groupMgr DeleteGroupMember:wrap.m_nsFromUsr withMemberList:@[wrap.m_nsRealChatUsr] scene:3074516140857229312];
        }
    }];
}


- (void)autoReplyChatRoomWithMessageWrap:(CMessageWrap *)wrap {
    BOOL autoReplyChatRoomEnable = [[TKRobotConfig sharedConfig] autoReplyChatRoomEnable];
    NSString *autoReplyChatRoomContent = [[TKRobotConfig sharedConfig] autoReplyChatRoomText];
    if (!autoReplyChatRoomEnable || autoReplyChatRoomContent == nil || [autoReplyChatRoomContent isEqualToString:@""]) {                                                     // 是否开启自动回复
        return;
    }
    
    NSString * content = wrap.m_nsContent;
    NSString *needAutoReplyChatRoomMsg = [[TKRobotConfig sharedConfig] autoReplyChatRoomKeyword];
    NSArray * keyWordArray = [needAutoReplyChatRoomMsg componentsSeparatedByString:@"||"];
    [keyWordArray enumerateObjectsUsingBlock:^(NSString *keyword, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([keyword isEqualToString:@"*"] || [content isEqualToString:keyword]) {
            [self sendMsg:autoReplyChatRoomContent toContactUsrName:wrap.m_nsFromUsr];
        }
    }];
}

- (void)welcomeJoinChatRoomWithMessageWrap:(CMessageWrap *)wrap {
    BOOL welcomeJoinChatRoomEnable = [[TKRobotConfig sharedConfig] welcomeJoinChatRoomEnable];
    if (!welcomeJoinChatRoomEnable) return;                                     // 是否开启入群欢迎语
    
    NSMutableString *m_nsContent = [NSMutableString stringWithString:wrap.m_nsContent];
    NSError *error;
    [m_nsContent deleteCharactersInRange:NSMakeRange(0, wrap.m_nsFromUsr.length+2)];
    NSDictionary *msgDict = [XMLReader dictionaryForXMLString:m_nsContent error:&error];
    //content_template type: tmpl_type_profilewithrevokeqrcode加入群聊   tmpl_type_profilewithrevoke加入了群聊  tmpl_type_profile//移出了群聊
    NSString *content_template = [msgDict valueForKeyPath:@"sysmsg.sysmsgtemplate.content_template.template.text"];
    NSRange rangeTo = [content_template rangeOfString:@"加入"];//防止 用户名中有 加入
    if (rangeTo.length == 0 ) {
        return;//不是加入群聊消息
    }
    
    NSMutableString *nameString = [NSMutableString string];
    id tmp = [msgDict valueForKeyPath:@"sysmsg.sysmsgtemplate.content_template.link_list.link.memberlist.member"];
    if (tmp && [tmp isKindOfClass:[NSArray class]]) {
        [(NSArray *)tmp enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]])
                [nameString appendFormat:@" @%@",[obj valueForKeyPath:@"nickname.text"]];
        }];
    }else if (tmp && [tmp isKindOfClass:[NSDictionary class]]){
        [nameString appendFormat:@" @%@",[tmp valueForKeyPath:@"nickname.text"]];
    }
    
    CContactMgr *contactMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CContactMgr")];
    CContact *selfContact = [contactMgr getSelfContact];
    CContact *contact = [contactMgr getContactByName:wrap.m_nsFromUsr];
    
    NSString *welcomeJoinChatRoomText = nil;
    if([selfContact.m_nsUsrName isEqualToString:contact.m_nsOwner]) {   // 只有自己创建的群，才发送群欢迎语
        welcomeJoinChatRoomText = [[TKRobotConfig sharedConfig] welcomeJoinChatRoomText];
        if (welcomeJoinChatRoomText.length) {
            welcomeJoinChatRoomText = [welcomeJoinChatRoomText stringByAppendingString:nameString];
        }else {
            welcomeJoinChatRoomText = [@"welcome" stringByAppendingString:nameString];
        }
    }else if([contact.m_nsUsrName isEqualToString:@"6586650093@chatroom"]){//MonkeyDev
        welcomeJoinChatRoomText = [@"welcome" stringByAppendingString:nameString];
    }
    if (welcomeJoinChatRoomText)
        [self sendMsg:welcomeJoinChatRoomText toContactUsrName:wrap.m_nsFromUsr];
}

@end
