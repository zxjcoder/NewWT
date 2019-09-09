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

@interface ZTextField()<UITextFieldDelegate>
{
    ///最大输入限制
    int _maxCount;
    ///设置最后一次输入内容
    NSString *_lastInputText;
}

@property (strong, nonatomic) UITextField *textField;

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
    _maxCount = 100;
    
    self.textField = [[UITextField alloc] init];
    [self.textField setDelegate:self];
    [self.textField setReturnKeyType:(UIReturnKeyDone)];
    [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textField setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textField setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self addSubview:self.textField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
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
}
- (void)drawPlaceholderInRect
{
    [self.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.textField.placeholder attributes:@{NSForegroundColorAttributeName:WHITECOLOR,NSFontAttributeName:[ZFont systemFontOfSize:kFont_Small_Size]}]];
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

///设置最大值
-(void)setMaxLength:(int)length
{
    _maxCount = length;
}
///获取最大值
-(int)getMaxLength
{
    return _maxCount;
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
    _lastInputText = string;
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (_maxCount > 0 && offsetRange.location < _maxCount) {
            return YES;
        } else {
            return NO;
        }
    } else {
        NSInteger caninputlen = _maxCount - comcatstr.length;
        if (caninputlen >= 0) {
            return YES;
        } else {
            NSInteger len = string.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            if (rg.length > 0) {
                NSString *s = kEmpty;
                //判断是否只普通的字符或asc码(对于中文和表情返回NO)
                BOOL asc = [string canBeConvertedToEncoding:NSASCIIStringEncoding];
                if (asc) {
                    //因为是ascii码直接取就可以了不会错
                    s = [string substringWithRange:rg];
                } else {
                    __block NSInteger idx = 0;
                    //截取出的字串
                    __block NSString  *trimString = kEmpty;
                    //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                                             options:NSStringEnumerationByComposedCharacterSequences
                                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                              if (idx >= rg.length) {
                                                  //取出所需要就break，提高效率
                                                  *stop = YES;
                                                  return ;
                                              }
                                              trimString = [trimString stringByAppendingString:substring];
                                              idx++;
                                          }];
                    s = trimString;
                }
                //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
                [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
            }
        }
        return NO;
    }
    return YES;
}

-(void)textFieldDidChange:(NSNotification *)sender
{
    if (_lastInputText.length > 0) {
        if ([Utils isContainsEmoji:_lastInputText]) {
            self.textField.text = [self.textField.text stringByReplacingOccurrencesOfString:_lastInputText withString:kEmpty];
        }
        _lastInputText = kEmpty;
    }
    UITextRange *selectedRange = [self.textField markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [self.textField positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        
    } else {
        NSString  *nsTextContent = self.textField.text;
        NSInteger existTextNum = nsTextContent.length;
        if (existTextNum > _maxCount) {
            //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
            NSString *s = [nsTextContent substringToIndex:_maxCount];
            [self.textField setText:s];
        }
    }
    if (self.onTextDidChange) {
        self.onTextDidChange(self.textField.text);
    }
}

@end
