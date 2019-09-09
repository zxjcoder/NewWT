//
//  ZAnswerDetailTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTableView.h"

@interface ZAnswerDetailTableView : ZTableView

///刷新顶部数据
@property (copy, nonatomic) void(^onRefreshHeader)();
///刷新底部数据
@property (copy, nonatomic) void(^onRefreshFooter)();
///头像->答案
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelAnswerBase *model);
///头像->评论
@property (copy, nonatomic) void(^onCommentPhotoClick)(ModelComment *model);
///同意
@property (copy, nonatomic) void(^onAgreeClick)(ModelAnswerBase *model);
///图片点击放大
@property (copy , nonatomic) void(^onImageClick)(UIImage *image, NSURL *imgUrl, CGSize size);

///开始滑动
@property (copy, nonatomic) void(^onOffsetChange)(CGFloat y);

///设置数据源
-(void)setViewDataWithDictionary:(NSDictionary *)dicResult;
///设置问题数据源
-(void)setViewDataWithModel:(ModelAnswerBase *)model;

@end
