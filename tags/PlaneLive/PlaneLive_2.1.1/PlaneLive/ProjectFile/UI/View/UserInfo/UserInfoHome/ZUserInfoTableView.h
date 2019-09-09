//
//  ZUserInfoTableView.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZUserInfoTableView : ZBaseTableView

///偏移量
@property (copy, nonatomic) void(^onContentOffsetY)(CGFloat alpha);
///我的头像
@property (copy, nonatomic) void(^onUserPhotoClick)();
///个人中心点击
@property (copy, nonatomic) void(^onUserInfoCenterItemClick)(ZUserInfoCenterItemType type);
///我的问题
@property (copy, nonatomic) void(^onQuestionClick)();
///我的粉丝
@property (copy, nonatomic) void(^onFansClick)();
///待我回答
@property (copy, nonatomic) void(^onAnswerClick)();

///设置数据源
-(void)setViewDataWithModel:(ModelUser *)model;
///设置是否审核状态
-(void)setIsAuditStatus:(BOOL)status;

@end
