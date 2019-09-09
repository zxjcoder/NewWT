//
//  ZTextField.m
//  PlaneCircle
//
//  Created by Daniel on 8/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTextField.h"
#import "Utils.h"
#import "ClassCategory.h"
#import "TextField.h"

@interface ZTextField()<UITextFieldDelegate>

/// 当前文本属于那个位置
@property (assign, nonatomic) int indexField;
/// 最大输入
@property (assign, nonatomic) int maxCount;
/// 是否支持表情
@property (assign, nonatomic) BOOL isEmoji;
/// 输入框
@property (strong, nonatomic) TextField *textField;

@end

@implementation ZTextField

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    self.maxCount = 100;
    self.isEmoji = true;
    if (!self.textField) {
        self.textField = [[TextField alloc] initWithFrame:self.bounds];
        [self.textField setDelegate:self];
        [self.textField setReturnKeyType:(UIReturnKeyDone)];
        [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
        [self.textField setClearButtonMode:(UITextFieldViewModeWhileEditing)];
        [self.textField setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        
        [self addSubview:self.textField];
    }
}

-(void)setViewFrame:(CGRect)frame
{
    [self setFrame:frame];
    [self.textField setFrame:self.bounds];
}

-(void)setFont:(UIFont*)font
{
    [self.textField setFont:font];
}
-(void)setKeyboardType:(UIKeyboardType)type
{
    [self.textField setKeyboardType:(type)];
}
-(void)setClearButtonMode:(UITextFieldViewMode)model
{
    [self.textField setClearButtonMode:(model)];
}
-(void)setReturnKeyType:(UIReturnKeyType)type
{
    [self.textField setReturnKeyType:(type)];
}
-(void)setText:(NSString *)val
{
    [self.textField setText:val];
}
-(void)setAttributedText:(NSAttributedString *)val
{
    [self.textField setAttributedText:val];
}
-(void)setTextAlignment:(NSTextAlignment)val
{
    [self.textField setTextAlignment:val];
}
-(void)setTextColor:(UIColor *)color
{
    [self.textField setTextColor:color];
}
-(void)setTintColor:(UIColor *)color
{
    [self.textField setTintColor:color];
}
-(void)setSecureTextEntry:(BOOL)val
{
    [self.textField setSecureTextEntry:val];
}
-(void)setPlaceholder:(NSString *)val
{
    [self.textField setPlaceholder:val];;
    [self drawPlaceholderColor:RGBCOLOR(166, 176, 190)];
}
-(void)setEnabled:(BOOL)enabled
{
    [self.textField setEnabled:enabled];
}
- (void)drawPlaceholderColor:(UIColor *)color
{
    [self.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.textField.placeholder attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[ZFont systemFontOfSize:kFont_Small_Size]}]];
}
-(void)setInputView:(UIView *)val
{
    [self.textField setInputView:val];;
}
-(void)setContentMode:(UIViewContentMode)val
{
    [self.textField setContentMode:val];;
}
-(void)setBorderStyle:(UITextBorderStyle)val
{
    [self.textField setBorderStyle:val];;
}
-(void)setBackgroundColor:(UIColor *)val
{
    [super setBackgroundColor:val];
    [self.textField setBackgroundColor:val];;
}
-(void)setInputAccessoryView:(UIView *)val
{
    [self.textField setInputAccessoryView:val];
}
-(void)setReplaceRange
{
    [self.textField setReplaceRange];
}
-(NSAttributedString *)attributedText
{
    return self.textField.attributedText;
}
-(NSString *)text
{
    return self.textField.text;
}
-(NSString *)placeholder
{
    return self.textField.placeholder;
}
///显示键盘
-(void)becomeFirstResponder
{
    [self.textField becomeFirstResponder];
}
///隐藏键盘
-(void)resignFirstResponder
{
    [self.textField resignFirstResponder];
}
///是否支持表情
-(void)setIsEmojiInput:(BOOL)isEmoji
{
    [self setIsEmoji:isEmoji];
}
///是否支持表情
-(BOOL)getIsEmojiInput
{
    return self.isEmoji;
}

-(void)dealloc
{
    OBJC_RELEASE(_textField);
    OBJC_RELEASE(_onReturnText);
    OBJC_RELEASE(_onEndEditText);
    OBJC_RELEASE(_onBeginEditText);
    OBJC_RELEASE(_onTextDidChange);
}

///设置最大值
-(void)setMaxLength:(int)length
{
    self.maxCount = length;
}
///获取最大值
-(int)getMaxLength
{
    return self.maxCount;
}

///设置键盘位置
-(void)setTextFieldIndex:(int)index
{
    [self setIndexField:index];
    [self.textField setTag:index];
}
///获取键盘位置
-(int)getTextFieldIndex
{
    return self.indexField;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.onBeginEditText) {
        self.onBeginEditText();
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.onReturnText) {
        self.onReturnText();
    }
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    GBLog(@"文本输入框 text: %@,  rangelength: %d, rangelocation: %d, string: %@", textField.text, range.length, range.location, string);
    if (string.length == 0) {
        NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (self.onTextDidChange) {
            self.onTextDidChange(comcatstr);
        }
    } else {
        if (!self.isEmoji && [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
            if (self.onTextDidChange) {
                self.onTextDidChange(textField.text);
            }
            return false;
        }
        if (!self.isEmoji && ![string isNineKeyBoard] && [string isEmoji]) {
            if (self.onTextDidChange) {
                self.onTextDidChange(textField.text);
            }
            return false;
        }
        if (self.maxCount > 0 && [textField.text stringByAppendingString:string].length > self.maxCount) {
            if (self.onTextDidChange) {
                self.onTextDidChange(textField.text);
            }
            return false;
        } else {
            NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
            if (self.onTextDidChange) {
                self.onTextDidChange(comcatstr);
            }
        }
    }
    return true;
}

@end

