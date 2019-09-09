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

@property (strong, nonatomic) UILabel *lbTItle;

@end

@implementation ZUserInfoShopButton

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
    CGFloat imgSize = 25;
    self.imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2-imgSize/2, 0, imgSize, imgSize)];
    [self addSubview:self.imgIcon];
    
    self.lbTItle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-23, self.width, 20)];
    [self.lbTItle setTextColor:BLACKCOLOR];
    [self.lbTItle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTItle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTItle setNumberOfLines:1];
    [self addSubview:self.lbTItle];
}

///设置数据源
-(void)setViewDataWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    [self.lbTItle setText:title];
    
    [self.imgIcon setImage:[SkinManager getImageWithName:imageName]];
}

@end
