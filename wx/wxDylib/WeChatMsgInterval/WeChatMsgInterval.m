//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  WeChatMsgInterval.m
//  WeChatMsgInterval
//
//  Created by Pillar on 2017/8/29.
//  Copyright (c) 2017年 unkown. All rights reserved.
//

#import "WeChatMsgInterval.h"
#import "CaptainHook.h"
#import <UIKit/UIKit.h>
#import "WeChatMsgIntervalHeader.h"


CHDeclareClass(BaseChatViewModel)
CHPropertyRetainNonatomic(BaseChatViewModel, NSString *, intervaleTime, setIntervaleTime);


CHDeclareClass(CommonMessageCellView)
CHPropertyRetainNonatomic(CommonMessageCellView, UIView *, expandView, setExpandView);

CHOptimizedMethod(1, self,id,CommonMessageCellView,initWithViewModel,BaseChatViewModel *,arg1){
    CommonMessageCellView *view =  CHSuper(1,CommonMessageCellView,initWithViewModel,arg1);
    view.expandView = [[UILabel alloc] init];
    view.expandView.font = [UIFont systemFontOfSize:12];
    return view;
}

CHOptimizedMethod(0, self,void,CommonMessageCellView,updateNodeStatus){
    CHSuper(0,CommonMessageCellView,updateNodeStatus);
    
    if (![self.viewModel isSender] && [self.viewModel intervaleTime].length > 0) {
        if ([[self.viewModel intervaleTime] isEqualToString:@"-1"]) {
            self.expandView.hidden = YES;
            return;
        }
        self.expandView.hidden = NO;
        self.expandView.text = [self.viewModel intervaleTime];
        [self.expandView sizeToFit];
        CGFloat centerX = 0,centerY = 0;
        if ([self isKindOfClass:NSClassFromString(@"VoiceMessageCellView")]) {
            UIView *m_contentView = CHIvar(self, m_contentView, __strong UIView *);
            UILabel* m_secLabel = CHIvar(self, m_secLabel, __strong UILabel *);
            CGRect frame = [self convertRect:m_secLabel.frame fromView:m_contentView];
            centerX = CGRectGetMaxX(frame) + 4 + self.expandView.bounds.size.width / 2;
            centerY = CGRectGetMidY(frame);
        }else{
            UIView *m_contentView = CHIvar(self, m_contentView, __strong UIView *);
            centerX = CGRectGetMaxX(m_contentView.frame) + 4 + self.expandView.bounds.size.width / 2;
            centerY = CGRectGetMaxY(m_contentView.frame) - 8 - self.expandView.bounds.size.height / 2;
        }
        self.expandView.center = CGPointMake(centerX, centerY);
        
        if (![self.expandView isDescendantOfView:self]) {
            [self addSubview:self.expandView];
        }
        
        
    }else{
        self.expandView.hidden = YES;
    }
    
    
}


CHDeclareClass(BaseMsgContentViewController)

CHDeclareMethod(1, NSString*,BaseMsgContentViewController,getTimeIntervalDescriptionWithTime,NSInteger,arg1){
    NSTimeInterval time = arg1;
    NSInteger seconds = time;
    if (seconds < 60) {
        if (seconds <= 0) {
            seconds = 1;
        }
        return [NSString stringWithFormat:@"%lds",(long)seconds];
    }
    //秒转分钟
    NSInteger minute = time/60;
    if (minute < 60) {
        return [NSString stringWithFormat:@"%ldm",(long)minute];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ldh",(long)hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ldd",(long)days];
    }
    //格式化日期对象格式
    return @"...";
}
CHOptimizedMethod(2, self,UITableViewCell *,BaseMsgContentViewController,tableView,UITableView*,arg1,cellForRowAtIndexPath,NSIndexPath *,arg2){
    
    ChatTableViewCell *cell = (ChatTableViewCell *)CHSuper(2, BaseMsgContentViewController,tableView,arg1,cellForRowAtIndexPath,arg2);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *arrMessageNodeData = CHIvar(self, m_arrMessageNodeData, __strong NSMutableArray *);
        id node = [[cell cellView] viewModel];
        
        if (![node isKindOfClass:NSClassFromString(@"ChatTimeViewModel")] &&
            ![node isKindOfClass:NSClassFromString(@"SystemMessageViewModel")] &&
            [node intervaleTime] == nil ) {
            
            CommonMessageViewModel *msgNode = (CommonMessageViewModel *)node;
            CommonMessageViewModel *preMsgNode = nil;
            
            NSInteger preIndex = arg2.section - 1;
            if (preIndex >= 0) {
                for (NSInteger i = preIndex; i >= 0; i--) {
                    id preNode = arrMessageNodeData[i];
                    if ([preNode isKindOfClass:NSClassFromString(@"ChatTimeViewModel")] ||
                        [preNode isKindOfClass:NSClassFromString(@"SystemMessageViewModel")]) {
                        continue;
                    }else{
                        preMsgNode = (CommonMessageViewModel *)preNode;
                        break;
                    }
                }
            }
            if (preMsgNode) {
                
                
                //  TextMessageSubViewModel  一个很奇葩的问题，微信的长文本会分隔成多个Cell进行显示
                if ([msgNode isKindOfClass:NSClassFromString(@"TextMessageSubViewModel")]) {
                    NSInteger subViewCount = [[(TextMessageSubViewModel *)msgNode parentModel] subViewModels].count;
                    if (arg2.row == subViewCount - 1) {
                        CGFloat createTime = [[(TextMessageSubViewModel *)msgNode parentModel] createTime];
                        msgNode.intervaleTime = [self getTimeIntervalDescriptionWithTime:createTime - preMsgNode.createTime];
                    }else{
                        msgNode.intervaleTime = @"-1";  // -1 不显示
                    }
                    
                }else{
                    msgNode.intervaleTime = [self getTimeIntervalDescriptionWithTime:msgNode.createTime - preMsgNode.createTime];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([cell.cellView respondsToSelector:@selector(updateNodeStatus)]) {
                        [cell.cellView updateNodeStatus];
                    }
                });
                
            }
        }
        
    });
    
    
    return cell;
}


CHConstructor{
    
    CHLoadLateClass(BaseChatViewModel);
    CHClassHook(0,BaseChatViewModel, intervaleTime);
    CHClassHook(1,BaseChatViewModel, setIntervaleTime);
    
    
    CHLoadLateClass(CommonMessageCellView);
    CHClassHook(1,CommonMessageCellView, initWithViewModel);
    CHClassHook(0, CommonMessageCellView,expandView);
    CHClassHook(1, CommonMessageCellView,setExpandView);
    CHClassHook(0, CommonMessageCellView,updateNodeStatus);
    
    
    CHLoadLateClass(BaseMsgContentViewController);
    CHClassHook(1, BaseMsgContentViewController,getTimeIntervalDescriptionWithTime);
    CHClassHook(2,BaseMsgContentViewController,tableView,cellForRowAtIndexPath);
    
}
