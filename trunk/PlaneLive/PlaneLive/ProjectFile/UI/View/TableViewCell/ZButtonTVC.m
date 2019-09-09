//
//  ZButtonTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButtonTVC.h"
#import "ZShadowButtonView.h"

@interface ZButtonTVC()

@property (strong, nonatomic) ZShadowButtonView *btnSubmit;

@end

@implementation ZButtonTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.cellH = [ZButtonTVC getH];
    self.space = 40 * kViewSace;
    if (IsIPhone4 || IsIPhone5) {
        self.space = 20;
    }
    CGFloat btnH = 40;
    self.btnSubmit = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(self.space, self.cellH/2-btnH/2, self.cellW-self.space*2, btnH))];
    ZWEAKSELF
    [self.btnSubmit setOnButtonClick:^{
        [weakSelf btnSubmitClick];
    }];
    [self.btnSubmit setButtonTitle:kSubmit];
    [self.viewMain addSubview:self.btnSubmit];
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
    [self.btnSubmit setButtonTitle:text];
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
