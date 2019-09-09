//
//  ZUserMessageTVC.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/5.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserMessageTVC : ZBaseTVC

@property (copy, nonatomic) void(^onRowHeightChange)(BOOL isShowAll, NSString *ids);
@property (copy, nonatomic) void(^onDeleteClick)(NSInteger row, ModelMyMessage *model);
@property (copy, nonatomic) void(^onSubscribeClick)(ModelMyMessage *model);

-(void)setShowAllState:(BOOL)isShow;
-(BOOL)getShowAllState;

@end
