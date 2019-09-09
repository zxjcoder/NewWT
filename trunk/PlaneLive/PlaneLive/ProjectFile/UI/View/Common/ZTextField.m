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
#import "ZLabel.h"
#import "ZBGTriangularView.h"

@interface ZTextField()<UITextFieldDelegate>

/// 当前文本属于那个位置
@property (assign, nonatomic) int indexField;
/// 最大输入
@property (assign, nonatomic) int maxCount;
/// 是否支持表情
@property (assign, nonatomic) BOOL isEmoji;
/// 输入框
@property (strong, nonatomic) TextField *textField;
@property (strong, nonatomic) UIImageView *imageLine1;
@property (strong, nonatomic) UIImageView *imageLine2;
@property (strong, nonatomic) UIImageView *imageIcon;
@property (strong, nonatomic) ZBGTriangularView *viewPrompt;
@property (assign, nonatomic) ZTextFieldInputType inputType;
@property (assign, nonatomic) BOOL isPromptShowing;
@property (assign, nonatomic) CGRect line1Frame;
@property (assign, nonatomic) CGRect line2Frame;
@property (assign, nonatomic) BOOL isShowIcon;
@property (assign, nonatomic) CGRect promptFrame;
@property (assign, nonatomic) CGRect iconFrame;
@property (assign, nonatomic) BOOL showLine;

@end

@implementation ZTextField

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    self.showLine = true;
    self.isShowIcon = false;
    self.isPromptShowing = false;
    self.maxCount = 100;
    self.isEmoji = true;
    self.inputType = ZTextFieldInputTypeNone;
    if (!self.textField) {
        self.textField = [[TextField alloc] initWithFrame:self.bounds];
        [self.textField setDelegate:self];
        [self.textField setReturnKeyType:(UIReturnKeyDone)];
        [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
        [self.textField setClearButtonMode:(UITextFieldViewModeWhileEditing)];
        [self.textField setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        
        [self addSubview:self.textField];
    }
    CGFloat iconSize = 20;
    self.iconFrame = CGRectMake(0, self.height/2-iconSize/2, iconSize, iconSize);
    self.imageIcon = [[UIImageView alloc] initWithFrame:(self.iconFrame)];
    [self.imageIcon setHidden:true];
    [self.imageIcon setUserInteractionEnabled:false];
    [self addSubview:self.imageIcon];
    
    self.line1Frame = CGRectMake(0, self.height-kLineHeight, self.width, kLineHeight);
    self.imageLine1 = [[UIImageView alloc] initWithImage:[UIImage createImageWithColor:COLORVIEWBACKCOLOR3]];
    self.imageLine1.frame = self.line1Frame;
    self.imageLine1.userInteractionEnabled = false;
    [self addSubview:self.imageLine1];
    
    self.line2Frame = CGRectMake(0, self.height-2, self.width, 2);
    self.imageLine2 = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"btn_gra3"]];
    self.imageLine2.frame = self.line2Frame;
    self.imageLine2.userInteractionEnabled = false;
    [self.imageLine2 setAlpha:0];
    [self addSubview:self.imageLine2];
    
    self.promptFrame = CGRectMake(0, -30, 22, 30);
    self.viewPrompt = [[ZBGTriangularView alloc] initWithFrame:(self.promptFrame)];
    self.viewPrompt.hidden = true;
    self.viewPrompt.alpha = 0;
    [self.viewPrompt setUserInteractionEnabled:false];
    [self addSubview:self.viewPrompt];
}
-(void)setViewFrame:(CGRect)frame
{
    [self setFrame:frame];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect iconNewFrame = self.iconFrame;
    CGFloat iconY = self.height/2-iconNewFrame.size.height/2;
    iconNewFrame.origin.y = iconY;
    [self.imageIcon setFrame:iconNewFrame];
    if (self.isShowIcon) {
        CGFloat textX = self.imageIcon.x+self.imageIcon.width+10;
        CGFloat textW = self.width-textX;
        [self.textField setFrame:CGRectMake(textX, 0, textW, self.height)];
        
        self.viewPrompt.frame = CGRectMake(textX, self.viewPrompt.y, self.viewPrompt.width, self.viewPrompt.height);
    } else {
        [self.textField setFrame:self.bounds];
        self.viewPrompt.frame = CGRectMake(0, self.viewPrompt.y, self.viewPrompt.width, self.viewPrompt.height);
    }
    self.line1Frame = CGRectMake(0, self.height-kLineHeight, self.width, kLineHeight);
    self.line2Frame = CGRectMake(0, self.height-2, self.width, 2);
    self.imageLine1.frame = self.line1Frame;
    self.imageLine2.frame = self.line2Frame;
    [self setNeedsDisplay];
    [self setChangeViewLevels];
}
-(void)setChangeViewLevels
{
    [self bringSubviewToFront:self.viewPrompt];
    [self sendSubviewToBack:self.textField];
    [self sendSubviewToBack:self.imageLine1];
    [self sendSubviewToBack:self.imageLine2];
    [self sendSubviewToBack:self.imageIcon];
}
-(void)setTextInputType:(ZTextFieldInputType)type
{
    self.inputType = type;
    self.imageIcon.hidden = true;
    self.isShowIcon = false;
    switch (type) {
        case ZTextFieldInputTypeCode:
        {
            self.imageIcon.hidden = false;
            self.isShowIcon = true;
            self.imageIcon.image = [UIImage imageNamed:@"verify_code"];
            break;
        }
        case ZTextFieldInputTypePassword:
        {
            self.imageIcon.hidden = false;
            self.isShowIcon = true;
            self.imageIcon.image = [UIImage imageNamed:@"password"];
            break;
        }
        case ZTextFieldInputTypeAccount:
        {
            self.imageIcon.hidden = false;
            self.isShowIcon = true;
            self.imageIcon.image = [UIImage imageNamed:@"user"];
            break;
        }
        default:
            break;
    }
    [self setViewFrame:self.frame];
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
///显示下划线
-(void)setIsShowLine:(BOOL)show
{
    self.showLine = show;
    self.imageLine1.hidden = !show;
    self.imageLine2.hidden = !show;
}
///设置错误提示
-(void)setPrompt:(NSString *)text
{
    if (!self.isPromptShowing) {
        [self.viewPrompt setErrorText:text];
        [self showPrompt];
    } else {
        [self dismissPromptEndShow:text];
    }
}
///提示层隐藏时间
-(CGFloat)dismissTime
{
    return 2.0f;
}
///显示提示层
-(void)showPrompt
{
    self.isPromptShowing = true;
    [self.viewPrompt setAlpha:0];
    self.viewPrompt.hidden = false;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [self.viewPrompt setAlpha:1];
    } completion:^(BOOL finished) {
        GCDAfterBlock([self dismissTime], ^{
            [self dismissPrompt];
        });
    }];
}
///隐藏提示层
-(void)dismissPrompt
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [self.viewPrompt setAlpha:0];
    } completion:^(BOOL finished) {
        [self.viewPrompt setHidden:true];
        self.isPromptShowing = false;
    }];
}
//隐藏完毕马上开始显示
-(void)dismissPromptEndShow:(NSString *)text
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [self.viewPrompt setAlpha:0];
    } completion:^(BOOL finished) {
        [self.viewPrompt setHidden:true];
        self.isPromptShowing = false;
        [self.viewPrompt setErrorText:text];
        [self showPrompt];
    }];
}
-(void)setCheckInputText
{
    switch (self.inputType) {
        case ZTextFieldInputTypeEMail:
        {
            NSString *text = self.textField.text;
            if (text == nil || text.length == 0) {
                [self setPrompt:@"电子邮件不能为空"];
                return;
            }
            if (![text isEmail]) {
                [self setPrompt:@"请输入有效的电子邮件"];
                return;
            }
            break;
        }
        case ZTextFieldInputTypePhone:
        {
            NSString *text = self.textField.text;
            if (text == nil || text.length == 0) {
                [self setPrompt:@"手机号不能为空"];
                return;
            }
            if (![text isMobile]) {
                [self setPrompt:@"请输入有效的手机号"];
                return;
            }
            break;
        }
        case ZTextFieldInputTypeAccount:
        {
            NSString *text = self.textField.text;
            if (text == nil || text.length == 0) {
                [self setPrompt:@"手机号不能为空"];
                return;
            }
            if (![text isMobile]) {
                [self setPrompt:@"请输入有效的手机号"];
                return;
            }
            break;
        }
        case ZTextFieldInputTypeCode:
        {
            NSString *text = self.textField.text;
            if (text == nil || text.length == 0) {
                [self setPrompt:@"验证码不能为空"];
                return;
            }
            if (![text isMobile]) {
                [self setPrompt:@"请输入有效的验证码"];
                return;
            }
            break;
        }
        case ZTextFieldInputTypePassword:
        {
            NSString *text = self.textField.text;
            if (text == nil || text.length == 0) {
                [self setPrompt:@"密码不能为空"];
                return;
            }
            if (![text isPassword]) {
                [self setPrompt:@"请输入有效的密码"];
                return;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.onBeginEditText) {
        self.onBeginEditText();
    }
    if (self.showLine) {
        self.imageLine2.alpha = 0;
        CGRect line2Frame = self.line2Frame;
        line2Frame.origin.x += 20;
        line2Frame.size.width -= 40;
        self.imageLine2.frame = line2Frame;
        [UIView animateWithDuration:0.1 animations:^{
            self.imageLine2.alpha = 1;
            self.imageLine2.frame = self.line2Frame;
        }];
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.showLine) {
        [UIView animateWithDuration:0.1 animations:^{
            self.imageLine2.alpha = 0;
            CGRect line2Frame = self.line2Frame;
            line2Frame.origin.x += 20;
            line2Frame.size.width -= 40;
            self.imageLine2.frame = line2Frame;
        } completion:^(BOOL finished) {
            [self setCheckInputText];
        }];
    }
    return true;
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

