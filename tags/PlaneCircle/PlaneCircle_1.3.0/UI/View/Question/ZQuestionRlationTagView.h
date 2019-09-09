//
//  ZQuestionRlationTagView.h
//  PlaneCircle
//
//  Created by Daniel on 8/4/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZQuestionRlationTagView : ZView


@property (copy, nonatomic) void(^onSearchTagClick)(ModelTag *model);

///设置数据源
-(void)setViewDataWithModel:(ModelTag *)model;

///获取高度
+(CGFloat)getViewH;

@end
