//
//  ZNewSubscribeAlreadyHasInfoView.h
//  PlaneLive
//
//  Created by WT on 02/04/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZView.h"

@interface ZNewSubscribeAlreadyHasInfoView : ZView

///批量下载
@property (copy, nonatomic) void(^onDownloadEvent)(ModelSubscribe *model);
/// 隐藏批量下载
-(void)setHiddenDownloadButton:(BOOL)isHidden;;

-(void)setCellDataWithModel:(ModelSubscribe *)model;
+(CGFloat)getH;

@end
