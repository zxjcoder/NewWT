//
//  ZCircleButton.h
//  小球拖拽拉伸
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockName)(UIButton *button);

@interface ZCircleButton : UIButton

///初始化对象
+(id)buttonWithFrame:(CGRect)frame isAllowDrag:(BOOL)isAllowDrag;
/**
 *  最大拖动范围,默认为100
 */
@property (nonatomic,assign) NSInteger maxDistance;
/**
 *  点击事件block
 */
@property (nonatomic,assign) blockName clickName;
/**
 *  拖动销毁事件block
 */
@property (nonatomic,assign) blockName panEndName;

@end
