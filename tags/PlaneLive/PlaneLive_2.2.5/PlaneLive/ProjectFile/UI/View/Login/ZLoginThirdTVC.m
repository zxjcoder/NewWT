//
//  ZLoginThirdTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginThirdTVC.h"
#import "ZButton.h"

@interface ZLoginThirdTVC()

@property (strong, nonatomic) UIView *lbTitleLine1;
@property (strong, nonatomic) UIView *lbTitleLine2;
@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) ZButton *btnWeChat;

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
    
    self.cellH = [ZLoginThirdTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:kYouCanAlsoSelectTheFollowingWayToLogin];
    [self.lbTitle setTextColor:DESCCOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbTitleLine1 = [[UIView alloc] init];
    [self.lbTitleLine1 setBackgroundColor:DESCCOLOR];
    [self.lbTitle addSubview:self.lbTitleLine1];
    
    self.lbTitleLine2 = [[UIView alloc] init];
    [self.lbTitleLine2 setBackgroundColor:DESCCOLOR];
    [self.lbTitle addSubview:self.lbTitleLine2];
    
    self.btnWeChat = [[ZButton alloc] initWithText:kCWeChat imageName:@"login_btn_weixin"];
    [self.btnWeChat addTarget:self action:@selector(btnWeChatClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnWeChat setButtonTextColor:DESCCOLOR];
    [self.btnWeChat setButtonTextFontSize:kFont_Small_Size];
    [self.viewMain addSubview:self.btnWeChat];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat spaceX = kSizeSpace;
    [self.lbTitle setFrame:CGRectMake(0, kSize10, self.cellW, self.lbH)];
    
    CGFloat lineW = (self.cellW-([self.lbTitle getLabelWidthWithMinWidth:0]+8)-spaceX*2)/2;
    
    [self.lbTitleLine1 setFrame:CGRectMake(spaceX-2, self.lbH/2, lineW, 0.5)];
    [self.lbTitleLine2 setFrame:CGRectMake(self.cellW-spaceX-lineW+2, self.lbH/2, lineW, 0.5)];
    
    [self.lbTitle setHidden:NO];
    [self.lbTitleLine1 setHidden:NO];
    [self.lbTitleLine2 setHidden:NO];
    
    CGFloat btnW = 60;
    CGFloat btnH = 85;
    CGFloat btnY = self.lbTitle.y+self.lbTitle.height+20;
    if (self.btnWeChat.hidden) {
        [self.lbTitle setHidden:YES];
        [self.lbTitleLine1 setHidden:YES];
        [self.lbTitleLine2 setHidden:YES];
    } else {
        [self.lbTitle setHidden:NO];
        [self.lbTitleLine1 setHidden:NO];
        [self.lbTitleLine2 setHidden:NO];
        [self.btnWeChat setIconFrame:CGRectMake(self.cellW/2-btnW/2, btnY, btnW, btnH)];
    }
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
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
    [self.btnWeChat setAlpha:isShow==YES?1:0];
    [self.btnWeChat setHidden:!isShow];
}
-(void)setViewNil
{
    OBJC_RELEASE(_btnWeChat);
    OBJC_RELEASE(_lbTitleLine1);
    OBJC_RELEASE(_lbTitleLine2);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_onWeChatClick);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 200;
}

@end
