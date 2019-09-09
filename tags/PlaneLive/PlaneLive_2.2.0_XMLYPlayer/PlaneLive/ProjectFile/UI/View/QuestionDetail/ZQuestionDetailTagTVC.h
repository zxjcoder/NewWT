//
//  ZQuestionDetailTagTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZQuestionDetailTagTVC : ZBaseTVC

///话题点击
@property (copy, nonatomic) void(^onTopicClick)(ModelTag *model);

@end
