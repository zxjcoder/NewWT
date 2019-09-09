//
//  ZTextField.h
//  PlaneCircle
//
//  Created by Daniel on 8/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZTextFieldInputType)
{
    ZTextFieldInputTypeNone = 0,
    ZTextFieldInputTypeEMail = 1,
    ZTextFieldInputTypePhone = 2,
    ZTextFieldInputTypePassword = 3,
    ZTextFieldInputTypeAccount = 4,
    ZTextFieldInputTypeCode = 5,
};

@interface ZTextField : UIView

///文本开始编辑
@property (copy, nonatomic) void(^onBeginEditText)();
///文本换行
@property (copy, nonatomic) void(^onReturnText)();
///文本结束编辑
@property (copy, nonatomic) void(^onEndEditText)(NSString *text);
///文本内容编辑
@property (copy, nonatomic) void(^onTextDidChange)(NSString *text);

-(void)setViewFrame:(CGRect)frame;

///显示下划线
-(void)setIsShowLine:(BOOL)show;
///设置错误提示
-(void)setPrompt:(NSString *)text;
///设置当前输入类型
-(void)setTextInputType:(ZTextFieldInputType)type;

-(void)setFont:(UIFont*)font;
-(void)setKeyboardType:(UIKeyboardType)type;
-(void)setClearButtonMode:(UITextFieldViewMode)model;
-(void)setReturnKeyType:(UIReturnKeyType)type;

-(void)setText:(NSString *)val;
-(void)setAttributedText:(NSAttributedString *)val;
-(void)setTextAlignment:(NSTextAlignment)val;
-(void)setTextColor:(UIColor *)color;
-(void)setTintColor:(UIColor *)color;
-(void)setSecureTextEntry:(BOOL)val;
-(void)setPlaceholder:(NSString *)val;
-(void)setInputView:(UIView *)val;
-(void)setEnabled:(BOOL)enabled;
-(void)setContentMode:(UIViewContentMode)val;
-(void)setBorderStyle:(UITextBorderStyle)val;

-(void)setInputAccessoryView:(UIView *)val;
-(void)setReplaceRange;

-(NSAttributedString *)attributedText;
-(NSString *)text;
- (void)drawPlaceholderColor:(UIColor *)color;
-(NSString *)placeholder;

///设置键盘位置
-(void)setTextFieldIndex:(int)index;
///获取键盘位置
-(int)getTextFieldIndex;

///显示键盘
-(void)becomeFirstResponder;
///隐藏键盘
-(void)resignFirstResponder;

///设置最大值
-(void)setMaxLength:(int)length;
///获取最大值
-(int)getMaxLength;

///是否支持表情
-(void)setIsEmojiInput:(BOOL)isEmoji;
///是否支持表情
-(BOOL)getIsEmojiInput;

///添加键盘监听事件
-(void)addTextFieldTextDidChangeNotification;
///删除键盘监听事件
-(void)removeTextFieldTextDidChangeNotification;

@end
