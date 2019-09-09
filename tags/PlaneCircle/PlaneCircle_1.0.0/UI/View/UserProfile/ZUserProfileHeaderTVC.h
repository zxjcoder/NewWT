//
//  ZUserProfileHeaderTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

typedef NS_ENUM(NSInteger ,ZUserProfileHeaderItemType)
{
    ///问题
    ZUserProfileHeaderItemTypeQuestion = 1,
    ///粉丝
    ZUserProfileHeaderItemTypeFans = 2,
    ///回答
    ZUserProfileHeaderItemTypeAnswer = 3,
};

@interface ZUserProfileHeaderTVC : ZBaseTVC

///子项点击事件
@property (copy, nonatomic) void(^onItemClick)(ZUserProfileHeaderItemType type, NSString *title);

@end
