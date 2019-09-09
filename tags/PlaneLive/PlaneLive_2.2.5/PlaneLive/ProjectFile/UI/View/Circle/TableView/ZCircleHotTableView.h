//
//  ZCircleHotTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZCircleHotTableView : ZBaseTableView

///广告点击事件
//@property (copy, nonatomic) void(^onBannerClick)(ModelBanner *model);

///新闻选中
//@property (copy ,nonatomic) void(^onHotArticleViewClick)(ModelHotArticle *model);

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelCircleHot *model);

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);

///获取第一条问题标题的坐标
-(CGRect)getFirstQuestionFrame;
///获取第一条问题回答的坐标
-(CGRect)getFirstAnswerFrame;

@end
