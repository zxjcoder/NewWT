//
//  ZCircleQuestionViewController.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"

@interface ZCircleQuestionViewController : ZBaseViewController

///父级VC
@property (weak, nonatomic) id preVC;

///设置关联实务ID
-(void)setPracticeId:(NSString *)practiceId;

@end
