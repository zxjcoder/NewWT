//
//  ZDownloadFooterView.h
//  PlaneLive
//
//  Created by Daniel on 10/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZDownloadFooterView : ZView

/// 删除按钮
@property (copy, nonatomic) void(^onDeleteClick)();

/// 设置总记录数
-(void)setDownloadSelCount:(int)count;

/// 获取View高度
+(CGFloat)getH;

@end
