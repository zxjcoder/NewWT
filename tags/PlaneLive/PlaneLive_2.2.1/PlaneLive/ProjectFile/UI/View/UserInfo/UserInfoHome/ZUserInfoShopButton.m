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

@property (strong, nonatomic) UILabel *lbCount;

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
                [self.imgIcon setImage:[SkinManager getImageWithName:@"my_purchase_new"]];
                break;
            case ZUserInfoCenterItemTypeShoppingCart:
                [self.lbTitle setText:kShoppingCart];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"my_shopping_new"]];
                break;
            case ZUserInfoCenterItemTypePurchaseRecord:
                [self.lbTitle setText:kPurchaseRecord];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"my_purchase_history_new"]];
                break;
            case ZUserInfoCenterItemTypeBalance:
                [self.lbTitle setText:kBalance];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"my_balance_new"]];
                break;
            default:
                break;
        }
    }
    return self;
}

-(void)innerInit
{
    CGFloat imgSize = 22;
    self.imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2-imgSize/2, 10, imgSize, imgSize)];
    [self addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imgIcon.y+self.imgIcon.height+3, self.width, 20)];
    [self.lbTitle setTextColor:MAINCOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setNumberOfLines:1];
    [self addSubview:self.lbTitle];
    
    CGFloat countH = 20;
    self.lbCount = [[UILabel alloc] initWithFrame:CGRectMake(self.imgIcon.x+self.imgIcon.width/2+2, 3, countH, countH)];
    [self.lbCount setTextColor:WHITECOLOR];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbCount setViewRoundNoBorder];
    [self.lbCount setHidden:YES];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setBackgroundColor:REDCOLOR];
    [self addSubview:self.lbCount];
}
-(void)setItemCount:(long)count
{
    [self.lbCount setHidden:count==0];
    if (count >= kNumberReadMaxCount) {
        [self.lbCount setText:@"99"];
    } else {
        [self.lbCount setText:[NSString stringWithFormat:@"%ld", count]];
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbCount);
}

@end
