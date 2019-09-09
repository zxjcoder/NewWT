//
//  ZRankAchievementView.h
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZRankAchievementView : ZView

///律师事务所
@property (copy, nonatomic) void(^onLawyerClick)();
///证券公司
@property (copy, nonatomic) void(^onSecuritiesClick)();
///会计事务所
@property (copy, nonatomic) void(^onAccountingClick)();

+(CGFloat)getViewH;

@end
