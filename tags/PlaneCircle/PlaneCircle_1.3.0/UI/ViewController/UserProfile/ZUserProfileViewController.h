//
//  ZUserProfileViewController.h
//  PlaneCircle
//
//  Created by Daniel on 6/10/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"

@interface ZUserProfileViewController : ZBaseViewController

///父级页面
@property (weak, nonatomic) id preVC;

///设置数据源
-(void)setViewDataWithModel:(ModelUserBase *)model;

@end
