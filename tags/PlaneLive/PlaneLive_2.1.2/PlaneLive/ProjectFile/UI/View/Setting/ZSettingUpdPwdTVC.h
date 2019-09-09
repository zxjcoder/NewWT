//
//  ZSettingUpdPwdTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

typedef NS_ENUM(NSInteger, ZSettingUpdPwdTVCType)
{
    ///新密码
    ZSettingUpdPwdTVCTypeNewPwd = 1,
    ///就密码
    ZSettingUpdPwdTVCTypeOldPwd = 2,
};

@interface ZSettingUpdPwdTVC : ZBaseTVC

@property (assign, nonatomic) ZSettingUpdPwdTVCType type;

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellType:(ZSettingUpdPwdTVCType)cellType;

-(NSString *)getText;

@end
