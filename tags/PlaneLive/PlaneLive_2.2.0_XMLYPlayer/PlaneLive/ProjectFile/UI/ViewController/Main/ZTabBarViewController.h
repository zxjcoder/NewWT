//
//  ZTabBarViewController.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTabBarViewController : UITabBarController

///收到显示对应模块页面的通知
-(void)setShowViewControllerWithParam:(NSDictionary *)dicParam;
///显示登录窗口
-(void)setShowLoginVCWithAnimated:(BOOL)animated;
///刷新用户数据
-(void)setRefreshUserInfo;
///显示问题提问
-(void)setShowQuestionVC;
///显示实务详情
-(void)setShowPracticeVC;
///显示搜索问答
-(void)setShowSearchQuestionAnswerVC;
///显示搜索实务
-(void)setShowSearchPractice;
///显示已订阅订阅详情
-(void)setShowSubscribeAlreadyHasVC:(ModelSubscribeDetail *)model;
///显示已购界面
-(void)setShowPurchaseVC;
///显示播放界面
-(void)setShowPlayVCWithPractice:(ModelPractice *)model;
///注销登录
-(void)logout;

@end
