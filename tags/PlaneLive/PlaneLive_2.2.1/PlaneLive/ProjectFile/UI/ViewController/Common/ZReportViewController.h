//
//  ZReportViewController.h
//  PlaneCircle
//
//  Created by Daniel on 7/22/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"

@interface ZReportViewController : ZBaseViewController

///设置数据源
-(void)setViewDataWithIds:(NSString *)ids type:(ZReportType)type;

@end
