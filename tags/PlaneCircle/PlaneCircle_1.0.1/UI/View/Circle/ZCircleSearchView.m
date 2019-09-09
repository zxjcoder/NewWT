//
//  ZCircleSearchView.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleSearchView.h"
#import "ClassCategory.h"
#import "Utils.h"

@interface ZCircleSearchView()<UITextFieldDelegate>
{
    BOOL _isClear;
    NSString *_lastText;
}
@property (strong, nonatomic) UIView *viewContent;
///搜索输入框
@property (strong, nonatomic) UITextField *textField;
///搜索图片
@property (strong, nonatomic) UIButton *btnSearch;
///提问
@property (strong, nonatomic) UIButton *btnQuestion;

@end

@implementation ZCircleSearchView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:MAINCOLOR];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:RGBCOLOR(254,156,84)];
    [self.viewContent setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    
    self.textField = [[UITextField alloc] init];
    [self.textField setDelegate:self];
    [self.textField setTextColor:WHITECOLOR];
    [self.textField setTintColor:WHITECOLOR];
    [self.textField setClearButtonMode:(UITextFieldViewModeNever)];
    [self.textField setPlaceholder:@"点击搜索问答、用户"];
    [self.textField setContentMode:(UIViewContentModeLeft)];
    [self.textField setReturnKeyType:(UIReturnKeyDone)];
    [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textField setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self drawPlaceholderInRect];
    [self setClearButton];
    [self.viewContent addSubview:self.textField];
    
    self.btnSearch = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateNormal)];
    [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateHighlighted)];
    [self.btnSearch setImageEdgeInsets:(UIEdgeInsetsMake(1, 1, 1, 1))];
    [[self.btnSearch titleLabel] setFont:[UIFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.btnSearch addTarget:self action:@selector(btnSearchClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnSearch];
    
    self.btnQuestion = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnQuestion setTitle:@"提问" forState:(UIControlStateNormal)];
    [self.btnQuestion setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [[self.btnQuestion titleLabel] setFont:[UIFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.btnQuestion addTarget:self action:@selector(btnQuestionClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnQuestion];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)drawPlaceholderInRect
{
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.textField.placeholder attributes:@{NSForegroundColorAttributeName:WHITECOLOR,NSFontAttributeName:[UIFont systemFontOfSize:kFont_Small_Size]}];
}

- (void)setClearButton
{
    [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateNormal)];
    [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateHighlighted)];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat contentH = 32;
    [self.viewContent setFrame:CGRectMake(10, 25, self.width-75, contentH)];
    
    [self.textField setFrame:CGRectMake(10, 1, self.viewContent.width-contentH-5, self.viewContent.height)];
    
    [self.btnSearch setFrame:CGRectMake(self.viewContent.width-36, 1, contentH, contentH)];
    
    [self.btnQuestion setFrame:CGRectMake(self.width-60, 22.5, 50, 40)];
}

-(NSString *)getSearchContent
{
    return self.textField.text;
}

-(void)btnQuestionClick
{
    if (_isClear) {
        _isClear = NO;
        [self.textField resignFirstResponder];
        [self setClearStateChange];
        if (self.onClearClick) {
            self.onClearClick();
        }
    } else {
        if (self.onQuestionClick) {
            self.onQuestionClick();
        }
    }
}

-(void)btnSearchClick
{
    if (!_isClear) {
        if (self.onSearchClick) {
            self.onSearchClick(self.textField.text);
        }
        [self.textField resignFirstResponder];
        [self setClearStateChange];
    } else {
        [self.textField setText:kEmpty];
    }
}

-(void)setClearStateChange
{
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        if (_isClear) {
            [ws.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_delete"] forState:(UIControlStateNormal)];
            [ws.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_delete"] forState:(UIControlStateHighlighted)];
            [ws.btnQuestion setTitle:@"取消" forState:(UIControlStateNormal)];
        } else {
            [ws.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateNormal)];
            [ws.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateHighlighted)];
            [ws.btnQuestion setTitle:@"提问" forState:(UIControlStateNormal)];
        }
    }];
}

-(void)dealloc
{
    OBJC_RELEASE(_textField);
    OBJC_RELEASE(_btnSearch);
    OBJC_RELEASE(_btnQuestion);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_lastText);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.onBeginClick) {
        self.onBeginClick();
    }
    _isClear = YES;
    [self setClearStateChange];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void)textFieldDidChange:(NSNotification *)sender
{
    if (![_lastText isEqualToString:self.textField.text.toTrim]) {
        _lastText = self.textField.text.toTrim;
        
        if ([Utils isContainsEmoji:self.textField.text.toTrim]) {
            [self.textField setText:[self.textField.text stringByReplacingOccurrencesOfString:_lastText withString:kEmpty]];
            return;
        }
        
        if (self.onSearchClick) {
            self.onSearchClick(self.textField.text.toTrim);
        }
    }
}

@end
