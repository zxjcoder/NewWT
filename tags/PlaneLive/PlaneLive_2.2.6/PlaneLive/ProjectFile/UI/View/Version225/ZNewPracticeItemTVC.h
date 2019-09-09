//
//  ZNewPracticeItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 19/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZNewPracticeItemTVC : ZBaseTVC

///播放中
-(void)setModelPlayStatus:(BOOL)isPlay;

///隐藏价格
-(void)setHiddenPrice;
///隐藏底部时间
-(void)setHiddenTime;
///隐藏分割线
-(void)setHiddenLine:(BOOL)hidden;

///无底部时间和点赞的高度
+(CGFloat)getMinH;

@end
