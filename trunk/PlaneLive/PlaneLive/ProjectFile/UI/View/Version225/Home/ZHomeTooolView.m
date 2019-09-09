//
//  ZHomeTooolView.m
//  PlaneLive
//
//  Created by Daniel on 2016/12/23.
//  Copyright © 2016年 WT. All rights reserved.
//

#import "ZHomeTooolView.h"
#import "ZButton.h"
#import "ZView.h"

@interface ZHomeTooolView()

@property (strong, nonatomic) ZView *viewTop;
@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZButton *btnItem1;
@property (strong, nonatomic) ZButton *btnItem2;
@property (strong, nonatomic) ZButton *btnItem3;
@property (strong, nonatomic) ZButton *btnItem4;

@end

@implementation ZHomeTooolView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [self setBackgroundColor:CLEARCOLOR];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat btnY = 5;
    CGFloat btnW = 60;
    CGFloat btnH = 75;
    CGFloat space = 20;
    CGFloat itemSpace = (self.width-space*2-btnW*4)/3;
    self.viewTop = [[ZView alloc] initWithFrame:(CGRectMake(0, 0, self.width, 20))];
    [self.viewTop setBackgroundColor:WHITECOLOR];
    [[self.viewTop layer] setMasksToBounds:true];
    [self.viewTop setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewTop];
    
    self.viewContent = [[ZView alloc] initWithFrame:(CGRectMake(0, 10, self.width, self.height-10))];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewContent];
    
    self.btnItem1 = [[ZButton alloc] initWithText:kPractice imageName:@"weke"];
    [self.btnItem1 setIconFrame:CGRectMake(space, btnY, btnW, btnH)];
    [self.btnItem1 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnItem1 setTag:1];
    [self.btnItem1 setButtonTextFontSize:kFont_Min_Size];
    [self.btnItem1 setButtonTextColor:COLORTEXT2];
    [self.viewContent addSubview:self.btnItem1];
    
    self.btnItem2 = [[ZButton alloc] initWithText:kSeriesCourse imageName:@"series"];
    [self.btnItem2 setIconFrame:CGRectMake(space+btnW+itemSpace, btnY, btnW, btnH)];
    [self.btnItem2 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnItem2 setTag:2];
    [self.btnItem2 setButtonTextFontSize:kFont_Min_Size];
    [self.btnItem2 setButtonTextColor:COLORTEXT2];
    [self.viewContent addSubview:self.btnItem2];
    
    self.btnItem3 = [[ZButton alloc] initWithText:kPopularSubscription imageName:@"training"];
    [self.btnItem3 setIconFrame:CGRectMake(space+btnW*2+itemSpace*2, btnY, btnW, btnH)];
    [self.btnItem3 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnItem3 setTag:3];
    [self.btnItem3 setButtonTextFontSize:kFont_Min_Size];
    [self.btnItem3 setButtonTextColor:COLORTEXT2];
    [self.viewContent addSubview:self.btnItem3];
    
    self.btnItem4 = [[ZButton alloc] initWithText:@"专业机构" imageName:@"mechanism"];
    [self.btnItem4 setIconFrame:CGRectMake(space+btnW*3+itemSpace*3, btnY, btnW, btnH)];
    [self.btnItem4 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnItem4 setTag:4];
    [self.btnItem4 setButtonTextFontSize:kFont_Min_Size];
    [self.btnItem4 setButtonTextColor:COLORTEXT2];
    [self.viewContent addSubview:self.btnItem4];
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
    OBJC_RELEASE(_btnItem4);
}
@end
