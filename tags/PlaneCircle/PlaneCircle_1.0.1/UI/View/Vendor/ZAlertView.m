//
//  ZAlertView.m
//  Product
//
//  Created by Daniel on 15/8/3.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//

#import "ZAlertView.h"

#define kAlertViewBaseTag 1000
#define kAlertViewContentViewWidth 260.0f
#define kAlertViewButtonHeight 45.0f
#define kAlertViewMarginLeftRight 9.0f
#define kAlertViewMarginTopButtom 18.0f

#define kAlertViewAnimateDuration 0.15f

#define kZAlertViewTitleFontSize 14.0f
#define kZAlertViewMessageFontSize 14.0f
#define kZAlertViewButtonFontSize 14.0f

#define kZAlertViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]
#define kZAlertViewContentBackgroundColor HEXCOLOR(0xe8e8e8)

#define kZAlertViewLineBackgroundColor HEXCOLOR(0xdadbdd)

#define kZAlertViewTitleTextColor HEXCOLOR(0x333333)
#define kZAlertViewMessageTextColor HEXCOLOR(0x333333)

#define kZAlertViewButtonDoneTextColor MAINCOLOR
#define kZAlertViewButtonCancelTextColor HEXCOLOR(0x646464)

@interface ZAlertView()
{
    UIView *contentView;
    UIButton *cancelBtn;
    
    UIImage *titleImage;
    UILabel *titleLabel;
    
    NSLayoutConstraint *contentViewHeightConstraint;
}
///消息内容
@property (nonatomic,strong) UILabel *msgLabel;
///消息字体大小(alertViewStyle为Default),否则为输入框字体大小
@property (nonatomic, strong) UIFont *messageFont;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *message;
@property (nonatomic,strong) NSMutableArray *buttonTitleList;

@property (nonatomic, strong)   NSMutableArray *textFields;

@property (nonatomic,copy) void (^dialogViewCompleteHandle)(ZAlertView *, NSInteger);

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
    OBJC_RELEASE(_textFields);
    OBJC_RELEASE(_title);
    OBJC_RELEASE(_message);
    OBJC_RELEASE(_messageFont);
    OBJC_RELEASE(_msgLabel);
    OBJC_RELEASE(cancelBtn);
    OBJC_RELEASE(titleImage);
    OBJC_RELEASE(titleLabel);
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    OBJC_RELEASE(contentView);
    OBJC_RELEASE(contentViewHeightConstraint);
    OBJC_RELEASE(_dialogViewCompleteHandle);
}
#pragma mark - Private

- (NSMutableArray *)textFields
{
    if (!_textFields) {
        _textFields = [NSMutableArray array];
    }
    return _textFields;
}


- (UIFont *)messageFont
{
    if (!_messageFont) {
        _messageFont = [UIFont systemFontOfSize:kZAlertViewMessageFontSize];
    }
    return _messageFont;
}

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
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    //内容视图
    contentView = [[UIView alloc]init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.clipsToBounds = YES;
    contentView.backgroundColor = kZAlertViewContentBackgroundColor;
    [contentView.layer setCornerRadius:5.0f];
    [self addSubview:contentView];
    
    NSDictionary *bindDic_contentView = NSDictionaryOfVariableBindings(contentView);
    NSString *formatStr_contentView = [NSString stringWithFormat:@"H:[contentView(%f)]",kAlertViewContentViewWidth];
    NSArray *contentView_H = [NSLayoutConstraint constraintsWithVisualFormat:formatStr_contentView options:0 metrics:nil views:bindDic_contentView];
    NSLayoutConstraint *contentView_CX = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *contentView_CY = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraints:contentView_H];
    [self addConstraint:contentView_CX];
    [self addConstraint:contentView_CY];
    
    //标题
    titleLabel = [[UILabel alloc]init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont boldSystemFontOfSize:kZAlertViewTitleFontSize];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = kZAlertViewTitleTextColor;
    [contentView addSubview:titleLabel];
    
    NSDictionary *dic_titleLabel = @{@"width":@(150.0f)};
    NSArray *titleLabel_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleLabel(width)]" options:0 metrics:dic_titleLabel views:NSDictionaryOfVariableBindings(titleLabel)];
    NSLayoutConstraint *titleLabel_CX = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [contentView addConstraints:titleLabel_H];
    [contentView addConstraint:titleLabel_CX];
    
    //横线
    UIView *lineView = [[UIView alloc]init];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    lineView.backgroundColor = kZAlertViewLineBackgroundColor;
    [contentView addSubview:lineView];
    
    //多按钮
    NSMutableDictionary *bindBtnsDic = [NSMutableDictionary dictionary];
    NSDictionary *dic_btns = @{@"leftRight":@(0),@"height":@(kAlertViewButtonHeight)};
    NSString *formatStr_btns = @"H:|-leftRight-";
    float btnWidth = (kAlertViewContentViewWidth - (_buttonTitleList.count - 1)) / _buttonTitleList.count;
    if(_buttonTitleList.count > 1) {
        //分割线
        UIView *lineView1 = [[UIView alloc]init];
        lineView1.translatesAutoresizingMaskIntoConstraints = NO;
        lineView1.backgroundColor = kZAlertViewLineBackgroundColor;
        [contentView addSubview:lineView1];
        
        NSString *formate_H = [NSString stringWithFormat:@"H:|-%f-[lineView1(%f)]",btnWidth,1.0f];
        NSString *formate_V = [NSString stringWithFormat:@"V:[lineView1(%f)]|",kAlertViewButtonHeight];
        NSArray *lineView1_H = [NSLayoutConstraint constraintsWithVisualFormat:formate_H options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView1)];
        NSArray *lineView1_V = [NSLayoutConstraint constraintsWithVisualFormat:formate_V options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView1)];
        [contentView addConstraints:lineView1_H];
        [contentView addConstraints:lineView1_V];
    }
    for (int i = 0; i < _buttonTitleList.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:kZAlertViewButtonFontSize]];
        [btn setTitle:[_buttonTitleList objectAtIndex:i] forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        if(i > 0 && i == _buttonTitleList.count - 1) {//最后一个
            [btn setTitleColor:kZAlertViewButtonDoneTextColor forState:UIControlStateNormal];
        } else if (_buttonTitleList.count == 1) {//只有一个
            [btn setTitleColor:kZAlertViewButtonDoneTextColor forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:kZAlertViewButtonCancelTextColor forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:kAlertViewBaseTag + i];
        [contentView addSubview:btn];
        
        NSString *btnFlag = [NSString stringWithFormat:@"btn%d",i];
        [bindBtnsDic setObject:btn forKey:btnFlag];
        
        if(i > 0 && i == _buttonTitleList.count - 1) {
            formatStr_btns = [formatStr_btns stringByAppendingFormat:@"-1-[%@(%f)]",btnFlag,btnWidth];
        } else {
            formatStr_btns = [formatStr_btns stringByAppendingFormat:@"[%@(%f)]",btnFlag,btnWidth];
        }
        
        NSString *btn_formatStr = [NSString stringWithFormat:@"V:[btn(height@500)]|"];
        NSArray *btn_V = [NSLayoutConstraint constraintsWithVisualFormat:btn_formatStr options:0 metrics:dic_btns views:NSDictionaryOfVariableBindings(btn)];
        [contentView addConstraints:btn_V];
    }
    formatStr_btns = [formatStr_btns stringByAppendingString:@"-leftRight-|"];
    //按钮约束
    NSArray *btns_H = [NSLayoutConstraint constraintsWithVisualFormat:formatStr_btns options:0 metrics:dic_btns views:bindBtnsDic];
    [contentView addConstraints:btns_H];
    
    UIButton *relateBtn = bindBtnsDic[@"btn0"];
    NSMutableDictionary *bindDic = nil;
    NSDictionary *paramDic = @{@"topMargin":@(kAlertViewMarginTopButtom),@"lineHeight":@(1.0),@"msgMarginLeftRight":@(17.0f),@"marginTop":@(kAlertViewMarginTopButtom),@"marginLeft":@(kAlertViewMarginLeftRight)};
    
    if (self.alertViewStyle == ZAlertViewStyleDefault) {
        //消息体
        UIFont *msgFont = self.messageFont;
        _msgLabel = [[UILabel alloc]init];
        _msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.font = msgFont;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.textColor = kZAlertViewMessageTextColor;
        _msgLabel.text = _message;
        _msgLabel.numberOfLines = 0;
        [contentView addSubview:_msgLabel];
        
        bindDic =  [@{@"titleLabel":titleLabel,
                      @"msgLabel":_msgLabel,
                      @"lineView":lineView,
                      @"relateBtn":relateBtn} mutableCopy];
        //文本约束
        NSArray *msgLabel_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-msgMarginLeftRight-[msgLabel]-msgMarginLeftRight-|" options:0 metrics:paramDic views:bindDic];
        [contentView addConstraints:msgLabel_H];
        
        NSString *formatStr = @"V:|-topMargin-[titleLabel]-topMargin-[msgLabel]-topMargin-[lineView(lineHeight)][relateBtn]|";
        NSArray *views_V = [NSLayoutConstraint constraintsWithVisualFormat:formatStr options:0 metrics:paramDic views:bindDic];
        [contentView addConstraints:views_V];
    } else {
        bindDic =  [@{@"titleLabel":titleLabel,
                      @"lineView":lineView,
                      @"relateBtn":relateBtn} mutableCopy];
        NSString *formatStr = @"V:|-topMargin-[titleLabel]-topMargin-";
        int textFieldCount = self.alertViewStyle==ZAlertViewStyleLoginAndPasswordInput? 2:1;
        for (int i = 0; i < textFieldCount; i++) {
            UITextField *textField = [[UITextField alloc] init];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            textField.font = self.messageFont;
            textField.secureTextEntry = (i==1 || self.alertViewStyle == ZAlertViewStyleSecureTextInput);
            textField.layer.masksToBounds = YES;
            
            if (textFieldCount > 1) {
                textField.placeholder = i? @"请输入密码":@"请输入账号";
            } else {
                textField.placeholder = @"请输入内容";
            }
            
            [self.textFields addObject:textField];
            [contentView addSubview:textField];
            
            NSString *textFieldFlag = [NSString stringWithFormat:@"textField%d",i];
            [bindDic setValue:textField forKey:textFieldFlag];
            
            if(i > 0 && i == _buttonTitleList.count - 1) {
                formatStr = [formatStr stringByAppendingFormat:@"-1-[%@]", textFieldFlag];
            } else {
                formatStr = [formatStr stringByAppendingFormat:@"[%@]", textFieldFlag];
            }
            NSString *formatStr_textFields = [NSString stringWithFormat:@"H:|-msgMarginLeftRight-[%@]-msgMarginLeftRight-|", textFieldFlag];
            NSArray *textField_H = [NSLayoutConstraint constraintsWithVisualFormat:formatStr_textFields options:0 metrics:paramDic views:bindDic];
            [contentView addConstraints:textField_H];
        }
        formatStr = [formatStr stringByAppendingString:@"-topMargin-[lineView(lineHeight)][relateBtn]|"];
        
        NSArray *views_V = [NSLayoutConstraint constraintsWithVisualFormat:formatStr options:0 metrics:paramDic views:bindDic];
        [contentView addConstraints:views_V];
    }
    
    //横线约束
    NSArray *lineView_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineView]|" options:0 metrics:paramDic views:bindDic];
    [contentView addConstraints:lineView_H];

    //自动布局后的高度
    CGSize size = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSDictionary *dic_contentView = @{@"height":@(size.height)};
    NSArray *contentView_Height = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(height@400)]" options:0 metrics:dic_contentView views:bindDic_contentView];
    [self addConstraints:contentView_Height];
    contentViewHeightConstraint = contentView_Height[0];
}

-(void)buttonAction:(UIButton *)sender
{
    NSInteger selIndex = sender.tag - kAlertViewBaseTag;
    __weak typeof(*&self) weakSelf = self;
    if(_dialogViewCompleteHandle) {
        _dialogViewCompleteHandle(weakSelf, selIndex);
    }
    [self closeView];
}

-(void)closeView
{
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:kAlertViewAnimateDuration animations:^{
        contentView.alpha = 0;
//        contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [ws.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [ws removeFromSuperview];
    }];
}

#pragma mark - ShowMessage

-(void)showInView:(UIView *)baseView completion:(void (^)(ZAlertView *alertView, NSInteger selectIndex))completeBlock
{
    self.dialogViewCompleteHandle = completeBlock;
    if(!_seriesAlert) {
        for (UIView *subView in baseView.subviews) {
            if([subView isKindOfClass:[ZAlertView class]]) {
                return;
            }
        }
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [baseView addSubview:self];
    
    NSArray *view_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)];
    NSArray *view_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)];
    [baseView addConstraints:view_H];
    [baseView addConstraints:view_V];
    
    
    contentView.alpha = 0;
//    contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:kAlertViewAnimateDuration animations:^{
        contentView.alpha = 1.0;
//        contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
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

- (NSString *)textWithTextFieldIndex:(NSInteger)textFieldIndex
{
    UITextField *textField = self.textFields[textFieldIndex];
    return textField.text;
}

@end


