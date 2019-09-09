//
//  ZPurchasedNavigationView.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZPurchasedNavigationView.h"
#import "ZButton.h"

@interface ZPurchasedNavigationView()

///实务
@property (strong, nonatomic) ZButton *btnItem1;
///系列课
@property (strong, nonatomic) ZButton *btnItem2;
///订阅
@property (strong, nonatomic) ZButton *btnItem3;
///选中线
@property (strong, nonatomic) ZView *viewToolLine;
///导航线
@property (strong, nonatomic) ZView *viewNavLine;
@property (assign, nonatomic) CGFloat btnS;
@property (assign, nonatomic) CGFloat btnW;

@end

@implementation ZPurchasedNavigationView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

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
    CGFloat btnW = 65;
    CGFloat btnS = (self.width-btnW*3)/4;
    self.btnS = btnS;
    self.btnW = btnW;
    self.btnItem1 = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnItem1 setTitle:kPractice forState:(UIControlStateNormal)];
    [self.btnItem1 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [self.btnItem1 setFrame:CGRectMake(btnS, 0, btnW, 42.5)];
    [self.btnItem1 setTag:0];
    [[self.btnItem1 titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.btnItem1 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnItem1];
    
    self.btnItem2 = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnItem2 setTitle:@"系列课" forState:UIControlStateNormal];
    [self.btnItem2 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnItem2 setFrame:CGRectMake(self.width/2-btnW/2, 0, btnW, 42.5)];
    [self.btnItem2 setTag:1];
    [[self.btnItem2 titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.btnItem2 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnItem2];
    
    self.btnItem3 = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnItem3 setTitle:kSubscribe forState:UIControlStateNormal];
    [self.btnItem3 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [self.btnItem3 setFrame:CGRectMake(self.width-btnW-btnS, 0, btnW, 42.5)];
    [self.btnItem3 setTag:2];
    [[self.btnItem3 titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.btnItem3 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnItem3];
    
    CGFloat lineX = self.width/2-btnW/2;
    CGFloat lineY = self.height-2;
    self.viewToolLine = [[ZView alloc] initWithFrame:CGRectMake(lineX, lineY, btnW, 2)];
    [self.viewToolLine setBackgroundColor:MAINCOLOR];
    [self addSubview:self.viewToolLine];
    
    self.viewNavLine = [[ZView alloc] initWithFrame:CGRectMake(-65, self.height-kLineHeight, self.width+130, kLineHeight)];
    [self.viewNavLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewNavLine];
    
    [self sendSubviewToBack:self.viewNavLine];
}
-(void)btnItemClick:(UIButton *)sender
{
    [self setItemDefaultSelect:sender.tag];
}
///设置默认选中子项
-(void)setItemDefaultSelect:(NSInteger)index
{
    if (self.onItemClick) {
        self.onItemClick(index);
    }
    switch (index) {
        case 1:
        {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                if (self.btnItem1) {
                    [self.btnItem1 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                }
                if (self.btnItem2) {
                    [self.btnItem2 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                }
                if (self.btnItem3) {
                    [self.btnItem3 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                }
                CGRect lineFrame = self.viewToolLine.frame;
                lineFrame.origin.x = self.width/2-self.btnW/2;
                [self.viewToolLine setFrame:lineFrame];
            }];
            break;
        }
        case 2:
        {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                if (self.btnItem1) {
                    [self.btnItem1 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                }
                if (self.btnItem2) {
                    [self.btnItem2 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                }
                if (self.btnItem3) {
                    [self.btnItem3 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                }
                CGRect lineFrame = self.viewToolLine.frame;
                lineFrame.origin.x = self.width-self.btnW-self.btnS;
                [self.viewToolLine setFrame:lineFrame];
            }];
            break;
        }
        default:
        {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                if (self.btnItem1) {
                    [self.btnItem1 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                }
                if (self.btnItem2) {
                    [self.btnItem2 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                }
                if (self.btnItem3) {
                    [self.btnItem3 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                }
                CGRect lineFrame = self.viewToolLine.frame;
                lineFrame.origin.x = self.btnS;
                [self.viewToolLine setFrame:lineFrame];
            }];
            break;
        }
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_btnItem1);
    OBJC_RELEASE(_btnItem2);
    OBJC_RELEASE(_btnItem3);
    OBJC_RELEASE(_viewNavLine);
    OBJC_RELEASE(_viewToolLine);
    OBJC_RELEASE(_onItemClick);
}
@end
