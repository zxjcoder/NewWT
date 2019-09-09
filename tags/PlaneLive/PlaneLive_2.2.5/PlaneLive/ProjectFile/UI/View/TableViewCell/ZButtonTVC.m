//
//  ZButtonTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButtonTVC.h"

@interface ZButtonTVC()

@property (strong, nonatomic) ZButton *btnSubmit;
@property (strong, nonatomic) UIView *viewSubmit;

@end

@implementation ZButtonTVC

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
    
    self.cellH = [ZButtonTVC getH];
    
    self.btnSubmit = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSubmit setTitle:kSubmit forState:(UIControlStateNormal)];
    [self.btnSubmit setTitle:kSubmit forState:(UIControlStateHighlighted)];
    [[self.btnSubmit titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    CGFloat spaceX = 40 * kViewSace;
    CGFloat btnH = 40;
    
    self.viewSubmit = [[UIView alloc] initWithFrame:(CGRectMake(spaceX, self.cellH/2-btnH/2, self.cellW-spaceX*2, btnH))];
    [self.viewSubmit setButtonShadowColorWithRadius:20];
    [self.viewMain addSubview:self.viewSubmit];
    
    [self.btnSubmit setFrame:self.viewSubmit.bounds];
    [self.btnSubmit setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1"] forState:(UIControlStateNormal)];
    [self.btnSubmit setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1_c"] forState:(UIControlStateHighlighted)];
    //UIImage *imageS = [Utils resizedTransformtoSize:(CGSizeMake(self.btnSubmit.width, self.btnSubmit.height)) image:[UIImage imageNamed:@"btn_gra1_c"]];
    //UIImage *image = [Utils resizedTransformtoSize:(CGSizeMake(self.btnSubmit.width, self.btnSubmit.height)) image:[UIImage imageNamed:@"btn_gra1"]];
    //[self.btnSubmit setBackgroundImage:image forState:(UIControlStateNormal)];
    //[self.btnSubmit setBackgroundImage:imageS forState:(UIControlStateHighlighted)];
    [self.btnSubmit.layer setMasksToBounds:true];
    [self.btnSubmit setViewRound:20 borderWidth:0 borderColor:CLEARCOLOR];
    
    [self.viewSubmit addSubview:self.btnSubmit];
}
-(void)btnSubmitClick
{
    if (self.onSubmitClick) {
        self.onSubmitClick();
    }
}
-(void)setCellBackGroundColor:(UIColor *)color
{
    [self.viewMain setBackgroundColor:color];
}
-(void)setButtonText:(NSString *)text
{
    [self.btnSubmit setTitle:text forState:(UIControlStateNormal)];
    [self.btnSubmit setTitle:text forState:(UIControlStateHighlighted)];
}
-(void)setViewNil
{
    OBJC_RELEASE(_btnSubmit);
    OBJC_RELEASE(_onSubmitClick);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 45;
}

@end
