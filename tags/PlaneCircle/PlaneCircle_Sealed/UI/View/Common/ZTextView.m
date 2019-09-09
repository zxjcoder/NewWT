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
    ///显示最大显示数
    UILabel *_lbMaxCount;
    ///是否允许换行
    BOOL _isNewLine;
    ///设置隐藏最大数量
    BOOL _isHiddenLabel;
    ///上次输入内容
    NSString *_lastInputText;
}
///最大输入文字
@property (assign, nonatomic) int maxCount;
///描述文字
@property (assign, nonatomic) int descCount;

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
    OBJC_RELEASE(_lbMaxCount);
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
    _descCount = 4;
    
    _textView = [[UITextView alloc] init];
    [_textView setDelegate:self];
    [_textView setScrollEnabled:YES];
    [_textView setBackgroundColor:WHITECOLOR];
    [_textView setUserInteractionEnabled:YES];
    [_textView setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [_textView setReturnKeyType:(UIReturnKeyDone)];
    [self addSubview:_textView];
    
    _placeholder = [[UILabel alloc] init];
    [_placeholder setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [_placeholder setBackgroundColor:[UIColor clearColor]];
    [_placeholder setNumberOfLines:1];
    [_placeholder setUserInteractionEnabled:NO];
    [_placeholder setTextColor:RGBCOLOR(169, 169, 169)];
    [_placeholder setHidden:YES];
    [_placeholder setUserInteractionEnabled:NO];
    [_placeholder setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [_textView addSubview:_placeholder];
    
    _lbMaxCount = [[UILabel alloc] init];
    [_lbMaxCount setTextAlignment:(NSTextAlignmentRight)];
    [_lbMaxCount setTextColor:BLACKCOLOR1];
    [_lbMaxCount setHidden:YES];
    [_lbMaxCount setUserInteractionEnabled:NO];
    [self addSubview:_lbMaxCount];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (self.tag) {
        case ZTextViewIndexCommment:
            [_textView setFrame:self.bounds];
            [_lbMaxCount setHidden:YES];
            break;
        default:
            if (_lbMaxCount.hidden) {
                [_textView setFrame:CGRectMake(0, 5, self.width, self.height-5)];
            } else {
                [_textView setFrame:CGRectMake(0, 5, self.width, self.height-35)];
            }
            break;
    }
    [_placeholder setFrame:CGRectMake(5, 6, self.frame.size.width-10, 22)];
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

///获取文本
-(NSString *)text
{
    return _textView.text;
}
///设置文本
-(void)setText:(NSString *)text
{
    [_textView setText:text];
    [_placeholder setHidden:text.length!=0];
    [self setMaxCountText:text.length];
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
    
    [self setMaxCountText:text.length];
    
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
    switch (self.tag) {
        case ZTextViewIndexCommment:
            [_textView setFrame:self.bounds];
            [_lbMaxCount setHidden:YES];
            break;
        default:
            [_textView setFrame:CGRectMake(0, 5, self.width, self.height-35)];
            [_lbMaxCount setFrame:CGRectMake(0, self.height-30, self.width-kSize13, 30)];
            if (_isHiddenLabel == NO) {
                [_lbMaxCount setHidden:_maxCount==0];
                
                [self setMaxCountText:_textView.text.length];
            } else {
                [_lbMaxCount setHidden:_isHiddenLabel];
            }
            break;
    }
}
///设置最大输入
-(void)setMaxLength:(int)count
{
    [self setMaxCount:count];
    [self setMaxCountText:_textView.text.length];
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
    [_lbMaxCount setLabelColorWithRange:NSMakeRange(_lbMaxCount.text.length-count, count) color:DESCCOLOR];
}
///设置输入限制文本
-(void)setMaxCountText:(NSInteger)count
{
    if (_lbMaxCount && !_lbMaxCount.hidden) {
        if ((_maxCount-count) >= 0) {
            [_lbMaxCount setText:[NSString stringWithFormat:@"%d/%d",(int)count,_maxCount]];
        } else {
            [_lbMaxCount setText:[NSString stringWithFormat:@"%d/%d",(int)(_maxCount-count),_maxCount]];
        }
        [_lbMaxCount setLabelColorWithRange:NSMakeRange(_lbMaxCount.text.length-_descCount, _descCount) color:DESCCOLOR];
    }
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _lastInputText = text;
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
    }
//    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    UITextRange *selectedRange = [textView markedTextRange];
//    //获取高亮部分
//    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//    //如果有高亮且当前字数开始位置小于最大限制时允许输入
//    if (selectedRange && pos) {
//        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
//        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
//        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
//        
//    } else {
//        NSInteger caninputlen = _maxCount - comcatstr.length;
//        if (caninputlen >= 0) {
//            return YES;
//        } else {
//            NSInteger len = text.length + caninputlen;
//            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
//            NSRange rg = {0,MAX(len,0)};
//            if (rg.length > 0) {
//                NSString *s = kEmpty;
//                //判断是否只普通的字符或asc码(对于中文和表情返回NO)
//                BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
//                if (asc) {
//                    s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
//                } else {
//                    __block NSInteger idx = 0;
//                    __block NSString  *trimString = kEmpty;//截取出的字串
//                    //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
//                    [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
//                                             options:NSStringEnumerationByComposedCharacterSequences
//                                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
//                                              if (idx >= rg.length) {
//                                                  *stop = YES; //取出所需要就break，提高效率
//                                                  return ;
//                                              }
//                                              trimString = [trimString stringByAppendingString:substring];
//                                              idx++;
//                                          }];
//                    
//                    s = trimString;
//                }
//                //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
//                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//                [self setMaxCountText:textView.text.length];
//            }
//        }
//        return NO;
//    }
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
//    if (!_isNewLine && _lastInputText.length > 0) {
//        if ([Utils isContainsEmoji:_lastInputText]) {
//            textView.text = [textView.text stringByReplacingOccurrencesOfString:_lastInputText withString:kEmpty];
//        }
//        _lastInputText = kEmpty;
//    }
//
//    UITextRange *selectedRange = [textView markedTextRange];
//    //获取高亮部分
//    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//    //如果在变化中是高亮部分在变，就不要计算字符了
//    if (selectedRange && pos) {
//        
//    } else {
//        NSString  *nsTextContent = textView.text;
//        NSInteger existTextNum = nsTextContent.length;
//        if (existTextNum > _maxCount) {
//            //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
//            NSString *s = [nsTextContent substringToIndex:_maxCount];
//            [textView setText:s];
//        }
//        if (self.onTextDidChange) {
//            NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
//            NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
//            NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
//            self.onTextDidChange(nsTextContent, offsetRange);
//        }
//        if (self.onContentHeightChange) {
//            CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
//            self.onContentHeightChange(sizeToFit.height);
//        }
//    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > _maxCount) {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:_maxCount];
        [textView setText:s];
    }
    if (self.onTextDidChange) {
        self.onTextDidChange(textView.text, textView.selectedRange);
    }
    if (self.onContentHeightChange) {
        CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
        if (_lbMaxCount.hidden) {
            self.onContentHeightChange(sizeToFit.height);
        } else {
            self.onContentHeightChange(sizeToFit.height+35);
        }
    }
    [self setMaxCountText:textView.text.length];
    [_placeholder setHidden:textView.text.length!=0];
}

@end
