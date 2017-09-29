//
//  WBSettingViewController.m
//  WeChatRedEnvelop
//
//  Created by 杨志超 on 2017/2/22.
//  Copyright © 2017年 swiftyper. All rights reserved.
//

#import "WBSettingViewController.h"
#import "WeChatRedEnvelop.h"
#import "WBRedEnvelopConfig.h"
#import <objc/runtime.h>
#import "WBMultiSelectGroupsViewController.h"
#import "FishConfigurationCenter.h"
#import "MapView.h"
#import "TKSettingViewController.h"

#import "FLEXManager.h"
@interface WBSettingViewController () <MultiSelectGroupsViewControllerDelegate>

@property (nonatomic, strong) MMTableViewInfo *tableViewInfo;

@end

@implementation WBSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _tableViewInfo = [[objc_getClass("MMTableViewInfo") alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MMTableView *tableView = [self.tableViewInfo getTableView];
    //*
    CGRect rect = self.view.bounds;
    rect.origin.y = 64;
    rect.size.height -= rect.origin.y;
    tableView.frame = rect;
     //*/
    [self.view addSubview:tableView];
    
    
    [self initTitle];
    [self reloadTableData];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopLoading];
}

- (void)initTitle {
    self.title = @"微信小助手";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]}];
}

- (void)reloadTableData {
    [self.tableViewInfo clearAllSection];
    
    [self addBasicSettingSection];
    
    [self addAdvanceSettingSection];
    
    [self addSupportSection];
    /*
    CContactMgr *contactMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CContactMgr")];
    if ([contactMgr isInContactList:@"gh_6e8bddcdfca3"]) {
        [self addAdvanceSettingSection];
    } else {
        [self addAdvanceLimitSection];
    }
    [self addAboutSection];
    //*/
    
    MMTableView *tableView = [self.tableViewInfo getTableView];
    [tableView reloadData];
}

#pragma mark - BasicSetting

- (void)addBasicSettingSection {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoHeader:@"红包功能"];
    
    [sectionInfo addCell:[self createAutoReceiveRedEnvelopCell]];
    [sectionInfo addCell:[self createDelaySettingCell]];
    [sectionInfo addCell:[self createReceiveSelfRedEnvelopCell]];
    [sectionInfo addCell:[self createQueueCell]];
    [sectionInfo addCell:[self createBlackListCell]];
    [self.tableViewInfo addSection:sectionInfo];
}


- (MMTableViewCellInfo *)createAutoReceiveRedEnvelopCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(switchRedEnvelop:) target:self title:@"自动抢红包" on:[WBRedEnvelopConfig sharedConfig].autoReceiveEnable];
}

- (MMTableViewCellInfo *)createDelaySettingCell {
    NSInteger delaySeconds = [WBRedEnvelopConfig sharedConfig].delaySeconds;
    NSString *delayString = delaySeconds == 0 ? @"不延迟" : [NSString stringWithFormat:@"%ld 秒", (long)delaySeconds];
    
    MMTableViewCellInfo *cellInfo;
    if ([WBRedEnvelopConfig sharedConfig].autoReceiveEnable) {
        cellInfo = [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(settingDelay) target:self title:@"延迟抢红包" rightValue: delayString accessoryType:1];
    } else {
        cellInfo = [objc_getClass("MMTableViewCellInfo") normalCellForTitle:@"延迟抢红包" rightValue: @"抢红包已关闭"];
    }
    return cellInfo;
}

- (void)switchRedEnvelop:(UISwitch *)envelopSwitch {
    [WBRedEnvelopConfig sharedConfig].autoReceiveEnable = envelopSwitch.on;
    
    [self reloadTableData];
}

- (void)settingDelay {
    UIAlertView *alert = [UIAlertView new];
    alert.title = @"延迟抢红包(秒)";
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    [alert addButtonWithTitle:@"取消"];
    [alert addButtonWithTitle:@"确定"];
    
    [alert textFieldAtIndex:0].placeholder = @"延迟时长";
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *delaySecondsString = [alertView textFieldAtIndex:0].text;
        NSInteger delaySeconds = [delaySecondsString integerValue];
        
        [WBRedEnvelopConfig sharedConfig].delaySeconds = delaySeconds;
        
        [self reloadTableData];
    }
}

#pragma mark - ProSetting
- (void)addAdvanceSettingSection {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoHeader:@"装逼必备"];
    [sectionInfo addCell:[self changeStepCountCell]];
    [sectionInfo addCell:[self longBackgroundCell]];
    [sectionInfo addCell:[self createAbortRemokeMessageCell]];
    //[sectionInfo addCell:[self createKeywordFilterCell]];
    [sectionInfo addCell:[self hideRedPintCell]];
    [sectionInfo addCell:[self hideTabRedPintCell]];
    [sectionInfo addCell:[self changeLocalCell]];
    [self.tableViewInfo addSection:sectionInfo];
}

- (MMTableViewCellInfo *)longBackgroundCell {
    return [(id)objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(handleLongBackgroundMode:) target:[FishConfigurationCenter sharedInstance] title:@"长期后台运行" on:[FishConfigurationCenter sharedInstance].longBackgroundMode];
}

- (MMTableViewCellInfo *)changeLocalCell {
    NSString *locationName = [FishConfigurationCenter sharedInstance].locationInfo[@"name"];
    NSString *rightValue = locationName.length ? locationName : @"拖动地图选择";
    return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(changeLocal) target:self title:@"更改定位" rightValue:rightValue accessoryType:1];
}

- (MMTableViewCellInfo *)hidedFriendCell {
    return [(id)objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(handleFriendMode:) target:[FishConfigurationCenter sharedInstance] title:@"关闭朋友圈入口" on:[FishConfigurationCenter sharedInstance].isFriendMode];
}

- (MMTableViewCellInfo *)hideRedPintCell {
    return [(id)objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(handleRedMode:) target:[FishConfigurationCenter sharedInstance] title:@"关闭聊天小红点" on:[FishConfigurationCenter sharedInstance].isRedMode];
}

- (MMTableViewCellInfo *)hideTabRedPintCell {
    return [(id)objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(handleTabRedMode:) target:[FishConfigurationCenter sharedInstance] title:@"关闭tab小红点" on:[FishConfigurationCenter sharedInstance].isTabRedMode];
}

- (MMTableViewCellInfo *)changeStepCountCell{
    NSInteger stepCount = [FishConfigurationCenter sharedInstance].stepCount;
    return [objc_getClass("MMTableViewCellInfo") editorCellForSel:@selector(handleStepCount:) target:[FishConfigurationCenter sharedInstance] title:@"微信运动步数" margin:300.0 tip:@"请输入步数" focus:NO text:[NSString stringWithFormat:@"%zi", stepCount]];
}

- (MMTableViewCellInfo *)createReceiveSelfRedEnvelopCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(settingReceiveSelfRedEnvelop:) target:self title:@"抢自己发的红包" on:[WBRedEnvelopConfig sharedConfig].receiveSelfRedEnvelop];
}

- (MMTableViewCellInfo *)createQueueCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(settingReceiveByQueue:) target:self title:@"防止同时抢多个红包" on:[WBRedEnvelopConfig sharedConfig].serialReceive];
}

- (MMTableViewCellInfo *)createBlackListCell {
    
    if ([WBRedEnvelopConfig sharedConfig].blackList.count == 0) {
        return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(showBlackList) target:self title:@"群聊过滤" rightValue:@"已关闭" accessoryType:1];
    } else {
        NSString *blackListCountStr = [NSString stringWithFormat:@"已选 %lu 个群", (unsigned long)[WBRedEnvelopConfig sharedConfig].blackList.count];
        return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(showBlackList) target:self title:@"群聊过滤" rightValue:blackListCountStr accessoryType:1];
    }
    
}

- (MMTableViewSectionInfo *)createAbortRemokeMessageCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(settingMessageRevoke:) target:self title:@"消息防撤回" on:[WBRedEnvelopConfig sharedConfig].revokeEnable];
}

- (MMTableViewSectionInfo *)createKeywordFilterCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForTitle:@"关键词过滤" rightValue:@"开发中..."];
}

- (void)settingReceiveSelfRedEnvelop:(UISwitch *)receiveSwitch {
    [WBRedEnvelopConfig sharedConfig].receiveSelfRedEnvelop = receiveSwitch.on;
}

- (void)settingReceiveByQueue:(UISwitch *)queueSwitch {
    [WBRedEnvelopConfig sharedConfig].serialReceive = queueSwitch.on;
}

- (void)showBlackList {
    WBMultiSelectGroupsViewController *contactsViewController = [[WBMultiSelectGroupsViewController alloc] initWithBlackList:[WBRedEnvelopConfig sharedConfig].blackList];
    contactsViewController.delegate = self;
    
    MMUINavigationController *navigationController = [[objc_getClass("MMUINavigationController") alloc] initWithRootViewController:contactsViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)settingMessageRevoke:(UISwitch *)revokeSwitch {
    [WBRedEnvelopConfig sharedConfig].revokeEnable = revokeSwitch.on;
}

#pragma mark - ProLimit

- (void)addAdvanceLimitSection {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoHeader:@"高级功能" Footer:@"关注公众号后开启高级功能"];
    
    [sectionInfo addCell:[self createReceiveSelfRedEnvelopLimitCell]];
    [sectionInfo addCell:[self createQueueLimitCell]];
    [sectionInfo addCell:[self createBlackListLimitCell]];
    [sectionInfo addCell:[self createAbortRemokeMessageLimitCell]];
    [sectionInfo addCell:[self createKeywordFilterLimitCell]];
    
    [self.tableViewInfo addSection:sectionInfo];
}

- (MMTableViewCellInfo *)createReceiveSelfRedEnvelopLimitCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForTitle:@"抢自己发的红包" rightValue:@"未启用"];
}

- (MMTableViewCellInfo *)createQueueLimitCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForTitle:@"防止同时抢多个红包" rightValue:@"未启用"];
}

- (MMTableViewCellInfo *)createBlackListLimitCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForTitle:@"群聊过滤" rightValue:@"未启用"];
}

- (MMTableViewSectionInfo *)createKeywordFilterLimitCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForTitle:@"关键词过滤" rightValue:@"未启用"];
}

- (MMTableViewSectionInfo *)createAbortRemokeMessageLimitCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForTitle:@"消息防撤回" rightValue:@"未启用"];
}

#pragma mark - About
- (void)addAboutSection {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    [sectionInfo addCell:[self createGithubCell]];
    [sectionInfo addCell:[self createBlogCell]];
    
    [self.tableViewInfo addSection:sectionInfo];
}

- (MMTableViewCellInfo *)createGithubCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(showGithub) target:self title:@"我的 Github" rightValue: @"★ star" accessoryType:1];
}

- (MMTableViewCellInfo *)createBlogCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(showBlog) target:self title:@"我的博客" accessoryType:1];
}

- (void)showGithub {
    NSURL *gitHubUrl = [NSURL URLWithString:@"https://github.com/buginux/WeChatRedEnvelop"];
    MMWebViewController *webViewController = [[objc_getClass("MMWebViewController") alloc] initWithURL:gitHubUrl presentModal:NO extraInfo:nil];
    [self.navigationController PushViewController:webViewController animated:YES];
}

- (void)showBlog {
    NSURL *blogUrl = [NSURL URLWithString:@"http://www.swiftyper.com"];
    MMWebViewController *webViewController = [[objc_getClass("MMWebViewController") alloc] initWithURL:blogUrl presentModal:NO extraInfo:nil];
    [self.navigationController PushViewController:webViewController animated:YES];
}

#pragma mark - Support
- (void)addSupportSection {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    [sectionInfo addCell:[self createMoreSettingCell]];
    [sectionInfo addCell:[self createFlexCell]];
    [sectionInfo addCell:[self createWeChatPayingCell]];
    
    [self.tableViewInfo addSection:sectionInfo];
}

- (MMTableViewCellInfo *)createFlexCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(settingFLEX:) target:self title:@"开启FLEX" on:NO];
}

- (MMTableViewCellInfo *)createMoreSettingCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(moreSetting) target:self title:@"更多功能" accessoryType:1];
}
- (MMTableViewCellInfo *)createWeChatPayingCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(payingToAuthor) target:self title:@"支持作者" rightValue:@"打赏开发" accessoryType:1];
}
- (void)settingFLEX:(UISwitch *)envelopSwitch{
    if (envelopSwitch.isOn) {
        [[FLEXManager sharedManager] showExplorer];
    }else {
        [[FLEXManager sharedManager] hideExplorer];
    }
}

- (void)moreSetting{
    TKSettingViewController *more = [[objc_getClass("TKSettingViewController") alloc] init];
    [self.navigationController PushViewController:more animated:YES];
}
- (void)payingToAuthor {
    [self startLoadingNonBlock];
    ScanQRCodeLogicController *scanQRCodeLogic = [[objc_getClass("ScanQRCodeLogicController") alloc] initWithViewController:self CodeType:3];
    scanQRCodeLogic.fromScene = 2;
    
    NewQRCodeScanner *qrCodeScanner = [[objc_getClass("NewQRCodeScanner") alloc] initWithDelegate:scanQRCodeLogic CodeType:3];
    [qrCodeScanner notifyResult:@"wxp://f2f0puyBFtkVV6yJFxu1Ypj1KakusZ6oVpyV" type:@"QR_CODE" version:6];//
}

#pragma mark - MultiSelectGroupsViewControllerDelegate
- (void)onMultiSelectGroupCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)onMultiSelectGroupReturn:(NSArray *)arg1 {
    [WBRedEnvelopConfig sharedConfig].blackList = arg1;
    
    [self reloadTableData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeLocal{
    [[MapView shareMapView] show];
    __weak typeof(self) weak_self = self;
    [MapView shareMapView].customAction = ^(NSString *obj, int idx) {
        if (idx != 1) {
            return ;
        }
        [weak_self reloadTableData];
    };
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
