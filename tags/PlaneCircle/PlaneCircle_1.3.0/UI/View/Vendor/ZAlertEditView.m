//
//  ZAlertEditView.m
//  PlaneCircle
//
//  Created by Daniel on 6/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAlertEditView.h"
#import "ClassCategory.h"
#import "ZProgressHUD.h"
#import "Utils.h"
#import "ZTextField.h"

#define kAlertEditViewContentW 280
#define kAlertEditViewContentH 130

@interface ZAlertEditView()
{
    NSString *_lastText;
}
///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;

@property (strong ,nonatomic) UIView *viewBG;

@property (strong ,nonatomic) UIView *viewContent;

@property (strong, nonatomic) ZTextField *textField;

@property (strong, nonatomic) UIButton *btnCancel;

@property (strong, nonatomic) UIButton *btnSave;

@property (strong, nonatomic) UIView *viewLine1;
@property (strong, nonatomic) UIView *viewLine2;

@property (assign, nonatomic) CGFloat keyboardH;

@property (assign, nonatomic) CGRect contentFrame;

@end

@implementation ZAlertEditView

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
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
    [self getBgView];
    [self getContentView];
    [self setContentView];
    [self setViewFrame];
}

-(void)getBgView
{
    self.viewBG = [[UIView alloc] init];
    [self.viewBG setBackgroundColor:BLACKCOLOR];
    [self.viewBG setAlpha:0.4f];
    [self addSubview:self.viewBG];
}

-(void)getContentView
{
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setClipsToBounds:YES];
    [self.viewContent setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    
    [self sendSubviewToBack:self.viewBG];
}

-(void)setContentView
{
    self.textField = [[ZTextField alloc] init];
    [self.textField setPlaceholder:@"请输入话题"];
    [self.textField setMaxLength:kNumberTopicMaxLength];
    [self.textField setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.textField setReturnKeyType:(UIReturnKeyDone)];
    [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textField setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.viewContent addSubview:self.textField];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine2];
    
    self.btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.btnCancel setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [[self.btnCancel titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnCancel];
    
    self.btnSave = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSave setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.btnSave setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnSave titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnSave addTarget:self action:@selector(btnSaveClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnSave];
}

-(void)setViewFrame
{
    [self.viewBG setFrame:self.bounds];
    self.contentFrame = CGRectMake(self.width/2-kAlertEditViewContentW/2, (self.height)/2-kAlertEditViewContentH/2, kAlertEditViewContentW, kAlertEditViewContentH);
    [self.viewContent setFrame:self.contentFrame];
    
    [self.textField setViewFrame:CGRectMake(20, 20, kAlertEditViewContentW-40, 40)];
    CGFloat btnH = 45;
    CGFloat btnY = kAlertEditViewContentH-btnH;
    CGFloat lineH = 0.8;
    [self.viewLine1 setFrame:CGRectMake(0, btnY, kAlertEditViewContentW, lineH)];
    [self.viewLine2 setFrame:CGRectMake(kAlertEditViewContentW/2-lineH/2, kAlertEditViewContentH-btnH, lineH, btnH)];
    [self.btnCancel setFrame:CGRectMake(0, btnY+lineH, kAlertEditViewContentW/2, btnH)];
    [self.btnSave setFrame:CGRectMake(kAlertEditViewContentW/2, btnY+lineH, kAlertEditViewContentW/2, btnH)];
}

-(void)btnSaveClick
{
    if (self.onSubmitClick) {
        self.onSubmitClick(self.textField.text);
    }
}

-(void)btnCancelClick
{
    if (self.onCancelClick) {
        self.onCancelClick();
    }
    [self dismiss];
}

-(void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_btnSave);
    OBJC_RELEASE(_btnCancel);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
}

-(void)setViewContentFrameWithKeyboardH:(CGFloat)keyboardH
{
    [self setKeyboardH:keyboardH];
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [ws.viewContent setFrame:CGRectMake(ws.width/2-kAlertEditViewContentW/2, (ws.height-keyboardH)/2-kAlertEditViewContentH/2, kAlertEditViewContentW, kAlertEditViewContentH)];
    } completion:^(BOOL finished) {
        [ws setIsAnimateing:NO];
    }];
}

-(void)show
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [self.viewBG setAlpha:0];
    [self.viewContent setAlpha:0.4f];
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [ws.viewBG setAlpha:0.4f];
        [ws.viewContent setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [ws setIsAnimateing:NO];
    }];
}

-(void)dismiss
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [ws.viewBG setAlpha:0.0f];
        [ws.viewContent setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [ws setIsAnimateing:NO];
        [ws setViewNil];
        [ws removeFromSuperview];
    }];
}

-(void)setDefaultText:(NSString *)text
{
    [self.textField setText:text];
}

@end
