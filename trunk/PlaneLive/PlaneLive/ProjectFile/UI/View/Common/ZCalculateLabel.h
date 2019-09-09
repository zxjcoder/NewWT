//
//  ZCalculateLabel.h
//  PlaneCircle
//
//  Created by Daniel on 7/25/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

///计算高度
@interface ZCalculateLabel : UILabel

///单例模式
+(ZCalculateLabel *)shareCalculateLabel;

///根据字体和宽度获取一行的文本高度
-(CGFloat)getALineHeightWithFont:(UIFont *)font width:(CGFloat)width;

///根据字体,高度,文本内容获取一行宽度
-(CGFloat)getALineWidthWithFont:(UIFont *)font height:(CGFloat)height text:(NSString *)text;

///获取最大高度->numberOfLines!=0的情况
-(CGFloat)getMaxLineHeightWithLabel:(UILabel *)label;

///获取最大高度
-(CGFloat)getMaxLineHeightWithLabel:(UILabel *)label line:(NSInteger)line;

@end
