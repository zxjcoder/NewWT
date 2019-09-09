//
//  ZTopicHeaderView.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

@interface ZTopicHeaderView : UIView

///关注话题
@property (copy, nonatomic) void(^onAttentionClick)(ModelTag *model);

-(void)setViewDataWithModel:(ModelTag *)model;

+(CGFloat)getViewH;

@end
