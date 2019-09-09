//
//  ZReportView.h
//  PlaneCircle
//
//  Created by Daniel on 7/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

///举报
@interface ZReportView : UIView

///确定点击
@property (copy, nonatomic) void(^onSubmitClick)(NSString *content);
///取消点击
@property (copy, nonatomic) void(^onCancelClick)();
///其他点击
@property (copy, nonatomic) void(^onOtherClick)();

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
