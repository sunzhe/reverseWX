#line 1 "/Users/admin/Documents/git/github/2/reverseWX/wx/wxDylib/wxDylib.xm"


#import <UIKit/UIKit.h>

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


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class WCDeviceStepObject; @class MMTabBarController; @class WCBizUtil; @class FindFriendEntryViewController; @class MMTableViewCellInfo; @class NewSettingViewController; @class CMessageMgr; @class BaseMsgContentViewController; @class MMTableViewSectionInfo; @class ChatRoomInfoViewController; @class MicroMessengerAppDelegate; @class MMBadgeView; @class ContactInfoViewController; @class CMessageWrap; @class CContactMgr; @class AddContactToChatRoomViewController; @class MMServiceCenter; @class CLLocation; @class WCRedEnvelopesLogicMgr; 
static BOOL (*_logos_orig$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *, NSDictionary *); static BOOL _logos_method$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *, NSDictionary *); static void (*_logos_orig$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$)(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST, SEL, HongBaoRes *, HongBaoReq *); static void _logos_method$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST, SEL, HongBaoRes *, HongBaoReq *); static unsigned int _logos_method$_ungrouped$WCRedEnvelopesLogicMgr$calculateDelaySeconds(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$)(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, NSString *, CMessageWrap *); static void _logos_method$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, NSString *, CMessageWrap *); static void (*_logos_orig$_ungrouped$CMessageMgr$onRevokeMsgCgiReturn$)(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$CMessageMgr$onRevokeMsgCgiReturn$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$CMessageMgr$onRevokeMsg$)(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, CMessageWrap *); static void _logos_method$_ungrouped$CMessageMgr$onRevokeMsg$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, CMessageWrap *); static id (*_logos_orig$_ungrouped$CMessageMgr$GetMsg$BizMsgClientID$)(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, id, id); static id _logos_method$_ungrouped$CMessageMgr$GetMsg$BizMsgClientID$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, id, id); static id (*_logos_orig$_ungrouped$CMessageMgr$GetMsgByCreateTime$FromID$FromCreateTime$Limit$LeftCount$FromSequence$)(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, id, unsigned int, unsigned int, unsigned int, unsigned int*, unsigned int); static id _logos_method$_ungrouped$CMessageMgr$GetMsgByCreateTime$FromID$FromCreateTime$Limit$LeftCount$FromSequence$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, id, unsigned int, unsigned int, unsigned int, unsigned int*, unsigned int); static void (*_logos_orig$_ungrouped$CMessageMgr$AddMsg$MsgWrap$)(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, id, CMessageWrap *); static void _logos_method$_ungrouped$CMessageMgr$AddMsg$MsgWrap$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, id, CMessageWrap *); static void (*_logos_orig$_ungrouped$NewSettingViewController$reloadTableData)(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$NewSettingViewController$reloadTableData(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$NewSettingViewController$setting(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$NewSettingViewController$followMyOfficalAccount(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$AddContactToChatRoomViewController$reloadTableData)(_LOGOS_SELF_TYPE_NORMAL AddContactToChatRoomViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$AddContactToChatRoomViewController$reloadTableData(_LOGOS_SELF_TYPE_NORMAL AddContactToChatRoomViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$ChatRoomInfoViewController$reloadTableData)(_LOGOS_SELF_TYPE_NORMAL ChatRoomInfoViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$ChatRoomInfoViewController$reloadTableData(_LOGOS_SELF_TYPE_NORMAL ChatRoomInfoViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$BaseMsgContentViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL BaseMsgContentViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$BaseMsgContentViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL BaseMsgContentViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$MMTabBarController$setTabBarBadgeImage$forIndex$)(_LOGOS_SELF_TYPE_NORMAL MMTabBarController* _LOGOS_SELF_CONST, SEL, id, unsigned int); static void _logos_method$_ungrouped$MMTabBarController$setTabBarBadgeImage$forIndex$(_LOGOS_SELF_TYPE_NORMAL MMTabBarController* _LOGOS_SELF_CONST, SEL, id, unsigned int); static void (*_logos_orig$_ungrouped$MMTabBarController$setTabBarBadgeString$forIndex$)(_LOGOS_SELF_TYPE_NORMAL MMTabBarController* _LOGOS_SELF_CONST, SEL, id, unsigned int); static void _logos_method$_ungrouped$MMTabBarController$setTabBarBadgeString$forIndex$(_LOGOS_SELF_TYPE_NORMAL MMTabBarController* _LOGOS_SELF_CONST, SEL, id, unsigned int); static void (*_logos_orig$_ungrouped$MMTabBarController$setTabBarBadgeValue$forIndex$)(_LOGOS_SELF_TYPE_NORMAL MMTabBarController* _LOGOS_SELF_CONST, SEL, unsigned int, unsigned int); static void _logos_method$_ungrouped$MMTabBarController$setTabBarBadgeValue$forIndex$(_LOGOS_SELF_TYPE_NORMAL MMTabBarController* _LOGOS_SELF_CONST, SEL, unsigned int, unsigned int); static void (*_logos_orig$_ungrouped$MMBadgeView$didMoveToSuperview)(_LOGOS_SELF_TYPE_NORMAL MMBadgeView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$MMBadgeView$didMoveToSuperview(_LOGOS_SELF_TYPE_NORMAL MMBadgeView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$MMBadgeView$setHidden$)(_LOGOS_SELF_TYPE_NORMAL MMBadgeView* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$MMBadgeView$setHidden$(_LOGOS_SELF_TYPE_NORMAL MMBadgeView* _LOGOS_SELF_CONST, SEL, BOOL); static CLLocationCoordinate2D (*_logos_orig$_ungrouped$CLLocation$coordinate)(_LOGOS_SELF_TYPE_NORMAL CLLocation* _LOGOS_SELF_CONST, SEL); static CLLocationCoordinate2D _logos_method$_ungrouped$CLLocation$coordinate(_LOGOS_SELF_TYPE_NORMAL CLLocation* _LOGOS_SELF_CONST, SEL); static long long (*_logos_orig$_ungrouped$FindFriendEntryViewController$tableView$numberOfRowsInSection$)(_LOGOS_SELF_TYPE_NORMAL FindFriendEntryViewController* _LOGOS_SELF_CONST, SEL, id, long long); static long long _logos_method$_ungrouped$FindFriendEntryViewController$tableView$numberOfRowsInSection$(_LOGOS_SELF_TYPE_NORMAL FindFriendEntryViewController* _LOGOS_SELF_CONST, SEL, id, long long); static unsigned int (*_logos_orig$_ungrouped$WCDeviceStepObject$m7StepCount)(_LOGOS_SELF_TYPE_NORMAL WCDeviceStepObject* _LOGOS_SELF_CONST, SEL); static unsigned int _logos_method$_ungrouped$WCDeviceStepObject$m7StepCount(_LOGOS_SELF_TYPE_NORMAL WCDeviceStepObject* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MMServiceCenter(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MMServiceCenter"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MMTableViewCellInfo(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MMTableViewCellInfo"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WCBizUtil(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WCBizUtil"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MMTableViewSectionInfo(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MMTableViewSectionInfo"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CContactMgr(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CContactMgr"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$ContactInfoViewController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("ContactInfoViewController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CMessageWrap(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CMessageWrap"); } return _klass; }
#line 17 "/Users/admin/Documents/git/github/2/reverseWX/wx/wxDylib/wxDylib.xm"


static BOOL _logos_method$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIApplication * application, NSDictionary * launchOptions) {
  		
    CContactMgr *contactMgr = [[_logos_static_class_lookup$MMServiceCenter() defaultCenter] getService:_logos_static_class_lookup$CContactMgr()];
    CContact *contact = [contactMgr getContactForSearchByName:@"gh_6e8bddcdfca3"];
    if (contact) {
        [contactMgr addLocalContact:contact listType:2];
        [contactMgr getContactsFromServer:@[contact]];
    }
    return _logos_orig$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$(self, _cmd, application, launchOptions);
}




static void _logos_method$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, HongBaoRes * arg1, HongBaoReq * arg2) {
    
    _logos_orig$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$(self, _cmd, arg1, arg2);
    
    
    if (arg1.cgiCmdid != 3) { return; }
    
    NSString *(^parseRequestSign)() = ^NSString *() {
        NSString *requestString = [[NSString alloc] initWithData:arg2.reqText.buffer encoding:NSUTF8StringEncoding];
        NSDictionary *requestDictionary = [_logos_static_class_lookup$WCBizUtil() dictionaryWithDecodedComponets:requestString separator:@"&"];
        NSString *nativeUrl = [[requestDictionary stringForKey:@"nativeUrl"] stringByRemovingPercentEncoding];
        NSDictionary *nativeUrlDict = [_logos_static_class_lookup$WCBizUtil() dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
        
        return [nativeUrlDict stringForKey:@"sign"];
    };
    
    NSDictionary *responseDict = [[[NSString alloc] initWithData:arg1.retText.buffer encoding:NSUTF8StringEncoding] JSONDictionary];
    
    WeChatRedEnvelopParam *mgrParams = [[WBRedEnvelopParamQueue sharedQueue] dequeue];
    
    BOOL (^shouldReceiveRedEnvelop)() = ^BOOL() {
        
        
        if (!mgrParams) { return NO; }
        
        
        if ([responseDict[@"receiveStatus"] integerValue] == 2) { return NO; }
        
        
        if ([responseDict[@"hbStatus"] integerValue] == 4) { return NO; }
        
        
        if (!responseDict[@"timingIdentifier"]) { return NO; }
        
        if (mgrParams.isGroupSender) { 
            return [WBRedEnvelopConfig sharedConfig].autoReceiveEnable;
        } else {
            return [parseRequestSign() isEqualToString:mgrParams.sign] && [WBRedEnvelopConfig sharedConfig].autoReceiveEnable;
        }
    };
    
    if (shouldReceiveRedEnvelop()) {
        mgrParams.timingIdentifier = responseDict[@"timingIdentifier"];
        
        unsigned int delaySeconds = [self calculateDelaySeconds];
        WBReceiveRedEnvelopOperation *operation = [[WBReceiveRedEnvelopOperation alloc] initWithRedEnvelopParam:mgrParams delay:delaySeconds];
        
        if ([WBRedEnvelopConfig sharedConfig].serialReceive) {
            [[WBRedEnvelopTaskManager sharedManager] addSerialTask:operation];
        } else {
            [[WBRedEnvelopTaskManager sharedManager] addNormalTask:operation];
        }
    }
}


static unsigned int _logos_method$_ungrouped$WCRedEnvelopesLogicMgr$calculateDelaySeconds(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSInteger configDelaySeconds = [WBRedEnvelopConfig sharedConfig].delaySeconds;
    
    if ([WBRedEnvelopConfig sharedConfig].serialReceive) {
        unsigned int serialDelaySeconds;
        if ([WBRedEnvelopTaskManager sharedManager].serialQueueIsEmpty) {
            serialDelaySeconds = configDelaySeconds;
        } else {
            serialDelaySeconds = 15;
        }
        
        return serialDelaySeconds;
    } else {
        return (unsigned int)configDelaySeconds;
    }
}




NSMutableArray * filtMessageWrapArr(NSMutableArray *msgList) {
    NSMutableArray *msgListResult = [msgList mutableCopy];
    for (id msgWrap in msgList) {
        Ivar nsFromUsrIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsFromUsr");
        NSString *m_nsFromUsr = object_getIvar(msgWrap, nsFromUsrIvar);
        if ([FishConfigurationCenter sharedInstance].chatIgnoreInfo[m_nsFromUsr].boolValue) {
            [msgListResult removeObject:msgWrap];
        }
    }
    return msgListResult;
}


static void _logos_method$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * msg, CMessageWrap * wrap) {
    _logos_orig$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$(self, _cmd, msg, wrap);
    
    switch(wrap.m_uiMessageType) {
        case 49: { 
            
            
            BOOL (^isRedEnvelopMessage)() = ^BOOL() {
                return [wrap.m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound;
            };
            
            if (isRedEnvelopMessage()) { 
                CContactMgr *contactManager = [[_logos_static_class_lookup$MMServiceCenter() defaultCenter] getService:[_logos_static_class_lookup$CContactMgr() class]];
                CContact *selfContact = [contactManager getSelfContact];
                
                BOOL (^isSender)() = ^BOOL() {
                    return [wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName];
                };
                
                
                BOOL (^isGroupReceiver)() = ^BOOL() {
                    return [wrap.m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound;
                };
                
                
                BOOL (^isGroupSender)() = ^BOOL() {
                    return isSender() && [wrap.m_nsToUsr rangeOfString:@"chatroom"].location != NSNotFound;
                };
                
                
                BOOL (^isReceiveSelfRedEnvelop)() = ^BOOL() {
                    return [WBRedEnvelopConfig sharedConfig].receiveSelfRedEnvelop;
                };
                
                
                BOOL (^isGroupInBlackList)() = ^BOOL() {
                    return [[WBRedEnvelopConfig sharedConfig].blackList containsObject:wrap.m_nsFromUsr];
                };
                
                
                BOOL (^shouldReceiveRedEnvelop)() = ^BOOL() {
                    if (![WBRedEnvelopConfig sharedConfig].autoReceiveEnable) { return NO; }
                    if (isGroupInBlackList()) { return NO; }
                    
                    return isGroupReceiver() || (isGroupSender() && isReceiveSelfRedEnvelop());
                };
                
                NSDictionary *(^parseNativeUrl)(NSString *nativeUrl) = ^(NSString *nativeUrl) {
                    nativeUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
                    return [_logos_static_class_lookup$WCBizUtil() dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
                };
                
                
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
                }
            }
            break;
        }
        default:
            break;
    }
    
}

static void _logos_method$_ungrouped$CMessageMgr$onRevokeMsgCgiReturn$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    _logos_orig$_ungrouped$CMessageMgr$onRevokeMsgCgiReturn$(self, _cmd, arg1);
}
static void _logos_method$_ungrouped$CMessageMgr$onRevokeMsg$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CMessageWrap * arg1) {
    if (![WBRedEnvelopConfig sharedConfig].revokeEnable) {
        _logos_orig$_ungrouped$CMessageMgr$onRevokeMsg$(self, _cmd, arg1);
        return;
    }
    
    NSError *error;
    NSDictionary *msgDict = [XMLReader dictionaryForXMLString:arg1.m_nsContent error:&error];
    
    NSString *session = [msgDict valueForKeyPath:@"sysmsg.revokemsg.session.text"];
    NSString *newmsgid = [msgDict valueForKeyPath:@"sysmsg.revokemsg.newmsgid.text"];
    NSString *replacemsg = [msgDict valueForKeyPath:@"sysmsg.revokemsg.replacemsg.text"];
    
    if(error || !session || !newmsgid){
        return;
    }
    
    CMessageWrap *theMsg = [self GetMsg:session n64SvrID:[newmsgid longLongValue]];
    if(!theMsg){
        theMsg = [self GetRevokeMsgBySvrId:[newmsgid longLongValue]];
    }
    
    
    
    
    BOOL isSender = [_logos_static_class_lookup$CMessageWrap() isSenderFromMsgWrap:arg1];
    
    
    CMessageWrap *msgWrap = [[_logos_static_class_lookup$CMessageWrap() alloc] initWithMsgType:0x2710];

    NSString *sendContent = replacemsg;
    
    if (isSender) {
        [msgWrap setM_nsFromUsr:arg1.m_nsToUsr];
        [msgWrap setM_nsToUsr:arg1.m_nsFromUsr];
        
        if (theMsg && theMsg.m_uiMessageType == 1) {
            sendContent = [NSString stringWithFormat:@"你撤回一条消息:\n%@", theMsg.m_nsContent];
        }
    } else {
        
        [msgWrap setM_nsToUsr:arg1.m_nsToUsr];
        [msgWrap setM_nsFromUsr:arg1.m_nsFromUsr];
        
        if (theMsg){
            NSString *name = [replacemsg stringByReplacingOccurrencesOfString:@"撤回了一条消息" withString:@""];
            if (theMsg.m_uiMessageType == 1) {
                sendContent = [NSString stringWithFormat:@"拦截%@的一条撤回消息:\n%@", name, theMsg.m_nsContent];
            }else{
                sendContent = [NSString stringWithFormat:@"拦截%@的一条非文本撤回消息", name];
            }
        }
    }
    NSLog(@"撤回消息 = %@", sendContent);
    [msgWrap setM_uiStatus:0x4];
    [msgWrap setM_nsContent:sendContent];
    [msgWrap setM_uiCreateTime:[arg1 m_uiCreateTime]];
    [self AddLocalMsg:session MsgWrap:msgWrap fixTime:0x1 NewMsgArriveNotify:0x0];
}

static id _logos_method$_ungrouped$CMessageMgr$GetMsg$BizMsgClientID$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2){
    id result = _logos_orig$_ungrouped$CMessageMgr$GetMsg$BizMsgClientID$(self, _cmd, arg1, arg2);
    return result;
}

static id _logos_method$_ungrouped$CMessageMgr$GetMsgByCreateTime$FromID$FromCreateTime$Limit$LeftCount$FromSequence$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4, unsigned int* arg5, unsigned int arg6){
    id result = _logos_orig$_ungrouped$CMessageMgr$GetMsgByCreateTime$FromID$FromCreateTime$Limit$LeftCount$FromSequence$(self, _cmd, arg1, arg2, arg3, arg4, arg5, arg6);
    if ([FishConfigurationCenter sharedInstance].chatIgnoreInfo[arg1].boolValue) {
        return filtMessageWrapArr(result);
    }
    return result;
}

static void _logos_method$_ungrouped$CMessageMgr$AddMsg$MsgWrap$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, CMessageWrap * msgWrap){
    _logos_orig$_ungrouped$CMessageMgr$AddMsg$MsgWrap$(self, _cmd, arg1, msgWrap);
    NSString* content = [msgWrap m_nsContent];
    NSLog(@"发送消息: %@", content);
    
    NSString *key = @"记步";
    if ([content hasPrefix:key]){
        NSString *tmp = [content stringByReplacingOccurrencesOfString:key withString:@""];
        [FishConfigurationCenter sharedInstance].stepCount = tmp.integerValue;
    }
    
    if ([content isEqualToString:@"开启默认位置"]){
        [FishConfigurationCenter sharedInstance].defaultAddressMode = YES;
    }else if ([content isEqualToString:@"关闭默认位置"]){
        [FishConfigurationCenter sharedInstance].defaultAddressMode = NO;
    }else if ([content isEqualToString:@"更改定位"]){
        [[MapView shareMapView] show];
    }
}





static void _logos_method$_ungrouped$NewSettingViewController$reloadTableData(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$NewSettingViewController$reloadTableData(self, _cmd);
    
    MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");
    
    MMTableViewSectionInfo *sectionInfo = [_logos_static_class_lookup$MMTableViewSectionInfo() sectionInfoDefaut];
    
    MMTableViewCellInfo *settingCell = [_logos_static_class_lookup$MMTableViewCellInfo() normalCellForSel:@selector(setting) target:self title:@"微信小助手" accessoryType:1];
    [sectionInfo addCell:settingCell];
    















    [tableViewInfo insertSection:sectionInfo At:0];
    
    MMTableView *tableView = [tableViewInfo getTableView];
    [tableView reloadData];
}


static void _logos_method$_ungrouped$NewSettingViewController$setting(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    WBSettingViewController *settingViewController = [WBSettingViewController new];
    [self.navigationController PushViewController:settingViewController animated:YES];
}


static void _logos_method$_ungrouped$NewSettingViewController$followMyOfficalAccount(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    CContactMgr *contactMgr = [[_logos_static_class_lookup$MMServiceCenter() defaultCenter] getService:_logos_static_class_lookup$CContactMgr()];
    
    CContact *contact = [contactMgr getContactByName:@"gh_6e8bddcdfca3"];
    
    ContactInfoViewController *contactViewController = [[_logos_static_class_lookup$ContactInfoViewController() alloc] init];
    [contactViewController setM_contact:contact];
    
    [self.navigationController PushViewController:contactViewController animated:YES]; 
}





static void _logos_method$_ungrouped$AddContactToChatRoomViewController$reloadTableData(_LOGOS_SELF_TYPE_NORMAL AddContactToChatRoomViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$AddContactToChatRoomViewController$reloadTableData(self, _cmd);
    MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");
    MMTableViewSectionInfo *sectionInfo = [_logos_static_class_lookup$MMTableViewSectionInfo() sectionInfoDefaut];
    
    NSString *userName = [FishConfigurationCenter sharedInstance].currentUserName;
    
    MMTableViewCellInfo *ignoreCellInfo = [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(handleIgnoreChatRoom:) target:[FishConfigurationCenter sharedInstance] title:@"屏蔽此傻逼" on:[FishConfigurationCenter sharedInstance].chatIgnoreInfo[userName].boolValue];
    [sectionInfo addCell:ignoreCellInfo];
    
    [tableViewInfo insertSection:sectionInfo At:1];
    MMTableView *tableView = [tableViewInfo getTableView];
    [tableView reloadData];
}




static void _logos_method$_ungrouped$ChatRoomInfoViewController$reloadTableData(_LOGOS_SELF_TYPE_NORMAL ChatRoomInfoViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$ChatRoomInfoViewController$reloadTableData(self, _cmd);
    MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");
    MMTableViewSectionInfo *sectionInfo = [_logos_static_class_lookup$MMTableViewSectionInfo() sectionInfoDefaut];
    
    NSString *userName = [FishConfigurationCenter sharedInstance].currentUserName;
    
    MMTableViewCellInfo *ignoreCellInfo = [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(handleIgnoreChatRoom:) target:[FishConfigurationCenter sharedInstance] title:@"屏蔽群消息" on:[FishConfigurationCenter sharedInstance].chatIgnoreInfo[userName].boolValue];
    [sectionInfo addCell:ignoreCellInfo];
    [tableViewInfo insertSection:sectionInfo At:1];
    
    MMTableView *tableView = [tableViewInfo getTableView];
    [tableView reloadData];
}
                               



static void _logos_method$_ungrouped$BaseMsgContentViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL BaseMsgContentViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated){
    _logos_orig$_ungrouped$BaseMsgContentViewController$viewDidAppear$(self, _cmd, animated);
    id contact = [self GetContact];
    [FishConfigurationCenter sharedInstance].currentUserName = [contact valueForKey:@"m_nsUsrName"];
}



static void _logos_method$_ungrouped$MMTabBarController$setTabBarBadgeImage$forIndex$(_LOGOS_SELF_TYPE_NORMAL MMTabBarController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, unsigned int arg2){
    if ([FishConfigurationCenter sharedInstance].isRedMode){
        arg1 = nil;
    }
    _logos_orig$_ungrouped$MMTabBarController$setTabBarBadgeImage$forIndex$(self, _cmd, arg1, arg2);
}
static void _logos_method$_ungrouped$MMTabBarController$setTabBarBadgeString$forIndex$(_LOGOS_SELF_TYPE_NORMAL MMTabBarController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, unsigned int arg2){
    if ([FishConfigurationCenter sharedInstance].isRedMode){
        arg1 = nil;
    }
    _logos_orig$_ungrouped$MMTabBarController$setTabBarBadgeString$forIndex$(self, _cmd, arg1, arg2);
}
static void _logos_method$_ungrouped$MMTabBarController$setTabBarBadgeValue$forIndex$(_LOGOS_SELF_TYPE_NORMAL MMTabBarController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, unsigned int arg1, unsigned int arg2){
    if ([FishConfigurationCenter sharedInstance].isRedMode){
        arg1 = 0;
    }
    _logos_orig$_ungrouped$MMTabBarController$setTabBarBadgeValue$forIndex$(self, _cmd, arg1, arg2);
}



static void _logos_method$_ungrouped$MMBadgeView$didMoveToSuperview(_LOGOS_SELF_TYPE_NORMAL MMBadgeView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    _logos_orig$_ungrouped$MMBadgeView$didMoveToSuperview(self, _cmd);
    if ([FishConfigurationCenter sharedInstance].isRedMode){
        self.hidden = YES;
    }
}
static void _logos_method$_ungrouped$MMBadgeView$setHidden$(_LOGOS_SELF_TYPE_NORMAL MMBadgeView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL hidden){
    if ([FishConfigurationCenter sharedInstance].isRedMode){
        hidden = YES;
    }
    _logos_orig$_ungrouped$MMBadgeView$setHidden$(self, _cmd, hidden);
}






















static CLLocationCoordinate2D _logos_method$_ungrouped$CLLocation$coordinate(_LOGOS_SELF_TYPE_NORMAL CLLocation* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    CLLocationCoordinate2D coordinate = _logos_orig$_ungrouped$CLLocation$coordinate(self, _cmd);
    NSDictionary *locationInfo = [FishConfigurationCenter sharedInstance].locationInfo;
    double latitude = [locationInfo[@"latitude"] doubleValue];
    double longitude = [locationInfo[@"longitude"] doubleValue];
    if(longitude || latitude ){
        coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    return coordinate;
}




static long long _logos_method$_ungrouped$FindFriendEntryViewController$tableView$numberOfRowsInSection$(_LOGOS_SELF_TYPE_NORMAL FindFriendEntryViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, long long arg2){
    if (arg2 == 0 && [FishConfigurationCenter sharedInstance].isFriendMode){
        return 0;
    }
    return _logos_orig$_ungrouped$FindFriendEntryViewController$tableView$numberOfRowsInSection$(self, _cmd, arg1, arg2);
}



static unsigned int _logos_method$_ungrouped$WCDeviceStepObject$m7StepCount(_LOGOS_SELF_TYPE_NORMAL WCDeviceStepObject* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
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
        [FishConfigurationCenter sharedInstance].stepCount = _logos_orig$_ungrouped$WCDeviceStepObject$m7StepCount(self, _cmd);
    }
    return (unsigned int)[FishConfigurationCenter sharedInstance].stepCount;
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$MicroMessengerAppDelegate = objc_getClass("MicroMessengerAppDelegate"); MSHookMessageEx(_logos_class$_ungrouped$MicroMessengerAppDelegate, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$);Class _logos_class$_ungrouped$WCRedEnvelopesLogicMgr = objc_getClass("WCRedEnvelopesLogicMgr"); MSHookMessageEx(_logos_class$_ungrouped$WCRedEnvelopesLogicMgr, @selector(OnWCToHongbaoCommonResponse:Request:), (IMP)&_logos_method$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$, (IMP*)&_logos_orig$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'I'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$WCRedEnvelopesLogicMgr, @selector(calculateDelaySeconds), (IMP)&_logos_method$_ungrouped$WCRedEnvelopesLogicMgr$calculateDelaySeconds, _typeEncoding); }Class _logos_class$_ungrouped$CMessageMgr = objc_getClass("CMessageMgr"); MSHookMessageEx(_logos_class$_ungrouped$CMessageMgr, @selector(AsyncOnAddMsg:MsgWrap:), (IMP)&_logos_method$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$, (IMP*)&_logos_orig$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$);MSHookMessageEx(_logos_class$_ungrouped$CMessageMgr, @selector(onRevokeMsgCgiReturn:), (IMP)&_logos_method$_ungrouped$CMessageMgr$onRevokeMsgCgiReturn$, (IMP*)&_logos_orig$_ungrouped$CMessageMgr$onRevokeMsgCgiReturn$);MSHookMessageEx(_logos_class$_ungrouped$CMessageMgr, @selector(onRevokeMsg:), (IMP)&_logos_method$_ungrouped$CMessageMgr$onRevokeMsg$, (IMP*)&_logos_orig$_ungrouped$CMessageMgr$onRevokeMsg$);MSHookMessageEx(_logos_class$_ungrouped$CMessageMgr, @selector(GetMsg:BizMsgClientID:), (IMP)&_logos_method$_ungrouped$CMessageMgr$GetMsg$BizMsgClientID$, (IMP*)&_logos_orig$_ungrouped$CMessageMgr$GetMsg$BizMsgClientID$);MSHookMessageEx(_logos_class$_ungrouped$CMessageMgr, @selector(GetMsgByCreateTime:FromID:FromCreateTime:Limit:LeftCount:FromSequence:), (IMP)&_logos_method$_ungrouped$CMessageMgr$GetMsgByCreateTime$FromID$FromCreateTime$Limit$LeftCount$FromSequence$, (IMP*)&_logos_orig$_ungrouped$CMessageMgr$GetMsgByCreateTime$FromID$FromCreateTime$Limit$LeftCount$FromSequence$);MSHookMessageEx(_logos_class$_ungrouped$CMessageMgr, @selector(AddMsg:MsgWrap:), (IMP)&_logos_method$_ungrouped$CMessageMgr$AddMsg$MsgWrap$, (IMP*)&_logos_orig$_ungrouped$CMessageMgr$AddMsg$MsgWrap$);Class _logos_class$_ungrouped$NewSettingViewController = objc_getClass("NewSettingViewController"); MSHookMessageEx(_logos_class$_ungrouped$NewSettingViewController, @selector(reloadTableData), (IMP)&_logos_method$_ungrouped$NewSettingViewController$reloadTableData, (IMP*)&_logos_orig$_ungrouped$NewSettingViewController$reloadTableData);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$NewSettingViewController, @selector(setting), (IMP)&_logos_method$_ungrouped$NewSettingViewController$setting, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$NewSettingViewController, @selector(followMyOfficalAccount), (IMP)&_logos_method$_ungrouped$NewSettingViewController$followMyOfficalAccount, _typeEncoding); }Class _logos_class$_ungrouped$AddContactToChatRoomViewController = objc_getClass("AddContactToChatRoomViewController"); MSHookMessageEx(_logos_class$_ungrouped$AddContactToChatRoomViewController, @selector(reloadTableData), (IMP)&_logos_method$_ungrouped$AddContactToChatRoomViewController$reloadTableData, (IMP*)&_logos_orig$_ungrouped$AddContactToChatRoomViewController$reloadTableData);Class _logos_class$_ungrouped$ChatRoomInfoViewController = objc_getClass("ChatRoomInfoViewController"); MSHookMessageEx(_logos_class$_ungrouped$ChatRoomInfoViewController, @selector(reloadTableData), (IMP)&_logos_method$_ungrouped$ChatRoomInfoViewController$reloadTableData, (IMP*)&_logos_orig$_ungrouped$ChatRoomInfoViewController$reloadTableData);Class _logos_class$_ungrouped$BaseMsgContentViewController = objc_getClass("BaseMsgContentViewController"); MSHookMessageEx(_logos_class$_ungrouped$BaseMsgContentViewController, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$BaseMsgContentViewController$viewDidAppear$, (IMP*)&_logos_orig$_ungrouped$BaseMsgContentViewController$viewDidAppear$);Class _logos_class$_ungrouped$MMTabBarController = objc_getClass("MMTabBarController"); MSHookMessageEx(_logos_class$_ungrouped$MMTabBarController, @selector(setTabBarBadgeImage:forIndex:), (IMP)&_logos_method$_ungrouped$MMTabBarController$setTabBarBadgeImage$forIndex$, (IMP*)&_logos_orig$_ungrouped$MMTabBarController$setTabBarBadgeImage$forIndex$);MSHookMessageEx(_logos_class$_ungrouped$MMTabBarController, @selector(setTabBarBadgeString:forIndex:), (IMP)&_logos_method$_ungrouped$MMTabBarController$setTabBarBadgeString$forIndex$, (IMP*)&_logos_orig$_ungrouped$MMTabBarController$setTabBarBadgeString$forIndex$);MSHookMessageEx(_logos_class$_ungrouped$MMTabBarController, @selector(setTabBarBadgeValue:forIndex:), (IMP)&_logos_method$_ungrouped$MMTabBarController$setTabBarBadgeValue$forIndex$, (IMP*)&_logos_orig$_ungrouped$MMTabBarController$setTabBarBadgeValue$forIndex$);Class _logos_class$_ungrouped$MMBadgeView = objc_getClass("MMBadgeView"); MSHookMessageEx(_logos_class$_ungrouped$MMBadgeView, @selector(didMoveToSuperview), (IMP)&_logos_method$_ungrouped$MMBadgeView$didMoveToSuperview, (IMP*)&_logos_orig$_ungrouped$MMBadgeView$didMoveToSuperview);MSHookMessageEx(_logos_class$_ungrouped$MMBadgeView, @selector(setHidden:), (IMP)&_logos_method$_ungrouped$MMBadgeView$setHidden$, (IMP*)&_logos_orig$_ungrouped$MMBadgeView$setHidden$);Class _logos_class$_ungrouped$CLLocation = objc_getClass("CLLocation"); MSHookMessageEx(_logos_class$_ungrouped$CLLocation, @selector(coordinate), (IMP)&_logos_method$_ungrouped$CLLocation$coordinate, (IMP*)&_logos_orig$_ungrouped$CLLocation$coordinate);Class _logos_class$_ungrouped$FindFriendEntryViewController = objc_getClass("FindFriendEntryViewController"); MSHookMessageEx(_logos_class$_ungrouped$FindFriendEntryViewController, @selector(tableView:numberOfRowsInSection:), (IMP)&_logos_method$_ungrouped$FindFriendEntryViewController$tableView$numberOfRowsInSection$, (IMP*)&_logos_orig$_ungrouped$FindFriendEntryViewController$tableView$numberOfRowsInSection$);Class _logos_class$_ungrouped$WCDeviceStepObject = objc_getClass("WCDeviceStepObject"); MSHookMessageEx(_logos_class$_ungrouped$WCDeviceStepObject, @selector(m7StepCount), (IMP)&_logos_method$_ungrouped$WCDeviceStepObject$m7StepCount, (IMP*)&_logos_orig$_ungrouped$WCDeviceStepObject$m7StepCount);} }
#line 515 "/Users/admin/Documents/git/github/2/reverseWX/wx/wxDylib/wxDylib.xm"
