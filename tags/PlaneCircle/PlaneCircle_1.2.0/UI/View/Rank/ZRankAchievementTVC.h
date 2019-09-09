//
//  ZRankAchievementTVC.h
//  PlaneCircle
//
//  Created by Daniel on 8/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZRankAchievementTVC : ZBaseTVC

///律师事务所
@property (copy, nonatomic) void(^onLawyerClick)();
///证券公司
@property (copy, nonatomic) void(^onSecuritiesClick)();
///会计事务所
@property (copy, nonatomic) void(^onAccountingClick)();

@end
