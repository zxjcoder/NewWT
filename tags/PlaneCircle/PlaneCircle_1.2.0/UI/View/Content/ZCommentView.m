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
    [self setBackgroundColor:RGBCOLOR(254,241,231)];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:RGBCOLOR(240, 228, 219)];
    [self addSubview:self.viewLine];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:4 borderWidth:1 borderColor:self.viewLine.backgroundColor];
    [self addSubview:self.viewContent];
    
    __weak typeof(self) weakSelf = self;
    self.textView = [[ZTextView alloc] init];
    [self.textView setPlaceholderText:@"写下您的评论..."];
    [self.textView setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.textView setOnTextDidChange:^(NSString *content, NSRange range, int inputLength) {
        [weakSelf setButtonState:content.length==0];
        if (weakSelf.onTextEditing) {
            weakSelf.onTextEditing(content, range, inputLength);
        }
    }];
    [self.textView setOnContentHeightChange:^(CGFloat contentH) {
        if (weakSelf.onViewHeightChange) {
            weakSelf.onViewHeightChange(contentH+18);
        }
    }];
    [self.textView setOnBeginEditText:^{
        if (weakSelf.onBeginEditText) {
            weakSelf.onBeginEditText();
        }
    }];
    [self.textView setOnRevokeChange:^(NSRange range, int inputLength) {
        [weakSelf setButtonState:weakSelf.textView.text.length==0];
        if (weakSelf.onRevokeChange) {
            weakSelf.onRevokeChange(range, inputLength);
        }
    }];
    [self.viewContent addSubview:self.textView];
    
    self.btnPublish = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPublish setTitle:@"发布" forState:(UIControlStateNormal)];
    [self.btnPublish setBackgroundColor:RGBCOLOR(254,241,231)];
    [self.btnPublish setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnPublish setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnPublish titleLabel] setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
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
    
    CGFloat contentX = 14;
    CGFloat btnW = 45;
    CGFloat btnH = 28;
    CGFloat btnX = frame.size.width-btnW-14;
    CGFloat contentW = frame.size.width-contentX-btnW-14-9;
    
    [self.viewContent setFrame:CGRectMake(contentX, 6, contentW, frame.size.height-12)];
    CGFloat textS = 3;
    [self.textView setFrame:CGRectMake(textS, textS, self.viewContent.width-textS*2, self.viewContent.height-textS*2)];
    
    CGFloat btnY = frame.size.height/2-btnH/2;
    [self.btnPublish setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
}

-(void)setButtonState:(BOOL)isCommenting
{
    if (isCommenting) {
        [self.btnPublish setBackgroundColor:RGBCOLOR(254,241,231)];
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
        CGSize sizeToFit = [self.textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)];
        self.onViewHeightChange(sizeToFit.height+18);
    }
}

///获取输入内容
-(NSString *)getContentText
{
    return self.textView.text;
}

-(void)setPublishSuccess
{
    [self.textView setViewText:kEmpty];
    [self.btnPublish setBackgroundColor:RGBCOLOR(254,241,231)];
    [self.btnPublish setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [ws setViewFrame:ws.oldFrame];
    }];
}

@end
