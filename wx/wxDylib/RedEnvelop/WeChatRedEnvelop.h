#pragma mark - Util
#import <UIKit/UIKit.h>
#import "WeChatRobot.h"

NSMutableArray * filtMessageWrapArr(NSMutableArray *msgList);

@interface WCBizUtil : NSObject

+ (id)dictionaryWithDecodedComponets:(id)arg1 separator:(id)arg2;

@end

@interface SKBuiltinBuffer_t : NSObject

@property(retain, nonatomic) NSData *buffer; // @dynamic buffer;

@end

#pragma mark - Message

@interface MMLanguageMgr: NSObject

- (id)getStringForCurLanguage:(id)arg1 defaultTo:(id)arg2;


@end

#pragma mark - RedEnvelop

@interface WCRedEnvelopesControlData : NSObject

@property(retain, nonatomic) CMessageWrap *m_oSelectedMessageWrap;

@end

@interface WCRedEnvelopesLogicMgr: NSObject

- (void)OpenRedEnvelopesRequest:(id)params;
- (void)ReceiverQueryRedEnvelopesRequest:(id)arg1;
- (void)GetHongbaoBusinessRequest:(id)arg1 CMDID:(unsigned int)arg2 OutputType:(unsigned int)arg3;

/** Added Methods */
- (unsigned int)calculateDelaySeconds;

@end

@interface HongBaoRes : NSObject

@property(retain, nonatomic) SKBuiltinBuffer_t *retText; // @dynamic retText;
@property(nonatomic) int cgiCmdid; // @dynamic cgiCmdid;

@end

@interface HongBaoReq : NSObject

@property(retain, nonatomic) SKBuiltinBuffer_t *reqText; // @dynamic reqText;

@end


#pragma mark - QRCode

@interface ScanQRCodeLogicController: NSObject

@property(nonatomic) unsigned int fromScene;
- (id)initWithViewController:(id)arg1 CodeType:(int)arg2;
- (void)tryScanOnePicture:(id)arg1;
- (void)doScanQRCode:(id)arg1;
- (void)showScanResult;

@end

@interface NewQRCodeScanner: NSObject

- (id)initWithDelegate:(id)arg1 CodeType:(int)arg2;
- (void)notifyResult:(id)arg1 type:(id)arg2 version:(int)arg3;

@end

#pragma mark - MMTableView


#pragma mark - UI


@interface MMWebViewController: NSObject

- (id)initWithURL:(id)arg1 presentModal:(_Bool)arg2 extraInfo:(id)arg3;

@end


@protocol ContactSelectViewDelegate <NSObject>

- (void)onSelectContact:(CContact *)arg1;

@end

@interface MMUINavigationController : UINavigationController

@end

#pragma mark - UtilCategory

@interface NSMutableDictionary (SafeInsert)

- (void)safeSetObject:(id)arg1 forKey:(id)arg2;

@end

@interface NSDictionary (NSDictionary_SafeJSON)

- (id)arrayForKey:(id)arg1;
- (id)dictionaryForKey:(id)arg1;
- (double)doubleForKey:(id)arg1;
- (float)floatForKey:(id)arg1;
- (long long)int64ForKey:(id)arg1;
- (long long)integerForKey:(id)arg1;
- (id)stringForKey:(id)arg1;

@end

@interface NSString (NSString_SBJSON)

- (id)JSONArray;
- (id)JSONDictionary;
- (id)JSONValue;

@end

#pragma mark - UICategory

@interface UINavigationController (LogicController)

- (void)PushViewController:(id)arg1 animated:(_Bool)arg2;

@end


@interface ContactInfoViewController : MMUIViewController

@property(retain, nonatomic) CContact *m_contact; // @synthesize m_contact;

@end

@protocol MultiSelectContactsViewControllerDelegate <NSObject>
- (void)onMultiSelectContactReturn:(NSArray *)arg1;

@optional
- (int)getFTSCommonScene;
- (void)onMultiSelectContactCancelForSns;
- (void)onMultiSelectContactReturnForSns:(NSArray *)arg1;
@end

@interface MultiSelectContactsViewController : UIViewController

@property(nonatomic) _Bool m_bKeepCurViewAfterSelect; // @synthesize m_bKeepCurViewAfterSelect=_m_bKeepCurViewAfterSelect;
@property(nonatomic) unsigned int m_uiGroupScene; // @synthesize m_uiGroupScene;

@property(nonatomic, weak) id <MultiSelectContactsViewControllerDelegate> m_delegate; // @synthesize m_delegate;

@end

@interface BaseMsgContentViewController : MMUIViewController
- (id)GetContact;
@end

@interface FindFriendEntryViewController : MMUIViewController
- (long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2;
@end

@interface MMBadgeView : UIView

@end

@interface WCTimeLineCellView : UIView
- (void)initTimeLabel;
@end
