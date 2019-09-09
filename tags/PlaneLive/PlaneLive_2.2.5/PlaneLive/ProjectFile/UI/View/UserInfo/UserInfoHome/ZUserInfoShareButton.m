//
//  ZUserInfoShareButton.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoShareButton.h"
#import "ZImageView.h"
#import "ZLabel.h"

@interface ZUserInfoShareButton()

@property (strong, nonatomic) ZImageView *imgIcon;

@property (strong, nonatomic) ZLabel *lbTitle;

@property (strong, nonatomic) ZLabel *lbCount;

@end

@implementation ZUserInfoShareButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat imgS = 18;
    CGFloat imgY = self.height/2-imgS/2;
    CGFloat imgX = 10*APP_FRAME_WIDTH/320;
    self.imgIcon = [[ZImageView alloc] initWithFrame:CGRectMake(imgX, imgY, imgS, imgS)];
    [self.imgIcon setUserInteractionEnabled:NO];
    [self addSubview:self.imgIcon];
    
    CGFloat lbX = imgX+imgS+5;
    CGFloat titleY = 10;
    CGFloat titleH = 18;
    CGFloat lbW = self.width-lbX;
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, titleY, lbW, titleH)];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self addSubview:self.lbTitle];
    
    CGFloat countH = 20;
    CGFloat countY = titleY+titleH;
    self.lbCount = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, countY, lbW, countH)];
    [self.lbCount setTextColor:WHITECOLOR];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self addSubview:self.lbCount];
}

-(void)setViewDataWithTitle:(NSString *)title imageName:(NSString *)imageName count:(long)count
{
    [self.imgIcon setImageName:imageName];
    
    [self.lbTitle setText:title];
    
    [self.lbCount setText:[NSString stringWithFormat:@"%ld", count]];
}

@end
