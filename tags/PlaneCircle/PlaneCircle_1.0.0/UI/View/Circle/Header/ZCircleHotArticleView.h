//
//  ZCircleHotArticleView.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

///新闻文章
@interface ZCircleHotArticleView : UIView

///新闻选中
@property (copy ,nonatomic) void(^onHotArticleViewClick)(ModelHotArticle *model);

///设置数据源
-(void)setViewDataWithModel:(ModelHotArticle *)model;

@end
