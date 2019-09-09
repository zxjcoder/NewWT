//
//  ZRankHotTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZRankHotTVC : ZBaseTVC

@property (copy, nonatomic) void(^onRankCompanyClick)(ModelRankCompany *model);

@property (copy, nonatomic) void(^onRankUserClick)(ModelRankUser *model);

-(void)setCellDataWithDictionary:(NSDictionary *)dicResult;

@end
