//
//  ZShareView.h
//  PlaneCircle
//
//  Created by Daniel on 6/10/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZShareView : UIView

///子项按钮事件
@property (copy, nonatomic) void(^onItemClick)(ZShareType type);

///初始化对象
-(id)initWithShowShareType:(ZShowShareType)showType;

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
