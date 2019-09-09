//
//  ZHomeTooolView.m
//  PlaneLive
//
//  Created by Daniel on 2016/12/23.
//  Copyright © 2016年 WT. All rights reserved.
//

#import "ZHomeTooolView.h"
#import "ZButton.h"

@interface ZHomeTooolView()

@property (strong, nonatomic) ZButton *btnItem1;
@property (strong, nonatomic) ZButton *btnItem2;
@property (strong, nonatomic) ZButton *btnItem3;
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZHomeTooolView

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
    CGFloat btnY = 10;
    CGFloat btnW = 60;
    CGFloat btnH = self.height-btnY*2-10;
    CGFloat itemW = self.width/3;
    
    self.btnItem1 = [[ZButton alloc] initWithText:@"经典实务" imageName:@"classic_practice_icon"];
    [self.btnItem1 setIconFrame:CGRectMake(itemW/2-btnW/2, btnY, btnW, btnH)];
    [self.btnItem1 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnItem1 setTag:1];
    [self.btnItem1 setButtonTextColor:BLACKCOLOR1];
    [self addSubview:self.btnItem1];
    
    self.btnItem2 = [[ZButton alloc] initWithText:@"热门订阅" imageName:@"hot_subscription_icon"];
    [self.btnItem2 setIconFrame:CGRectMake(self.width/2-btnW/2, btnY, btnW, btnH)];
    [self.btnItem2 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnItem2 setTag:2];
    [self.btnItem2 setButtonTextColor:BLACKCOLOR1];
    [self addSubview:self.btnItem2];
    
    self.btnItem3 = [[ZButton alloc] initWithText:@"系列课" imageName:@"series_courses_icon"];
    [self.btnItem3 setIconFrame:CGRectMake(self.width-itemW/2-btnW/2, btnY, btnW, btnH)];
    [self.btnItem3 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnItem3 setTag:3];
    [self.btnItem3 setButtonTextColor:BLACKCOLOR1];
    [self addSubview:self.btnItem3];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.height-10, self.width, 10)];
    [self addSubview:self.imgLine];
}
-(void)btnItemClick:(ZButton *)sender
{
    if (self.onItemClick) {
        self.onItemClick(sender.tag);
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_btnItem1);
    OBJC_RELEASE(_btnItem2);
    OBJC_RELEASE(_btnItem3);
    OBJC_RELEASE(_imgLine);
}
@end
