//
//  ZNewSubscribeAlreadyHasDescTVC.h
//  PlaneLive
//
//  Created by WT on 29/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBaseTVC.h"
#import "ZSubscribeDetailTextTVC.h"

/// 已购系列课,培训课 课程简介TVC
@interface ZNewSubscribeAlreadyHasDescTVC : ZBaseTVC

///初始化
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZSubscribeDetailTextTVCType)type;

@end
