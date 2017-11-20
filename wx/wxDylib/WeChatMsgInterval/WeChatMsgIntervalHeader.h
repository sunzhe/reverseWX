//
//  WeChatMsgIntervalHeader.h
//  WeChatMsgInterval
//
//  Created by Pillar on 2017/8/28.
//  Copyright © 2017年 unkown. All rights reserved.
//

#ifndef WeChatMsgIntervalHeader_h
#define WeChatMsgIntervalHeader_h

#import <UIKit/UIKit.h>
@class CContact, CMessageWrap;
@interface BaseChatViewModel : NSObject
@property (weak, nonatomic) id cellView;
@property (nonatomic) double createTime;
@property (nonatomic) NSString *intervaleTime;
@end

@interface BaseMessageViewModel : BaseChatViewModel
@end

@interface CommonMessageViewModel : BaseMessageViewModel
@property(readonly, nonatomic) _Bool isSender; // @synthesize isSender=m_isSender;
@property(readonly, nonatomic) CContact *m_contact;
@property(readonly, nonatomic) CMessageWrap *m_messageWrap;
@end

@interface TextMessageViewModel : CommonMessageViewModel
@property(readonly, nonatomic) NSString *m_contentText;
- (NSMutableArray *) subViewModels;
@end

@interface TextMessageSubViewModel : TextMessageViewModel
@property (weak, nonatomic) TextMessageViewModel* parentModel;
@end


//@interface BaseMsgContentViewController : UIViewController{
//    NSMutableArray *m_arrMessageNodeData;
//}
//
//- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
//- (NSString *)getTimeIntervalDescriptionWithTime:(NSInteger)time;
//
//@end

@interface BaseChatCellView : UIView
@end

@interface BaseMessageCellView : BaseChatCellView
@end

@interface CommonMessageCellView : BaseMessageCellView{
    UIView *m_contentView;
}
@property (readonly, nonatomic) id viewModel;
@property (nonatomic) UILabel *expandView;
@property (nonatomic) UIButton *expandBtn;
- (void) updateNodeStatus;
- (void) initWithViewModel:(id)model;

- (void) onExpandBtnClick;
@end


@interface VoiceMessageCellView : CommonMessageCellView{
    UILabel *m_secLabel;
}

@end


@interface ChatTableViewCell : UITableViewCell
@property (readonly, nonatomic) id cellView;
@end


#endif /* WeChatMsgIntervalHeader_h */
