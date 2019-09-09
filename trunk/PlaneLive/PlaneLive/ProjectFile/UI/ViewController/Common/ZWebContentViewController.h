//
//  ZWebContentViewController.h
//  PlaneLive
//
//  Created by Daniel on 06/03/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseViewController.h"

///实务和订阅网页详情-课件或内容
@interface ZWebContentViewController : ZBaseViewController

///设置加载到评论区域
-(void)setViewWithMessageLoad;
///设置数据源
-(void)setViewDataWithModel:(ModelEntity *)model isCourse:(BOOL)isCourse;

@end
