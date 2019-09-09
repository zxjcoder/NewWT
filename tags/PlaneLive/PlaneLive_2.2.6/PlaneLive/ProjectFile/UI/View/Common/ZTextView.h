//
//  ZTextView.h
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTextView : UIView

///文本开始编辑
@property (copy, nonatomic) void(^onBeginEditText)();
///文本换行
@property (copy, nonatomic) void(^onReturnText)();
///文本结束编辑
@property (copy, nonatomic) void(^onEndEditText)(NSString *text, NSRange selectedRange);
///撤销事件
@property (copy, nonatomic) void(^onRevokeChange)(NSString *text, NSRange range);
///文本内容编辑
@property (copy, nonatomic) void(^onTextDidChange)(NSString *text, NSRange range);
///内容高度监听
@property (copy, nonatomic) void(^onContentHeightChange)(CGFloat height);

///设置背景
-(void)setViewBackgroundColor:(UIColor *)color;
///设置提示内容
-(void)setPlaceholderText:(NSString *)text;

///设置字体
-(void)setFont:(UIFont *)font;

///设置键盘
-(void)setReturnKeyType:(UIReturnKeyType )keyType;
///根据内容获取内容高度
- (CGSize)setViewSizeThatFits:(CGSize)size;;
///获取文本
-(NSString *)text;

///设置文本
-(void)setText:(NSString *)text;

///设置是否允许换行
-(void)setIsInputNewLine:(BOOL)isNewLine;

///设置是否状态栏点击到顶部
-(void)setScrollsToTop:(BOOL)isTop;

///显示键盘
-(void)becomeFirstResponder;
///隐藏键盘
-(void)resignFirstResponder;

///设置键盘
-(void)setInputAccessoryView:(UIView *)view;
///设置值
-(void)setAttributedText:(NSMutableAttributedString *)attStr;
///获取值
-(NSAttributedString *)attributedText;
///设置颜色
-(void)setTextColor:(UIColor *)color;

///设置指数提示是否显示
-(void)setIsHiddenCountLabel:(BOOL)isHidden;

///设置内容
-(void)setViewText:(NSString *)text;

///设置坐标
-(void)setViewFrame:(CGRect)frame;
///设置最大输入
-(void)setMaxLength:(int)count;
///获取最大输入
-(int)getMaxLength;
///设置最大输入颜色
-(void)setDescColorCount:(int)count;

///是否支持表情
-(void)setIsEmojiInput:(BOOL)isEmoji;
///是否支持表情
-(BOOL)getIsEmojiInput;

@end
