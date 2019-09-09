//
//  ZSubscribeNavigationView.m
//  PlaneLive
//
//  Created by Daniel on 08/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeNavigationView.h"
#import "ZButton.h"

@interface ZSubscribeNavigationView()

///已定
@property (strong, nonatomic) ZButton *btnItem1;
///推荐
@property (strong, nonatomic) ZButton *btnItem2;
///选中线
@property (strong, nonatomic) ZView *viewToolLine;
///导航线
@property (strong, nonatomic) ZView *viewNavLine;

@end

@implementation ZSubscribeNavigationView

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
    CGFloat btnW = 95;
    self.btnItem1 = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnItem1 setTitle:kHasBeenSet forState:(UIControlStateNormal)];
    [self.btnItem1 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [self.btnItem1 setFrame:CGRectMake(self.width/2-btnW, 0, btnW, 42.5)];
    [self.btnItem1 setTag:0];
    [[self.btnItem1 titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.btnItem1 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnItem1];
    
    self.btnItem2 = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnItem2 setTitle:kRecommend forState:UIControlStateNormal];
    [self.btnItem2 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnItem2 setFrame:CGRectMake(self.width/2, 0, btnW, 42.5)];
    [self.btnItem2 setTag:1];
    [[self.btnItem2 titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.btnItem2 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnItem2];
    
    CGFloat lineX = self.width/2;
    CGFloat lineY = self.height-2.5;
    self.viewToolLine = [[ZView alloc] initWithFrame:CGRectMake(lineX, lineY, btnW, 2.5)];
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
    switch (index) {
        case 1:
        {
            if (self.onItemClick) {
                self.onItemClick(index);
            }
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                if (self.btnItem1) {
                    [self.btnItem1 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                }
                if (self.btnItem2) {
                    [self.btnItem2 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                }
                CGRect lineFrame = self.viewToolLine.frame;
                lineFrame.origin.x = self.width/2;
                [self.viewToolLine setFrame:lineFrame];
            }];
            break;
        }
        default:
        {
            if (self.onItemClick) {
                self.onItemClick(index);
            }
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                if (self.btnItem1) {
                    [self.btnItem1 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                }
                if (self.btnItem2) {
                    [self.btnItem2 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                }
                CGRect lineFrame = self.viewToolLine.frame;
                lineFrame.origin.x = self.width/2-lineFrame.size.width;
                [self.viewToolLine setFrame:lineFrame];
            }];
            break;
        }
    }
}
///设置横向偏移量
-(void)setOffsetChange:(CGFloat)offX
{
    CGFloat offsetIndex = abs((int)((offX+65)/self.width));
    CGRect lineFrame = self.viewToolLine.frame;
    if (offsetIndex == 0) {
        lineFrame.origin.x = self.width/2-lineFrame.size.width;
    } else {
        lineFrame.origin.x = self.width/2;
    }
    [self.viewToolLine setFrame:lineFrame];
}

@end
