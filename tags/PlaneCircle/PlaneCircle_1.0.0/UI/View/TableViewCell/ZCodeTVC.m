//
//  ZCodeTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCodeTVC.h"

@interface ZCodeTVC()

@property (strong, nonatomic) UILabel *lbPrompt;

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) UITextField *textCode;

@property (strong, nonatomic) UIButton *btnSend;

@property (strong, nonatomic) NSString *strAccount;

@end

@implementation ZCodeTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = self.getH;
    
    self.lbPrompt = [[UILabel alloc] init];
    [self.lbPrompt setTextColor:DESCCOLOR];
    [self.lbPrompt setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbPrompt];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRoundWithNoBorder];
    [self.viewMain addSubview:self.viewContent];
    
    self.textCode = [[UITextField alloc] init];
    [self.textCode setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.textCode setReturnKeyType:(UIReturnKeyDone)];
    [self.textCode setPlaceholder:@"请输入验证码"];
    [self.textCode setBorderStyle:(UITextBorderStyleNone)];
    [self.textCode setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.viewContent addSubview:self.textCode];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine];
    
    self.btnSend = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSend addTarget:self action:@selector(btnSendClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnSend];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbPrompt setFrame:CGRectMake(0, self.space, self.cellW, self.lbH)];
    [self.viewContent setFrame:CGRectMake(self.space, self.lbPrompt.y+self.lbPrompt.height+self.space, self.cellW-self.space*2, 45)];
    CGFloat btnW = 100;
    CGFloat btnY = 3;
    [self.textCode setFrame:CGRectMake(self.space, btnY, self.viewContent.width-btnW, self.viewContent.height-btnY*2)];
    [self.viewLine setFrame:CGRectMake(self.textCode.x+self.textCode.width, 5, 1, self.viewContent.height-10)];
    [self.btnSend setFrame:CGRectMake(self.viewLine.x+self.viewLine.width, 0, btnW, 45)];
}

-(void)btnSendClick
{
    if (self.onSendCodeClick) {
        self.onSendCodeClick();
    }
}

-(void)setAccount:(NSString*)account
{
    [self setStrAccount:account];
    [self.lbPrompt setText:[NSString stringWithFormat:@"点击发送验证码到手机号[%@]",account]];
}

-(void)setSendSuccess
{
    [self.lbPrompt setText:[NSString stringWithFormat:@"已经向手机号[%@]发送了验证码",self.strAccount]];
}

-(NSString *)getCode
{
    return self.textCode.text;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbPrompt);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_btnSend);
    OBJC_RELEASE(_textCode);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 105;
}
+(CGFloat)getH
{
    return 105;
}

@end
