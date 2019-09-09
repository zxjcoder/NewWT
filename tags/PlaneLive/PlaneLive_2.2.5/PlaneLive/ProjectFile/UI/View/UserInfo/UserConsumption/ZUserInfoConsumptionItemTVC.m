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
    self.cellH = [ZUserInfoConsumptionItemTVC getH];
    self.space = 20;
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] init];
        [self.lbTitle setTextColor:COLORTEXT2];
        [self.lbTitle setNumberOfLines:0];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.viewMain addSubview:self.lbTitle];
    }
    if (!self.lbTime) {
        self.lbTime = [[ZLabel alloc] init];
        [self.lbTime setNumberOfLines:1];
        [self.lbTime setTextColor:COLORTEXT1];
        [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.viewMain addSubview:self.lbTime];
    }
    if (!self.lbPrice) {
        self.lbPrice = [[ZLabel alloc] init];
        [self.lbPrice setTextColor:COLORCONTENT3];
        [self.lbPrice setNumberOfLines:1];
        [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
        [self.lbPrice setFont:[ZFont boldSystemFontOfSize:kFont_Small_Size]];
        [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.viewMain addSubview:self.lbPrice];
    }
    if (!self.imgLine) {
        self.imgLine = [UIImageView getTLineView];
        [self.viewMain addSubview:self.imgLine];
    }
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGRect titleFrame = CGRectMake(self.space, 18, self.cellW-self.space*2, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    titleFrame.size.height = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    [self.lbTitle setFrame:titleFrame];
    
    [self.lbTime setFrame:(CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+18, self.cellW-self.space*2, self.lbH))];
    
    [self.lbPrice setFrame:(CGRectMake(self.cellW-self.space-140, self.lbTime.y, 140, self.lbH))];
    self.cellH = self.lbTime.y+self.lbTime.height+10;
    [self.imgLine setFrame:(CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight))];
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
-(void)setTypeValue:(NSString *)type time:(NSString *)time
{
    [self.lbTime setText:[NSString stringWithFormat:@"%@  %@", type, time]];
    [self.lbTime setTextColor:COLORTEXT3];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    NSRange range = NSMakeRange(0, type.length);
    UIFont *font = [ZFont systemFontOfSize:kFont_Min_Size];
    [self.lbTime setLabelFontWithRange:range font:font color:COLORTEXT1];
}
-(CGFloat)setCellDataWithRechargeRecord:(ModelRechargeRecord *)model
{
    [self.lbTitle setText:model.title];
    
    [self setTypeValue:model.pay_type time:model.pay_time];
    
    [self.lbPrice setText:[NSString stringWithFormat:@"%.2f", [model.price floatValue]]];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(CGFloat)setCellDataWithRewardPlay:(ModelRewardRecord *)model
{
    [self.lbTitle setText:[NSString stringWithFormat:@"%@: %@", kAwardPresenter, model.title]];
    
    [self setTypeValue:model.pay_type time:model.pay_time];
    
    [self.lbPrice setText:[NSString stringWithFormat:@"%.2f", [model.price floatValue]]];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(CGFloat)setCellDataWithSubscribePlay:(ModelSubscribePlay *)model
{
    [self setTypeValue:model.pay_type time:model.pay_time];
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
