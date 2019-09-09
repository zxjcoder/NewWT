//
//  ZLoginThirdTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

///登录第三方CELL
@interface ZLoginThirdTVC : ZBaseTVC

///微信
@property (copy, nonatomic) void(^onWeChatClick)();
///QQ
@property (copy, nonatomic) void(^onQQClick)();
///有赞
@property (copy, nonatomic) void(^onPraiseClick)();

///是否显示微信登陆
-(void)setShowWeChatLogin:(BOOL)isShow;
///是否现实QQ登陆
-(void)setShowMobileQQLogin:(BOOL)isShow;
///是否现实有赞登陆
-(void)setShowMobilePraiseLogin:(BOOL)isShow;

@end
