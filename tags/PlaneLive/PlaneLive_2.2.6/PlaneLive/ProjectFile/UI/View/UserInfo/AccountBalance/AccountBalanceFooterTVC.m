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
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    CGRect descFrame = CGRectMake(self.space, 15, self.cellW-self.space*2, self.lbMinH);
    self.lbDesc = [[TYAttributedLabel alloc] initWithFrame:descFrame];
    [self.lbDesc setText:kAccountBalancePaymentTips];
    // 文字间隙
    self.lbDesc.characterSpacing = 1;
    // 文本行间隙
    self.lbDesc.linesSpacing = 2;
    [self.lbDesc setTextColor:COLORTEXT3];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    NSRange range = [kAccountBalancePaymentTips rangeOfString:kRechargeProcessDescription];
    [self.lbDesc addLinkWithLinkData:kRechargeProcessDescription linkColor:BLUECOLOR underLineStyle:(kCTUnderlineStyleNone) range:range];
    NSRange wechatRange = [kAccountBalancePaymentTips rangeOfString:kContactWeChatCustomerServiceDescription];
    [self.lbDesc addLinkWithLinkData:kContactWeChatCustomerServiceDescription linkColor:BLUECOLOR underLineStyle:(kCTUnderlineStyleNone) range:wechatRange];
    [self.lbDesc setDelegate:self];
    [self.lbDesc setNumberOfLines:0];
    [self.viewMain addSubview:self.lbDesc];
    
    [self.lbDesc sizeToFit];
    
    self.cellH = self.lbDesc.y+self.lbDesc.height+20;
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
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        if ([[(TYLinkTextStorage*)textStorage linkData] isKindOfClass:[NSString class]]) {
            NSString *linkValue = (NSString*)[(TYLinkTextStorage*)textStorage linkData];
            if ([linkValue isEqualToString:kRechargeProcessDescription]) {
                if (self.onLinkClick) {
                    self.onLinkClick();
                }
            } else if ([linkValue isEqualToString:kContactWeChatCustomerServiceDescription]) {
                if (self.onWechatLinkClick) {
                    self.onWechatLinkClick();
                }
            }
        }
    }
}

@end
