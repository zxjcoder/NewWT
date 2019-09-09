//
//  ZPlayBottomButton.m
//  PlaneLive
//
//  Created by WT on 14/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZPlayBottomButton.h"
#import "ZCalculateLabel.h"

@interface ZPlayBottomButton()

@property (strong ,nonatomic) UIImageView *imageIcon;
@property (strong ,nonatomic) UILabel *lbTitle;

@end

@implementation ZPlayBottomButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.imageIcon = [[UIImageView alloc] initWithFrame:(CGRectMake(self.width/2-11, 5, 22, 22))];
    [self.imageIcon setUserInteractionEnabled:false];
    [self addSubview:self.imageIcon];
    
    CGFloat titleW = self.width+2;
    UIFont *titleFont = [ZFont systemFontOfSize:kFont_Min_Size];
    CGFloat titleH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:titleFont width:titleW];
    self.lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(-1, self.imageIcon.y+self.imageIcon.height+3, titleW, titleH))];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setTextColor:COLORTEXT3];
    [self.lbTitle setFont:titleFont];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setUserInteractionEnabled:false];
    [self addSubview:self.lbTitle];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.imageIcon.frame = CGRectMake(self.width/2-11, 5, 22, 22);
    CGFloat titleW = self.width+2;
    UIFont *titleFont = [ZFont systemFontOfSize:kFont_Min_Size];
    CGFloat titleH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:titleFont width:titleW];
    self.lbTitle.frame = CGRectMake(-1, self.imageIcon.y+self.imageIcon.height+3, titleW, titleH);
}
-(void)setButtonIcon:(NSString *)icon
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.imageIcon.image = [UIImage imageNamed:icon];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)setButtonTitle:(NSString *)title
{
    [self.lbTitle setText:title];
}

@end
