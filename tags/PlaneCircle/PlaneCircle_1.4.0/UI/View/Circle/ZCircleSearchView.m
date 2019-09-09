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
#import "ZTextField.h"

@interface ZCircleSearchView()
{
    __block BOOL _isClear;
    NSString *_lastText;
}
@property (strong, nonatomic) UIView *viewContent;
///搜索输入框
@property (strong, nonatomic) ZTextField *textField;
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
    
    self.textField = [[ZTextField alloc] init];
    [self.textField setTextFieldIndex:ZTextFieldIndexCircleSearch];
    __weak typeof(self) weakSelf = self;
    [self.textField setOnTextDidChange:^(NSString *text) {
        if (weakSelf.onSearchClick) {
            weakSelf.onSearchClick(text);
        }
    }];
    [self.textField setOnBeginEditText:^{
        _isClear = YES;
        [weakSelf setClearStateChange];
        if (weakSelf.onBeginClick) {
            weakSelf.onBeginClick();
        }
    }];
    [self.textField setTextColor:WHITECOLOR];
    [self.textField setTintColor:WHITECOLOR];
    [self.textField setClearButtonMode:(UITextFieldViewModeNever)];
    [self.textField setPlaceholder:kClickSearchQuestionOrAnswerOrUser];
    [self.textField setContentMode:(UIViewContentModeLeft)];
    [self.textField setReturnKeyType:(UIReturnKeyDone)];
    [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textField setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.textField drawPlaceholderInRect];
    [self.textField setMaxLength:kSearchContentMaxLength];
    [self setClearButton];
    [self.viewContent addSubview:self.textField];
    
    self.btnSearch = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateNormal)];
    [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateHighlighted)];
    [self.btnSearch setImageEdgeInsets:(UIEdgeInsetsMake(1, 1, 1, 1))];
    [[self.btnSearch titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.btnSearch addTarget:self action:@selector(btnSearchClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnSearch];
    
    self.btnQuestion = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnQuestion setTitle:kPutQuestion forState:(UIControlStateNormal)];
    [self.btnQuestion setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [[self.btnQuestion titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.btnQuestion addTarget:self action:@selector(btnQuestionClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnQuestion];
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
    [self.viewContent setFrame:CGRectMake(14, 25, self.width-79, contentH)];
    
    [self.textField setViewFrame:CGRectMake(13, 1, self.viewContent.width-contentH-5, self.viewContent.height)];
    
    [self.btnSearch setFrame:CGRectMake(self.viewContent.width-36, 1, contentH, contentH)];
    
    [self.btnQuestion setFrame:CGRectMake(self.width-57, 22.5, 50, 40)];
}

-(NSString *)getSearchContent
{
    return self.textField.text;
}
///显示键盘
-(void)setViewShowKeyboard
{
    [self.textField becomeFirstResponder];
}

///隐藏键盘
-(void)setViewHiddenKeyboard
{
    [self.textField resignFirstResponder];
}

-(void)btnQuestionClick
{
    if (_isClear) {
        _isClear = NO;
        [self.textField resignFirstResponder];
        [self setClearStateChange];
        [self.textField setText:nil];
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
        [self setClearStateChange];
        if (self.onSearchClick) {
            self.onSearchClick(self.textField.text);
        }
        [self.textField resignFirstResponder];
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
            [ws.btnQuestion setTitle:kCancel forState:(UIControlStateNormal)];
        } else {
            [ws.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateNormal)];
            [ws.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateHighlighted)];
            [ws.btnQuestion setTitle:kPutQuestion forState:(UIControlStateNormal)];
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
}

@end
