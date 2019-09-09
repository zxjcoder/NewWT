//
//  ZRankSearchView.m
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankSearchView.h"
#import "ClassCategory.h"
#import "Utils.h"
#import "ZTextField.h"

@interface ZRankSearchView()
{
    __block BOOL _isShowClear;
    NSString *_lastText;
}
@property (strong, nonatomic) UIView *viewContent;
///搜索输入框
@property (strong, nonatomic) ZTextField *textField;
///搜索图片
@property (strong, nonatomic) UIButton *btnSearch;
///取消
@property (strong, nonatomic) UIButton *btnCancel;

@end

@implementation ZRankSearchView

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

-(void)innerInit
{
    [self setBackgroundColor:MAINCOLOR];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:RGBCOLOR(254,156,84)];
    [self.viewContent setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    
    self.textField = [[ZTextField alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.textField setOnTextDidChange:^(NSString *text) {
        if (weakSelf.onSearchClick) {
            weakSelf.onSearchClick(text);
        }
    }];
    [self.textField setOnBeginEditText:^{
        _isShowClear = YES;
        [weakSelf setClearStateChange];
        if (weakSelf.onBeginEditClick) {
            weakSelf.onBeginEditClick();
        }
    }];
    [self.textField setOnReturnText:^{
        [weakSelf btnCancelClick];
    }];
    [self.textField setTextColor:WHITECOLOR];
    [self.textField setTintColor:WHITECOLOR];
    [self.textField setClearButtonMode:(UITextFieldViewModeNever)];
    [self.textField setPlaceholder:@"点击搜索机构、人员"];
    [self.textField setContentMode:(UIViewContentModeLeft)];
    [self.textField setReturnKeyType:(UIReturnKeyDone)];
    [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textField setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
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
    
    self.btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.btnCancel setHidden:YES];
    [self.btnCancel setAlpha:0];
    [self.btnCancel setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [[self.btnCancel titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnCancel];
    
    [self setViewFrame];
}

- (void)setClearButton
{
    [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateNormal)];
    [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateHighlighted)];
}

-(void)setViewFrame
{
    CGFloat viewW = APP_FRAME_WIDTH;
    CGFloat contentH = 32;
    ///显示取消
    if (!_isShowClear) {
        [self.viewContent setFrame:CGRectMake(10, 25, viewW-20, contentH)];
        
        [self.textField setViewFrame:CGRectMake(10, 1, self.viewContent.width-contentH-5, self.viewContent.height)];
        
        [self.btnSearch setFrame:CGRectMake(self.viewContent.width-36, 1, contentH, contentH)];
    } else {
        [self.viewContent setFrame:CGRectMake(10, 25, self.width-75, contentH)];
        
        [self.textField setViewFrame:CGRectMake(10, 1, self.viewContent.width-contentH-5, self.viewContent.height)];
        
        [self.btnSearch setFrame:CGRectMake(self.viewContent.width-36, 1, contentH, contentH)];
    }
    [self.btnCancel setFrame:CGRectMake(self.width-60, 22.5, 50, 40)];
}

-(NSString *)getSearchContent
{
    return self.textField.text;
}

-(void)btnCancelClick
{
    _isShowClear = NO;
    [self.textField resignFirstResponder];
    [self setClearStateChange];
    if (self.onClearClick) {
        self.onClearClick();
    }
}

-(void)btnSearchClick
{
    [self.textField setText:kEmpty];
    if (self.onSearchClick) {
        self.onSearchClick(self.textField.text);
    }
}

-(void)setClearStateChange
{
    [self.textField setText:nil];
    [self.btnCancel setHidden:NO];
    [self.btnCancel setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        ///显示取消
        if (_isShowClear) {
            [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_delete"] forState:(UIControlStateNormal)];
            [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_delete"] forState:(UIControlStateHighlighted)];
            [self.btnCancel setAlpha:1];
            
        } else {
            [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateNormal)];
            [self.btnSearch setImage:[SkinManager getImageWithName:@"icon_quanzi_search"] forState:(UIControlStateHighlighted)];
            [self.btnCancel setAlpha:0];
        }
        [self setViewFrame];
    } completion:^(BOOL finished) {
        if (!_isShowClear) {
            [self.btnCancel setHidden:YES];
        }
    }];
}

-(void)dealloc
{
    OBJC_RELEASE(_textField);
    OBJC_RELEASE(_btnSearch);
    OBJC_RELEASE(_btnCancel);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_lastText);
}

@end
