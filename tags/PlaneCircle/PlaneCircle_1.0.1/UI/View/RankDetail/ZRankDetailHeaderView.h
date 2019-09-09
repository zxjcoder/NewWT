//
//  ZRankDetailHeaderView.h
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZRankDetailHeaderView : ZView

@property (copy, nonatomic) void(^onUpdRankCompanyClick)(ModelRankCompany *model);

@property (copy, nonatomic) void(^onUpdRankUserClick)(ModelRankUser *model);

-(void)setViewDataWithModel:(ModelEntity *)model;

-(CGFloat)getH;

@end
