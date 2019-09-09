//
//  ZLoginThirdTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

///登录第三方CELL - 已经废弃
@interface ZLoginThirdTVC : ZBaseTVC

///微信
@property (copy, nonatomic) void(^onWeChatClick)();

///是否显示微信登陆
-(void)setShowWeChatLogin:(BOOL)isShow;

-(void)setViewFrame;

@end
