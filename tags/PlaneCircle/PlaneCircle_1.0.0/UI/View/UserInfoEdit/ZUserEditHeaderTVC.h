//
//  ZUserEditHeaderTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserEditHeaderTVC : ZBaseTVC

///开始编辑
@property (copy ,nonatomic) void(^onBeginEdit)();
///头像点击事件
@property (copy, nonatomic) void(^onPhotoClick)();

///获取昵称
-(NSString *)getNickName;
///获取个性签名
-(NSString *)getSign;
///设置头像
-(void)setUserPhoto:(NSData *)dataPhoto;

@end
