//
//  ZLoginThirdTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginThirdTVC.h"

@interface ZLoginThirdTVC()
{
    BOOL _isShowWeChat;
    BOOL _isShowQQ;
}
@property (strong, nonatomic) UIView *lbTitleLine1;
@property (strong, nonatomic) UIView *lbTitleLine2;
@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIButton *btnWeChat;

@property (strong, nonatomic) UIButton *btnQQ;

@end

@implementation ZLoginThirdTVC

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
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:@"您还可以选择以下方式登录"];
    [self.lbTitle setTextColor:MAINCOLOR];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Least_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbTitleLine1 = [[UIView alloc] init];
    [self.lbTitleLine1 setBackgroundColor:MAINCOLOR];
    [self.lbTitle addSubview:self.lbTitleLine1];
    
    self.lbTitleLine2 = [[UIView alloc] init];
    [self.lbTitleLine2 setBackgroundColor:MAINCOLOR];
    [self.lbTitle addSubview:self.lbTitleLine2];
    
    self.btnWeChat = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnWeChat setImage:[SkinManager getImageWithName:@"login_btn_weixin"] forState:(UIControlStateNormal)];
    [self.btnWeChat setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnWeChat addTarget:self action:@selector(btnWeChatClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnWeChat];
    
    self.btnQQ = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnQQ setImage:[SkinManager getImageWithName:@"login_btn_qq"] forState:(UIControlStateNormal)];
    [self.btnQQ setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnQQ addTarget:self action:@selector(btnQQClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnQQ];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat spaceX = 40;
    [self.lbTitle setFrame:CGRectMake(0, kSize10, self.cellW, self.lbH)];
    
    CGFloat lineW = (self.cellW-([self.lbTitle getLabelWidthWithMinWidth:0]+8)-spaceX*2)/2;
    
    [self.lbTitleLine1 setFrame:CGRectMake(spaceX-2, self.lbH/2, lineW, 0.5)];
    [self.lbTitleLine2 setFrame:CGRectMake(self.cellW-spaceX-lineW+2, self.lbH/2, lineW, 0.5)];
    
    [self.lbTitle setHidden:NO];
    [self.lbTitleLine1 setHidden:NO];
    [self.lbTitleLine2 setHidden:NO];
    
    CGFloat btnSize = 60;
    CGFloat btnY = self.lbTitle.y+self.lbTitle.height+20;
    if (_isShowWeChat && _isShowQQ) {
        [self.btnQQ setHidden:NO];
        [self.btnWeChat setHidden:NO];
        [self.btnWeChat setFrame:CGRectMake(self.cellW/2-btnSize-20, btnY, btnSize, btnSize)];
        [self.btnQQ setFrame:CGRectMake(self.cellW/2+20, btnY, btnSize, btnSize)];
    } else if (_isShowWeChat && !_isShowQQ) {
        [self.btnQQ setHidden:YES];
        [self.btnWeChat setHidden:NO];
        [self.btnWeChat setFrame:CGRectMake(self.cellW/2-btnSize/2, btnY, btnSize, btnSize)];
    } else if (!_isShowWeChat && _isShowQQ) {
        [self.btnQQ setHidden:NO];
        [self.btnWeChat setHidden:YES];
        [self.btnQQ setFrame:CGRectMake(self.cellW/2-btnSize/2, btnY, btnSize, btnSize)];
    } else {
        [self.lbTitle setHidden:YES];
        [self.lbTitleLine1 setHidden:YES];
        [self.lbTitleLine2 setHidden:YES];
        [self.btnQQ setHidden:YES];
        [self.btnWeChat setHidden:YES];
    }
}

-(void)btnQQClick
{
    if (self.onQQClick) {
        self.onQQClick();
    }
}

-(void)btnWeChatClick
{
    if (self.onWeChatClick) {
        self.onWeChatClick();
    }
}

///是否显示微信登陆
-(void)setShowWeChatLogin:(BOOL)isShow
{
    _isShowWeChat = isShow;
    [self.btnWeChat setHidden:!isShow];
}
///是否现实QQ登陆
-(void)setShowMobileQQLogin:(BOOL)isShow
{
    _isShowQQ = isShow;
    [self.btnQQ setHidden:!isShow];
}

-(void)setViewNil
{
    OBJC_RELEASE(_btnQQ);
    OBJC_RELEASE(_btnWeChat);
    OBJC_RELEASE(_lbTitleLine1);
    OBJC_RELEASE(_lbTitleLine2);
    OBJC_RELEASE(_lbTitle);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 130;
}
+(CGFloat)getH
{
    return 130;
}

@end
