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
    
    self.btnCheck = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCheck setImage:[[SkinManager getImageWithName:@"icon_check_select"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch] forState:(UIControlStateNormal)];
    [self.btnCheck setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnCheck.imageView setViewRound:4 borderWidth:1 borderColor:VIEW_BACKCOLOR2];
    [self.btnCheck addTarget:self action:@selector(btnCheckClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnCheck];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:MAINCOLOR];
    [self.lbTitle setText:IHaveReadAndAgreedToThePlaneLiveUserAgreement];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.lbTitle.text];
    [str addAttribute:NSFontAttributeName value:[ZFont systemFontOfSize:kFont_Min_Size] range:NSMakeRange(0, 13)];
    [str addAttribute:NSForegroundColorAttributeName value:DESCCOLOR range:NSMakeRange(0, 13)];
    self.lbTitle.attributedText = str;
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
    
    [self.btnCheck setFrame:CGRectMake(self.space-4, self.space, 35, 35)];
    
    CGFloat lbX = self.btnCheck.x+self.btnCheck.width;
    [self.lbTitle setFrame:CGRectMake(lbX, self.space, self.cellW-lbX, 35)];
    
    [self.btnAgreement setFrame:CGRectMake(self.lbTitle.x+135, self.space, 120, 35)];
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
        [self.btnCheck setImage:[[SkinManager getImageWithName:@"icon_check_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeTile] forState:(UIControlStateNormal)];
    } else {
        [self.btnCheck setImage:[[SkinManager getImageWithName:@"icon_check_select"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch] forState:(UIControlStateNormal)];
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
