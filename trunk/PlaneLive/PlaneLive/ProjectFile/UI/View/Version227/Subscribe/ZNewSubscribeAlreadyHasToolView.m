//
//  ZNewSubscribeAlreadyHasToolView.m
//  PlaneLive
//
//  Created by WT on 30/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewSubscribeAlreadyHasToolView.h"
#import "ZButton.h"
#import "ZImageView.h"

@interface ZNewSubscribeAlreadyHasToolView()

@property (strong, nonatomic) ZButton *btnList;
@property (strong, nonatomic) ZButton *btnInfo;

@property (strong, nonatomic) ZView *viewLine;
@property (strong, nonatomic) ZImageView *imageLine;
@property (assign, nonatomic) CGFloat itemW;

@end

@implementation ZNewSubscribeAlreadyHasToolView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:WHITECOLOR];
        self.itemW = self.width/2;
        CGFloat btnH = 36;
        self.btnList = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnList setTitle:@"课程列表" forState:(UIControlStateNormal)];
        [[self.btnList titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
        [self.btnList setTitleColor:COLORTEXT1 forState:(UIControlStateNormal)];
        [self.btnList addTarget:self action:@selector(btnListEvent) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnList setFrame:(CGRectMake(self.width/4-self.itemW/2, 10, self.itemW, btnH))];
        [self addSubview:self.btnList];
        
        self.btnInfo = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnInfo setTitle:@"课程简介" forState:(UIControlStateNormal)];
        [[self.btnInfo titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
        [self.btnInfo setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
        [self.btnInfo addTarget:self action:@selector(btnInfoEvent) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnInfo setFrame:(CGRectMake(self.width/2+self.width/4-self.itemW/2, 10, self.itemW, btnH))];
        [self addSubview:self.btnInfo];
        
        self.imageLine = [ZImageView getDLineView];
        [self.imageLine setFrame:(CGRectMake(20, self.height-kLineHeight, self.width-40, kLineHeight))];
        [self addSubview:self.imageLine];
        
        CGFloat lineW = 30;
        CGFloat lineH = 2;
        self.viewLine = [[ZView alloc] initWithFrame:(CGRectMake(self.btnList.x+self.btnList.width/2-lineW/2, self.height-lineH, lineW, lineH))];
        [self.viewLine setBackgroundColor:COLORTEXT1];
        [self addSubview:self.viewLine];
        
        [self sendSubviewToBack:self.imageLine];
    }
    return self;
}
-(void)btnListEvent
{
    if (self.onListEvent) {
        self.onListEvent();
    }
}
-(void)btnInfoEvent
{
    if (self.onInfoEvent) {
        self.onInfoEvent();
    }
}
/// 偏移x位置
-(void)setLineOffset:(CGFloat)offX
{
    [self.viewLine setHidden:false];
    CGRect lineFrame = self.viewLine.frame;
    lineFrame.origin.x = offX/2+(self.itemW/2-lineFrame.size.width/2);
    [self.viewLine setFrame:lineFrame];
}
/// 设置选中索引
-(void)setSelectIndex:(NSInteger)index
{
    switch (index) {
        case 1:
            [self.btnList setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
            [self.btnInfo setTitleColor:COLORTEXT1 forState:(UIControlStateNormal)];
            break;
        default:
            [self.btnList setTitleColor:COLORTEXT1 forState:(UIControlStateNormal)];
            [self.btnInfo setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
            break;
    }
}
+(CGFloat)getH
{
    return 46;
}

@end
