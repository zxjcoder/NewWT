//
//  ZUserItemTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

typedef NS_ENUM(NSInteger, ZUserItemTVCType)
{
    ///收藏
    ZUserItemTVCTypeCollection = 1,
    ///回答
    ZUserItemTVCTypeAnswer = 2,
    ///关注
    ZUserItemTVCTypeAttention = 3,
    ///问题反馈
    ZUserItemTVCTypeFeedback = 4,
    ///设置
    ZUserItemTVCTypeSetting = 5,
    ///协议
    ZUserItemTVCTypeAgreement = 6,
    ///通知中心
    ZUserItemTVCTypeNoticeCenter = 7,
    ///评论
    ZUserItemTVCTypeComment = 8,
    ///任务中心
    ZUserItemTVCTypeTaskCenter = 9,
};

@interface ZUserItemTVC : ZBaseTVC

@property (assign, nonatomic) ZUserItemTVCType type;

///初始化对象
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellType:(ZUserItemTVCType)cellType;

@end
