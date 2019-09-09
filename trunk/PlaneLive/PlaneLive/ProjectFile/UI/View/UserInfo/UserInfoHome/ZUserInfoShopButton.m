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
        [self innerInitItem];
        
        [self setTag:type];
        
        switch (type) {
            case ZUserInfoCenterItemTypeShoppingCart:
                [self.lbTitle setText:kShoppingCart];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"cart"]];
                break;
            case ZUserInfoCenterItemTypePurchaseRecord:
                [self.lbTitle setText:kPurchaseRecord];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"pay_record"]];
                break;
            case ZUserInfoCenterItemTypeBalance:
                [self.lbTitle setText:kBalance];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"balance"]];
                break;
            case ZUserInfoCenterItemTypeDownload:
                [self.lbTitle setText:kDownloadManager];
                [self.imgIcon setImage:[SkinManager getImageWithName:@"download_a"]];
                break;
            default:
                break;
        }
    }
    return self;
}

-(void)innerInitItem
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat imgSize = 50;
    self.imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2-imgSize/2, 5, imgSize, imgSize)];
    [self addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(-5, self.imgIcon.y+self.imgIcon.height+5, self.width+10, 18)];
    [self.lbTitle setTextColor:COLORTEXT2];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setNumberOfLines:1];
    [self addSubview:self.lbTitle];
    
    CGFloat countH = 20;
    self.lbCount = [[UILabel alloc] initWithFrame:CGRectMake(self.width-countH-3, 5, countH, countH)];
    [self.lbCount setTextColor:WHITECOLOR];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Minimum_Size]];
    [self.lbCount setViewRoundNoBorder];
    [self.lbCount setHidden:YES];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setBackgroundColor:COLORCOUNTBG];
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
