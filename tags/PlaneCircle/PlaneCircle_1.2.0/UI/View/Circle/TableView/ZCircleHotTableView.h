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
@property (copy, nonatomic) void(^onBannerClick)(ModelBanner *model);

///新闻选中
@property (copy ,nonatomic) void(^onHotArticleViewClick)(ModelHotArticle *model);

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelCircleHot *model);

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelCircleHot *model);

@end
