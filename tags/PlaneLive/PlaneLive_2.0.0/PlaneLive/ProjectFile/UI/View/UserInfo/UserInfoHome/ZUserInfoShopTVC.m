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

@property (strong, nonatomic) ZView *viewHeader;

@property (strong, nonatomic) ZLabel *lbHeader;
///购物车
@property (strong, nonatomic) ZUserInfoShopButton *btnShopCart;
///待支付
@property (strong, nonatomic) ZUserInfoShopButton *btnWaitPay;
///已支付
@property (strong, nonatomic) ZUserInfoShopButton *btnPay;
///余额查询
@property (strong, nonatomic) ZUserInfoShopButton *btnBalanceSay;

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
    return 80;
}

@end
