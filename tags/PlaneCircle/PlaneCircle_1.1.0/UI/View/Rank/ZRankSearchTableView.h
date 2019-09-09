//
//  ZRankSearchTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZRankSearchTableView : ZBaseTableView

@property (copy, nonatomic) void(^onRankCompanyClick)(ModelRankCompany *model);

@property (copy, nonatomic) void(^onRankUserClick)(ModelRankUser *model);

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult;

@end
