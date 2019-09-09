//
//  ZNewUserEditPhotoTVC.h
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBaseTVC.h"

/// 头像
@interface ZNewUserEditPhotoTVC : ZBaseTVC

///头像点击事件
@property (copy, nonatomic) void(^onPhotoClick)();

-(void)setUserPhoto:(NSData *)dataPhoto;

@end
