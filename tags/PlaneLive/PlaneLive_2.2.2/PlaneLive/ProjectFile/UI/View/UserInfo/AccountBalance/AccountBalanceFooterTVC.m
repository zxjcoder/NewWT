//
//  AccountBalanceFooterTVC.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "AccountBalanceFooterTVC.h"
#import <TYAttributedLabel/TYAttributedLabel.h>

@interface AccountBalanceFooterTVC()<TYAttributedLabelDelegate>

@property (strong, nonatomic) TYAttributedLabel *lbDesc;

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
    self.lbDesc = [[TYAttributedLabel alloc] initWithFrame:descFrame];
    [self.lbDesc setText:kAccountBalancePaymentTips];
    // 文字间隙
    self.lbDesc.characterSpacing = 1;
    // 文本行间隙
    self.lbDesc.linesSpacing = 2;
    NSRange range = [kAccountBalancePaymentTips rangeOfString:kRechargeProcessDescription];
    [self.lbDesc addLinkWithLinkData:kRechargeProcessDescription linkColor:BLUECOLOR underLineStyle:(kCTUnderlineStyleNone) range:range];
    [self.lbDesc setDelegate:self];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setNumberOfLines:0];
    [self.viewMain addSubview:self.lbDesc];
    
    [self.lbDesc sizeToFit];
    
    self.cellH = self.lbDesc.y+self.lbDesc.height+kSize20;
}

-(void)dealloc
{
    _lbDesc.delegate = nil;
    OBJC_RELEASE(_lbDesc);
    [super setViewNil];
}

#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point
{
    if (self.onLinkClick) {
        self.onLinkClick();
    }
}

@end
