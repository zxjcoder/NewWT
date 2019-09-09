//
//  ZAlertHintView.h
//  PlaneLive
//
//  Created by Daniel on 30/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

///支付平台枚举
typedef NS_ENUM(NSInteger, ZAlertHintViewType)
{
    ///编辑昵称
    ZAlertHintViewTypeNickName = 0,
    ///绑定手机号
    ZAlertHintViewTypeBindPhone = 1
};

/// 提示框
@interface ZAlertHintView : ZView

///初始化
-(id)initWithType:(ZAlertHintViewType )type;

///确认按钮点击
@property (copy, nonatomic) void(^onConfirmationClick)();
///取消按钮点击
@property (copy, nonatomic) void(^onCloseClick)();

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
