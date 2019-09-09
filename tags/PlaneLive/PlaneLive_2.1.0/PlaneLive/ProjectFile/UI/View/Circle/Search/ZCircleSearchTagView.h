//
//  ZCircleSearchTagView.h
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

@interface ZCircleSearchTagView : UIView

@property (copy, nonatomic) void(^onSearchTagClick)(ModelTag *model);

///设置数据源
-(void)setViewDataWithModel:(ModelTag *)model;

///获取高度
+(CGFloat)getViewH;

@end
