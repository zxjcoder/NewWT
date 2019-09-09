//
//  ZUserInfoShopButton.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoShopButton.h"

@interface ZUserInfoShopButton()

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) UILabel *lbTitle;

@end

@implementation ZUserInfoShopButton

-(instancetype)initWithPoint:(CGPoint)point type:(ZUserInfoCenterItemType)type
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, ZUserInfoShopButtonWidth, ZUserInfoShopButtonHeight)];
    if (self) {
        [self innerInit];
        
        [self setTag:type];
        
        switch (type) {
            case ZUserInfoCenterItemTypePurchase:
                [self.lbTitle setText:kBeenPurchased];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"mien_purchase_icon"]];
                break;
            case ZUserInfoCenterItemTypeShoppingCart:
                [self.lbTitle setText:kShoppingCart];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"mien_shoppingcart_icon"]];
                break;
            case ZUserInfoCenterItemTypePurchaseRecord:
                [self.lbTitle setText:kPurchaseRecord];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"mien_purchaserecord_icon"]];
                break;
            case ZUserInfoCenterItemTypeBalance:
                [self.lbTitle setText:kBalance];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"mine_mybalance_icon"]];
                break;
            default:
                break;
        }
    }
    return self;
}

-(void)innerInit
{
    CGFloat imgSize = 25;
    self.imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2-imgSize/2, 1, imgSize, imgSize)];
    [self addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-24, self.width, 20)];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setNumberOfLines:1];
    [self addSubview:self.lbTitle];
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgIcon);
}

@end
