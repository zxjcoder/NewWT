//
//  PushKeyManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

/**************************通知KEY**************************/

///App已经进入后台
static NSString *const ZApplicationDidEnterBackgroundNotification = @"ZApplicationDidEnterBackgroundNotification";
///App已经进入前台
static NSString *const ZApplicationDidBecomeActiveNotification = @"ZApplicationDidBecomeActiveNotification";

///App榜单状态改变
static NSString *const ZAppRankStateChangeNotification = @"ZAppRankStateChangeNotification";
///App审核状态改变
static NSString *const ZAppAuditStateChangeNotification = @"ZAppAuditStateChangeNotification";
///App数量改变
static NSString *const ZAppNumberChangeNotification = @"ZAppNumberChangeNotification";

///用户信息改变
static NSString *const ZLoginChangeNotification = @"ZLoginChangeNotification";

///用户信息改变
static NSString *const ZUserInfoChangeNotification = @"ZUserInfoChangeNotification";


///充值成功
static NSString *const ZPaySuccessNotification = @"ZPaySuccessNotification";
///充值失败
static NSString *const ZPayFailNotification = @"ZPayFailNotification";
///取消充值
static NSString *const ZPayCancelNotification = @"ZPayCancelNotification";

///问题变化
static NSString *const ZPublishQuestionNotification = @"ZPublishQuestionNotification";
///实务变化
static NSString *const ZPracticeChangeNotification = @"ZPracticeChangeNotification";

///播放提问点击
static NSString *const ZPlayQuestionNotification = @"ZPlayQuestionNotification";
///播放评论点击
static NSString *const ZPlayCommentNotification = @"ZPlayCommentNotification";
///播放显示
static NSString *const ZPlayShowViewNotification = @"ZPlayShowViewNotification";
///播放错误
static NSString *const ZPlayErrorNotification = @"ZPlayErrorNotification";
///播放取消
static NSString *const ZPlayCancelNotification = @"ZPlayCancelNotification";
///播放开始
static NSString *const ZPlayStartNotification = @"ZPlayStartNotification";
///播放状态改变
static NSString *const ZPlayChangeNotification = @"ZPlayChangeNotification";
///上一首
static NSString *const ZPlayPreNotification = @"ZPlayPreNotification";
///下一首
static NSString *const ZPlayNextNotification = @"ZPlayNextNotification";
///上一首下一首按钮可以使用
static NSString *const ZPlayEnabledNotification = @"ZPlayEnabledNotification";
///隐藏评论按钮
static NSString *const ZPlayHiddenNotification = @"ZPlayHiddenNotification";
///远程操作通知
static NSString *const ZPlayRemoteNotification = @"ZPlayRemoteNotification";

///收到显示对应模块页面的通知
static NSString *const ZShowViewControllerNotification = @"ZShowViewControllerNotification";
///字体设置改变
static NSString *const ZFontSizeChangeNotification = @"ZFontSizeChangeNotification";

///显示提问页面
static NSString *const ZShowQuestionVCNotification = @"ZShowQuestionVCNotification";

