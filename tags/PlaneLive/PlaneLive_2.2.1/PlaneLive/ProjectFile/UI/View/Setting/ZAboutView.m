//
//  ZAboutView.m
//  Project
//
//  Created by Daniel on 16/1/20.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "ZAboutView.h"

@interface ZAboutView()

@property (strong, nonatomic) UIImageView *imgLogo;
@property (strong, nonatomic) UILabel *lbPlatform;

@end

@implementation ZAboutView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)dealloc
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_lbPlatform);
}

- (void)innerInit
{
    self.backgroundColor = VIEW_BACKCOLOR2;
    
    self.imgLogo = [[UIImageView alloc] init];
    self.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    self.imgLogo.image = [SkinManager getImageWithName:@"Icon"];
    [self.imgLogo.layer setMasksToBounds:YES];
    [self.imgLogo setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.imgLogo];
    
    self.lbPlatform = [[UILabel alloc] init];
    self.lbPlatform.textAlignment = NSTextAlignmentCenter;
    self.lbPlatform.textColor = BLACKCOLOR1;
    self.lbPlatform.text = [NSString stringWithFormat:@"%@ Version %@", APP_PROJECT_NAME, APP_PROJECT_VERSION];
    [self.lbPlatform setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self addSubview:self.lbPlatform];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgWidth = 100;
    CGFloat imgHeight = 100;
    CGFloat imgY = (self.height - imgHeight) / 2 - 15;
    CGFloat imgX = (self.width - imgWidth) / 2;
    [self.imgLogo setFrame:CGRectMake(imgX, imgY, imgWidth, imgHeight)];
    
    [self.lbPlatform setFrame:CGRectMake(0, self.imgLogo.y+self.imgLogo.height+15, self.width, 22)];
}

@end
