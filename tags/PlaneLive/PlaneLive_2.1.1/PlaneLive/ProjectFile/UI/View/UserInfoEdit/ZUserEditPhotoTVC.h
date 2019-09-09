//
//  ZUserEditPhotoTVC.h
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

///头像
@interface ZUserEditPhotoTVC : ZBaseTVC

///头像点击事件
@property (copy, nonatomic) void(^onPhotoClick)();

-(void)setUserPhoto:(NSData *)dataPhoto;

@end
