//
//  ZMyQuestionNewTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZMyQuestionNewTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onQuestionClick)(ModelQuestionBase *model);

///删除按钮点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelMyNewQuestion *model);

///头像点击
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);

///回答点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///设置分页数量
@property (copy, nonatomic) void(^onPageNumChange)(int pageNum);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

///设置昵称描述内容类型 0 你 1 他  2 她
-(void)setViewNickNameDescType:(int)nickNameDescType;

@end
