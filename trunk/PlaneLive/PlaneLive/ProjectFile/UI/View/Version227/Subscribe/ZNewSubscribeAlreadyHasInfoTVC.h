//
//  ZNewSubscribeAlreadyHasInfoTVC.h
//  PlaneLive
//
//  Created by WT on 29/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBaseTVC.h"

/// 已购系列课,培训课 图片标题团队TVC
@interface ZNewSubscribeAlreadyHasInfoTVC : ZBaseTVC

///批量下载
@property (copy, nonatomic) void(^onDownloadEvent)(ModelSubscribe *model);
/// 隐藏批量下载
-(void)setHiddenDownloadButton:(BOOL)isHidden;
/// 透明度批量下载
-(void)setDownloadButtonAlpha:(CGFloat)alpha;

@end
