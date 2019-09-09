//
//  ZUserInfoShopView.m
//  PlaneLive
//
//  Created by Daniel on 24/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZUserInfoShopView.h"
#import "ZUserInfoShopButton.h"

@interface ZUserInfoShopView()

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

@implementation ZUserInfoShopView

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
    CGFloat btnW = ZUserInfoShopButtonWidth;
    CGFloat itemW = self.width/4;
    CGFloat btnY = 10;
    CGFloat btnX = itemW/2-btnW/2;
    self.btnPurchase = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(btnX, btnY) type:(ZUserInfoCenterItemTypePurchase)];
    [self.btnPurchase addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPurchase];
    
    self.btnShopCart = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(itemW+btnX, btnY) type:(ZUserInfoCenterItemTypeShoppingCart)];
    [self.btnShopCart addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnShopCart];
    
    self.btnPurchaseRecord = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(itemW*2+btnX, btnY) type:(ZUserInfoCenterItemTypePurchaseRecord)];
    [self.btnPurchaseRecord addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPurchaseRecord];
    
    self.btnBalance = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(itemW*3+btnX, btnY) type:(ZUserInfoCenterItemTypeBalance)];
    [self.btnBalance addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnBalance];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.height-kLineMaxHeight, self.width, kLineMaxHeight)];
    [self addSubview:self.imgLine];
    
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
    [self addSubview:self.lbShopCartCount];
}
-(void)btnItemClick:(ZUserInfoShopButton *)sender
{
    if (self.onUserInfoShoppingCartItemClick) {
        self.onUserInfoShoppingCartItemClick(sender.tag);
    }
}
-(void)setViewDataWithModel:(ModelUser *)model
{
    [self.lbShopCartCount setHidden:model.shoppingCartCount==0];
    if (model.shoppingCartCount > kNumberMaxCount) {
        [self.lbShopCartCount setText:[NSString stringWithFormat:@"%d", kNumberMaxCount]];
    } else {
        [self.lbShopCartCount setText:[NSString stringWithFormat:@"%d", model.shoppingCartCount]];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_btnBalance);
    OBJC_RELEASE(_btnPurchaseRecord);
    OBJC_RELEASE(_btnBalance);
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
