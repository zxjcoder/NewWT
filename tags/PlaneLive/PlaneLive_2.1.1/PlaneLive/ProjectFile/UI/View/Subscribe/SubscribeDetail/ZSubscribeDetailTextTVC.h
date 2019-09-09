//
//  ZSubscribeDetailTextTVC.h
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

typedef NS_ENUM(NSInteger, ZSubscribeDetailTextTVCType)
{
    /// 主题介绍
    ZSubscribeDetailTextTVCTypeInfo,
    /// 团队介绍
    ZSubscribeDetailTextTVCTypeTeamInfo,
    /// 适合人群
    ZSubscribeDetailTextTVCTypeFitPeople,
    /// 订阅须知
    ZSubscribeDetailTextTVCTypeMustKnow,
    /// 需要帮助
    ZSubscribeDetailTextTVCTypeNeedHelp,
    /// 近期推送
    ZSubscribeDetailTextTVCTypeLatestPush,
};

@interface ZSubscribeDetailTextTVC : ZBaseTVC

///初始化
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZSubscribeDetailTextTVCType)type;

@end
