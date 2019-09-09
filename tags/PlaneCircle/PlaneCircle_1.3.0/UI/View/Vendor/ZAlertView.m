//
//  ZAlertView.m
//  Product
//
//  Created by Daniel on 15/8/3.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//

#import "ZAlertView.h"
#import "ClassCategory.h"

#define kAlertViewBaseTag 1000
#define kAlertViewContentViewWidth 260.0f
#define kAlertViewButtonHeight 40.0f
#define kAlertViewMarginLeftRight 9.0f
#define kAlertViewMarginTopButtom 18.0f

#define kAlertViewAnimateDuration 0.15f

#define kZAlertViewTitleFontSize 14.0f
#define kZAlertViewMessageFontSize 14.0f
#define kZAlertViewButtonFontSize 14.0f

#define kZAlertViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]
#define kZAlertViewContentBackgroundColor HEXCOLOR(0xe8e8e8)

#define kZAlertViewLineBackgroundColor RGBCOLOR(209, 209, 209)

#define kZAlertViewTitleTextColor RGBCOLOR(78, 78, 78)
#define kZAlertViewMessageTextColor RGBCOLOR(78, 78, 78)

#define kZAlertViewButtonDoneTextColor MAINCOLOR
#define kZAlertViewButtonCancelTextColor RGBCOLOR(78, 78, 78)

typedef NS_ENUM(NSInteger, ZAlertViewStyle)
{
    ///默认提示框
    ZAlertViewStyleDefault = 0,
    ///可输入密码提示框
    ZAlertViewStyleSecureTextInput,
    ///可输入文本提示框
    ZAlertViewStylePlainTextInput,
    ///可输入登录信息提示框
    ZAlertViewStyleLoginAndPasswordInput
};

@interface ZAlertView()
{
    UIView *contentView;
    
    UILabel *titleLabel;
}
///消息内容
@property (nonatomic,strong) UILabel *msgLabel;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *message;

@property (nonatomic,strong) NSMutableArray *buttonTitleList;

///提示框样式
@property (nonatomic, assign) ZAlertViewStyle alertViewStyle;

@end

@implementation ZAlertView

-(id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = kZAlertViewBackgroundColor;
        self.title = title;
        self.message = message;
        
        va_list args;
        va_start(args, otherButtonTitles);
        _buttonTitleList = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
            [_buttonTitleList addObject:str];
        }
        va_end(args);
        
        [self innerInit];
    }
    return self;
}

- (void)dealloc
{
    OBJC_RELEASE(_title);
    OBJC_RELEASE(_message);
    OBJC_RELEASE(_msgLabel);
    OBJC_RELEASE(titleLabel);
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    OBJC_RELEASE(contentView);
    OBJC_RELEASE(_onDialogViewCompleteHandle);
}
#pragma mark - Private

- (void)setAlertViewStyle:(ZAlertViewStyle)alertViewStyle
{
    _alertViewStyle = alertViewStyle;
    if (_alertViewStyle != ZAlertViewStyleDefault) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self innerInit];
    }
}

-(void)innerInit
{
    [self setFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    
    //内容视图
    contentView = [[UIView alloc]init];
    contentView.clipsToBounds = YES;
    contentView.backgroundColor = kZAlertViewContentBackgroundColor;
    [contentView.layer setCornerRadius:5.0f];
    [self addSubview:contentView];
    
    CGFloat contentH = 0;
    CGRect contentFrame = CGRectMake(self.frame.size.width/2-kAlertViewContentViewWidth/2, 0, kAlertViewContentViewWidth, 0);
    [contentView setFrame:contentFrame];
    
    //标题
    titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:kZAlertViewTitleFontSize];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = kZAlertViewTitleTextColor;
    [contentView addSubview:titleLabel];
    
    CGFloat space = 10;
    if (_title.length > 0) {
        CGFloat titleH = 20;
        CGFloat titleY = space;
        contentH = titleY+titleH+space;
        [titleLabel setFrame:CGRectMake(0, titleY, contentFrame.size.width, titleH)];
    } else {
        contentH = space;
    }
    //消息体
    _msgLabel = [[UILabel alloc] init];
    _msgLabel.backgroundColor = [UIColor clearColor];
    _msgLabel.font = [UIFont systemFontOfSize:kZAlertViewMessageFontSize];
    _msgLabel.textAlignment = NSTextAlignmentLeft;
    _msgLabel.textColor = kZAlertViewMessageTextColor;
    _msgLabel.text = _message;
    [_msgLabel setNumberOfLines:0];
    [_msgLabel setLineBreakMode:(NSLineBreakByCharWrapping|NSLineBreakByTruncatingTail)];
    CGFloat lineH = 0.5;
    
    CGFloat messageH = 20;
    CGRect messageFrame = CGRectMake(10, contentH, contentView.width-20, messageH);
    [_msgLabel setFrame:messageFrame];
    CGFloat messageNewH = [_msgLabel getLabelHeightWithMinHeight:messageH];
    messageFrame.size.height = messageNewH;
    [_msgLabel setFrame:messageFrame];
    
    [contentView addSubview:_msgLabel];
    
    contentH = messageFrame.origin.y+messageFrame.size.height;
    
    //横线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kZAlertViewLineBackgroundColor;
    [contentView addSubview:lineView];
    
    [lineView setFrame:CGRectMake(0, contentH+space, contentView.width, lineH)];
    
    CGFloat itemX = 0;
    CGFloat itemY = lineView.y+lineView.height;
    if (_buttonTitleList.count == 1) {
        CGFloat itemW = contentView.width;
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn.titleLabel setFont:[ZFont boldSystemFontOfSize:kZAlertViewButtonFontSize]];
        [btn setTitle:_buttonTitleList.firstObject forState:UIControlStateNormal];
        [btn setTitleColor:kZAlertViewButtonDoneTextColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:kAlertViewBaseTag];
        [btn setFrame:CGRectMake(itemX, itemY, itemW, kAlertViewButtonHeight)];
        [contentView addSubview:btn];
        
        contentH = itemY+kAlertViewButtonHeight;
    } else if (_buttonTitleList.count == 2) {
        CGFloat itemW = contentView.width/2;
        for (int i = 0; i < _buttonTitleList.count; i++) {
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [btn.titleLabel setFont:[ZFont boldSystemFontOfSize:kZAlertViewButtonFontSize]];
            [btn setTitle:[_buttonTitleList objectAtIndex:i] forState:UIControlStateNormal];
            if(i > 0 && i == _buttonTitleList.count - 1) {//最后一个
                [btn setTitleColor:kZAlertViewButtonDoneTextColor forState:UIControlStateNormal];
            } else if (_buttonTitleList.count == 1) {//只有一个
                [btn setTitleColor:kZAlertViewButtonDoneTextColor forState:UIControlStateNormal];
            } else {
                [btn setTitleColor:kZAlertViewButtonCancelTextColor forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:kAlertViewBaseTag + i];
            [btn setFrame:CGRectMake(itemX, itemY, itemW, kAlertViewButtonHeight)];
            [contentView addSubview:btn];
            itemX = itemW;
            if (i > 0) {
                UIView *btnLine = [[UIView alloc]init];
                btnLine.backgroundColor = kZAlertViewLineBackgroundColor;
                [contentView addSubview:btnLine];
                [btnLine setFrame:CGRectMake(itemX, itemY, lineH, kAlertViewButtonHeight)];
            }
        }
        contentH = itemY+kAlertViewButtonHeight;
    } else {
        CGFloat itemW = contentView.width;
        for (int i = 0; i < _buttonTitleList.count; i++) {
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [btn.titleLabel setFont:[ZFont boldSystemFontOfSize:kZAlertViewButtonFontSize]];
            [btn setTitle:[_buttonTitleList objectAtIndex:i] forState:UIControlStateNormal];
            if(i > 0 && i == _buttonTitleList.count - 1) {//最后一个
                [btn setTitleColor:kZAlertViewButtonDoneTextColor forState:UIControlStateNormal];
            } else if (_buttonTitleList.count == 1) {//只有一个
                [btn setTitleColor:kZAlertViewButtonDoneTextColor forState:UIControlStateNormal];
            } else {
                [btn setTitleColor:kZAlertViewButtonCancelTextColor forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:kAlertViewBaseTag + i];
            [btn setFrame:CGRectMake(itemX, itemY, itemW, kAlertViewButtonHeight)];
            [contentView addSubview:btn];
            if (i <= _buttonTitleList.count-1) {
                UIView *btnLine = [[UIView alloc]init];
                btnLine.backgroundColor = kZAlertViewLineBackgroundColor;
                [contentView addSubview:btnLine];
                [btnLine setFrame:CGRectMake(0, btn.y+btn.height-lineH, itemW, lineH)];
            }
            
            itemY = itemY+btn.height;
        }
        contentH = itemY;
    }
    contentFrame.size.height = contentH;
    contentFrame.origin.y = self.height/2-contentH/2;
    [contentView setFrame:contentFrame];
}

-(void)buttonAction:(UIButton *)sender
{
    NSInteger selIndex = sender.tag - kAlertViewBaseTag;
    __weak typeof(self) weakSelf = self;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(alertView:didButtonClickWithIndex:)] == YES) {
            [self.delegate alertView:weakSelf didButtonClickWithIndex:selIndex];
        }
    }
    if(self.onDialogViewCompleteHandle) {
        self.onDialogViewCompleteHandle(weakSelf, selIndex);
    }
    [self closeView];
}

-(void)closeView
{
    [UIView animateWithDuration:kAlertViewAnimateDuration animations:^{
        contentView.alpha = 0;
        contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [contentView setHidden:YES];
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

#pragma mark - ShowMessage

-(void)showInView:(UIView *)baseView completion:(void (^)(ZAlertView *alertView, NSInteger selectIndex))completeBlock
{
    self.onDialogViewCompleteHandle = completeBlock;
    for (UIView *subView in baseView.subviews) {
        if([subView isKindOfClass:[ZAlertView class]]) {
            return;
        }
    }
    [baseView addSubview:self];
    [baseView bringSubviewToFront:self];
    
    contentView.alpha = 0;
    contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:kAlertViewAnimateDuration animations:^{
        contentView.alpha = 1.0;
        contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

-(void)showWithCompletion:(void (^)(ZAlertView *alertView, NSInteger selectIndex))completeBlock
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self showInView:keyWindow completion:completeBlock];
}

-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self showInView:keyWindow completion:nil];
}

+(void)showWithMessage:(NSString*)message
{
    ZAlertView *alertView = [[ZAlertView alloc] initWithTitle:kPrompt message:message buttonTitles:kDetermine, nil];
    [alertView setAlertViewStyle:(ZAlertViewStyleDefault)];
    [alertView showWithCompletion:nil];
}

+(void)showWithMessage:(NSString*)message completion:(void (^)(void))completion
{
    ZAlertView *alertView = [[ZAlertView alloc] initWithTitle:kPrompt message:message buttonTitles:kDetermine, nil];
    [alertView setAlertViewStyle:(ZAlertViewStyleDefault)];
    [alertView showWithCompletion:^(ZAlertView *alertView, NSInteger selectIndex) {
        if (completion) {
            completion();
        }
    }];
}

+(void)showWithMessage:(NSString*)message doneCompletion:(void (^)(void))doneCompletion
{
    ZAlertView *alertView = [[ZAlertView alloc] initWithTitle:kPrompt message:message buttonTitles:kCancel,kDetermine, nil];
    [alertView setAlertViewStyle:(ZAlertViewStyleDefault)];
    [alertView showWithCompletion:^(ZAlertView *alertView, NSInteger selectIndex) {
        if (selectIndex == 1 && doneCompletion) {
            doneCompletion();
        }
    }];
}

+(void)showWithMessage:(NSString *)message completion:(void (^)(ZAlertView *alertView, NSInteger selectIndex))completion cancelTitle:(NSString*)cancelTitle doneTitle:(NSString*)doneTitle
{
    ZAlertView *alertView = [[ZAlertView alloc] initWithTitle:kPrompt message:message buttonTitles:cancelTitle,doneTitle,nil];
    [alertView setAlertViewStyle:(ZAlertViewStyleDefault)];
    [alertView showWithCompletion:^(ZAlertView *alertView, NSInteger selectIndex) {
        if (completion) {
            completion(alertView,selectIndex);
        }
    }];
}

+(void)showWithTitle:(NSString *)title message:(NSString *)message doneCompletion:(void (^)(void))doneCompletion
{
    ZAlertView *alertView = [[ZAlertView alloc] initWithTitle:title message:message buttonTitles:kCancel,kDetermine, nil];
    [alertView setAlertViewStyle:(ZAlertViewStyleDefault)];
    [alertView showWithCompletion:^(ZAlertView *alertView, NSInteger selectIndex) {
        if (selectIndex == 1 && doneCompletion) {
            doneCompletion();
        }
    }];
}

+(void)showWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(ZAlertView *alertView, NSInteger selectIndex))completion cancelTitle:(NSString*)cancelTitle doneTitle:(NSString*)doneTitle
{
    ZAlertView *alertView = [[ZAlertView alloc] initWithTitle:title message:message buttonTitles:cancelTitle,doneTitle,nil];
    [alertView setAlertViewStyle:(ZAlertViewStyleDefault)];
    [alertView showWithCompletion:^(ZAlertView *alertView, NSInteger selectIndex) {
        if (completion) {
            completion(alertView,selectIndex);
        }
    }];
}

@end


