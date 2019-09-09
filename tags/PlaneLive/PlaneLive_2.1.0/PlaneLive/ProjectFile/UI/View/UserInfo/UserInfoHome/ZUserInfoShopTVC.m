//
//  ZUserInfoShopTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoShopTVC.h"
#import "ZUserInfoShopButton.h"

@interface ZUserInfoShopTVC()

///购物车
@property (strong, nonatomic) ZUserInfoShopButton *btnShopCart;
///已购
@property (strong, nonatomic) ZUserInfoShopButton *btnPurchase;
///购买记录
@property (strong, nonatomic) ZUserInfoShopButton *btnPurchaseRecord;
///余额查询
@property (strong, nonatomic) ZUserInfoShopButton *btnBalance;
///购物车数量
@property (strong, nonatomic) UILabel *lbShopCartCount;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZUserInfoShopTVC

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.cellH = [ZUserInfoShopTVC getH];
    
    CGFloat btnS = 15;
    CGFloat btnY = 10;
    CGFloat btnW = ZUserInfoShopButtonWidth;
    self.btnPurchase = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(btnS, btnY) type:(ZUserInfoCenterItemTypePurchase)];
    [self.btnPurchase addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnPurchase];
    
    CGFloat space = (self.cellW-btnS*2-ZUserInfoShopButtonWidth*4)/3;
    self.btnShopCart = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(btnS+btnW+space, btnY) type:(ZUserInfoCenterItemTypeShoppingCart)];
    [self.btnShopCart addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnShopCart];
    
    self.btnPurchaseRecord = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(btnS+btnW*2+space*2, btnY) type:(ZUserInfoCenterItemTypePurchaseRecord)];
    [self.btnPurchaseRecord addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnPurchaseRecord];
    
    self.btnBalance = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(self.cellW-btnS-btnW, btnY) type:(ZUserInfoCenterItemTypeBalance)];
    [self.btnBalance addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnBalance];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
    [self.viewMain addSubview:self.imgLine];
    
    CGFloat lbW = 16;
    CGFloat lbH = 16;
    self.lbShopCartCount = [[UILabel alloc] initWithFrame:CGRectMake(self.btnShopCart.x+self.btnShopCart.width/2+lbW/2+4, self.btnShopCart.y-lbH/2+3, lbW, lbH)];
    [self.lbShopCartCount setText:kZero];
    [self.lbShopCartCount setFont:[ZFont systemFontOfSize:kFont_Minimum_Size]];
    [self.lbShopCartCount setTextColor:WHITECOLOR];
    [self.lbShopCartCount setBackgroundColor:MAINCOLOR];
    [self.lbShopCartCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbShopCartCount setHidden:YES];
    [self.lbShopCartCount setViewRoundNoBorder];
    [self.viewMain addSubview:self.lbShopCartCount];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(void)btnItemClick:(ZUserInfoShopButton *)sender
{
    if (self.onUserInfoShoppingCartItemClick) {
        self.onUserInfoShoppingCartItemClick(sender.tag);
    }
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.lbShopCartCount setHidden:model.shoppingCartCount==0];
    if (model.shoppingCartCount > kNumberMaxCount) {
        [self.lbShopCartCount setText:[NSString stringWithFormat:@"%d", kNumberMaxCount]];
    } else {
        [self.lbShopCartCount setText:[NSString stringWithFormat:@"%d", model.shoppingCartCount]];
    }
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_btnBalance);
    OBJC_RELEASE(_btnPurchaseRecord);
    OBJC_RELEASE(_btnBalance);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 68;
}

@end
