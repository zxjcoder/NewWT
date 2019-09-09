//
//  ZQuestionDetailAttTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZQuestionDetailAttTVC : ZBaseTVC

///关注问题
@property (copy, nonatomic) void(^onAttentionClick)(ModelQuestionDetail *model);

@end
