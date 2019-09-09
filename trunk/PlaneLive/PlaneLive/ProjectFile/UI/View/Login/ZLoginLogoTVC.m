
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
    
    self.cellH = [ZLoginLogoTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgLogo = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"wutong_logo"]];
    [self.viewMain addSubview:self.imgLogo];
    
    CGFloat imgW = 88;
    CGFloat imgH = 80;
    CGFloat imgY = 20;
    CGFloat imgX = self.cellW/2-imgW/2;
    [self.imgLogo setFrame:CGRectMake(imgX, imgY, imgW, imgH)];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
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

+(CGFloat)getH
{
    return 120;
}

@end
