//
//  AccountBalanceFooterTVC.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "AccountBalanceFooterTVC.h"

@interface AccountBalanceFooterTVC()

@property (strong, nonatomic) ZLabel *lbDesc;

@end

@implementation AccountBalanceFooterTVC

///初始化
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
    
    CGRect descFrame = CGRectMake(kSizeSpace, kSizeSpace, self.cellW-kSizeSpace*2, self.lbMinH);
    self.lbDesc = [[ZLabel alloc] initWithFrame:descFrame];
    [self.lbDesc setText:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n\n%@\n",kAccountBalancePaymentTips1,kAccountBalancePaymentTips2,kAccountBalancePaymentTips3,kAccountBalancePaymentTips4,kAccountBalancePaymentTips5]];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setNumberOfLines:0];
    [self.viewMain addSubview:self.lbDesc];
    
    CGFloat descH = [self.lbDesc getLabelHeightWithMinHeight:self.lbMinH];
    descFrame.size.height = descH;
    [self.lbDesc setFrame:descFrame];
    self.cellH = self.lbDesc.y+self.lbDesc.height+kSize20;
}

-(void)dealloc
{
    OBJC_RELEASE(_lbDesc);
    [super setViewNil];
}

@end
