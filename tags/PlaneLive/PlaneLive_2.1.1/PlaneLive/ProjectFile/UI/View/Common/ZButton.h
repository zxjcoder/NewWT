//
//  ZButton.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kButtonShareW 70
#define kButtonShareH 80

@interface ZButton : UIButton

///数据对象
@property (strong, nonatomic) ModelEntity *model;

@property (assign, nonatomic) ZShareType type;

///初始化
-(id)initWithDownloadWithFrame:(CGRect)frame;

///初始化
-(id)initWithShareType:(ZShareType)type;

///初始化
-(id)initWithReportType:(ZReportViewType)type;

///初始化
-(id)initWithText:(NSString *)text imageName:(NSString *)imageName;

///获取文本内容
-(NSString *)getText;

///获取文本标题
-(NSString *)getTitle;

///设置下载图片
-(void)setDownloadImage:(NSString *)image;
///设置下载进度
-(void)setDownloadProgress:(CGFloat)progress;

///设置坐标->图片间距5
-(void)setIconFrame:(CGRect)frame;

///设置坐标->图片大小25
-(void)setBtnFrame:(CGRect)frame;

///设置坐标->图片大小50
-(void)setBtnPoint:(CGPoint)point;

///设置按钮文字
-(void)setButtonText:(NSString *)text;

///设置按钮文字颜色
-(void)setButtonTextColor:(UIColor *)color;

///设置按钮文字大小
-(void)setButtonTextFontSize:(CGFloat)size;

///设置按钮图片
-(void)setButtonImageName:(NSString *)imageName;

@end
