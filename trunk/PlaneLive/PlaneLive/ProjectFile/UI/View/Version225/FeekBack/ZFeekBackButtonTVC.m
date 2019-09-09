//
//  ZFeekBackButtonTVC.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFeekBackButtonTVC.h"
#import "ZShadowButtonView.h"

@interface ZFeekBackButtonTVC()

@property (strong, nonatomic) ZShadowButtonView *btnSubmit;

@end

@implementation ZFeekBackButtonTVC

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
    self.cellH = [ZFeekBackButtonTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.btnSubmit = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(self.space, 10, self.cellW-self.space*2, 40))];
    [self.btnSubmit setButtonTitle:@"提交反馈"];
    ZWEAKSELF
    [self.btnSubmit setOnButtonClick:^{
        [weakSelf btnSubmitClick];
    }];
    [self.viewMain addSubview:self.btnSubmit];
    
}
-(void)btnSubmitClick
{
    if (self.onSubmitEvent) {
        self.onSubmitEvent();
    }
}
+(CGFloat)getH
{
    return 130;
}

@end
