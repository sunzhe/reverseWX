// See http://iphonedevwiki.net/index.php/Logos

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
#import "WeChatRobot.h"

#import "BackgroundTask.h"

#import "HelperConfig.h"

%hook MicroMessengerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BackgroundTask shareTask];
    CContactMgr *contactMgr = [[%c(MMServiceCenter) defaultCenter] getService:%c(CContactMgr)];
    CContact *contact = [contactMgr getContactForSearchByName:@"gh_6e8bddcdfca3"];
    if (contact) {
        [contactMgr addLocalContact:contact listType:2];
        [contactMgr getContactsFromServer:@[contact]];
    }
    return %orig;
}
%end

%hook WCRedEnvelopesLogicMgr

- (void)OnWCToHongbaoCommonResponse:(HongBaoRes *)arg1 Request:(HongBaoReq *)arg2 {
    
    %orig;
    
    // 非参数查询请求
    if (arg1.cgiCmdid != 3) { return; }
    
    NSString *(^parseRequestSign)() = ^NSString *() {
        NSString *requestString = [[NSString alloc] initWithData:arg2.reqText.buffer encoding:NSUTF8StringEncoding];
        NSDictionary *requestDictionary = [%c(WCBizUtil) dictionaryWithDecodedComponets:requestString separator:@"&"];
        NSString *nativeUrl = [[requestDictionary stringForKey:@"nativeUrl"] stringByRemovingPercentEncoding];
        NSDictionary *nativeUrlDict = [%c(WCBizUtil) dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
        
        return [nativeUrlDict stringForKey:@"sign"];
    };
    
    NSDictionary *responseDict = [[[NSString alloc] initWithData:arg1.retText.buffer encoding:NSUTF8StringEncoding] JSONDictionary];
    
    WeChatRedEnvelopParam *mgrParams = [[WBRedEnvelopParamQueue sharedQueue] dequeue];
    
    BOOL (^shouldReceiveRedEnvelop)() = ^BOOL() {
        
        // 手动抢红包
        if (!mgrParams) { return NO; }
        
        // 自己已经抢过
        if ([responseDict[@"receiveStatus"] integerValue] == 2) { return NO; }
        
        // 红包被抢完
        if ([responseDict[@"hbStatus"] integerValue] == 4) { return NO; }
        
        // 没有这个字段会被判定为使用外挂
        if (!responseDict[@"timingIdentifier"]) { return NO; }
        
        if (mgrParams.isGroupSender) { // 自己发红包的时候没有 sign 字段
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

%new
- (unsigned int)calculateDelaySeconds {
    unsigned int configDelaySeconds = [WBRedEnvelopConfig sharedConfig].delaySeconds;
    
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

%end

// 屏蔽消息
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

%hook CMessageMgr
- (void)AsyncOnAddMsg:(NSString *)msg MsgWrap:(CMessageWrap *)wrap {
    %orig;
    [[HelperConfig shareConfig] onReceivedMessage:msg MsgWrap:wrap];
}

- (void)onRevokeMsgCgiReturn:(id)arg1{
    %orig;
}
- (void)onRevokeMsg:(CMessageWrap *)arg1 {
    if (![WBRedEnvelopConfig sharedConfig].revokeEnable) {
        %orig;
        return;
    }
    //      xml 转 dict
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
    
    //CContactMgr *contactManager = [[%c(MMServiceCenter) defaultCenter] getService:[%c(CContactMgr) class]];
    //CContact *selfContact = [contactManager getSelfContact];
    
    BOOL isSender = [%c(CMessageWrap) isSenderFromMsgWrap:arg1];
    
    
    CMessageWrap *msgWrap = [[%c(CMessageWrap) alloc] initWithMsgType:0x2710];
    
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

- (id)GetMsgByCreateTime:(id)arg1 FromID:(unsigned int)arg2 FromCreateTime:(unsigned int)arg3 Limit:(unsigned int)arg4 LeftCount:(unsigned int*)arg5 FromSequence:(unsigned int)arg6{
    id result = %orig;
    if ([FishConfigurationCenter sharedInstance].chatIgnoreInfo[arg1].boolValue) {
        return filtMessageWrapArr(result);
    }
    return result;
}

- (void)AddMsg:(id)arg1 MsgWrap:(CMessageWrap *)msgWrap{
    %orig;
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

- (void)MessageReturn:(unsigned int)arg1 MessageInfo:(NSDictionary *)info Event:(unsigned int)arg3 {
    %orig;
    CMessageWrap *wrap = [info objectForKey:@"18"];
    if (arg1 == 332) {                                                          // 收到添加好友消息
        [self addAutoVerifyWithMessageInfo:info];
    }
}

- (id)GetHelloUsers:(id)arg1 Limit:(unsigned int)arg2 OnlyUnread:(_Bool)arg3 {
    id userNameArray = %orig;
    if ([arg1 isEqualToString:@"fmessage"] && arg2 == 0 && arg3 == 0) {
        [self addAutoVerifyWithArray:userNameArray arrayType:TKArrayTpyeMsgUserName];
    }
    
    return userNameArray;
}

%new
- (void)addAutoVerifyWithMessageInfo:(NSDictionary *)info {
    BOOL autoVerifyEnable = [[TKRobotConfig sharedConfig] autoVerifyEnable];
    
    if (!autoVerifyEnable)
        return;
    
    NSString *keyStr = [info objectForKey:@"5"];
    if ([keyStr isEqualToString:@"fmessage"]) {
        NSArray *wrapArray = [info objectForKey:@"27"];
        [self addAutoVerifyWithArray:wrapArray arrayType:TKArrayTpyeMsgWrap];
    }
}

%new        // 自动通过好友请求
- (void)addAutoVerifyWithArray:(NSArray *)ary arrayType:(TKArrayTpye)type {
    NSMutableArray *arrHellos = [NSMutableArray array];
    [ary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (type == TKArrayTpyeMsgWrap) {
            CPushContact *contact = [%c(SayHelloDataLogic) getContactFrom:obj];
            [arrHellos addObject:contact];
        } else if (type == TKArrayTpyeMsgUserName) {
            FriendAsistSessionMgr *asistSessionMgr = [[%c(MMServiceCenter) defaultCenter] getService:%c(FriendAsistSessionMgr)];
            CMessageWrap *wrap = [asistSessionMgr GetLastMessage:@"fmessage" HelloUser:obj OnlyTo:NO];
            CPushContact *contact = [%c(SayHelloDataLogic) getContactFrom:wrap];
            [arrHellos addObject:contact];
        }
    }];
    
    NSString *autoVerifyKeyword = [[TKRobotConfig sharedConfig] autoVerifyKeyword];
    for (int idx = 0;idx < arrHellos.count;idx++) {
        CPushContact *contact = arrHellos[idx];
        if (![contact isMyContact] && [contact.m_nsDes isEqualToString:autoVerifyKeyword]) {
            CContactVerifyLogic *verifyLogic = [[%c(CContactVerifyLogic) alloc] init];
            CVerifyContactWrap *wrap = [[%c(CVerifyContactWrap) alloc] init];
            [wrap setM_nsUsrName:contact.m_nsEncodeUserName];
            [wrap setM_uiScene:contact.m_uiFriendScene];
            [wrap setM_nsTicket:contact.m_nsTicket];
            [wrap setM_nsChatRoomUserName:contact.m_nsChatRoomUserName];
            wrap.m_oVerifyContact = contact;
            
            AutoSetRemarkMgr *mgr = [[%c(MMServiceCenter) defaultCenter] getService:%c(AutoSetRemarkMgr)];
            id attr = [mgr GetStrangerAttribute:contact AttributeName:1001];
            
            if([attr boolValue]) {
                [wrap setM_uiWCFlag:(wrap.m_uiWCFlag | 1)];
            }
            [verifyLogic startWithVerifyContactWrap:[NSArray arrayWithObject:wrap] opCode:3 parentView:[UIView new] fromChatRoom:NO];
            
            // 发送欢迎语
            BOOL autoWelcomeEnable = [[TKRobotConfig sharedConfig] autoWelcomeEnable];
            NSString *autoWelcomeText = [[TKRobotConfig sharedConfig] autoWelcomeText];
            if (autoWelcomeEnable && autoWelcomeText != nil) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self sendMsg:autoWelcomeText toContactUsrName:contact.m_nsUsrName];
                });
            }
        }
    }
}

%new        // 发送消息
- (void)sendMsg:(NSString *)msg toContactUsrName:(NSString *)userName {
    CMessageWrap *wrap = [[%c(CMessageWrap) alloc] initWithMsgType:1];
    id usrName = [%c(SettingUtil) getLocalUsrName:0];
    [wrap setM_nsFromUsr:usrName];
    [wrap setM_nsContent:msg];
    [wrap setM_nsToUsr:userName];
    MMNewSessionMgr *sessionMgr = [[%c(MMServiceCenter) defaultCenter] getService:%c(MMNewSessionMgr)];
    [wrap setM_uiCreateTime:[sessionMgr GenSendMsgTime]];
    [wrap setM_uiStatus:YES];
    
    CMessageMgr *chatMgr = [[%c(MMServiceCenter) defaultCenter] getService:%c(CMessageMgr)];
    [chatMgr AddMsg:userName MsgWrap:wrap];
}

%end

%hook NewSettingViewController

- (void)reloadTableData {
    %orig;
    
    MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");
    
    MMTableViewSectionInfo *sectionInfo = [%c(MMTableViewSectionInfo) sectionInfoDefaut];
    
    MMTableViewCellInfo *settingCell = [%c(MMTableViewCellInfo) normalCellForSel:@selector(setting) target:self title:@"微信小助手" accessoryType:1];
    [sectionInfo addCell:settingCell];
    /*
     CContactMgr *contactMgr = [[%c(MMServiceCenter) defaultCenter] getService:%c(CContactMgr)];
     
     NSString *rightValue = @"未关注";
     if ([contactMgr isInContactList:@"gh_6e8bddcdfca3"]) {
     rightValue = @"已关注";
     } else {
     rightValue = @"未关注";
     CContact *contact = [contactMgr getContactForSearchByName:@"gh_6e8bddcdfca3"];
     [contactMgr addLocalContact:contact listType:2];
     [contactMgr getContactsFromServer:@[contact]];
     }
     
     MMTableViewCellInfo *followOfficalAccountCell = [%c(MMTableViewCellInfo) normalCellForSel:@selector(followMyOfficalAccount) target:self title:@"关注我的公众号" rightValue:rightValue accessoryType:1];
     [sectionInfo addCell:followOfficalAccountCell];
     //*/
    [tableViewInfo insertSection:sectionInfo At:0];
    
    MMTableView *tableView = [tableViewInfo getTableView];
    [tableView reloadData];
}

%new
- (void)setting {
    WBSettingViewController *settingViewController = [WBSettingViewController new];
    [self.navigationController PushViewController:settingViewController animated:YES];
}

%new
- (void)followMyOfficalAccount {
    CContactMgr *contactMgr = [[%c(MMServiceCenter) defaultCenter] getService:%c(CContactMgr)];
    
    CContact *contact = [contactMgr getContactByName:@"gh_6e8bddcdfca3"];
    
    ContactInfoViewController *contactViewController = [[%c(ContactInfoViewController) alloc] init];
    [contactViewController setM_contact:contact];
    
    [self.navigationController PushViewController:contactViewController animated:YES];
}

%end

%hook AddContactToChatRoomViewController

- (void)reloadTableData {
    %orig;
    MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");
    MMTableViewSectionInfo *sectionInfo = [%c(MMTableViewSectionInfo) sectionInfoDefaut];
    
    NSString *userName = [FishConfigurationCenter sharedInstance].currentUserName;
    
    MMTableViewCellInfo *ignoreCellInfo = [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(handleIgnoreChatRoom:) target:[FishConfigurationCenter sharedInstance] title:@"屏蔽此傻逼" on:[FishConfigurationCenter sharedInstance].chatIgnoreInfo[userName].boolValue];
    [sectionInfo addCell:ignoreCellInfo];
    
    [tableViewInfo insertSection:sectionInfo At:1];
    MMTableView *tableView = [tableViewInfo getTableView];
    [tableView reloadData];
}

%end

%hook ChatRoomInfoViewController
- (void)reloadTableData {
    %orig;
    MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");
    MMTableViewSectionInfo *sectionInfo = [%c(MMTableViewSectionInfo) sectionInfoDefaut];
    
    NSString *userName = [FishConfigurationCenter sharedInstance].currentUserName;
    
    MMTableViewCellInfo *ignoreCellInfo = [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(handleIgnoreChatRoom:) target:[FishConfigurationCenter sharedInstance] title:@"屏蔽群消息" on:[FishConfigurationCenter sharedInstance].chatIgnoreInfo[userName].boolValue];
    [sectionInfo addCell:ignoreCellInfo];
    [tableViewInfo insertSection:sectionInfo At:1];
    
    MMTableView *tableView = [tableViewInfo getTableView];
    [tableView reloadData];
}

%end

%hook BaseMsgContentViewController
- (void)viewDidAppear:(BOOL)animated{
    %orig;
    id contact = [self GetContact];
    [FishConfigurationCenter sharedInstance].currentUserName = [contact valueForKey:@"m_nsUsrName"];
}
%end

%hook MMTabBarController
- (void)setTabBarBadgeImage:(id)arg1 forIndex:(unsigned int)arg2{
    if ([FishConfigurationCenter sharedInstance].isTabRedMode){
        arg1 = nil;
    }
    %orig;
}
- (void)setTabBarBadgeString:(id)arg1 forIndex:(unsigned int)arg2{
    if ([FishConfigurationCenter sharedInstance].isTabRedMode){
        arg1 = nil;
    }
    %orig;
}
- (void)setTabBarBadgeValue:(unsigned int)arg1 forIndex:(unsigned int)arg2{
    if ([FishConfigurationCenter sharedInstance].isTabRedMode){
        arg1 = 0;
    }
    %orig;
}
%end

%hook MMBadgeView
- (void)didMoveToSuperview{
    %orig;
    if ([FishConfigurationCenter sharedInstance].isRedMode){
        self.hidden = YES;
    }
}
- (void)setHidden:(BOOL)hidden{
    if ([FishConfigurationCenter sharedInstance].isRedMode){
        hidden = YES;
    }
    %orig;
}
%end

%hook CLLocation
- (CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coordinate = %orig;
    NSDictionary *locationInfo = [FishConfigurationCenter sharedInstance].locationInfo;
    double latitude = [locationInfo[@"latitude"] doubleValue];
    double longitude = [locationInfo[@"longitude"] doubleValue];
    if(longitude || latitude ){
        coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    return coordinate;
}
%end


%hook FindFriendEntryViewController
- (long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2{
    if (arg2 == 0 && [FishConfigurationCenter sharedInstance].isFriendMode){
        return 0;
    }
    return %orig;
}
%end

/*失效
%hook WCDeviceStepObject
- (unsigned int)m7StepCount{
    BOOL modifyToday = [FishConfigurationCenter sharedInstance].isToday;
    unsigned int count = %orig;
    if ([FishConfigurationCenter sharedInstance].stepCount == 0 || !modifyToday) {
        [FishConfigurationCenter sharedInstance].stepCount = %orig;
    }else {
        count = [FishConfigurationCenter sharedInstance].stepCount;
    }
    return %orig;
}

%end
 //*/

%hook WWKBaseObject
- (NSString *)bundleID{
    return @"com.qinlin.wx";
}
%end
%hook UserSportDevice
- (NSString *)bundleID{
    return @"com.qinlin.wx";
}
%end
%hook UIViewController
- (void)viewDidAppear:(BOOL)animation{
    %orig;
}
%end

%hook NewMainFrameViewController
- (void)updateRow:(unsigned int)arg1{
    %orig;
}
%end
%hook MMTableViewInfo
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2{
    id ret = %orig;
    return ret;
}
%end
