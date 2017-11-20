//
//  WeChatHeader.h
//  WechatPod
//
//  Created by monkey on 2017/8/2.
//  Copyright © 2017年 Coder. All rights reserved.
//

#ifndef WeChatHeader_h
#define WeChatHeader_h

#import <UIKit/UIKit.h>
#import "WeChatRobot.h"
@interface GameController : NSObject

+ (NSString*)getMD5ByGameContent:(NSInteger) content;

@end

@interface MMMsgLogicManager

-(void)PushOtherBaseMsgControllerByContact:(CContact*)contact navigationController:(UINavigationController*)navi animated:(BOOL)animated;
@end


@interface CAppViewControllerManager

+ (UINavigationController*)getCurrentNavigationController;
@end

@interface BaseMsgContentViewController: UIViewController {
    NSMutableArray *m_arrMessageNodeData;
}
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
- (NSString *)getTimeIntervalDescriptionWithTime:(NSInteger)time;
- (id)getCurrentChatName;

@end



#endif /* WeChatHeader_h */
