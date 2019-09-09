//
//  ZTrafficDownloadView.h
//  PlaneLive
//
//  Created by WT on 29/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"

/// 未WIFI情况下批量下载提示框
@interface ZTrafficDownloadView : ZView

///初始化
-(id)initWithSize:(int)size;
///确认按钮点击
@property (copy, nonatomic) void(^onConfirmationClick)();
///取消按钮点击
@property (copy, nonatomic) void(^onCloseClick)();

-(void)show;
-(void)dismiss;

@end
