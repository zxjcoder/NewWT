//
//  ZPracticeDetailViewController.h
//  PlaneCircle
//
//  Created by Daniel on 6/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"

@interface ZPracticeDetailViewController : ZBaseViewController

///父级VC
@property (weak, nonatomic) id preVC;
///是否推送
@property (assign, nonatomic) BOOL isPushVC;

///设置数据源
-(void)setViewDataWithArray:(NSArray *)arr arrDefaultRow:(NSInteger)row;

@end
