//
//  WCImageEmotion.m
//  wx
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 ahaschool. All rights reserved.
//

#import "WCImageEmotion.h"
#import "CaptainHook.h"
#import <UIKit/UIKit.h>
#import "WeChatWebEmoticonHeader.h"
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



CHDeclareClass(MsgImgFullScreenViewController)
CHDeclareClass(PhotoViewController)

CHDeclareClass(WCActionSheet)

//CHOptimizedMethod(5, self, id, WCActionSheet, initWithTitle, id, arg1, delegate, id, arg2, cancelButtonTitle, id, arg3, destructiveButtonTitle, id, arg4, otherButtonTitles, id, arg5){
//    return CHSuper(5, WCActionSheet, initWithTitle, arg1, delegate, arg2, cancelButtonTitle, arg3, destructiveButtonTitle, arg4, otherButtonTitles, arg5);
//}

CHOptimizedMethod(1, self, void, WCActionSheet, showInView, id, arg1){
    BOOL isImage = NO;
    BOOL hasSave = NO;
    NSMutableArray *_buttonTitleList = [self valueForKey:@"_buttonTitleList"];
    for (NSObject *tmp in _buttonTitleList){
        NSString *title = [tmp valueForKey:@"_title"];
        if (!isImage && [title isEqualToString:@"保存图片"]) {
            isImage = YES;
        }else if (!hasSave && [title isEqualToString:@"保存为表情"]) {
            hasSave = YES;
        }
    }
    if (isImage && !hasSave) {
        [self addButtonWithTitle:@"保存为表情" atIndex:_buttonTitleList.count-1];
        self.cancelButtonIndex = _buttonTitleList.count-1;
        //[self reloadInnerView];
    }
    CHSuper(1, WCActionSheet, showInView, arg1);
}


CHOptimizedMethod(1, self, void, MsgImgFullScreenViewController, onLongPressBegin, id, arg1){
    CHSuper(1, MsgImgFullScreenViewController, onLongPressBegin, arg1);
}

CHOptimizedMethod(1, self, void, MsgImgFullScreenViewController, onLongPress, id, arg1){
    CHSuper(1, MsgImgFullScreenViewController, onLongPress, arg1);
}


void __handelImage(NSData *data, WCActionSheet *sheet, long long idx, UIViewController *view){
    if (idx == sheet.cancelButtonIndex) {
        return;
    }
    NSString *title = [sheet buttonTitleAtIndex:idx];
    if (![title isEqualToString:@"保存为表情"]) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSData *imgData = data;
        
        if (imgData) {
            
            BOOL isGif = [objc_getClass("CUtility") isGIFFile:imgData];
            
            // 如果是Gif动态图
            if (isGif){
                
                NSString *md5 = [objc_getClass("CBaseFile") GetDataMD5:imgData];
                
                //保存在本地
                if ([objc_getClass("EmoticonUtil") saveEmoticonToEmoticonDirForMd5:md5 data:imgData isCleanable:YES]) {
                    
                    CEmoticonMgr *emoticonMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CEmoticonMgr") class]];
                    
                    // 检查本地是否存在
                    if ([emoticonMgr CheckEmoticonExistInCustomListByMd5:md5]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [objc_getClass("CControlUtil") showAlert:nil message:@"表情已存在" delegate:nil cancelButtonTitle:nil];
                        });
                        
                    }else{
                        
                        // 否则上传服务器
                        dispatch_async(dispatch_get_main_queue(), ^{
                            AddEmoticonWrap *wrap = [[objc_getClass("AddEmoticonWrap") alloc] init];
                            wrap.source = 1;
                            wrap.md5 = md5;
                            EmoticonCustomManageAddLogic* addlogic =  [[objc_getClass("EmoticonCustomManageAddLogic") alloc] init];
                            //addlogic.delegate = (MMWebViewController *)self.webviewController;
                            //[(MMWebViewController *)self.webviewController setAddLogic:addlogic];
                            [addlogic startAddEmoticonWithWrap:wrap];
                        });
                        
                    }
                }
            }else{
                
                // 如果是静态图
                UIImage *image = [UIImage imageWithData:imgData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    EmoticonPickViewController *pickViewController = [[objc_getClass("EmoticonPickViewController") alloc] init];
                    pickViewController.m_image = image;
                    //MMWebViewController *webViewController =  (MMWebViewController *)self.webviewController;
                    [view.navigationController PushViewController:pickViewController animated:YES];
                });
            }
            
        }else{
            // 获取不到图片数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [objc_getClass("CControlUtil") showAlert:nil message:@"图片数据为空" delegate:nil cancelButtonTitle:nil];
            });
        }
    });
}

CHOptimizedMethod(2, self, void, MsgImgFullScreenViewController, actionSheet, WCActionSheet *, arg1, clickedButtonAtIndex, long long, arg2){
    
    CHSuper(2, MsgImgFullScreenViewController, actionSheet, arg1, clickedButtonAtIndex, arg2);
    if (arg2 == arg1.cancelButtonIndex) {
        return;
    }
    
    int m_iCurrentPage = [[self valueForKeyPath:@"pagingScrollView.m_iCurrentPage"] intValue];
    NSString *path = [self imagePathAtPage:m_iCurrentPage];
    __handelImage([NSData dataWithContentsOfFile:path], arg1, arg2, self);
}


CHOptimizedMethod(2, self, void, PhotoViewController, actionSheet, WCActionSheet *, arg1, clickedButtonAtIndex, long long, arg2){
    
    CHSuper(2, PhotoViewController, actionSheet, arg1, clickedButtonAtIndex, arg2);
    if (arg2 == arg1.cancelButtonIndex) {
        return;
    }
    int m_iCurrentPage = [[self valueForKeyPath:@"pagingScrollView.m_iCurrentPage"] intValue];
    NSData *data = [self imageDataAtPage:m_iCurrentPage];
    __handelImage(data, arg1, arg2, self);
}

CHConstructor{
    CHLoadLateClass(WCActionSheet);
    //CHClassHook(5, WCActionSheet, initWithTitle, delegate, cancelButtonTitle, destructiveButtonTitle, otherButtonTitles);
    CHClassHook(1, WCActionSheet, showInView);
    
    CHLoadLateClass(MsgImgFullScreenViewController);
    CHClassHook(1, MsgImgFullScreenViewController, onLongPressBegin);
    CHClassHook(1, MsgImgFullScreenViewController, onLongPress);
    CHClassHook(2, MsgImgFullScreenViewController, actionSheet, clickedButtonAtIndex);
    
    CHLoadLateClass(PhotoViewController);
    CHClassHook(2, PhotoViewController, actionSheet, clickedButtonAtIndex);
}

