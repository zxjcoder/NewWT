//
//  ZUserInfoConsumptionItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 13/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoConsumptionItemTVC.h"

@interface ZUserInfoConsumptionItemTVC()

@property (strong, nonatomic) ZLabel *lbTitle;

@property (strong, nonatomic) ZLabel *lbTime;

@property (strong, nonatomic) ZLabel *lbPrice;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZUserInfoConsumptionItemTVC

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
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbTime = [[ZLabel alloc] init];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTime];
    
    self.lbPrice = [[ZLabel alloc] init];
    [self.lbPrice setTextColor:MAINCOLOR];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat priceW = 10;
    CGFloat priceX = self.cellW-self.space-priceW;
    CGRect priceFrame = CGRectMake(priceX, kSize13, priceW, self.lbH);
    [self.lbPrice setFrame:priceFrame];
    CGFloat priceNewW = [self.lbPrice getLabelWidthWithMinWidth:priceW]+kSize5;
    CGFloat priceNewX = self.cellW-self.space-priceNewW;
    priceFrame.origin.x = priceNewX;
    priceFrame.size.width = priceNewW;
    [self.lbPrice setFrame:priceFrame];
    
    CGFloat lbX = self.space;
    CGFloat lbW = self.cellW - lbX*2;
    CGRect titleFrame = CGRectMake(lbX, kSize13, lbW - priceNewW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    CGFloat timeY = self.lbTitle.y+self.lbTitle.height+kSize5;
    [self.lbTime setFrame:CGRectMake(lbX, timeY, lbW, self.lbMinH)];
    
    self.cellH = self.lbTime.y+self.lbTime.height+kSize6;
    [self.imgLine setFrame:CGRectMake(lbX, self.cellH-self.lineH, lbW, self.lineH)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbPrice);
    OBJC_RELEASE(_imgLine);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)setCellDataWithRechargeRecord:(ModelRechargeRecord *)model
{
    [self.lbTitle setText:model.title];
    
    [self.lbTime setText:[NSString stringWithFormat:@"%@  %@", model.pay_type, model.pay_time]];
    
    [self.lbPrice setText:[NSString stringWithFormat:@"%.2f", [model.price floatValue]]];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(CGFloat)setCellDataWithRewardPlay:(ModelRewardRecord *)model
{
    [self.lbTitle setText:[NSString stringWithFormat:@"%@: %@", kAwardPresenter, model.title]];
    
    [self.lbTime setText:[NSString stringWithFormat:@"%@  %@", model.pay_type, model.pay_time]];
    
    [self.lbPrice setText:[NSString stringWithFormat:@"%.2f", [model.price floatValue]]];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(CGFloat)setCellDataWithSubscribePlay:(ModelSubscribePlay *)model
{
    [self.lbTime setText:[NSString stringWithFormat:@"%@  %@", model.pay_type, model.pay_time]];
    
    switch (model.type) {
        case 0:
        {
            [self.lbTitle setText:model.title];
            if (model && model.units.length > 0) {
                [self.lbPrice setText:[NSString stringWithFormat:@"%.2f/%@", [model.price floatValue], model.units]];
            } else {
                [self.lbPrice setText:[NSString stringWithFormat:@"%.2f", [model.price floatValue]]];
            }
            break;
        }
        case 1:
        {
            [self.lbTitle setText:model.title];
            if (model && model.units.length > 0) {
                [self.lbPrice setText:[NSString stringWithFormat:@"%.2f/%@", [model.price floatValue], model.units]];
            } else {
                [self.lbPrice setText:[NSString stringWithFormat:@"%.2f", [model.price floatValue]]];
            }
            break;
        }
        case 2:
        {
            [self.lbTitle setText:model.title];
            [self.lbPrice setText:[NSString stringWithFormat:@"%.2f", [model.price floatValue]]];
            break;
        }
        default:
        {
            [self.lbTitle setText:model.title];
            [self.lbPrice setText:[NSString stringWithFormat:@"%.2f", [model.price floatValue]]];
            break;
        }
    }
    [self setViewFrame];
    
    return self.cellH;
}

@end
