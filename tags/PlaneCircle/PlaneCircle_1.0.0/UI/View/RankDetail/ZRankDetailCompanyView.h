//
//  ZRankDetailCompanyView.h
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZRankDetailCompanyView : ZView

///1选中公司,2选中人
@property (assign, nonatomic) int selType;

@property (copy, nonatomic) void(^onRefreshCompanyFooter)();

@property (copy, nonatomic) void(^onRefreshUserFooter)();

@property (copy, nonatomic) void(^onUpdRankCompanyClick)(ModelRankCompany *model);

-(void)setViewDataWithModel:(ModelRankCompany *)model;

-(void)setViewCompanyWithDictionary:(NSDictionary *)dic;

-(void)setViewUserWithDictionary:(NSDictionary *)dic;

-(void)endRefreshCompanyFooter;

-(void)endRefreshUserFooter;

@end
