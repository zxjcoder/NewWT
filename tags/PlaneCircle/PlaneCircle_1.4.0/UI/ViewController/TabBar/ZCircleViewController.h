//
//  ZCircleViewController.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"

///圈子
@interface ZCircleViewController : ZBaseViewController

///显示键盘
-(void)setViewShowKeyboard;

///顶部内容区域切换
-(void)setScrollViewContentOffsetWithIndex:(ZCircleToolViewItem)index;

@end
