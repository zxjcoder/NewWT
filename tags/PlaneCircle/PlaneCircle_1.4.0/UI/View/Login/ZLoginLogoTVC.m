
//
//  ZLoginLogoTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginLogoTVC.h"

@interface ZLoginLogoTVC()

@property (strong, nonatomic) UIImageView *imgLogo;

@end

@implementation ZLoginLogoTVC

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
    
    self.cellH = self.getH;
 
    self.imgLogo = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"login_logo"]];
    [self.viewMain addSubview:self.imgLogo];
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLogo);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgW = 246/2;
    CGFloat imgH = 246/2;
    CGFloat imgY = 50;
    CGFloat imgX = self.cellW/2-imgW/2;
    [self.imgLogo setFrame:CGRectMake(imgX, imgY, imgW, imgH)];
    
}

-(CGFloat)getH
{
    return 210;
}
+(CGFloat)getH
{
    return 210;
}

@end
