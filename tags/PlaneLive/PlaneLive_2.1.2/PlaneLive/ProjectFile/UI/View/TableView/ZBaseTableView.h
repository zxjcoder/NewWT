//
//  ZBaseTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTableView.h"

@interface ZBaseTableView : ZTableView

///原始数据
@property (strong, nonatomic) NSDictionary *dicRawData;

///设置数据源
-(void)setViewDataWithDictionary:(NSDictionary *)dicResult;

///设置数据源
-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;

///设置关键字
-(void)setViewKeyword:(NSString *)keyword;


@end
