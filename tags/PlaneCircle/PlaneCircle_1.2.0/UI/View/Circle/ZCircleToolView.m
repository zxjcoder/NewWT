//
//  ZCircleToolView.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleToolView.h"
#import "ClassCategory.h"

#import <UMMobClick/MobClick.h>

@interface ZCircleToolView()

///推荐
@property (strong, nonatomic) UIButton *btnHot;
///动态
@property (strong, nonatomic) UIButton *btnDynamic;
///最新
@property (strong, nonatomic) UIButton *btnNew;
///关注
@property (strong, nonatomic) UIButton *btnAtt;
///线
@property (strong, nonatomic) UIView *viewLine;
@property (strong, nonatomic) UIView *viewLine1;

@end

@implementation ZCircleToolView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.btnHot = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnHot setTitle:@"推荐" forState:(UIControlStateNormal)];
    [self.btnHot setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnHot setTag:1];
    [[self.btnHot titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnHot addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnHot];
    
    self.btnDynamic = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDynamic setTitle:@"动态" forState:(UIControlStateNormal)];
    [self.btnDynamic setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnDynamic setTag:2];
    [[self.btnDynamic titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnDynamic addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnDynamic];
    
    self.btnNew = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnNew setTitle:@"最新" forState:(UIControlStateNormal)];
    [self.btnNew setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnNew setTag:3];
    [[self.btnNew titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnNew addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnNew];
    
    self.btnAtt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAtt setTitle:@"关注" forState:(UIControlStateNormal)];
    [self.btnAtt setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnAtt setTag:4];
    [[self.btnAtt titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnAtt addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnAtt];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:MAINCOLOR];
    [self addSubview:self.viewLine];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewLine1];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemW = self.width/4;
    [self.btnHot setFrame:CGRectMake(0, 0, itemW, self.height-2)];
    [self.btnDynamic setFrame:CGRectMake(itemW, 0, itemW, self.height-2)];
    [self.btnNew setFrame:CGRectMake(itemW*2, 0, itemW, self.height-2)];
    [self.btnAtt setFrame:CGRectMake(itemW*3, 0, itemW, self.height-2)];

    [self.viewLine setFrame:CGRectMake(0, self.height-2-0.5, itemW, 2)];
    [self.viewLine1 setFrame:CGRectMake(0, self.height-0.8, self.width, 0.8)];
}

-(void)btnItemClick:(UIButton*)sender
{
    [self itemChange:sender.tag];
}

-(void)itemChange:(NSInteger)index
{
    switch (index) {
        case 2:
        {
            //TODO:ZWW备注-添加友盟统计事件
            [MobClick event:kEvent_Circle_Dynamic];
            __weak typeof(self) ws = self;
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [ws.btnHot setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [ws.btnDynamic setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                [ws.btnNew setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [ws.btnAtt setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }];
            break;
        }
        case 3:
        {
            //TODO:ZWW备注-添加友盟统计事件
            [MobClick event:kEvent_Circle_New];
            __weak typeof(self) ws = self;
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [ws.btnHot setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [ws.btnDynamic setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [ws.btnNew setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                [ws.btnAtt setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }];
            break;
        }
        case 4:
        {
            //TODO:ZWW备注-添加友盟统计事件
            [MobClick event:kEvent_Circle_Attention];
            __weak typeof(self) ws = self;
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [ws.btnHot setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [ws.btnDynamic setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [ws.btnNew setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [ws.btnAtt setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
            }];
            break;
        }
        default:
        {
            //TODO:ZWW备注-添加友盟统计事件
            [MobClick event:kEvent_Circle_Recommend];
            __weak typeof(self) ws = self;
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [ws.btnHot setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                [ws.btnDynamic setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [ws.btnNew setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [ws.btnAtt setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }];
            break;
        }
    }
    if (self.onItemClick) {
        self.onItemClick(index);
    }
}

-(void)setViewSelectItemWithType:(ZCircleToolViewItem)item
{
    [self itemChange:item];
}

-(void)setOffsetChange:(CGFloat)offX
{
    CGRect lineFrame = self.viewLine.frame;
    lineFrame.origin.x = offX/4;
    [self.viewLine setFrame:lineFrame];
}

-(void)dealloc
{
    OBJC_RELEASE(_btnAtt);
    OBJC_RELEASE(_btnHot);
    OBJC_RELEASE(_btnNew);
    OBJC_RELEASE(_btnDynamic);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_onItemClick);
}

@end
