//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  WeChatSelectAll.m
//  WeChatSelectAll
//
//  Created by allen on 2017/8/4.
//  Copyright (c) 2017年 allen. All rights reserved.
//

#import "WeChatSelectAll.h"
#import "CaptainHook.h"
#import <UIKit/UIKit.h>

CHDeclareClass(CMessageMgr);

CHOptimizedMethod(2, self, void, CMessageMgr, AddMsg, id, arg1, MsgWrap, id, wrap){
    
    Ivar uiMessageTypeIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_uiMessageType");
    ptrdiff_t offset = ivar_getOffset(uiMessageTypeIvar);
    unsigned char *stuffBytes = (unsigned char *)(__bridge void *)wrap;
    NSUInteger m_uiMessageType = * ((NSUInteger *)(stuffBytes + offset));
    
    NSString *knFromUser = object_getIvar(wrap, class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsFromUsr"));
    NSString *knToUsr = object_getIvar(wrap, class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsToUsr"));
    NSString *knContent = object_getIvar(wrap, class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsContent"));
    NSString *knSource = object_getIvar(wrap, class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsMsgSource"));
    
    id contactManager = [objc_getClass("MMServiceCenter") performSelector:@selector(defaultCenter)];
    id manager = [contactManager performSelector:@selector(getService:) withObject:[objc_getClass("CContactMgr") class]];
    id selfContact = [manager performSelector:@selector(getSelfContact)];
    
    if (m_uiMessageType == 1){
        NSString *tmpFromUser = [selfContact performSelector:@selector(m_nsUsrName)];
        if ([knFromUser isEqualToString:tmpFromUser]) {
            if ([knToUsr hasSuffix:@"@chatroom"]) {
                if( knSource == nil){
                    NSArray *result = (NSArray *)[objc_getClass("CContact") performSelector:@selector(getChatRoomMemberWithoutMyself:) withObject:knToUsr];
                    if ([knContent hasPrefix:@"#所有人"]){
                        // 前缀要求
                        NSString *subStr = [knContent substringFromIndex:4];
                        NSMutableString *string = [NSMutableString string];
                        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [string appendFormat:@",%@",[obj performSelector:@selector(m_nsUsrName)]];
                        }];
                        NSString *sourceString = [string substringFromIndex:1];
                        [wrap performSelector:@selector(setM_uiStatus:) withObject:@(3)];
                        [wrap performSelector:@selector(setM_nsContent:) withObject:subStr];
                        [wrap performSelector:@selector(setM_nsMsgSource:) withObject:[NSString stringWithFormat:@"<msgsource><atuserlist>%@</atuserlist></msgsource>",sourceString]];
                    }
                }
            }
        }
    }
    CHSuper(2, CMessageMgr,AddMsg,arg1,MsgWrap,wrap);
}


//所有被hook的类和函数放在这里的构造函数中
CHConstructor
{
    @autoreleasepool
    {
        CHLoadLateClass(CMessageMgr);
        CHHook(2, CMessageMgr, AddMsg, MsgWrap);
        
        
    }
}
