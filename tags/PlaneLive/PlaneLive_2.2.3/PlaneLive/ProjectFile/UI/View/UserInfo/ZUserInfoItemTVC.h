//
//  ZUserInfoItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserInfoItemTVC : ZBaseTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZUserInfoItemTVCType)type;

-(ZUserInfoItemTVCType)getCellType;

-(void)setHiddenLineView;

@end
