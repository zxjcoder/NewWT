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
    ///显示空文本描述
    UILabel *_placeholder;
    ///是否允许换行
    BOOL _isNewLine;
    ///是否撤销内容
    BOOL _isRevoke;
    ///最后一次
    NSRange _lastRange;
}
///最后一次输入内容
@property (strong, nonatomic) NSString *lastInputText;
///上一次文本内容
@property (strong, nonatomic) NSString *lastViewText;

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
    OBJC_RELEASE(_lastViewText);
    OBJC_RELEASE(_lastInputText);
}

-(void)innerInit
{
    _isRevoke = NO;
    
    [self setDelegate:self];
    [self setScrollEnabled:YES];
    [self setBackgroundColor:WHITECOLOR];
    [self setUserInteractionEnabled:YES];
    [self setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self setReturnKeyType:(UIReturnKeyDone)];
    
    _placeholder = [[UILabel alloc] init];
    [_placeholder setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [_placeholder setBackgroundColor:[UIColor clearColor]];
    [_placeholder setNumberOfLines:1];
    [_placeholder setUserInteractionEnabled:NO];
    [_placeholder setTextColor:RGBCOLOR(169, 169, 169)];
    [_placeholder setHidden:YES];
    [_placeholder setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self addSubview:_placeholder];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_placeholder setFrame:CGRectMake(5, 6, self.frame.size.width-10, 22)];
    [_placeholder setHidden:self.text.length!=0];
}

-(void)setPlaceholderText:(NSString *)text
{
    [_placeholder setText:text];
}

-(void)setViewText:(NSString *)text
{
    [self setText:text];
    [_placeholder setHidden:text.length!=0];
}

-(void)setViewLastText:(NSString *)text
{
    [self setLastViewText:text];
}

-(void)setIsInputNewLine:(BOOL)isNewLine
{
    _isNewLine = isNewLine;
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _isRevoke = text.length==0;
    [self setLastInputText:text];
    if (!_isNewLine) {
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
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
        self.onEndEditText(textView.selectedRange);
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([_lastViewText isEqualToString:textView.text]) {
        return;
    }
    if (!_isNewLine) {
        if ([Utils isContainsEmoji:textView.text]) {
            [textView setText:[textView.text stringByReplacingOccurrencesOfString:self.lastInputText withString:kEmpty]];
            return;
        }
    }
    NSRange range = textView.selectedRange;
    if (range.location != _lastRange.location) {
        if (_isRevoke) {
            if (self.onRevokeChange) {
                int inputLength = abs((int)(_lastViewText.length-textView.text.length));
                self.onRevokeChange(range, inputLength);
                
//                GBLog(@"onRevokeChange text: %@, \n inputLength: %d, lastViewText: %@ \n replacementText: %@ , \n range-location: %ld , range-length: %ld",textView.text, inputLength, _lastViewText, _lastInputText, (long)range.location,(long)range.length);
            }
        } else {
            if (self.onTextDidChange) {
                int inputLength = abs((int)(textView.text.length-_lastViewText.length));
                self.onTextDidChange(textView.text, range, inputLength);
                
//                GBLog(@"onTextDidChange text: %@, \n inputLength: %d, lastViewText: %@ \n replacementText: %@ , \n range-location: %ld , range-length: %ld",textView.text, inputLength, _lastViewText, _lastInputText, (long)range.location,(long)range.length);
            }
        }
        if (self.onContentHeightChange) {
            CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
            self.onContentHeightChange(sizeToFit.height);
        }
    }
    _isRevoke = NO;
    _lastRange = range;
    [self setLastInputText:kEmpty];
    [self setLastViewText:textView.text];
    [_placeholder setHidden:textView.text.length!=0];
}

@end
