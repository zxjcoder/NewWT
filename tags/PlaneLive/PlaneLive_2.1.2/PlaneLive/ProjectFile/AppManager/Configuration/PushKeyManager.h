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

///远程操作通知
static NSString *const ZPlayRemoteNotification = @"ZPlayRemoteNotification";
///播放音乐改变
static NSString *const ZPlayChangeNotification = @"ZPlayChangeNotification";

///收到显示对应模块页面的通知
static NSString *const ZShowViewControllerNotification = @"ZShowViewControllerNotification";
///字体设置改变
static NSString *const ZFontSizeChangeNotification = @"ZFontSizeChangeNotification";

///改变TabbarItem的通知
static NSString *const ZChangeTabbarItem = @"ZChangeTabbarItem";

///任务完成的通知
static NSString *const ZTaskCompleteNotification = @"ZTaskCompleteNotification";

///订阅成功的通知
static NSString *const ZSubscribeSuccessNotification = @"ZSubscribeSuccessNotification";

///购物车结算成功
static NSString *const ZCartPaySuccessNotification = @"ZCartPaySuccessNotification";




