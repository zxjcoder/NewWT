//
//  ZTopicLabel.h
//  PlaneCircle
//
//  Created by Daniel on 6/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

@interface ZTopicLabel : UIView

@property (copy, nonatomic) void(^onDeleteClick)(ModelTag *model);

-(void)setTopicWithModel:(ModelTag *)model;

-(void)setViewFont:(UIFont *)font;

-(CGFloat)getH;
+(CGFloat)getH;
-(CGFloat)getW;

@end
