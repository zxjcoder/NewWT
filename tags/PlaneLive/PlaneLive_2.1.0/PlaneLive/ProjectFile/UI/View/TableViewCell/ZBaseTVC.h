//
//  ZBaseTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ModelEntity.h"
#import "ZButton.h"
#import "ZImageView.h"
#import "ClassCategory.h"
#import "ZTVCBGView.h"
#import "ZCalculateLabel.h"
#import "ZFont.h"
#import "ZLabel.h"
#import "ZRichStyleLabel.h"
#import "ZView.h"

@interface ZBaseTVC : UITableViewCell

///主视图
@property (strong, nonatomic) ZTVCBGView *viewMain;
///间隔大小
@property (assign, nonatomic) CGFloat space;

///CELL宽度
@property (assign, nonatomic) CGFloat cellW;
///CELL高度
@property (assign, nonatomic) CGFloat cellH;

///右侧箭头宽度
@property (assign, nonatomic) CGFloat arrowW;
///分割线高度->比较细
@property (assign, nonatomic) CGFloat lineH;
///分割线高度->比较粗
@property (assign, nonatomic) CGFloat lineMaxH;

///按钮边框宽度
@property (assign, nonatomic) CGFloat borderW;
///提交或保持按钮高度
@property (assign, nonatomic) CGFloat buttonH;

///右边提示宽度-只供4个汉字
@property (assign, nonatomic) CGFloat leftW;
///右边X距离
@property (assign, nonatomic) CGFloat rightX;
///文本默认高度
@property (assign, nonatomic) CGFloat lbH;
///文本小字号高度
@property (assign, nonatomic) CGFloat lbMinH;

///设置字体大小
@property (assign, nonatomic) CGFloat fontSize;

///初始化
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

///设置CELL数据对象
-(CGFloat)setCellDataWithModel:(ModelEntity *)model;

///设置关键字
-(void)setCellKeyword:(NSString *)keyword;

///初始化数据
-(void)innerInit;

///回收内存
-(void)setViewNil;

///获取当前CELL高度
+(CGFloat)getH;
///获取当前CELL高度
-(CGFloat)getH;

@end
