//
//  ZNewBindAccountPhoneTVC.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewBindAccountPhoneTVC.h"

@interface ZNewBindAccountPhoneTVC()

@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbAccountType;
@property (strong, nonatomic) ZImageView *imageIcon;
@property (strong, nonatomic) ZLabel *lbAccount;

@end

@implementation ZNewBindAccountPhoneTVC

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
    
    self.cellH = [ZNewBindAccountPhoneTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(self.space, 13, 280, self.lbMinH))];
        [self.lbTitle setTextColor:COLORTEXT2];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.viewMain addSubview:self.lbTitle];
    }
    if (!self.imageIcon) {
        self.imageIcon = [[ZImageView alloc] initWithFrame:(CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+18, 24, 24))];
        [self.viewMain addSubview:self.imageIcon];
    }
    if (!self.lbAccountType) {
        self.lbAccountType = [[ZLabel alloc] initWithFrame:(CGRectMake(self.imageIcon.x+self.imageIcon.width+10, self.imageIcon.y+2, 85, self.lbH))];
        [self.lbAccountType setTextColor:COLORTEXT1];
        [self.lbAccountType setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.viewMain addSubview:self.lbAccountType];
    }
    CGFloat accountX = (self.lbAccountType.x+self.lbAccountType.width);
    CGFloat accountW = self.cellW-accountX-self.space;
    if (!self.lbAccount) {
        self.lbAccount = [[ZLabel alloc] initWithFrame:(CGRectMake(accountX, self.lbAccountType.y, accountW, self.lbH))];
        [self.lbAccount setTextColor:COLORTEXT1];
        [self.lbAccount setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbAccount setTextAlignment:(NSTextAlignmentRight)];
        [self.viewMain addSubview:self.lbAccount];
    }
    UIImageView *imageLine = [UIImageView getDLineView];
    imageLine.frame = CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight);
    [self.viewMain addSubview:imageLine];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}
-(void)setViewFrame
{
    
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.lbTitle setText:@"当前登录账号"];
    self.imageIcon.image = [SkinManager getImageWithName:@"phone"];
    switch (model.loginType) {
        case WTAccountTypeWeChat:
            self.imageIcon.image = [SkinManager getImageWithName:@"weixin_a"];
            self.lbAccount.text = model.nickname;
            self.lbAccountType.text = @"微信账号";
            break;
        default:
            self.imageIcon.image = [SkinManager getImageWithName:@"phone"];
            self.lbAccount.text = model.phone;
            self.lbAccountType.text = @"手机账号";
            break;
    }
    return self.cellH;
}
-(void)setViewNil
{
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 100;
}

@end
