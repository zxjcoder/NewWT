
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
 
    self.imgLogo = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"Icon"]];
    [self.imgLogo.layer setMasksToBounds:YES];
    [self.imgLogo setViewRound:6 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.imgLogo];
    
    CGFloat imgW = 90;
    CGFloat imgH = 90;
    CGFloat imgY = 25;
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
    return 125;
}

@end
