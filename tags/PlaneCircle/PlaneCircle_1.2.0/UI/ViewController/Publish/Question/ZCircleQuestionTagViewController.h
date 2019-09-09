//
//  ZCircleQuestionTagViewController.h
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"
#import "ZCircleQuestionViewController.h"
#import "ZQuestionEditViewController.h"

@interface ZCircleQuestionTagViewController : ZBaseViewController

///父级VC
@property (weak, nonatomic) ZCircleQuestionViewController *preVC;
///编辑问题VC
@property (weak, nonatomic) ZQuestionEditViewController *preQVC;

@end
