//
//  ZMyAnswerCommentTableView.h
//  PlaneCircle
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZMyAnswerCommentTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelQuestionMyAnswerComment *model);

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelQuestionMyAnswerComment *model);

///删除按钮点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelQuestionMyAnswerComment *model);

///设置分页数量
@property (copy, nonatomic) void(^onPageNumChange)(int pageNum);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

@end
