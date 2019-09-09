//
//  ZSettingAboutTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/26/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSettingAboutTVC.h"

@interface ZSettingAboutTVC()

@property (strong, nonatomic) UIImageView *imgLogo;
@property (strong, nonatomic) UILabel *lbPlatform;

@end

@implementation ZSettingAboutTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.cellH = [ZSettingAboutTVC getH];
    
    [self.viewMain setBackgroundColor:VIEW_BACKCOLOR2];
    
    self.imgLogo = [[UIImageView alloc] init];
    self.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    self.imgLogo.image = [SkinManager getImageWithName:@"Icon"];
    [self.imgLogo.layer setMasksToBounds:YES];
    [self.imgLogo setViewRound:10 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.imgLogo];
    
    self.lbPlatform = [[UILabel alloc] init];
    self.lbPlatform.textAlignment = NSTextAlignmentCenter;
    self.lbPlatform.textColor = BLACKCOLOR1;
    self.lbPlatform.text = [NSString stringWithFormat:@"%@ Version %@", kPlaneLive, APP_PROJECT_VERSION];
    [self.lbPlatform setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self addSubview:self.lbPlatform];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgWidth = 100;
    CGFloat imgHeight = 100;
    CGFloat imgY = 30;
    CGFloat imgX = (self.width - imgWidth) / 2;
    [self.imgLogo setFrame:CGRectMake(imgX, imgY, imgWidth, imgHeight)];
    
    [self.lbPlatform setFrame:CGRectMake(0, self.imgLogo.y+self.imgLogo.height+15, self.width, 22)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_lbPlatform);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getH
{
    return 185;
}

@end
