//
//  ZMyAnswerTableView.h
//  PlaneCircle
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZMyAnswerTableView : ZBaseTableView

///头像点击
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);

///回答点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///问题区域点击
@property (copy, nonatomic) void(^onQuestionClick)(ModelQuestionBase *model);

///删除按钮点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelQuestionMyAnswer *model);

///设置分页数量
@property (copy, nonatomic) void(^onPageNumChange)(int pageNum);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;


@end
