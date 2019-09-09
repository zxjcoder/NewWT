//
//  ZRegisterAgreementTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRegisterAgreementTVC.h"
#import "Utils.h"

@interface ZRegisterAgreementTVC()
{
    BOOL _isCheck;
}
@property (strong, nonatomic) UIButton *btnCheck;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIButton *btnAgreement;

@end

@implementation ZRegisterAgreementTVC

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
    
    self.cellH = [ZRegisterAgreementTVC getH];
    
    _isCheck = YES;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.btnCheck = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCheck setImage:[SkinManager getImageWithName:@"checkbox"] forState:(UIControlStateNormal)];
     [self.btnCheck setImage:[SkinManager getImageWithName:@"checkbox_s"] forState:(UIControlStateSelected)];
    [self.btnCheck setSelected:true];
    [self.btnCheck addTarget:self action:@selector(btnCheckClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnCheck];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setText:IHaveReadAndAgreedToThePlaneLiveUserAgreement];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.lbTitle.text];
    [str addAttribute:NSFontAttributeName value:[ZFont systemFontOfSize:kFont_Min_Size] range:NSMakeRange(0, 11)];
    [str addAttribute:NSForegroundColorAttributeName value:COLORTEXT3 range:NSMakeRange(0, 11)];
    self.lbTitle.attributedText = str;
    [self.lbTitle setUserInteractionEnabled:false];
    [self.viewMain addSubview:self.lbTitle];
    
    self.btnAgreement = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAgreement addTarget:self action:@selector(btnAgreementClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnAgreement];
    
    [self.viewMain sendSubviewToBack:self.lbTitle];
    [self.viewMain bringSubviewToFront:self.btnAgreement];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat spaceX = 40*kViewSace;
    if (IsIPhone5 || IsIPhone4) {
        spaceX = 20;
    }
    [self.btnCheck setFrame:CGRectMake(spaceX - 10, self.cellH / 2 - 20, 40, 40)];
    
    CGFloat lbX = self.btnCheck.x+self.btnCheck.width - 5;
    [self.lbTitle setFrame:CGRectMake(lbX, self.cellH / 2 - 35 / 2, self.cellW-lbX, 35)];
    
    [self.btnAgreement setFrame:CGRectMake(self.lbTitle.x+135, self.cellH / 2 - 35 / 2, 120, 35)];
}

-(void)btnAgreementClick
{
    if (self.onAgreementClick) {
        self.onAgreementClick();
    }
}

-(void)btnCheckClick
{
    if (_isCheck) {
        [self.btnCheck setSelected:false];
    } else {
        [self.btnCheck setSelected:true];
    }
    _isCheck = !_isCheck;
}
-(void)setCellBackGroundColor:(UIColor *)color
{
    [self.viewMain setBackgroundColor:color];
}
-(BOOL)getCheckState
{
    return _isCheck;
}

-(void)setViewNil
{
    OBJC_RELEASE(_btnCheck);
    OBJC_RELEASE(_btnAgreement);
    OBJC_RELEASE(_lbTitle);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 55;
}

@end
