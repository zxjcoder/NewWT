//
//  ZRankDetailHeaderTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZRankDetailHeaderTVC : ZBaseTVC

@property (copy, nonatomic) void(^onUpdRankCompanyClick)(ModelRankCompany *model);

@property (copy, nonatomic) void(^onUpdRankUserClick)(ModelRankUser *model);

@end
