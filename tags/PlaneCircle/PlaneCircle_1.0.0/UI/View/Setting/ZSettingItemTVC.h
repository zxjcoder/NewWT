//
//  ZSettingItemTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

typedef NS_ENUM(NSInteger, ZSettingItemTVCType)
{
    ///修改密码
    ZSettingItemTVCTypeUpdatePwd = 1,
    ///黑名单管理
    ZSettingItemTVCTypeBlackListManager = 2,
    ///退出账号
    ZSettingItemTVCTypeExitUser = 3,
    ///清除缓存
    ZSettingItemTVCTypeClearCache = 4,
};

@interface ZSettingItemTVC : ZBaseTVC

@property (assign, nonatomic) ZSettingItemTVCType type;

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellType:(ZSettingItemTVCType)cellType;

-(void)setViewFileSize:(float)size;

@end