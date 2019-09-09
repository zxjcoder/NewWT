//
//  ZTextView.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTextView.h"
#import "ClassCategory.h"
#import "Utils.h"

@interface ZTextView()<UITextViewDelegate,UIScrollViewDelegate>
{
    UITextView *_textView;
    ///显示空文本描述
    UILabel *_placeholder;
    ///是否允许换行
    BOOL _isNewLine;
    ///设置隐藏最大数量
    BOOL _isHiddenLabel;
}
///最大输入文字
@property (assign, nonatomic) int maxCount;
///描述文字
@property (assign, nonatomic) int descCount;
/// 是否支持表情
@property (assign, nonatomic) BOOL isEmoji;

@end

@implementation ZTextView

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

-(void)dealloc
{
    OBJC_RELEASE(_placeholder);
    OBJC_RELEASE(_onReturnText);
    OBJC_RELEASE(_onEndEditText);
    OBJC_RELEASE(_onRevokeChange);
    OBJC_RELEASE(_onBeginEditText);
    OBJC_RELEASE(_onTextDidChange);
    OBJC_RELEASE(_onContentHeightChange);
    [_textView setDelegate:nil];
    OBJC_RELEASE(_textView);
}

-(void)innerInit
{
    self.descCount = 4;
    self.isEmoji = true;
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.bounds];
        [_textView setDelegate:self];
        [_textView setScrollEnabled:YES];
        [_textView setBackgroundColor:self.backgroundColor];
        [_textView setUserInteractionEnabled:YES];
        [_textView setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [_textView setReturnKeyType:(UIReturnKeyDone)];
        [self addSubview:_textView];
    }
    if (!_placeholder) {
        _placeholder = [[UILabel alloc] init];
        [_placeholder setFrame:CGRectMake(5, 6, self.frame.size.width-10, 18)];
        [_placeholder setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [_placeholder setBackgroundColor:[UIColor clearColor]];
        [_placeholder setNumberOfLines:1];
        [_placeholder setUserInteractionEnabled:NO];
        [_placeholder setTextColor:RGBCOLOR(169, 169, 169)];
        [_placeholder setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [_textView addSubview:_placeholder];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_placeholder setFrame:CGRectMake(5, 6, self.frame.size.width-10, 18)];
    [_placeholder setHidden:_textView.text.length!=0];
}
///设置背景
-(void)setViewBackgroundColor:(UIColor *)color
{
    [_textView setBackgroundColor:color];
    [self setBackgroundColor:color];
}
///设置提示内容
-(void)setPlaceholderText:(NSString *)text
{
    [_placeholder setText:text];
}
///设置字体
-(void)setFont:(UIFont *)font
{
    [_textView setFont:font];
}
///设置键盘
-(void)setReturnKeyType:(UIReturnKeyType )keyType
{
    [_textView setReturnKeyType:keyType];
}
///根据内容获取内容高度
- (CGSize)setViewSizeThatFits:(CGSize)size;
{
    return [_textView sizeThatFits:size];
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
///获取文本
-(NSString *)text
{
    return _textView.text;
}
///设置文本
-(void)setText:(NSString *)text
{
    [_textView setText:text];
    [_placeholder setHidden:text.toTrim.length!=0];
}
///设置是否状态栏点击到顶部
-(void)setScrollsToTop:(BOOL)isTop
{
    [_textView setScrollsToTop:isTop];
}
///显示键盘
-(void)becomeFirstResponder
{
    [_textView becomeFirstResponder];
}
///隐藏键盘
-(void)resignFirstResponder
{
    [_textView resignFirstResponder];
}
///设置键盘
-(void)setInputAccessoryView:(UIView *)view
{
    [_textView setInputAccessoryView:view];
}
///设置值
-(void)setAttributedText:(NSMutableAttributedString *)attStr
{
    [_textView setAttributedText:attStr];
    [_placeholder setHidden:_textView.text.length!=0];
}
///获取值
-(NSAttributedString *)attributedText
{
    return _textView.attributedText;
}
///设置颜色
-(void)setTextColor:(UIColor *)color
{
    [_textView setTextColor:color];
}
///设置指数提示是否显示
-(void)setIsHiddenCountLabel:(BOOL)isHidden
{
    _isHiddenLabel = isHidden;
}
-(void)setViewText:(NSString *)text
{
    [_textView setText:text];
    [_placeholder setHidden:text.length!=0];
    
    if (self.onContentHeightChange) {
        CGSize sizeToFit = [_textView sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
        self.onContentHeightChange(sizeToFit.height);
    }
}
///设置输入是否允许换行
-(void)setIsInputNewLine:(BOOL)isNewLine
{
    _isNewLine = isNewLine;
}
///设置坐标
-(void)setViewFrame:(CGRect)frame
{
    [self setFrame:frame];
    [_textView setFrame:self.bounds];
}
///设置最大输入
-(void)setMaxLength:(int)count
{
    [self setMaxCount:count];
}
///获取最大输入
-(int)getMaxLength;
{
    return self.maxCount;
}
///设置最大输入颜色
-(void)setDescColorCount:(int)count
{
    [self setDescCount:count];
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (!_isNewLine) {
        if ([text isEqualToString:@"\n"]) {
            if (self.onReturnText) {
                self.onReturnText();
            }
            [textView resignFirstResponder];
            return NO;
        }
    }
    if (text.length == 0) {
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (self.onRevokeChange && comcatstr) {
            self.onRevokeChange(comcatstr, range);
        }
    } else {
        if (!self.isEmoji && [[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
            return false;
        }
        if (!self.isEmoji && ![text isNineKeyBoard] && [text isEmoji]) {
            return false;
        }
        if (self.maxCount > 0 && [textView.text stringByAppendingString:text].length > self.maxCount) {
            return false;
        }
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.onBeginEditText) {
        self.onBeginEditText();
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (self.onEndEditText) {
        self.onEndEditText(textView.text, textView.selectedRange);
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (self.onTextDidChange) {
        self.onTextDidChange(textView.text, textView.selectedRange);
    }
    if (self.onContentHeightChange) {
        CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
        self.onContentHeightChange(sizeToFit.height);
    }
    [_placeholder setHidden:textView.text.length!=0];
}

@end
