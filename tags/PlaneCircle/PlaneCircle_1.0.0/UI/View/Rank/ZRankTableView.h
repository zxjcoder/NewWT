//
//  ZRankTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTableView.h"

@interface ZRankTableView : ZTableView

@property (copy, nonatomic) void(^onRankCompanyClick)(ModelRankCompany *model);

@property (copy, nonatomic) void(^onRankUserClick)(ModelRankUser *model);

///律师事务所
@property (copy, nonatomic) void(^onLawyerClick)();
///证券公司
@property (copy, nonatomic) void(^onSecuritiesClick)();
///会计事务所
@property (copy, nonatomic) void(^onAccountingClick)();

///刷新顶部数据
@property (copy, nonatomic) void(^onRefreshHeader)();

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult;

@end
