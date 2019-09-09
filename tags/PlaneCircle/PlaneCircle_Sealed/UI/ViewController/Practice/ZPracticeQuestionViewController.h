//
//  ZPracticeQuestionViewController.h
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"

@interface ZPracticeQuestionViewController : ZBaseViewController

///父级VC
@property (weak, nonatomic) id preVC;
///是否推送
@property (assign, nonatomic) BOOL isPushVC;

///添加问题成功
-(void)setPublishPracticeQuestion:(ModelQuestion *)model;
///设置数据源
-(void)setViewDataWithArray:(NSArray *)arr arrDefaultRow:(NSInteger)row;

@end
