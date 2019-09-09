//
//  ZSelectTopicViewController.h
//  PlaneCircle
//
//  Created by Daniel on 8/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"
#import "ZPublishQuestionViewController.h"
#import "ZQuestionEditViewController.h"

@interface ZSelectTopicViewController : ZBaseViewController

///父级VC
@property (weak, nonatomic) ZPublishQuestionViewController *preVC;
///编辑问题VC
@property (weak, nonatomic) ZQuestionEditViewController *preQVC;

@end
