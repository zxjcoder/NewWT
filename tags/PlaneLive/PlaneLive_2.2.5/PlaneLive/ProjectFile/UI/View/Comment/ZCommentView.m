//
//  ZCommentView.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCommentView.h"
#import "ZTextView.h"
#import "ClassCategory.h"

@interface ZCommentView()

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) ZTextView *textView;

@property (strong, nonatomic) UIButton *btnPublish;

@property (assign, nonatomic) CGRect oldFrame;

@property (strong, nonatomic) UIView *viewLine;

@property (assign, nonatomic) BOOL isShow;

@end

@implementation ZCommentView

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
    self = [super initWithFrame:(CGRect)frame];
    if (self) {
        [self innerInit];
        
        [self setOldFrame:frame];
        
        [self setViewFrame:frame];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewLine];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:VIEW_BACKCOLOR2];
    [self.viewContent setViewRound:4 borderWidth:1 borderColor:RGBCOLOR(240, 228, 219)];
    [self addSubview:self.viewContent];
    
    __weak typeof(self) weakSelf = self;
    self.textView = [[ZTextView alloc] init];
    [self.textView setViewBackgroundColor:VIEW_BACKCOLOR2];
    [self.textView setPlaceholderText:kWriteDownYourComments];
    [self.textView setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.textView setTag:ZTextViewIndexCommment];
    [self.textView setOnTextDidChange:^(NSString *text, NSRange range) {
        [weakSelf setButtonState:text.length==0];
        if (weakSelf.onTextEditing) {
            weakSelf.onTextEditing(text, range);
        }
    }];
    [self.textView setOnContentHeightChange:^(CGFloat contentH) {
        if (weakSelf.onViewHeightChange) {
            weakSelf.onViewHeightChange(contentH+18);
        }
    }];
    [self.textView setOnBeginEditText:^{
        [weakSelf setIsShow:YES];
        if (weakSelf.onBeginEditText) {
            weakSelf.onBeginEditText();
        }
    }];
    [self.textView setOnEndEditText:^(NSString *text, NSRange selectedRange) {
        [weakSelf setIsShow:NO];
    }];
    [self.textView setOnReturnText:^{
        if (weakSelf.onReturnText) {
            weakSelf.onReturnText();
        }
    }];
    [self.textView setOnRevokeChange:^(NSString *text, NSRange range) {
        [weakSelf setButtonState:text.length==0];
        if (weakSelf.onRevokeChange) {
            weakSelf.onRevokeChange(text, range);
        }
    }];
    [self.textView setMaxLength:kNumberAnswerCommentMaxLength];
    [self.textView setIsHiddenCountLabel:YES];
    [self.viewContent addSubview:self.textView];
    
    self.btnPublish = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPublish setTitle:kRelease forState:(UIControlStateNormal)];
    [self.btnPublish setTitle:kRelease forState:(UIControlStateHighlighted)];
    [self.btnPublish setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnPublish setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnPublish titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnPublish addTarget:self action:@selector(btnPublishClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPublish];
}

-(void)btnPublishClick
{
    if (self.textView.text.toTrim.length == 0) {
        return;
    }
    if (self.onPublishClick) {
        self.onPublishClick(self.textView.text);
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_btnPublish);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_textView);
    OBJC_RELEASE(_onTextEditing);
    OBJC_RELEASE(_onBeginEditText);
}

-(void)setViewFrame:(CGRect)frame
{
    [self setFrame:frame];
    
    [self.viewLine setFrame:CGRectMake(0, 0, self.width, kLineHeight)];
    
    CGFloat contentX = 14;
    CGFloat btnW = 45;
    CGFloat btnH = 28;
    CGFloat btnX = frame.size.width-btnW-14;
    CGFloat contentW = frame.size.width-contentX-btnW-14-9;
    
    [self.viewContent setFrame:CGRectMake(contentX, 8, contentW, frame.size.height-16)];
    CGFloat txtX = 3;
    CGFloat txtY = 1;
    [self.textView setViewFrame:CGRectMake(txtX, txtY, self.viewContent.width-txtX*2, self.viewContent.height-txtY*2)];
    
    CGFloat btnY = frame.size.height/2-btnH/2;
    [self.btnPublish setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
}

-(void)setButtonState:(BOOL)isCommenting
{
    if (isCommenting) {
        [self.btnPublish setBackgroundColor:WHITECOLOR];
        [self.btnPublish setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    } else {
        [self.btnPublish setBackgroundColor:MAINCOLOR];
        [self.btnPublish setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    }
}

///设置输入内容
-(void)setTextWithString:(NSString *)text
{
    [self.textView setViewText:text];
    
    if (self.onViewHeightChange) {
        CGSize sizeToFit = [self.textView setViewSizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)];
        self.onViewHeightChange(sizeToFit.height+18);
    }
}

///获取输入内容
-(NSString *)getContentText
{
    return self.textView.text;
}

///设置输入描述内容
-(void)setPlaceholderText:(NSString *)text
{
    [self.textView setPlaceholderText:text];
}
///设置输入描述内容
-(void)setPlaceholderDefaultText
{
    [self.textView setPlaceholderText:kWriteDownYourComments];
}
///设置按钮文字
-(void)setPublishText:(NSString *)text
{
    [self.btnPublish setTitle:text forState:(UIControlStateNormal)];
    [self.btnPublish setTitle:text forState:(UIControlStateHighlighted)];
}
///设置按钮文字
-(void)setPublishDefaultText
{
    [self.btnPublish setTitle:kRelease forState:(UIControlStateNormal)];
    [self.btnPublish setTitle:kRelease forState:(UIControlStateHighlighted)];
}
///显示键盘
-(void)setKeyboardShow
{
    if (self.isShow) {
        return;
    }
    [self.textView becomeFirstResponder];
}
///隐藏键盘
-(void)setKeyboardHidden
{
    [self.textView resignFirstResponder];
}
///设置输入最大值
-(void)setMaxInputLength:(int)length
{
    [self.textView setMaxLength:length];
}
///发布成功
-(void)setPublishSuccess
{
    [self setKeyboardHidden];
    [self.textView setViewText:kEmpty];
    [self setPublishDefaultText];
    [self setPlaceholderDefaultText];
    [self.btnPublish setBackgroundColor:WHITECOLOR];
    [self.btnPublish setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [ws setViewFrame:ws.oldFrame];
    }];
}

@end
