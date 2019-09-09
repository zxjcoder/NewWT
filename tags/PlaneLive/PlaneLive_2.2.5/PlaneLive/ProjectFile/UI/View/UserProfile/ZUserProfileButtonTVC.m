//
//  ZUserProfileButtonTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserProfileButtonTVC.h"
#import "Utils.h"

@interface ZUserProfileButtonTVC()

@property (strong, nonatomic) UIButton *btnOper;

@property (strong, nonatomic) ModelUserProfile *model;

@end

@implementation ZUserProfileButtonTVC

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
    
    self.cellH = [ZUserProfileButtonTVC getH];
    
    [self.viewMain setBackgroundColor:VIEW_BACKCOLOR2];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.btnOper = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnOper setHidden:YES];
    [self.btnOper setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self.btnOper setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnOper addTarget:self action:@selector(btnOperClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnOper];
    
    [self.btnOper setFrame:CGRectMake(20, 15, self.cellW-30, 35)];
}

-(void)btnOperClick
{
    if (self.onOperClick) {
        self.onOperClick();
    }
}
-(void)setButtonHidden:(BOOL)hidden
{
    [self.btnOper setHidden:hidden];
}
-(void)setButtonState:(BOOL)isAtting
{
    [self.btnOper setHidden:NO];
    if (isAtting) {
        [self.btnOper setBackgroundColor:RGBCOLOR(201, 201, 201)];
        [self.btnOper setTitle:kAlreadyAttention forState:(UIControlStateNormal)];
    } else {
        [self.btnOper setBackgroundColor:MAINCOLOR];
        [self.btnOper setTitle:kAttention forState:(UIControlStateNormal)];
    }
}

-(CGFloat)setCellDataWithModel:(ModelUserProfile *)model
{
    [super setCellDataWithModel:model];
    
    [self setModel:model];
    
    [self setButtonState:model.isAtt];
    
    [self.btnOper setHidden:[Utils isMyUserId:model.userId]];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_btnOper);
    OBJC_RELEASE(_model);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getH
{
    return 65;
}

@end
