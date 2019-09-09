//
//  ZPracticePayItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

typedef NS_ENUM(NSInteger, ZPracticePayItemTVCType)
{
    /// 主讲人简介
    ZPracticePayItemTVCTypeSpeaker,
    /// 实务简介
    ZPracticePayItemTVCTypePractice,
};

@interface ZPracticePayItemTVC : ZBaseTVC

///初始化
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZPracticePayItemTVCType)type;

@end
