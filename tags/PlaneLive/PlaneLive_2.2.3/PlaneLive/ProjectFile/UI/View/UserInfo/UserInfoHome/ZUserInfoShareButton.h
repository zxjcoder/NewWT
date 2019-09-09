//
//  ZUserInfoShareButton.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButton.h"

@interface ZUserInfoShareButton : ZButton

///设置数据源
-(void)setViewDataWithTitle:(NSString *)title imageName:(NSString *)imageName count:(long)count;

@end
