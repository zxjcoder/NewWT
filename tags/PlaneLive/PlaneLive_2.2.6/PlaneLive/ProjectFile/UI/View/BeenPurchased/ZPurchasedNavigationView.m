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

///子项视图
@property (strong, nonatomic) UIView *viewTool;
///全部
@property (strong, nonatomic) ZButton *btnItem0;
///微课
@property (strong, nonatomic) ZButton *btnItem1;
///系列课
@property (strong, nonatomic) ZButton *btnItem2;
///订阅
@property (strong, nonatomic) ZButton *btnItem3;
///搜索
@property (strong, nonatomic) ZButton *btnSearch;
///系列课小红点
@property (strong, nonatomic) UIView *viewPoint2;
///订阅小红点
@property (strong, nonatomic) UIView *viewPoint3;
///选中线
@property (strong, nonatomic) UIImageView *viewToolLine;
///导航线
@property (strong, nonatomic) UIView *viewNavLine;
@property (assign, nonatomic) CGFloat btnS;
@property (assign, nonatomic) CGFloat btnW;
@property (assign, nonatomic) CGFloat btnH;
///子项数量
@property (assign, nonatomic) int itemCount;

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
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.itemCount = 4;
    CGFloat btnSearchSize = 42;
    self.btnSearch = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSearch setImage:[SkinManager getImageWithName:@"search"] forState:(UIControlStateNormal)];
    [self.btnSearch setImage:[SkinManager getImageWithName:@"search"] forState:(UIControlStateHighlighted)];
    [self.btnSearch setImageEdgeInsets:(UIEdgeInsetsMake(4, 4, 4, 4))];
    [self.btnSearch setFrame:(CGRectMake(self.width - 20 - btnSearchSize, 3, btnSearchSize, btnSearchSize))];
    [self.btnSearch addTarget:self action:@selector(btnSearchEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnSearch];
    
    CGFloat btnS = 15;
    self.viewTool = [[UIView alloc] initWithFrame:CGRectMake(btnS, 0, self.btnSearch.x-btnS*2, self.height)];
    [self.viewTool setBackgroundColor:self.backgroundColor];
    [self addSubview:self.viewTool];
    
    CGFloat btnW = self.viewTool.width/self.itemCount;
    CGFloat btnH = 42;
    self.btnS = btnS;
    self.btnW = btnW;
    self.btnH = btnH;
    
    self.btnItem0 = [self createItemButton];
    [self.btnItem0 setTag:0];
    [self.btnItem0 setSelected:true];
    [self.btnItem0 setFrame:CGRectMake(0, 0, btnW, btnH)];
    [self.btnItem0 setTitle:kAll forState:(UIControlStateNormal)];
    [[self.btnItem0 titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.viewTool addSubview:self.btnItem0];
    
    self.btnItem1 = [self createItemButton];
    [self.btnItem1 setTag:1];
    [self.btnItem1 setSelected:false];
    [self.btnItem1 setFrame:CGRectMake(btnW, 0, btnW, btnH)];
    [self.btnItem1 setTitle:kPractice forState:(UIControlStateNormal)];
    [[self.btnItem1 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewTool addSubview:self.btnItem1];
    
    self.btnItem2 = [self createItemButton];
    [self.btnItem2 setTag:2];
    [self.btnItem2 setSelected:false];
    [self.btnItem2 setFrame:CGRectMake(btnW*2, 0, btnW, btnH)];
    [self.btnItem2 setTitle:kSeriesCourse forState:(UIControlStateNormal)];
    [[self.btnItem2 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewTool addSubview:self.btnItem2];
    
    self.btnItem3 = [self createItemButton];
    [self.btnItem3 setTag:3];
    [self.btnItem3 setSelected:false];
    [self.btnItem3 setFrame:CGRectMake(btnW*3, 0, btnW, btnH)];
    [self.btnItem3 setTitle:kSubscribe forState:(UIControlStateNormal)];
    [[self.btnItem3 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewTool addSubview:self.btnItem3];
    
    CGFloat pointSize = 5;
    CGFloat pointY = 8;
    self.viewPoint2 = [self createItemView];
    [self.btnItem2 addSubview:self.viewPoint2];
    
    self.viewPoint3 = [self createItemView];
    [self.btnItem3 addSubview:self.viewPoint3];
    
    self.viewToolLine = [[UIImageView alloc] init];
    CGFloat lineW = 30;
    CGFloat lineX = btnW/2-lineW/2;
    CGFloat lineHeight = 2;
    CGFloat lineY = self.viewTool.height-lineHeight;
    [self.viewToolLine setFrame:CGRectMake(lineX, lineY, lineW, lineHeight)];
    [self.viewTool addSubview:self.viewToolLine];
    
    self.viewNavLine = [[UIView alloc] initWithFrame:CGRectMake(-65, self.viewTool.height-kLineHeight, self.width+130, kLineHeight)];
    [self.viewNavLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewTool addSubview:self.viewNavLine];
    
    [self.viewTool sendSubviewToBack:self.viewNavLine];
}
-(void)setLineFrame
{
    [self.viewToolLine setBackgroundColor:COLORTEXT1];
}
-(UIButton*)createItemButton
{
    ZButton *btnItem = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [btnItem setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [btnItem setTitleColor:COLORTEXT1 forState:(UIControlStateSelected)];
    [btnItem setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
    [btnItem setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
    [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    return btnItem;
}
-(UIView*)createItemView
{
    CGFloat pointSize = 5;
    CGFloat pointY = 8;
    UIView *viewPoint = [[UIView alloc] initWithFrame:CGRectMake(self.btnW/2+24, pointY, pointSize, pointSize)];
    [viewPoint setHidden:YES];
    [viewPoint.layer setMasksToBounds:YES];
    [viewPoint setViewRound:pointSize/2 borderWidth:0 borderColor:CLEARCOLOR];
    [viewPoint setBackgroundColor:COLORCOUNTBG];
    [viewPoint setUserInteractionEnabled:NO];
    return viewPoint;
}
-(void)btnSearchEvent
{
    if (self.onSearchClick) {
        self.onSearchClick();
    }
}
-(void)setSubscriptionPoint:(int)unReadTotalCount
{
    // TODO: ZWW屏蔽已购小红点
    [self.viewPoint3 setHidden:unReadTotalCount==0];
}
-(void)setCurriculumPoint:(int)unReadTotalCount
{
    // TODO: ZWW屏蔽已购小红点
    [self.viewPoint2 setHidden:unReadTotalCount==0];
}
-(void)btnItemClick:(UIButton *)sender
{
    [self setItemDefaultSelect:sender.tag];
}
///改变索引
-(void)setChangeItemIndex:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            [self.btnItem0 setSelected:false];
            [self.btnItem1 setSelected:true];
            [self.btnItem2 setSelected:false];
            [self.btnItem3 setSelected:false];
            
            [[self.btnItem0 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            [[self.btnItem1 titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
            [[self.btnItem2 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            [[self.btnItem3 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            break;
        }
        case 2:
        {
            [self.btnItem0 setSelected:false];
            [self.btnItem1 setSelected:false];
            [self.btnItem2 setSelected:true];
            [self.btnItem3 setSelected:false];
            
            [[self.btnItem0 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            [[self.btnItem1 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            [[self.btnItem2 titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
            [[self.btnItem3 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            break;
        }
        case 3:
        {
            [self.btnItem0 setSelected:false];
            [self.btnItem1 setSelected:false];
            [self.btnItem2 setSelected:false];
            [self.btnItem3 setSelected:true];
            
            [[self.btnItem0 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            [[self.btnItem1 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            [[self.btnItem2 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            [[self.btnItem3 titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
            break;
        }
        default:
        {
            [self.btnItem0 setSelected:true];
            [self.btnItem1 setSelected:false];
            [self.btnItem2 setSelected:false];
            [self.btnItem3 setSelected:false];
            
            [[self.btnItem0 titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
            [[self.btnItem1 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            [[self.btnItem2 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            [[self.btnItem3 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
            break;
        }
    }
}
-(int)getNavItemCount
{
    return self.itemCount;
}
///设置横向偏移量
-(void)setOffsetChange:(CGFloat)offX
{
    CGRect lineFrame = self.viewToolLine.frame;
    lineFrame.origin.x = (offX*self.viewTool.width/APP_FRAME_WIDTH)/self.itemCount+self.btnW/2-lineFrame.size.width/2;
    [self.viewToolLine setFrame:lineFrame];
}
///设置默认选中子项
-(void)setItemDefaultSelect:(NSInteger)index
{
    if (self.onItemClick) {
        self.onItemClick(index);
    }
    [self setChangeItemIndex:index];
}
-(void)dealloc
{
    OBJC_RELEASE(_btnItem1);
    OBJC_RELEASE(_btnItem2);
    OBJC_RELEASE(_btnItem3);
    OBJC_RELEASE(_viewNavLine);
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_viewToolLine);
    OBJC_RELEASE(_onItemClick);
    OBJC_RELEASE(_viewPoint2);
    OBJC_RELEASE(_viewPoint3);
}
@end
