//
//  ZSettingButtonTVC.m
//  PlaneLive
//
//  Created by Daniel on 19/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZSettingButtonTVC.h"

@interface ZSettingButtonTVC()

@property (strong, nonatomic) ZButton *btnSubmit;
@property (strong, nonatomic) UIView *viewSubmit;

@end

@implementation ZSettingButtonTVC

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
    
    self.cellH = [ZSettingButtonTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.btnSubmit = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSubmit setTitle:@"退出登录" forState:(UIControlStateNormal)];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    CGFloat btnH = 40;
    self.viewSubmit = [[UIView alloc] initWithFrame:(CGRectMake(self.space, self.cellH/2-btnH/2, self.cellW-self.space*2, btnH))];
    //[self.viewSubmit setButtonShadowColorWithRadius:20];
    [self.viewMain addSubview:self.viewSubmit];
    
    [self.btnSubmit setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [self.btnSubmit setTitleColor:COLORTEXT3 forState:(UIControlStateHighlighted)];
    [self.btnSubmit setBackgroundColor:COLORVIEWBACKCOLOR3];
    [self.btnSubmit setFrame:self.viewSubmit.bounds];
    [self.btnSubmit.layer setMasksToBounds:true];
    [self.btnSubmit setViewRound:20 borderWidth:0 borderColor:CLEARCOLOR];
    
    [self.viewSubmit addSubview:self.btnSubmit];
}
-(void)btnSubmitClick
{
    if (self.onSubmitClick) {
        self.onSubmitClick();
    }
}
-(void)setCellBackGroundColor:(UIColor *)color
{
    [self.viewMain setBackgroundColor:color];
}
-(void)setButtonText:(NSString *)text
{
    [self.btnSubmit setTitle:text forState:(UIControlStateNormal)];
    [self.btnSubmit setTitle:text forState:(UIControlStateHighlighted)];
}
-(void)setViewNil
{
    OBJC_RELEASE(_btnSubmit);
    OBJC_RELEASE(_onSubmitClick);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 80;
}

@end
