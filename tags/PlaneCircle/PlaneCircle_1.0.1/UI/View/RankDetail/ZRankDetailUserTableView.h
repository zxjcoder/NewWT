//
//  ZRankDetailUserTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZRankDetailUserTableView : ZBaseTableView

@property (copy, nonatomic) void(^onRefreshCompanyFooter)();

@property (copy, nonatomic) void(^onUpdRankUserClick)(ModelRankUser *model);

-(void)setViewDataWithModel:(ModelRankUser *)model;

@end
