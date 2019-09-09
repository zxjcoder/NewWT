//
//  ZPracticeDetailPublishView.m
//  PlaneCircle
//
//  Created by Daniel on 6/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailPublishView.h"
#import "ZTextView.h"
#import "ClassCategory.h"

@interface ZPracticeDetailPublishView()

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) ZTextView *textView;

@property (strong, nonatomic) UIButton *btnPublish;

@property (strong, nonatomic) UIButton *btnPay;

@property (assign, nonatomic) CGRect oldFrame;

@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZPracticeDetailPublishView

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
            weakSelf.onTextEditing(content,range, inputLength);
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
    [self.btnPublish setBackgroundColor:weakSelf.backgroundColor];
    [self.btnPublish setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnPublish setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [self.btnPublish setUserInteractionEnabled:YES];
    [[self.btnPublish titleLabel] setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.btnPublish addTarget:self action:@selector(btnPublishClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPublish];
    
    self.btnPay = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPay setImage:[SkinManager getImageWithName:@"p_play"] forState:(UIControlStateNormal)];
    [self.btnPay setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnPay setUserInteractionEnabled:YES];
    [self.btnPay addTarget:self action:@selector(btnPayClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPay];
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

-(void)btnPayClick
{
    if (self.onPlayClick) {
        self.onPlayClick();
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_onPlayClick);
    OBJC_RELEASE(_onBeginEditText);
    OBJC_RELEASE(_onTextEditing);
    OBJC_RELEASE(_onPublishClick);
    OBJC_RELEASE(_onRevokeChange);
    OBJC_RELEASE(_onViewHeightChange);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_btnPay);
    OBJC_RELEASE(_btnPublish);
}

-(void)showKeyboard
{
    [self.textView becomeFirstResponder];
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

-(void)setViewFrame:(CGRect)frame
{
    [self setFrame:frame];
    
    CGFloat btnPlayS = 45;
    CGFloat btnPlayY = frame.size.height/2-btnPlayS/2;
    [self.btnPay setFrame:CGRectMake(0, btnPlayY, btnPlayS, btnPlayS)];
    
    CGFloat contentX = self.btnPay.x+btnPlayS;
    CGFloat btnW = 43;
    CGFloat btnH = 28;
    CGFloat btnX = frame.size.width-btnW-8;
    CGFloat contentW = frame.size.width-contentX-btnW-20;
    
    [self.viewContent setFrame:CGRectMake(contentX, 6, contentW, frame.size.height-12)];
    CGFloat textS = 3;
    [self.textView setFrame:CGRectMake(textS, textS, self.viewContent.width-textS*2, self.viewContent.height-textS*2)];
    
    CGFloat btnY = frame.size.height/2-btnH/2;
    [self.btnPublish setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
}

-(void)setPublishSuccess
{
    [self.textView setViewText:nil];
    [self.btnPublish setBackgroundColor:RGBCOLOR(254,241,231)];
    [self.btnPublish setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self setViewFrame:self.oldFrame];
    }];
}

@end
