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
///刷新用户数据
-(void)setRefreshUserInfo;
///显示问题提问
-(void)setShowQuestionVC;
///显示实务详情
-(void)setShowPracticeVC;
///显示搜索问答
-(void)setShowSearchQuestionAnswerVC;

@end
