//
//  ZRankDetailAchievementTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZRankDetailAchievementTableView : ZBaseTableView

-(void)setViewDataWithDictionary:(NSDictionary *)dic;

-(void)setViewDataWithModel:(ModelRankCompany *)model;

@end
